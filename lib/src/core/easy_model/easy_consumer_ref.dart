import 'dart:async';
import 'package:flutter/material.dart';
import 'model.dart';
import 'easy_model_widget.dart';

/// Consumer引用，用于在Consumer相关Widget中访问Model
///
/// 类似于Riverpod的WidgetRef，提供watch和read方法
class EasyConsumerRef {
  /// BuildContext
  final BuildContext context;

  /// 构造函数
  EasyConsumerRef(this.context);

  /// 监听Model变化（会触发重建）
  ///
  /// [rebuildOnChange] 是否在变化时重建，默认为true
  ///
  /// 返回Model实例，如果未找到则返回null
  T? watch<T extends Model>({bool rebuildOnChange = true}) {
    return EasyModel.watch<T>(context);
  }

  /// 读取Model（不会触发重建）
  ///
  /// 返回Model实例，如果未找到则返回null
  T? read<T extends Model>() {
    return EasyModel.read<T>(context);
  }

  /// 监听Model变化（用于副作用，不会触发重建）
  ///
  /// [callback] 当Model变化时调用的回调函数
  ///
  /// 返回StreamSubscription，可以用于取消订阅
  StreamSubscription<T> listen<T extends Model>(
    void Function(T model) callback,
  ) {
    return EasyModel.listen<T>(context, callback);
  }
}
