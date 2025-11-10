import 'dart:async';
import '../core/reactive.dart';
import '../extensions/stream/stream_controller_extensions.dart';

/// Future组合工具类
class FutureCombineUtils {
  /// 组合多个Future（类似Future.wait，但提供更详细的信息）
  ///
  /// [futures] Future列表
  /// [onData] 数据回调函数，参数为所有Future的结果列表
  /// [onError] 错误回调函数，参数为错误对象和索引
  /// [onComplete] 完成回调函数
  /// 返回Reactive<List<T>>
  static Reactive<List<T>> combine<T>(
    List<Future<T>> futures, {
    void Function(List<T>)? onData,
    void Function(Object error, int index)? onError,
    void Function()? onComplete,
  }) {
    final controller = StreamController<List<T>>.broadcast();
    final results = <T?>[];
    final errors = <Object?>[];
    int completedCount = 0;
    final totalCount = futures.length;

    // 初始化结果列表
    for (int i = 0; i < totalCount; i++) {
      results.add(null);
      errors.add(null);
    }

    // 处理每个Future
    for (int i = 0; i < futures.length; i++) {
      final index = i;
      futures[i].then((value) {
        results[index] = value;
        completedCount++;

        // 检查是否所有Future都完成
        if (completedCount == totalCount) {
          // 检查是否有错误
          final hasError = errors.any((error) => error != null);
          if (!hasError) {
            // 所有Future都成功
            final data = results.cast<T>();
            controller.emit(data);
            onData?.call(data);
            onComplete?.call();
            controller.close();
          }
        }
      }).catchError((error) {
        errors[index] = error;
        completedCount++;
        onError?.call(error, index);

        // 检查是否所有Future都完成
        if (completedCount == totalCount) {
          // 有错误，发射错误信息
          final hasSuccess = results.any((result) => result != null);
          if (!hasSuccess) {
            // 所有Future都失败
            controller.close();
            onComplete?.call();
          }
        }
      });
    }

    return controller.asReactive();
  }

  /// 组合两个Future
  ///
  /// [future1] 第一个Future
  /// [future2] 第二个Future
  /// [onData] 数据回调函数，参数为两个Future的结果
  /// [onError] 错误回调函数，参数为错误对象和Future索引（1或2）
  /// [onComplete] 完成回调函数
  /// 返回Reactive<(T1, T2)>
  static Reactive<(T1, T2)> combine2<T1, T2>(
    Future<T1> future1,
    Future<T2> future2, {
    void Function(T1, T2)? onData,
    void Function(Object error, int index)? onError,
    void Function()? onComplete,
  }) {
    final controller = StreamController<(T1, T2)>.broadcast();
    T1? result1;
    T2? result2;
    Object? error1;
    Object? error2;
    bool completed1 = false;
    bool completed2 = false;

    // 处理第一个Future
    future1.then((value) {
      result1 = value;
      completed1 = true;
      if (completed1 && completed2 && error1 == null && error2 == null) {
        final data = (result1!, result2!);
        controller.emit(data);
        onData?.call(result1!, result2!);
        onComplete?.call();
        controller.close();
      }
    }).catchError((error) {
      error1 = error;
      completed1 = true;
      onError?.call(error, 1);
      if (completed1 && completed2) {
        controller.close();
        onComplete?.call();
      }
    });

    // 处理第二个Future
    future2.then((value) {
      result2 = value;
      completed2 = true;
      if (completed1 && completed2 && error1 == null && error2 == null) {
        final data = (result1!, result2!);
        controller.emit(data);
        onData?.call(result1!, result2!);
        onComplete?.call();
        controller.close();
      }
    }).catchError((error) {
      error2 = error;
      completed2 = true;
      onError?.call(error, 2);
      if (completed1 && completed2) {
        controller.close();
        onComplete?.call();
      }
    });

    return controller.asReactive();
  }

