import 'dart:async';
import 'package:flutter/widgets.dart';
import '../core/reactive.dart';
import '../extensions/stream/stream_controller_extensions.dart';
import '../utils/timer/timer_group_manager.dart';

/// App生命周期Mixin
///
/// 提供应用生命周期监听功能，自动管理订阅和清理
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T> {
  StreamController<AppLifecycleState>? _lifecycleController;
  WidgetsBindingObserver? _lifecycleObserver;
  StreamSubscription<AppLifecycleState>? _lifecycleSubscription;

  /// 获取应用生命周期Reactive
  ///
  /// 返回Reactive<AppLifecycleState>
  Reactive<AppLifecycleState> get appLifecycle {
    if (_lifecycleController == null) {
      _lifecycleController = StreamController<AppLifecycleState>.broadcast();
      _lifecycleObserver = _AppLifecycleObserverMixin(_lifecycleController!);
      WidgetsBinding.instance.addObserver(_lifecycleObserver!);

      // 初始状态
      final initialState = WidgetsBinding.instance.lifecycleState;
      if (initialState != null) {
        _lifecycleController!.emit(initialState);
      }
    }
    return _lifecycleController!.asReactive();
  }

  /// 监听应用生命周期变化
  ///
  /// [onData] 数据回调
  /// [onError] 错误回调
  /// [onDone] 完成回调
  /// 返回StreamSubscription
  StreamSubscription<AppLifecycleState> listenAppLifecycle({
    required void Function(AppLifecycleState) onData,
    Function? onError,
    void Function()? onDone,
  }) {
    _lifecycleSubscription = appLifecycle.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
    return _lifecycleSubscription!;
  }

  @override
  void dispose() {
    _lifecycleSubscription?.cancel();
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance.removeObserver(_lifecycleObserver!);
    }
    _lifecycleController?.close();
    super.dispose();
  }

  /// 监听应用生命周期变化并自动处理定时器
  ///
  /// 自动调用 TimerGroupManager.handleLifecycleChange
  StreamSubscription<AppLifecycleState> listenAppLifecycleWithTimer({
    required void Function(AppLifecycleState) onData,
    Function? onError,
    void Function()? onDone,
  }) {
    return listenAppLifecycle(
      onData: (state) {
        TimerGroupManager.instance.handleLifecycleChange(state);
        onData(state);
      },
      onError: onError,
      onDone: onDone,
    );
  }
}

/// App生命周期观察器（Mixin内部使用）
class _AppLifecycleObserverMixin extends WidgetsBindingObserver {
  final StreamController<AppLifecycleState> controller;

  _AppLifecycleObserverMixin(this.controller);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.emit(state);
  }
}
