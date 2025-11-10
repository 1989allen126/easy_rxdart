import 'dart:async';
import '../../core/reactive.dart';
import 'timer_config.dart';
import 'timer_group_manager.dart';
import 'timer_info.dart';

/// 定时器工具类
class TimerUtils {
  /// 创建定时器
  ///
  /// [interval] 定时器间隔
  /// [immediate] 是否立即执行第一次
  /// [maxCount] 最大执行次数（null表示无限）
  /// [pauseOnBackground] 是否在后台暂停
  /// [id] 定时器ID（可选，不提供则自动生成UUID）
  /// 返回 Reactive<int>，每次触发时发出执行次数
  static Reactive<int> create({
    required Duration interval,
    bool immediate = false,
    int? maxCount,
    bool pauseOnBackground = true,
    String? id,
  }) {
    final manager = TimerGroupManager.instance;
    if (!manager.initialized) {
      manager.initialize();
    }

    return manager.register(TimerConfig(
      id: id,
      interval: interval,
      immediate: immediate,
      maxCount: maxCount,
      pauseOnBackground: pauseOnBackground,
      callback: (id, count) {
        // 回调在 Isolate 中执行，这里不需要处理
      },
    ));
  }

  /// 取消定时器
  ///
  /// [id] 定时器ID
  static void cancel(String id) {
    TimerGroupManager.instance.unregister(id);
  }

  /// 暂停定时器
  ///
  /// [id] 定时器ID
  static void pause(String id) {
    TimerGroupManager.instance.pause(id);
  }

  /// 恢复定时器
  ///
  /// [id] 定时器ID
  static void resume(String id) {
    TimerGroupManager.instance.resume(id);
  }

  /// 查询定时器信息
  ///
  /// [id] 定时器ID
  /// 返回定时器信息，如果不存在则返回null
  static Future<TimerInfo?> query(String id) {
    return TimerGroupManager.instance.query(id);
  }

  /// 查询所有定时器信息
  ///
  /// 返回所有定时器信息列表
  static Future<List<TimerInfo>> queryAll() {
    return TimerGroupManager.instance.queryAll();
  }
}
