import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// 防抖工具类
class DebounceUtils {
  /// 创建防抖Stream
  ///
  /// [source] 源Stream
  /// [duration] 防抖时间间隔
  /// 返回防抖后的Stream
  static Stream<T> debounce<T>(Stream<T> source, Duration duration) {
    return source.debounceTime(duration);
  }

  /// 创建防抖函数
  ///
  /// [callback] 回调函数
  /// [duration] 防抖时间间隔
  /// 返回防抖后的函数
  static void Function(T) debounceFunction<T>(
    void Function(T) callback,
    Duration duration,
  ) {
    Timer? timer;
    return (T value) {
      timer?.cancel();
      timer = Timer(duration, () => callback(value));
    };
  }

  /// 创建防抖函数（无参数）
  ///
  /// [callback] 回调函数
  /// [duration] 防抖时间间隔
  /// 返回防抖后的函数
  static VoidCallback debounceVoid(
    VoidCallback callback,
    Duration duration,
  ) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(duration, callback);
    };
  }

  /// 创建防抖函数（异步）
  ///
  /// [callback] 异步回调函数
  /// [duration] 防抖时间间隔
  /// 返回防抖后的异步函数
  static Future<void> Function(T) debounceAsync<T>(
    Future<void> Function(T) callback,
    Duration duration,
  ) {
    Timer? timer;
    Completer<void>? completer;
    return (T value) async {
      timer?.cancel();
      if (completer != null && !completer!.isCompleted) {
        completer!.complete();
      }
      completer = Completer<void>();
      timer = Timer(duration, () {
        callback(value).then((_) {
          if (!completer!.isCompleted) {
            completer!.complete();
          }
        }).catchError((error) {
          if (!completer!.isCompleted) {
            completer!.completeError(error);
          }
        });
      });
      return completer!.future;
    };
  }

  /// 创建防抖函数（异步无参数）
  ///
  /// [callback] 异步回调函数
  /// [duration] 防抖时间间隔
  /// 返回防抖后的异步函数
  static Future<void> Function() debounceAsyncVoid(
    Future<void> Function() callback,
    Duration duration,
  ) {
    Timer? timer;
    Completer<void>? completer;
    return () async {
      timer?.cancel();
      if (completer != null && !completer!.isCompleted) {
        completer!.complete();
      }
      completer = Completer<void>();
      timer = Timer(duration, () {
        callback().then((_) {
          if (!completer!.isCompleted) {
            completer!.complete();
          }
        }).catchError((error) {
          if (!completer!.isCompleted) {
            completer!.completeError(error);
          }
        });
      });
      return completer!.future;
    };
  }

  /// 创建防抖控制器
  ///
  /// [duration] 防抖时间间隔
  /// 返回防抖控制器
  static DebounceController<T> createController<T>(Duration duration) {
    return DebounceController<T>(duration);
  }
}

/// 防抖控制器
class DebounceController<T> {
  /// 防抖时间间隔
  final Duration duration;

  /// 定时器
  Timer? _timer;

  /// 回调函数
  void Function(T)? _callback;

  /// 构造函数
  DebounceController(this.duration);

  /// 设置回调函数
  void setCallback(void Function(T) callback) {
    _callback = callback;
  }

  /// 触发防抖
  void trigger(T value) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      _callback?.call(value);
    });
  }

  /// 取消防抖
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// 立即执行
  void flush() {
    _timer?.cancel();
    _timer = null;
  }

  /// 释放资源
  void dispose() {
    cancel();
    _callback = null;
  }
}
