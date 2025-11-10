import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/reactive.dart';
import '../extensions/stream/stream_controller_extensions.dart';
import '../utils/lifecycle_utils.dart';

/// 路由生命周期Mixin
///
/// 提供路由生命周期监听功能，自动管理订阅和清理
/// 支持两种使用方式：
/// 1. 通过 override 方法（推荐）
/// 2. 通过 Reactive Stream（支持链式操作）
///
/// 使用方式：
/// ```dart
/// // 1. 在 MaterialApp 中配置全局观察器
/// MaterialApp(
///   navigatorObservers: [LifecycleUtils.globalRouteObserver],
///   ...
/// )
///
/// // 2. 在路由页面中使用 Mixin（无需任何设置）
/// class _MyPageState extends State<MyPage> with RouteLifecycleMixin {
///
///   // 方式1: 通过 override 方法（推荐）
///   @override
///   void onRoutePushed() {
///     super.onRoutePushed();
///     print('路由已推送 - 当前页面被推送到导航栈');
///   }
///
///   @override
///   void onRoutePushNext() {
///     super.onRoutePushNext();
///     print('进入下一个页面 - 从当前页面导航到下一个页面');
///   }
///
///   @override
///   void onRoutePopNext() {
///     super.onRoutePopNext();
///     print('回到当前页面 - 从下一个页面返回到当前页面');
///   }
///
///   @override
///   void onRoutePopped() {
///     super.onRoutePopped();
///     print('退出当前页面 - 当前页面从导航栈弹出');
///   }
///
///     // 方式2: 通过 Reactive Stream（支持链式操作）
///   @override
///   void initState() {
///     super.initState();
///     // 方式2.1: 使用通用方法 listenRouteEvent（推荐）
///     listenRouteEvent(
///       predicate: (event) => event == RouteLifecycleEvent.pushed,
///       onData: (event) => print('路由已推送: $event'),
///     );
///
///     // 方式2.2: 使用快捷方法（更简洁）
///     listenRoutePushed(onData: () {
///       print('路由已推送');
///     });
///
///     listenRoutePopNext(onData: () {
///       print('回到当前页面');
///     });
///
///     listenRouteEntered(onData: () {
///       print('进入当前页面（推送或返回）');
///     });
///
///     listenRouteExited(onData: () {
///       print('退出当前页面（进入下一页或弹出）');
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(...);
///   }
/// }
/// ```
/// 路由生命周期事件类型
enum RouteLifecycleEvent {
  /// 路由已推送（进入当前页面）
  pushed,

  /// 路由已推送下一个（进入下一个页面）
  pushNext,

  /// 路由已弹出下一个（回到当前页面）
  popNext,

  /// 路由已弹出（退出当前页面）
  popped,
}

