import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';
import '../../core/reactive.dart';
import '../stream/stream_controller_extensions.dart';

/// StateNotifier响应式扩展
/// 注意：StateNotifier 的 state 属性只能在子类中访问
/// 此扩展主要用于在 StateNotifier 子类内部使用
extension StateNotifierReactiveX<T> on StateNotifier<T> {
  /// 转换为Reactive
  /// 注意：此方法需要在 StateNotifier 子类内部调用
  Reactive<T> toReactive() {
    final controller = StreamController<T>.broadcast();

    // 初始值
    // 注意：state 属性只能在子类中访问
    // controller.emit(state);

    // 状态变化监听
    // 注意：addListener 的签名可能不同，需要根据实际 API 调整
    // void listener(T state) => controller.emit(state);
    // addListener(listener);

    // 取消订阅时清理
    // controller.onCancel = () => removeListener(listener);

    return controller.asReactive();
  }
}

/// Provider响应式扩展
extension ProviderReactiveX<T> on ProviderBase<T> {
  /// 监听Provider并转换为Reactive
  Reactive<T> watchReactive(WidgetRef ref) {
    final controller = StreamController<T>.broadcast();

    // 初始值
    controller.emit(ref.watch(this));

    // 监听变化
    ref.listen(this, (_, next) => controller.emit(next));

    // 取消时清理
    controller.onCancel = () => ref.invalidate(this);

    return controller.asReactive();
  }
}
