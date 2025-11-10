import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/reactive.dart';
import '../extensions/stream/stream_controller_extensions.dart';

/// 生命周期工具类
class LifecycleUtils {
  /// 创建应用生命周期观察器
  ///
  /// 返回Reactive<AppLifecycleState>
  static Reactive<AppLifecycleState> observeAppLifecycle() {
    final controller = StreamController<AppLifecycleState>.broadcast();
    final observer = _AppLifecycleObserver(controller);
    WidgetsBinding.instance.addObserver(observer);

    // 初始状态
    final initialState = WidgetsBinding.instance.lifecycleState;
    if (initialState != null) {
      controller.emit(initialState);
    }

    // 清理
    controller.onCancel = () {
      WidgetsBinding.instance.removeObserver(observer);
    };

    return controller.asReactive();
  }

  /// 全局路由生命周期观察器
  ///
  /// 使用方式：
  /// ```dart
  /// // 在MaterialApp中配置
  /// MaterialApp(
  ///   navigatorObservers: [LifecycleUtils.globalRouteObserver],
  ///   ...
  /// )
  /// // 在路由页面中使用 RouteLifecycleMixin，会自动获取全局 observer
  /// ```
  static RouteObserver<PageRoute> get globalRouteObserver =>
      _globalRouteObserver;

  static final RouteObserver<PageRoute> _globalRouteObserver =
      RouteObserver<PageRoute>();
}

/// 应用生命周期观察器
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final StreamController<AppLifecycleState> controller;

  _AppLifecycleObserver(this.controller);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.emit(state);
  }
}
