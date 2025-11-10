import 'dart:async';
import 'package:flutter/foundation.dart';

/// 限流工具类
class ThrottleUtils {
  /// 创建限流函数
  ///
  /// [callback] 回调函数
  /// [duration] 限流时间间隔
  /// 返回限流后的函数
  static void Function(T) throttleFunction<T>(
    void Function(T) callback,
    Duration duration,
  ) {
    DateTime? lastCallTime;
    return (T value) {
      final now = DateTime.now();
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        callback(value);
      }
    };
  }

  /// 创建限流函数（无参数）
  ///
  /// [callback] 回调函数
  /// [duration] 限流时间间隔
  /// 返回限流后的函数
  static VoidCallback throttleVoid(
    VoidCallback callback,
    Duration duration,
  ) {
    DateTime? lastCallTime;
    return () {
      final now = DateTime.now();
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// 创建限流函数（异步）
  ///
  /// [callback] 异步回调函数
  /// [duration] 限流时间间隔
  /// 返回限流后的异步函数
  static Future<void> Function(T) throttleAsync<T>(
    Future<void> Function(T) callback,
    Duration duration,
  ) {
    DateTime? lastCallTime;
    return (T value) async {
      final now = DateTime.now();
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        await callback(value);
      }
    };
  }

  /// 创建限流函数（异步无参数）
  ///
  /// [callback] 异步回调函数
  /// [duration] 限流时间间隔
  /// 返回限流后的异步函数
  static Future<void> Function() throttleAsyncVoid(
    Future<void> Function() callback,
    Duration duration,
  ) {
    DateTime? lastCallTime;
    return () async {
      final now = DateTime.now();
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        await callback();
      }
    };
  }

  /// 创建限流控制器
  ///
  /// [duration] 限流时间间隔
  /// 返回限流控制器
  static ThrottleController<T> createController<T>(Duration duration) {
    return ThrottleController<T>(duration);
  }
}

/// 限流控制器
class ThrottleController<T> {
  /// 限流时间间隔
  final Duration duration;

  /// 上次调用时间
  DateTime? _lastCallTime;

  /// 回调函数
  void Function(T)? _callback;

  /// 构造函数
  ThrottleController(this.duration);

  /// 设置回调函数
  void setCallback(void Function(T) callback) {
    _callback = callback;
  }

  /// 触发限流
  void trigger(T value) {
    final now = DateTime.now();
    if (_lastCallTime == null ||
        now.difference(_lastCallTime!) >= duration) {
      _lastCallTime = now;
      _callback?.call(value);
    }
  }

  /// 重置限流
  void reset() {
    _lastCallTime = null;
  }

  /// 释放资源
  void dispose() {
    _lastCallTime = null;
    _callback = null;
  }
}