  /// 组合三个Future
  ///
  /// [future1] 第一个Future
  /// [future2] 第二个Future
  /// [future3] 第三个Future
  /// [onData] 数据回调函数，参数为三个Future的结果
  /// [onError] 错误回调函数，参数为错误对象和Future索引（1、2或3）
  /// [onComplete] 完成回调函数
  /// 返回Reactive<(T1, T2, T3)>
  static Reactive<(T1, T2, T3)> combine3<T1, T2, T3>(
    Future<T1> future1,
    Future<T2> future2,
    Future<T3> future3, {
    void Function(T1, T2, T3)? onData,
    void Function(Object error, int index)? onError,
    void Function()? onComplete,
  }) {
    final controller = StreamController<(T1, T2, T3)>.broadcast();
    T1? result1;
    T2? result2;
    T3? result3;
    Object? error1;
    Object? error2;
    Object? error3;
    bool completed1 = false;
    bool completed2 = false;
    bool completed3 = false;

    // 检查所有Future是否完成
    void checkComplete() {
      if (completed1 && completed2 && completed3) {
        if (error1 == null && error2 == null && error3 == null) {
          final data = (result1!, result2!, result3!);
          controller.emit(data);
          onData?.call(result1!, result2!, result3!);
          onComplete?.call();
          controller.close();
        } else {
          controller.close();
          onComplete?.call();
        }
      }
    }

    // 处理第一个Future
    future1.then((value) {
      result1 = value;
      completed1 = true;
      checkComplete();
    }).catchError((error) {
      error1 = error;
      completed1 = true;
      onError?.call(error, 1);
      checkComplete();
    });

    // 处理第二个Future
    future2.then((value) {
      result2 = value;
      completed2 = true;
      checkComplete();
    }).catchError((error) {
      error2 = error;
      completed2 = true;
      onError?.call(error, 2);
      checkComplete();
    });

    // 处理第三个Future
    future3.then((value) {
      result3 = value;
      completed3 = true;
      checkComplete();
    }).catchError((error) {
      error3 = error;
      completed3 = true;
      onError?.call(error, 3);
      checkComplete();
    });

    return controller.asReactive();
  }

  /// 组合多个Future（等待所有成功）
  ///
  /// [futures] Future列表
  /// [onData] 数据回调函数
  /// [onError] 错误回调函数
  /// [onComplete] 完成回调函数
  /// 返回Reactive<List<T>>
  static Reactive<List<T>> combineAll<T>(
    List<Future<T>> futures, {
    void Function(List<T>)? onData,
    void Function(Object error, int index)? onError,
    void Function()? onComplete,
  }) {
    return combine(
      futures,
      onData: onData,
      onError: onError,
      onComplete: onComplete,
    );
  }

  /// 组合多个Future（任意一个成功即可）
  ///
  /// [futures] Future列表
  /// [onData] 数据回调函数，参数为第一个成功的Future结果和索引
  /// [onError] 错误回调函数
  /// [onComplete] 完成回调函数
  /// 返回Reactive<(T, int)>
  static Reactive<(T, int)> combineAny<T>(
    List<Future<T>> futures, {
    void Function(T, int)? onData,
    void Function(Object error, int index)? onError,
    void Function()? onComplete,
  }) {
    final controller = StreamController<(T, int)>.broadcast();
    bool hasSuccess = false;

    for (int i = 0; i < futures.length; i++) {
      final index = i;
      futures[i].then((value) {
        if (!hasSuccess) {
          hasSuccess = true;
          final data = (value, index);
          controller.emit(data);
          onData?.call(value, index);
          onComplete?.call();
          controller.close();
        }
      }).catchError((error) {
        onError?.call(error, index);
        // 检查是否所有Future都失败
        if (!hasSuccess && index == futures.length - 1) {
          // 这里需要更复杂的逻辑来判断所有Future是否都失败
          // 简化处理：如果最后一个Future也失败，则关闭
          controller.close();
          onComplete?.call();
        }
      });
    }

    return controller.asReactive();
  }
}
