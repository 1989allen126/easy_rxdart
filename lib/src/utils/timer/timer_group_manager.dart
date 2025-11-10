import 'dart:async';
import 'dart:isolate';
import 'package:flutter/widgets.dart';
import '../../core/reactive.dart';
import 'timer_config.dart';
import 'timer_info.dart';
import 'timer_status.dart';
import 'timer_message.dart';

/// 定时器信息（Isolate内部使用）
class _TimerInfo {
  /// 定时器配置
  final TimerConfig config;

  /// 上次触发时间
  DateTime lastTime;

  /// 执行次数
  int count;

  /// 是否暂停
  bool paused;

  /// 注册时间
  final DateTime registerTime;

  /// 构造函数
  _TimerInfo({
    required this.config,
    required this.lastTime,
    required this.count,
    required this.paused,
    required this.registerTime,
  });

  /// 获取定时器状态
  TimerStatus get status {
    if (paused) {
      return TimerStatus.pause;
    }
    if (count == 0 && !config.immediate) {
      return TimerStatus.pending;
    }
    if (config.maxCount != null && count >= config.maxCount!) {
      return TimerStatus.stop;
    }
    return TimerStatus.running;
  }

  /// 转换为TimerInfo
  TimerInfo toTimerInfo() {
    final now = DateTime.now();
    final elapsed = now.difference(lastTime);
    final nextTrigger = elapsed < config.interval
        ? now.add(config.interval - elapsed)
        : now;

    return TimerInfo(
      id: config.id,
      status: status,
      interval: config.interval,
      pauseOnBackground: config.pauseOnBackground,
      immediate: config.immediate,
      maxCount: config.maxCount,
      count: count,
      lastTriggerTime: count > 0 ? lastTime : null,
      nextTriggerTime: status == TimerStatus.running || status == TimerStatus.pending
          ? nextTrigger
          : null,
    );
  }
}

/// 定时器组管理器
///
/// 使用 isolate 防止阻塞主线程，通过时间切片优化性能
/// 支持前后台切换时暂停/恢复定时器
class TimerGroupManager {
  /// 单例实例
  static TimerGroupManager? _instance;

  /// 获取单例实例
  static TimerGroupManager get instance {
    _instance ??= TimerGroupManager._();
    return _instance!;
  }

  /// 私有构造函数
  TimerGroupManager._();

  /// Isolate 端口
  SendPort? _sendPort;

  /// 接收端口
  ReceivePort? _receivePort;

  /// Isolate
  Isolate? _isolate;

  /// 定时器 Stream 控制器
  final Map<String, StreamController<int>> _controllers = {};

  /// 查询响应端口
  final Map<String, Completer<TimerInfo>> _queryCompleters = {};

  /// 查询所有响应端口
  Completer<List<TimerInfo>>? _queryAllCompleter;

  /// 是否已初始化
  bool _initialized = false;

  /// 是否已初始化（公开访问）
  bool get initialized => _initialized;

