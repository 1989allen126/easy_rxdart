import 'dart:async';

import 'package:uuid/uuid.dart';

import 'timer_config.dart';
import 'timer_group_manager.dart';

/// Easy Timer
/// 支持自动暂停功能（enabledAutoPause）
class EasyTimer {
  /// 定时器ID（自动生成）
  final String id;

  /// 定时器间隔
  final Duration interval;

  /// 是否周期性定时器
  final bool isPeriodic;

  /// 是否支持自动暂停（在后台时自动暂停）
  final bool enabledAutoPause;

  /// 回调函数
  final void Function(EasyTimer timer)? _callback;

  /// 订阅
  StreamSubscription<int>? _subscription;

  /// 是否已取消
  bool _isCancelled = false;

  /// 是否已取消
  bool get isActive => !_isCancelled;

  /// 是否正在运行
  bool get isRunning => _subscription != null && !_isCancelled;

  /// 私有构造函数
  EasyTimer._({
    String? id,
    required this.interval,
    required this.isPeriodic,
    this.enabledAutoPause = false,
    void Function(EasyTimer timer)? callback,
  })  : id = id ?? const Uuid().v4(),
        _callback = callback {
    _start();
  }

  /// 创建单次定时器（与原生Timer API一致）
  ///
  /// [duration] 延迟时间
  /// [callback] 回调函数
  /// [enabledAutoPause] 是否支持自动暂停（在后台时自动暂停，默认false）
  factory EasyTimer(
    Duration duration,
    void Function(EasyTimer timer) callback, {
    bool enabledAutoPause = false,
  }) {
    return EasyTimer._(
      interval: duration,
      isPeriodic: false,
      enabledAutoPause: enabledAutoPause,
      callback: callback,
    );
  }

  /// 创建周期性定时器（与原生Timer.periodic API一致）
  ///
  /// [duration] 定时器间隔
  /// [callback] 回调函数，参数为定时器本身
  /// [enabledAutoPause] 是否支持自动暂停（在后台时自动暂停，默认false）
  factory EasyTimer.periodic(
    Duration duration,
    void Function(EasyTimer timer) callback, {
    bool enabledAutoPause = false,
  }) {
    return EasyTimer._(
      interval: duration,
      isPeriodic: true,
      enabledAutoPause: enabledAutoPause,
      callback: callback,
    );
  }

  /// 启动定时器
  void _start() {
    if (_isCancelled) {
      return;
    }

    final manager = TimerGroupManager.instance;
    if (!manager.initialized) {
      manager.initialize();
    }

    // 注册定时器
    final reactive = manager.register(
      TimerConfig(
        id: id,
        interval: interval,
        immediate: !isPeriodic, // 单次定时器立即执行，周期性定时器不立即执行
        maxCount: isPeriodic ? null : 1, // 单次定时器只执行1次，周期性定时器无限次
        pauseOnBackground: enabledAutoPause, // 使用enabledAutoPause控制是否在后台暂停
        callback: (id, count) {
          // 回调在Isolate中执行，这里不需要处理
        },
      ),
    );

    // 监听定时器触发
    _subscription = reactive.listen((count) {
      if (_isCancelled || _callback == null) {
        return;
      }

      try {
        _callback!(this);
      } catch (e) {
        // 回调异常不影响定时器继续运行
      }

      // 单次定时器执行后自动取消
      if (!isPeriodic) {
        cancel();
      }
    });
  }

  /// 取消定时器（与原生Timer API一致）
  void cancel() {
    if (_isCancelled) {
      return;
    }

    _isCancelled = true;

    // 取消订阅
    _subscription?.cancel();
    _subscription = null;

    // 从管理器注销
    TimerGroupManager.instance.unregister(id);
  }

  /// 暂停定时器
  void pause() {
    if (_isCancelled) {
      return;
    }
    TimerGroupManager.instance.pause(id);
  }

  /// 恢复定时器
  void resume() {
    if (_isCancelled) {
      return;
    }
    TimerGroupManager.instance.resume(id);
  }
}