mixin RouteLifecycleMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  StreamController<RouteLifecycleEvent>? _lifecycleController;
  StreamSubscription<RouteLifecycleEvent>? _lifecycleSubscription;
  final List<StreamSubscription<RouteLifecycleEvent>> _subscriptions = [];

  /// 获取路由生命周期Reactive
  ///
  /// 返回Reactive<RouteLifecycleEvent>
  Reactive<RouteLifecycleEvent> get routeLifecycle {
    if (_lifecycleController == null) {
      _lifecycleController = StreamController<RouteLifecycleEvent>.broadcast();
    }
    return _lifecycleController!.asReactive();
  }

  @override
  void initState() {
    super.initState();
    // 注册到 RouteObserver
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      LifecycleUtils.globalRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    // 取消注册
    LifecycleUtils.globalRouteObserver.unsubscribe(this);
    // 清理所有订阅
    _lifecycleSubscription?.cancel();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    // 清理控制器
    _lifecycleController?.close();
    _lifecycleController = null;
    _lifecycleSubscription = null;
    super.dispose();
  }

  /// 监听路由生命周期变化
  ///
  /// [onData] 数据回调
  /// [onError] 错误回调
  /// [onDone] 完成回调
  /// 注意：订阅由 mixin 自动管理，无需手动取消
  void listenRouteLifecycle({
    required void Function(RouteLifecycleEvent) onData,
    Function? onError,
    void Function()? onDone,
  }) {
    _lifecycleSubscription?.cancel();
    _lifecycleSubscription = routeLifecycle.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  /// 监听路由事件
  ///
  /// [onData] 数据回调
  /// [predicate] 过滤条件（可选），返回 true 表示监听该事件
  /// [onError] 错误回调
  /// [onDone] 完成回调
  /// [cancelOnError] 是否在错误时取消订阅
  /// 注意：订阅由 mixin 自动管理，无需手动取消
  ///
  /// 示例：
  /// ```dart
  /// // 监听所有事件
  /// listenRouteEvent(
  ///   onData: (event) => print('路由事件: $event'),
  /// );
  ///
  /// // 只监听 pushed 事件
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushed,
  ///   onData: (event) => print('路由已推送'),
  /// );
  ///
  /// // 监听进入事件（pushed 或 popNext）
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushed ||
  ///                         event == RouteLifecycleEvent.popNext,
  ///   onData: (event) => print('进入当前页面'),
  /// );
  /// ```
  void listenRouteEvent({
    required void Function(RouteLifecycleEvent event) onData,
    bool Function(RouteLifecycleEvent)? predicate,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final subscription =
        routeLifecycle.where((event) => predicate?.call(event) ?? true).listen(
              (event) => onData(event),
              onError: onError,
              onDone: onDone,
              cancelOnError: cancelOnError,
            );
    _subscriptions.add(subscription);
  }

  /// 监听路由推送事件（进入当前页面）
  ///
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushed,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRoutePushed({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => event == RouteLifecycleEvent.pushed,
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 监听路由推送下一个事件（进入下一个页面）
  ///
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushNext,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRoutePushNext({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => event == RouteLifecycleEvent.pushNext,
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 监听路由弹出下一个事件（回到当前页面）
  ///
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.popNext,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRoutePopNext({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => event == RouteLifecycleEvent.popNext,
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 监听路由弹出事件（退出当前页面）
  ///
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.popped,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRoutePopped({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => event == RouteLifecycleEvent.popped,
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 监听路由进入事件（推送或弹出下一个）
  ///
  /// 包括：pushed（进入当前页面）和 popNext（回到当前页面）
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushed ||
  ///                         event == RouteLifecycleEvent.popNext,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRouteEntered({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => [
        RouteLifecycleEvent.pushed,
        RouteLifecycleEvent.popNext
      ].contains(event),
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 监听路由退出事件（推送下一个或弹出）
  ///
  /// 包括：pushNext（进入下一个页面）和 popped（退出当前页面）
  /// 快捷方法，等价于：
  /// ```dart
  /// listenRouteEvent(
  ///   predicate: (event) => event == RouteLifecycleEvent.pushNext ||
  ///                         event == RouteLifecycleEvent.popped,
  ///   onData: (event) => onData(),
  /// );
  /// ```
  void listenRouteExited({
    required void Function() onData,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    listenRouteEvent(
      predicate: (event) => [
        RouteLifecycleEvent.pushNext,
        RouteLifecycleEvent.popped
      ].contains(event),
      onData: (_) => onData(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  // RouteAware 接口方法
  @override
  void didPush() {
    _lifecycleController?.emit(RouteLifecycleEvent.pushed);
    onRoutePushed();
  }

  @override
  void didPopNext() {
    _lifecycleController?.emit(RouteLifecycleEvent.popNext);
    onRoutePopNext();
  }

  @override
  void didPop() {
    _lifecycleController?.emit(RouteLifecycleEvent.popped);
    onRoutePopped();
  }

  @override
  void didPushNext() {
    _lifecycleController?.emit(RouteLifecycleEvent.pushNext);
    onRoutePushNext();
  }

  /// 路由已推送（进入当前页面）
  ///
  /// 当当前页面被推送到导航栈时调用
  /// 可以 override 此方法来处理路由推送事件
  void onRoutePushed() {}

  /// 路由已弹出下一个（回到当前页面）
  ///
  /// 当从下一个页面返回到当前页面时调用
  /// 例如：从页面B返回到页面A时，页面A的此方法会被调用
  /// 可以 override 此方法来处理返回到当前页面的事件
  void onRoutePopNext() {}

  /// 路由已弹出（退出当前页面）
  ///
  /// 当当前页面从导航栈弹出时调用
  /// 例如：从页面A返回到上一页时，页面A的此方法会被调用
  /// 可以 override 此方法来处理路由弹出事件
  void onRoutePopped() {}

  /// 路由已推送下一个（进入下一个页面）
  ///
  /// 当从当前页面进入下一个页面时调用
  /// 例如：从页面A导航到页面B时，页面A的此方法会被调用
  /// 可以 override 此方法来处理进入下一个页面的事件
  void onRoutePushNext() {}
}
