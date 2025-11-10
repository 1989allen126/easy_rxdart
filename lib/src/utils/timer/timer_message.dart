import 'timer_config.dart';

/// 定时器管理器消息类型
enum TimerMessageType {
  /// 注册定时器
  register('register'),
  /// 取消注册定时器
  unregister('unregister'),
  /// 暂停定时器
  pause('pause'),
  /// 恢复定时器
  resume('resume'),
  /// 暂停所有定时器（后台）
  pauseAll('pauseAll'),
  /// 恢复所有定时器（前台）
  resumeAll('resumeAll'),
  /// 查询定时器信息
  query('query'),
  /// 查询所有定时器信息
  queryAll('queryAll'),
  /// 关闭管理器
  shutdown('shutdown');

  /// 消息类型名称
  final String name;

  /// 构造函数
  const TimerMessageType(this.name);

  /// 从名称创建
  static TimerMessageType? fromName(String name) {
    for (final type in TimerMessageType.values) {
      if (type.name == name) {
        return type;
      }
    }
    return null;
  }

  /// 从索引创建
  static TimerMessageType? fromIndex(int index) {
    if (index >= 0 && index < TimerMessageType.values.length) {
      return TimerMessageType.values[index];
    }
    return null;
  }
}

/// 定时器管理器消息
class TimerMessage {
  /// 消息类型
  final TimerMessageType type;

  /// 定时器ID
  final String? id;

  /// 定时器配置
  final TimerConfig? config;

  /// 构造函数
  TimerMessage({
    required this.type,
    this.id,
    this.config,
  });
}
