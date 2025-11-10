import 'package:flutter/material.dart';
import 'dart:async';
import 'model.dart';
import 'easy_model_widget.dart';

/// Consumer Hook，类似于Riverpod的Hook
///
/// 提供对Model的访问，可以在Hook中使用
///
/// ### 示例
///
/// ```
/// final counter = context.watch<CounterModel>();
/// ```
extension EasyConsumerHook on BuildContext {
  /// 监听Model变化（会触发重建）
  ///
  /// 返回Model实例，如果未找到则返回null
  T? watch<T extends Model>() {
    return EasyModel.watch<T>(this);
  }

  /// 读取Model（不会触发重建）
  ///
  /// 返回Model实例，如果未找到则返回null
  T? read<T extends Model>() {
    return EasyModel.read<T>(this);
  }

  /// 监听Model变化（用于副作用，不会触发重建）
  ///
  /// [callback] 当Model变化时调用的回调函数
  ///
  /// 返回StreamSubscription，可以用于取消订阅
  StreamSubscription<T> listen<T extends Model>(
    void Function(T model) callback,
  ) {
    return EasyModel.listen<T>(this, callback);
  }
}
