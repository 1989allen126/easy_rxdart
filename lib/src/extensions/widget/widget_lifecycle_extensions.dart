import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../core/reactive.dart';
import '../stream/stream_controller_extensions.dart';

/// Widget生命周期扩展
extension WidgetLifecycleExtension on Widget {
  /// 监听Widget生命周期
  ///
  /// 返回Reactive<WidgetLifecycleState>
  Reactive<WidgetLifecycleState> observeLifecycle() {
    final controller = StreamController<WidgetLifecycleState>.broadcast();
    // 注意：Widget本身无法直接监听生命周期
    // 需要在StatefulWidget的State中使用
    return controller.asReactive();
  }
}

/// Widget生命周期状态
enum WidgetLifecycleState {
  /// 初始化
  init,

  /// 已创建
  created,

  /// 已挂载
  mounted,

  /// 已激活
  activated,

  /// 已停用
  deactivated,

  /// 已卸载
  unmounted,

  /// 已销毁
  disposed,
}

/// State生命周期扩展
extension StateLifecycleExtension<T extends StatefulWidget> on State<T> {
  /// 监听State生命周期
  ///
  /// 返回Reactive<WidgetLifecycleState>
  Reactive<WidgetLifecycleState> observeLifecycle() {
    final controller = StreamController<WidgetLifecycleState>.broadcast();

    // 初始状态
    if (mounted) {
      controller.emit(WidgetLifecycleState.mounted);
    }

    // 注意：State的生命周期需要在State类内部通过重写生命周期方法来监听
    // 这里提供一个基础框架，实际使用需要在State类中手动调用

    return controller.asReactive();
  }

  /// 发射生命周期事件
  ///
  /// [state] 生命周期状态
  void emitLifecycle(WidgetLifecycleState state) {
    // 这个方法需要在State类中手动调用
    // 例如在initState、didChangeDependencies等生命周期方法中调用
  }
}

/// RouteObserver扩展
extension RouteObserverExtension on RouteObserver<PageRoute> {
  /// 监听路由生命周期
  ///
  /// [route] 要监听的路由
  /// 返回Reactive<RouteLifecycleState>
  Reactive<RouteLifecycleState> observeRoute(PageRoute route) {
    final controller = StreamController<RouteLifecycleState>.broadcast();

    // 订阅路由变化
    route.addScopedWillPopCallback(() async {
      controller.emit(RouteLifecycleState.willPop);
      return true;
    });

    // 注意：RouteObserver需要在MaterialApp中配置
    // 这里提供一个基础框架

    return controller.asReactive();
  }
}

/// 路由生命周期状态
enum RouteLifecycleState {
  /// 路由已推送
  pushed,

  /// 路由即将弹出
  willPop,

  /// 路由已弹出
  popped,

  /// 路由已替换
  replaced,

  /// 路由已移除
  removed,
}

/// Route生命周期工具类
class RouteLifecycleUtils {
  /// 创建路由观察器
  ///
  /// 返回RouteObserver
  static RouteObserver<PageRoute> createObserver() {
    return RouteObserver<PageRoute>();
  }

  /// 监听路由变化
  ///
  /// [observer] 路由观察器
  /// [route] 要监听的路由
  /// 返回Reactive<RouteLifecycleState>
  static Reactive<RouteLifecycleState> observe(
    RouteObserver<PageRoute> observer,
    PageRoute route,
  ) {
    final controller = StreamController<RouteLifecycleState>.broadcast();

    // 初始状态
    controller.emit(RouteLifecycleState.pushed);

    // 注意：实际的路由监听需要在RouteObserver的回调中实现
    // 这里提供一个基础框架

    return controller.asReactive();
  }
}

/// AppLifecycleState扩展
extension AppLifecycleStateExtension on AppLifecycleState {
  /// 转换为字符串
  ///
  /// 返回状态字符串
  String toValue() {
    switch (this) {
      case AppLifecycleState.resumed:
        return 'resumed';
      case AppLifecycleState.inactive:
        return 'inactive';
      case AppLifecycleState.paused:
        return 'paused';
      case AppLifecycleState.detached:
        return 'detached';
      case AppLifecycleState.hidden:
        return 'hidden';
    }
  }

  /// 是否处于活动状态
  ///
  /// 返回是否处于活动状态
  bool get isActive {
    return this == AppLifecycleState.resumed;
  }

  /// 是否处于后台状态
  ///
  /// 返回是否处于后台状态
  bool get isBackground {
    return this == AppLifecycleState.paused ||
        this == AppLifecycleState.inactive ||
        this == AppLifecycleState.detached ||
        this == AppLifecycleState.hidden;
  }
}

/// WidgetsBindingObserver扩展
extension WidgetsBindingObserverExtension on WidgetsBindingObserver {
  /// 监听应用生命周期
  ///
  /// 返回Reactive<AppLifecycleState>
  Reactive<AppLifecycleState> observeAppLifecycle() {
    final controller = StreamController<AppLifecycleState>.broadcast();

    // 注意：需要在WidgetsBindingObserver的didChangeAppLifecycleState方法中调用
    // 这里提供一个基础框架

    return controller.asReactive();
  }

  /// 发射应用生命周期事件
  ///
  /// [state] 应用生命周期状态
  void emitAppLifecycle(AppLifecycleState state) {
    // 这个方法需要在didChangeAppLifecycleState中调用
  }
}