  /// 应用生命周期状态
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  /// 初始化定时器管理器
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _timerIsolateEntry,
      _receivePort!.sendPort,
      debugName: 'TimerGroupManager',
    );

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _initialized = true;
      } else if (message is Map<String, dynamic>) {
        if (message.containsKey('type')) {
          final type = message['type'] as String;
          if (type == 'timerInfo') {
            // 单个定时器查询响应
            final id = message['id'] as String;
            final completer = _queryCompleters.remove(id);
            if (completer != null) {
              final timerInfo = TimerInfo.fromMap(message['data'] as Map<String, dynamic>);
              completer.complete(timerInfo);
            }
          } else if (type == 'timerInfoList') {
            // 所有定时器查询响应
            final completer = _queryAllCompleter;
            _queryAllCompleter = null;
            if (completer != null) {
              final list = (message['data'] as List<dynamic>)
                  .map((e) => TimerInfo.fromMap(e as Map<String, dynamic>))
                  .toList();
              completer.complete(list);
            }
          }
        } else {
          // 定时器触发消息
          final id = message['id'] as String;
          final count = message['count'] as int;
          _controllers[id]?.add(count);
        }
      }
    });

    _isolate!.addOnExitListener(_receivePort!.sendPort, response: 'shutdown');
  }

  /// 注册定时器
  ///
  /// [config] 定时器配置
  /// 返回 Reactive<int>，每次触发时发出执行次数
  Reactive<int> register(TimerConfig config) {
    if (!_initialized) {
      throw StateError('TimerGroupManager 未初始化，请先调用 initialize()');
    }

    final controller = StreamController<int>.broadcast();
    _controllers[config.id] = controller;

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.register,
      config: config,
    ));

    return Reactive(controller.stream);
  }

  /// 取消注册定时器
  ///
  /// [id] 定时器ID
  void unregister(String id) {
    if (!_initialized) {
      return;
    }

    _controllers[id]?.close();
    _controllers.remove(id);

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.unregister,
      id: id,
    ));
  }

  /// 暂停定时器
  ///
  /// [id] 定时器ID
  void pause(String id) {
    if (!_initialized) {
      return;
    }

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.pause,
      id: id,
    ));
  }

  /// 恢复定时器
  ///
  /// [id] 定时器ID
  void resume(String id) {
    if (!_initialized) {
      return;
    }

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.resume,
      id: id,
    ));
  }

  /// 查询定时器信息
  ///
  /// [id] 定时器ID
  /// 返回定时器信息，如果不存在则返回null
  Future<TimerInfo?> query(String id) async {
    if (!_initialized) {
      return null;
    }

    final completer = Completer<TimerInfo>();
    _queryCompleters[id] = completer;

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.query,
      id: id,
    ));

    try {
      final result = await completer.future.timeout(
        const Duration(seconds: 5),
      );
      return result;
    } on TimeoutException {
      _queryCompleters.remove(id);
      return null;
    } catch (e) {
      _queryCompleters.remove(id);
      return null;
    }
  }

  /// 查询所有定时器信息
  ///
  /// 返回所有定时器信息列表
  Future<List<TimerInfo>> queryAll() async {
    if (!_initialized) {
      return [];
    }

    if (_queryAllCompleter != null) {
      // 如果已有查询在进行，等待它完成
      return _queryAllCompleter!.future;
    }

    final completer = Completer<List<TimerInfo>>();
    _queryAllCompleter = completer;

    _sendPort?.send(TimerMessage(
      type: TimerMessageType.queryAll,
    ));

    try {
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _queryAllCompleter = null;
          return <TimerInfo>[];
        },
      );
    } catch (e) {
      _queryAllCompleter = null;
      return <TimerInfo>[];
    }
  }

  /// 处理应用生命周期变化
  ///
  /// [state] 应用生命周期状态
  void handleLifecycleChange(AppLifecycleState state) {
    if (!_initialized) {
      return;
    }

    final wasBackground = _lifecycleState == AppLifecycleState.paused ||
        _lifecycleState == AppLifecycleState.inactive ||
        _lifecycleState == AppLifecycleState.detached;
    final isBackground = state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached;

    _lifecycleState = state;

    if (wasBackground && !isBackground) {
      // 从后台切换到前台
      _sendPort?.send(TimerMessage(type: TimerMessageType.resumeAll));
    } else if (!wasBackground && isBackground) {
      // 从前台切换到后台
      _sendPort?.send(TimerMessage(type: TimerMessageType.pauseAll));
    }
  }

  /// 关闭定时器管理器
  Future<void> shutdown() async {
    if (!_initialized) {
      return;
    }

    _sendPort?.send(TimerMessage(type: TimerMessageType.shutdown));

    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();

    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);

    _sendPort = null;
    _receivePort = null;
    _isolate = null;
    _initialized = false;
  }

  /// 定时器 Isolate 入口点
  static void _timerIsolateEntry(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    final timers = <String, _TimerInfo>{};
    bool isPaused = false;

    // 时间切片配置
    const timeSlice = Duration(milliseconds: 10); // 每个时间切片10ms

    receivePort.listen((message) {
      if (message is TimerMessage) {
        switch (message.type) {
          case TimerMessageType.register:
            if (message.config != null) {
              final config = message.config!;
              final now = DateTime.now();
              final info = _TimerInfo(
                config: config,
                lastTime: now,
                count: 0,
                paused: false,
                registerTime: now,
              );
              timers[config.id] = info;

              // 如果立即执行
              if (config.immediate) {
                sendPort.send({
                  'id': config.id,
                  'count': 0,
                });
                info.count++;
                info.lastTime = DateTime.now();
              }
            }
            break;

          case TimerMessageType.unregister:
            if (message.id != null) {
              timers.remove(message.id);
            }
            break;

          case TimerMessageType.pause:
            if (message.id != null) {
              timers[message.id]?.paused = true;
            }
            break;

          case TimerMessageType.resume:
            if (message.id != null) {
              final info = timers[message.id];
              if (info != null) {
                info.paused = false;
                info.lastTime = DateTime.now(); // 重置时间，避免立即触发
              }
            }
            break;

          case TimerMessageType.pauseAll:
            isPaused = true;
            for (final info in timers.values) {
              if (info.config.pauseOnBackground) {
                info.paused = true;
              }
            }
            break;

          case TimerMessageType.resumeAll:
            isPaused = false;
            final now = DateTime.now();
            for (final info in timers.values) {
              if (info.config.pauseOnBackground) {
                info.paused = false;
                info.lastTime = now; // 重置时间，避免立即触发
              }
            }
            break;

          case TimerMessageType.query:
            if (message.id != null) {
              final info = timers[message.id!];
              if (info != null) {
                sendPort.send({
                  'type': 'timerInfo',
                  'id': message.id,
                  'data': info.toTimerInfo().toMap(),
                });
              } else {
                // 定时器不存在，返回idle状态
                sendPort.send({
                  'type': 'timerInfo',
                  'id': message.id,
                  'data': TimerInfo(
                    id: message.id!,
                    status: TimerStatus.idle,
                    interval: const Duration(seconds: 1),
                    pauseOnBackground: false,
                    immediate: false,
                    count: 0,
                  ).toMap(),
                });
              }
            }
            break;

          case TimerMessageType.queryAll:
            final timerInfoList = timers.values
                .map((info) => info.toTimerInfo().toMap())
                .toList();
            sendPort.send({
              'type': 'timerInfoList',
              'data': timerInfoList,
            });
            break;

          case TimerMessageType.shutdown:
            timers.clear();
            receivePort.close();
            break;
        }
      }
    });

    // 定时器循环（时间切片）
    Timer.periodic(timeSlice, (timer) {
      if (isPaused && timers.values.every((info) => info.config.pauseOnBackground)) {
        return; // 所有定时器都在后台暂停，跳过
      }

      final now = DateTime.now();

      // 处理每个定时器
      final toRemove = <String>[];
      for (final entry in timers.entries) {
        final id = entry.key;
        final info = entry.value;

        // 跳过暂停的定时器
        if (info.paused || (isPaused && info.config.pauseOnBackground)) {
          continue;
        }

        // 检查是否到达触发时间
        final elapsed = now.difference(info.lastTime);
        if (elapsed >= info.config.interval) {
          // 检查最大执行次数
          if (info.config.maxCount != null && info.count >= info.config.maxCount!) {
            toRemove.add(id);
            continue;
          }

          // 触发定时器
          sendPort.send({
            'id': id,
            'count': info.count,
          });

          info.count++;
          info.lastTime = now;
        }
      }

      // 移除已完成的定时器
      for (final id in toRemove) {
        timers.remove(id);
      }
    });
  }
}
