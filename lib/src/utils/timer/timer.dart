/// 定时器模块
///
/// 提供定时器组管理器，使用 isolate 防止阻塞主线程
/// 支持时间切片优化性能，支持前后台切换时暂停/恢复
library timer;

// 导出定时器状态
export 'timer_status.dart';

// 导出定时器信息
export 'timer_info.dart';

// 导出定时器配置
export 'timer_config.dart';

// 导出定时器消息
export 'timer_message.dart';

// 导出定时器组管理器
export 'timer_group_manager.dart';

// 导出定时器工具类
export 'timer_utils.dart';

// 导出EasyTimer
export 'easy_timer.dart';

