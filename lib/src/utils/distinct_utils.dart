import 'dart:async';

import 'package:flutter/material.dart';

/// 去重工具类
class DistinctUtils {
  /// 创建去重函数
  ///
  /// [callback] 回调函数
  /// [equals] 相等性比较函数
  /// 返回去重后的函数
  static void Function(T) distinctFunction<T>(
    void Function(T) callback, {
    bool Function(T, T)? equals,
  }) {
    T? lastValue;
    return (T value) {
      if (lastValue == null) {
        // 第一次调用，直接执行
        lastValue = value;
        callback(value);
      } else {
        // 后续调用，需要比较
        final isEqual = equals != null
            ? equals(lastValue!, value)
            : lastValue == value;
        if (!isEqual) {
          lastValue = value;
          callback(value);
        }
      }
    };
  }

  /// 创建去重函数（无参数）
  ///
  /// [callback] 回调函数
  /// 返回去重后的函数
  static VoidCallback distinctVoid(
    VoidCallback callback,
  ) {
    bool lastCalled = false;
    return () {
      if (!lastCalled) {
        lastCalled = true;
        callback();
      }
    };
  }

  /// 创建去重函数（异步）
  ///
  /// [callback] 异步回调函数
  /// [equals] 相等性比较函数
  /// 返回去重后的异步函数
  static Future<void> Function(T) distinctAsync<T>(
    Future<void> Function(T) callback, {
    bool Function(T, T)? equals,
  }) {
    T? lastValue;
    return (T value) async {
      if (lastValue == null) {
        // 第一次调用，直接执行
        lastValue = value;
        await callback(value);
      } else {
        // 后续调用，需要比较
        final isEqual = equals != null
            ? equals(lastValue!, value)
            : lastValue == value;
        if (!isEqual) {
          lastValue = value;
          await callback(value);
        }
      }
    };
  }

  /// 创建去重控制器
  ///
  /// [equals] 相等性比较函数
  /// 返回去重控制器
  static DistinctController<T> createController<T>({
    bool Function(T, T)? equals,
  }) {
    return DistinctController<T>(equals: equals);
  }
}

/// 去重控制器
class DistinctController<T> {
  /// 相等性比较函数
  final bool Function(T, T)? equals;

  /// 上次的值
  T? _lastValue;

  /// 回调函数
  void Function(T)? _callback;

  /// 构造函数
  DistinctController({this.equals});

  /// 设置回调函数
  void setCallback(void Function(T) callback) {
    _callback = callback;
  }

  /// 触发去重
  void trigger(T value) {
    if (_lastValue == null) {
      // 第一次调用，直接执行
      _lastValue = value;
      _callback?.call(value);
    } else {
      // 后续调用，需要比较
      final isEqual = equals != null
          ? equals!(_lastValue!, value)
          : _lastValue == value;
      if (!isEqual) {
        _lastValue = value;
        _callback?.call(value);
      }
    }
  }

  /// 重置去重
  void reset() {
    _lastValue = null;
  }

  /// 释放资源
  void dispose() {
    _lastValue = null;
    _callback = null;
  }
}
