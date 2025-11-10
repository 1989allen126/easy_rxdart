import 'dart:async';
import '../../core/easy_subject.dart';

/// Future扩展
extension FutureExtensions<T> on Future<T> {
  /// 转换为Stream
  ///
  /// 返回Stream<T>
  Stream<T> toStream() {
    return Stream.fromFuture(this);
  }

  /// 转换为EasyBehaviorSubject
  ///
  /// 返回EasyBehaviorSubject<T>
  EasyBehaviorSubject<T> toBehaviorSubject() {
    final subject = EasyBehaviorSubject<T>();
    then((value) => subject.add(value)).catchError((error) {
      subject.addError(error);
    });
    return subject;
  }

  /// 转换为EasyReplaySubject
  ///
  /// 返回EasyReplaySubject<T>
  EasyReplaySubject<T> toReplaySubject() {
    final subject = EasyReplaySubject<T>();
    then((value) => subject.add(value)).catchError((error) {
      subject.addError(error);
    });
    return subject;
  }

  /// 带超时的Future
  ///
  /// [timeout] 超时时间
  /// [onTimeout] 超时回调
  /// 返回带超时的Future
  Future<T> withTimeout(
    Duration timeout, {
    FutureOr<T> Function()? onTimeout,
  }) {
    return this.timeout(timeout, onTimeout: onTimeout);
  }

  /// 带重试的Future
  ///
  /// [retryCount] 重试次数
  /// [retryDelay] 重试延迟
  /// 返回带重试的Future
  Future<T> withRetry({
    int retryCount = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) {
    Future<T> attempt() async {
      try {
        return await this;
      } catch (e) {
        if (retryCount > 0) {
          await Future.delayed(retryDelay);
          return attempt();
        }
        rethrow;
      }
    }
    return attempt();
  }

  /// 带延迟的Future
  ///
  /// [delay] 延迟时间
  /// 返回带延迟的Future
  Future<T> withDelay(Duration delay) {
    return Future.delayed(delay).then((_) => this);
  }

  /// 带缓存的Future
  ///
  /// 缓存Future的结果，后续调用直接返回缓存值
  /// 返回带缓存的Future
  Future<T> cached() {
    T? cachedValue;
    Object? cachedError;
    bool isCompleted = false;
    final completer = Completer<T>();

    then((value) {
      cachedValue = value;
      isCompleted = true;
      if (!completer.isCompleted) {
        completer.complete(value);
      }
    }).catchError((error) {
      cachedError = error;
      isCompleted = true;
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    // 如果已经完成，直接返回缓存的结果
    if (isCompleted) {
      if (cachedError != null) {
        return Future<T>.error(cachedError!);
      }
      if (cachedValue != null) {
        return Future<T>.value(cachedValue!);
      }
    }

    return completer.future;
  }
}

/// Future工具类
class FutureUtils {
  /// 等待所有Future完成
  ///
  /// [futures] Future列表
  /// 返回所有结果的Future
  static Future<List<T>> waitAll<T>(List<Future<T>> futures) {
    return Future.wait(futures);
  }

  /// 等待任意一个Future完成
  ///
  /// [futures] Future列表
  /// 返回第一个完成的结果的Future
  static Future<T> waitAny<T>(List<Future<T>> futures) {
    final completer = Completer<T>();
    for (final future in futures) {
      future.then((value) {
        if (!completer.isCompleted) {
          completer.complete(value);
        }
      }).catchError((error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      });
    }
    return completer.future;
  }

  /// 创建延迟Future
  ///
  /// [value] 值
  /// [delay] 延迟时间
  /// 返回延迟后的Future
  static Future<T> delayed<T>(T value, Duration delay) {
    return Future.delayed(delay, () => value);
  }

  /// 创建错误Future
  ///
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// 返回包含错误的Future
  static Future<T> error<T>(Object error, [StackTrace? stackTrace]) {
    return Future.error(error, stackTrace);
  }

  /// 创建值Future
  ///
  /// [value] 值
  /// 返回包含值的Future
  static Future<T> value<T>(T value) {
    return Future.value(value);
  }
}
