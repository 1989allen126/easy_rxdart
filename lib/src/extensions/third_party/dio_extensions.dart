import 'dart:async';
import 'package:dio/dio.dart';

/// Dio扩展
extension DioExtensions on Dio {
  /// GET请求转换为Stream
  ///
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> getStream(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return Stream.fromFuture(
      get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// POST请求转换为Stream
  ///
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> postStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return Stream.fromFuture(
      post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// PUT请求转换为Stream
  ///
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> putStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return Stream.fromFuture(
      put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// DELETE请求转换为Stream
  ///
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> deleteStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return Stream.fromFuture(
      delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// PATCH请求转换为Stream
  ///
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> patchStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return Stream.fromFuture(
      patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// 请求转换为Stream（通用方法）
  ///
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// 返回Stream<Response>
  Stream<Response> requestStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return Stream.fromFuture(
      request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// 下载文件转换为Stream
  ///
  /// [urlPath] 下载URL
  /// [savePath] 保存路径
  /// [onReceiveProgress] 接收进度回调
  /// [options] 请求选项
  /// 返回Stream<Response>
  Stream<Response> downloadStream(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
    void Function(int, int)? onReceiveProgressValue,
  }) {
    return Stream.fromFuture(
      download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        options: options,
      ),
    );
  }
}

/// Response扩展
extension ResponseExtensions on Response {
  /// 转换为数据Stream
  ///
  /// [decoder] 解码函数，将响应数据转换为T
  /// 返回Stream<T>
  Stream<T> toDataStream<T>(T Function(dynamic) decoder) {
    return Stream.value(decoder(data));
  }

  /// 转换为JSON Stream
  ///
  /// 返回Stream<Map<String, dynamic>>
  Stream<Map<String, dynamic>> toJsonStream() {
    return Stream.value(data as Map<String, dynamic>);
  }

  /// 转换为列表Stream
  ///
  /// [decoder] 解码函数，将响应数据项转换为T
  /// 返回Stream<List<T>>
  Stream<List<T>> toListStream<T>(T Function(dynamic) decoder) {
    final list = (data as List).map((item) => decoder(item)).toList();
    return Stream.value(list);
  }
}

/// Dio错误扩展
extension DioErrorExtensions on DioException {
  /// 转换为错误Stream
  ///
  /// 返回Stream<DioException>
  Stream<DioException> toErrorStream() {
    return Stream.error(this);
  }

  /// 获取错误消息
  ///
  /// 返回错误消息字符串
  String getErrorMessage() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.sendTimeout:
        return '发送超时';
      case DioExceptionType.receiveTimeout:
        return '接收超时';
      case DioExceptionType.badResponse:
        return '响应错误: ${response?.statusCode}';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.unknown:
        return '未知错误: ${message ?? ''}';
      default:
        return '网络错误: ${message ?? ''}';
    }
  }
}
