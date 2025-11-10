/// EasyModel状态管理模块
///
/// 提供类似Riverpod的状态管理方案，支持watch、read、listen等操作
library easy_model;

// 导出基础类
export 'model.dart';
export 'easy_model_error.dart';

// 导出状态相关类
export 'easy_state_status.dart';
export 'easy_state.dart';
export 'easy_state_model.dart';

// 导出Widget相关类
export 'easy_model_widget.dart';
export 'easy_model_descendant.dart';

// 导出Consumer相关类
export 'easy_consumer_ref.dart';
export 'easy_consumer.dart';
export 'easy_consumer_widget.dart';
export 'easy_consumer_builder.dart';
export 'easy_consumer_state_builder.dart';
export 'easy_consumer_hook.dart';

// 导出模型管理器
export 'easy_model_manager.dart';
