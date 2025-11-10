import 'dart:async';
import 'package:dio/dio.dart';
import '../../core/reactive.dart';
import '../../core/reactive_utils.dart';
import '../stream/stream_controller_extensions.dart';

/// Dio响应式扩展
extension DioReactiveX on Dio {
  /// GET请求响应式封装
  Reactive<Response<T>> getX<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    final controller = StreamController<Response<T>>.broadcast();

    get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then((response) {
      controller.emit(response);
      controller.close();
    }).catchError((error) {
      controller.emitError(error);
      controller.close();
    });

    return controller.asReactive();
  }

  /// POST请求响应式封装
  Reactive<Response<T>> postX<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    final controller = StreamController<Response<T>>.broadcast();

    post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then((response) {
      controller.emit(response);
      controller.close();
    }).catchError((error) {
      controller.emitError(error);
      controller.close();
    });

    return controller.asReactive();
  }
}

/// 响应数据处理扩展
extension ResponseReactiveX<T> on Reactive<Response<T>> {
  /// 提取data并转换类型
  Reactive<R> mapData<R>(R Function(T) mapper) {
    return ReactiveUtils.whereNotNull(
      map((response) => mapper(response.data!)),
    );
  }

  /// 处理网络错误
  Reactive<Response<T>> handleError(void Function(DioException) onError) {
    return Reactive(
      stream.handleError((error) {
        if (error is DioException) {
          onError(error);
        }
      }),
    );
  }
}
