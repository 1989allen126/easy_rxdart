import 'timer_status.dart';

/// 定时器信息
class TimerInfo {
  /// 定时器ID
  final String id;

  /// 定时器状态
  final TimerStatus status;

  /// 定时器间隔
  final Duration interval;

  /// 是否在后台暂停
  final bool pauseOnBackground;

  /// 是否立即执行第一次
  final bool immediate;

  /// 最大执行次数（null表示无限）
  final int? maxCount;

  /// 当前执行次数
  final int count;

  /// 上次触发时间
  final DateTime? lastTriggerTime;

  /// 下次触发时间
  final DateTime? nextTriggerTime;

  /// 构造函数
  TimerInfo({
    required this.id,
    required this.status,
    required this.interval,
    required this.pauseOnBackground,
    required this.immediate,
    this.maxCount,
    required this.count,
    this.lastTriggerTime,
    this.nextTriggerTime,
  });

  /// 从Map创建
  factory TimerInfo.fromMap(Map<String, dynamic> map) {
    return TimerInfo(
      id: map['id'] as String,
      status: TimerStatus.values[map['status'] as int],
      interval: Duration(milliseconds: map['interval'] as int),
      pauseOnBackground: map['pauseOnBackground'] as bool,
      immediate: map['immediate'] as bool,
      maxCount: map['maxCount'] as int?,
      count: map['count'] as int,
      lastTriggerTime: map['lastTriggerTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastTriggerTime'] as int)
          : null,
      nextTriggerTime: map['nextTriggerTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextTriggerTime'] as int)
          : null,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.index,
      'interval': interval.inMilliseconds,
      'pauseOnBackground': pauseOnBackground,
      'immediate': immediate,
      'maxCount': maxCount,
      'count': count,
      'lastTriggerTime': lastTriggerTime?.millisecondsSinceEpoch,
      'nextTriggerTime': nextTriggerTime?.millisecondsSinceEpoch,
    };
  }
}
