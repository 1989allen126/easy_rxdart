/// 定时器状态
enum TimerStatus {
  /// 空闲状态（未注册）
  idle('idle'),
  /// 等待状态（已注册但未开始）
  pending('pending'),
  /// 运行中
  running('running'),
  /// 暂停
  pause('pause'),
  /// 已停止
  stop('stop');

  /// 状态名称
  final String name;

  /// 构造函数
  const TimerStatus(this.name);

  /// 从名称创建
  static TimerStatus? fromName(String name) {
    for (final status in TimerStatus.values) {
      if (status.name == name) {
        return status;
      }
    }
    return null;
  }

  /// 从索引创建
  static TimerStatus? fromIndex(int index) {
    if (index >= 0 && index < TimerStatus.values.length) {
      return TimerStatus.values[index];
    }
    return null;
  }
}
