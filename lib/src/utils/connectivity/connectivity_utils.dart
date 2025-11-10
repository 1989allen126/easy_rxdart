import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/reactive.dart';
import '../../extensions/stream/stream_extensions.dart';
import 'connectivity_status.dart';

/// 网络连接工具类
///
/// 提供网络状态监听功能，支持链式调用
class ConnectivityUtils {
  /// Connectivity实例
  static final Connectivity _connectivity = Connectivity();

  /// 网络状态流控制器
  static StreamController<NetworkInfo>? _controller;

  /// 网络状态流订阅
  static StreamSubscription? _subscription;

  /// 是否已初始化
  static bool _initialized = false;

  /// 监听网络状态变化（仅当状态改变时触发）
  ///
  /// [triggerFirst] 是否触发第一次
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> watchDistinctUntilChanged({bool triggerFirst = true}) {
    final stream = watch().stream;
    if (triggerFirst) {
      // 触发第一次，然后过滤重复值
      return Reactive(
        stream.distinctUntilChangedBy((prev, next) => prev.status == next.status),
      );
    } else {
      // 不触发第一次，直接过滤重复值
      return Reactive(
        stream.skip(1).distinctUntilChangedBy((prev, next) => prev.status == next.status),
      );
    }
  }

  /// 初始化网络监听
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> watch() {
    if (!_initialized) {
      _controller = StreamController<NetworkInfo>.broadcast();
      _subscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          final info = NetworkInfo.fromResult(result);
          _controller?.add(info);
        },
        onError: (error) {
          _controller?.addError(error);
        },
      );

      // 立即获取当前状态
      _connectivity.checkConnectivity().then((result) {
        final info = NetworkInfo.fromResult(result);
        _controller?.add(info);
      });

      _initialized = true;
    }

    return Reactive(_controller!.stream);
  }

  /// 获取当前网络状态
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> get current {
    return Reactive.fromFuture(
      _connectivity.checkConnectivity().then((result) {
        return NetworkInfo.fromResult(result);
      }),
    );
  }

  /// 检查是否已连接
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> isConnected() {
    return current.map((info) => info.isConnected);
  }

  /// 检查是否使用WiFi
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> isWifi() {
    return current.map((info) => info.isWifi);
  }

  /// 检查是否使用移动数据
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> isMobile() {
    return current.map((info) => info.isMobile);
  }

  /// 监听网络状态变化（仅当状态改变时触发）
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> watchChanges() {
    return Reactive(
      watch().stream.distinct((prev, next) => prev.status == next.status),
    );
  }

  /// 监听网络连接状态变化（仅当连接状态改变时触发）
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> watchConnection() {
    return Reactive(
      watch().stream.map((info) => info.isConnected).distinct(),
    );
  }

  /// 监听WiFi连接状态变化
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> watchWifi() {
    return Reactive(
      watch().stream.map((info) => info.isWifi).distinct(),
    );
  }

  /// 监听移动数据连接状态变化
  ///
  /// 返回Reactive<bool>，支持链式调用
  static Reactive<bool> watchMobile() {
    return Reactive(
      watch().stream.map((info) => info.isMobile).distinct(),
    );
  }

  /// 过滤仅WiFi连接
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> filterWifi(Reactive<NetworkInfo> source) {
    return source.where((info) => info.isWifi);
  }

  /// 过滤仅移动数据连接
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> filterMobile(Reactive<NetworkInfo> source) {
    return source.where((info) => info.isMobile);
  }

  /// 过滤仅已连接状态
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> filterConnected(Reactive<NetworkInfo> source) {
    return source.where((info) => info.isConnected);
  }

  /// 过滤仅未连接状态
  ///
  /// 返回Reactive<NetworkInfo>，支持链式调用
  static Reactive<NetworkInfo> filterDisconnected(Reactive<NetworkInfo> source) {
    return source.where((info) => !info.isConnected);
  }

  /// 关闭网络监听
  static void dispose() {
    _subscription?.cancel();
    _controller?.close();
    _subscription = null;
    _controller = null;
    _initialized = false;
  }
}

/// 网络状态Reactive扩展
extension NetworkInfoReactiveX on Reactive<NetworkInfo> {
  /// 转换为连接状态
  Reactive<bool> toIsConnected() {
    return map((info) => info.isConnected);
  }

  /// 转换为WiFi状态
  Reactive<bool> toIsWifi() {
    return map((info) => info.isWifi);
  }

  /// 转换为移动数据状态
  Reactive<bool> toIsMobile() {
    return map((info) => info.isMobile);
  }

  /// 转换为状态枚举
  Reactive<ConnectivityStatus> toStatus() {
    return map((info) => info.status);
  }

  /// 过滤仅WiFi连接
  Reactive<NetworkInfo> whereWifi() {
    return where((info) => info.isWifi);
  }

  /// 过滤仅移动数据连接
  Reactive<NetworkInfo> whereMobile() {
    return where((info) => info.isMobile);
  }

  /// 过滤仅已连接状态
  Reactive<NetworkInfo> whereConnected() {
    return where((info) => info.isConnected);
  }

  /// 过滤仅未连接状态
  Reactive<NetworkInfo> whereDisconnected() {
    return where((info) => !info.isConnected);
  }

  /// 仅在状态改变时触发
  Reactive<NetworkInfo> distinctByStatus() {
    return Reactive(
      stream.distinct((prev, next) => prev.status == next.status),
    );
  }

  /// 仅在连接状态改变时触发
  Reactive<NetworkInfo> distinctByConnection() {
    return Reactive(
      stream.distinct((prev, next) => prev.isConnected == next.isConnected),
    );
  }
}
