import 'package:uuid/uuid.dart';

/// 定时器配置
class TimerConfig {
  /// 定时器ID（UUID）
  final String id;

  /// 定时器间隔
  final Duration interval;

  /// 是否在后台暂停
  final bool pauseOnBackground;

  /// 是否立即执行第一次
  final bool immediate;

  /// 最大执行次数（null表示无限）
  final int? maxCount;

  /// 定时器回调
  final void Function(String id, int count) callback;

  /// 构造函数
  TimerConfig({
    String? id,
    required this.interval,
    this.pauseOnBackground = true,
    this.immediate = false,
    this.maxCount,
    required this.callback,
  }) : id = id ?? const Uuid().v4();

  /// 创建副本
  TimerConfig copyWith({
    String? id,
    Duration? interval,
    bool? pauseOnBackground,
    bool? immediate,
    int? maxCount,
    void Function(String id, int count)? callback,
  }) {
    return TimerConfig(
      id: id ?? this.id,
      interval: interval ?? this.interval,
      pauseOnBackground: pauseOnBackground ?? this.pauseOnBackground,
      immediate: immediate ?? this.immediate,
      maxCount: maxCount ?? this.maxCount,
      callback: callback ?? this.callback,
    );
  }
}
