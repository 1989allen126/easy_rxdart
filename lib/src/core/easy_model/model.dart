import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../extensions/stream/stream_controller_extensions.dart';
import '../reactive.dart';

/// 持有数据并允许其他类监听数据变化的基类
///
/// 若要通知监听器数据发生了变化，必须显式调用[notifyListeners]方法
///
/// 通常与[EasyModel] Widget结合使用，若不需要将Widget传递到widget树中，
/// 可以使用简单的[AnimatedBuilder]来监听变化，并在模型通知监听器时重建
///
/// ### 示例
///
/// ```
/// class CounterModel extends Model {
///   int _counter = 0;
///
///   int get counter => _counter;
///
///   void increment() {
///     _counter++;
///     notifyListeners();
///   }
/// }
/// ```
abstract class Model extends Listenable {
  /// 是否已销毁
  bool _disposed = false;

  /// 是否已销毁
  bool get isDisposed => _disposed;

  /// 销毁模型
  void dispose() {
    _disposed = true;
    _listeners.clear();
    _lastHashCode = null;
    _microtaskVersion = 0;
    _version = 0;
  }

  /// 使用Set存储监听器，确保唯一性
  final Set<VoidCallback> _listeners = Set<VoidCallback>();

  /// 记录模型版本，用于判断是否需要通知监听器
  int _version = 0;

  /// 微任务版本，用于防抖处理
  int _microtaskVersion = 0;

  /// 上一次的hashCode值，用于判断是否真的发生了变化
  int? _lastHashCode;

  /// 获取模型hashCode
  ///
  /// 子类可以重写此方法来提供自定义的hashCode计算逻辑
  ///
  /// 返回模型的hashCode值
  @override
  int get hashCode {
    // 使用对象的identityHashCode作为基础，结合版本号
    return Object.hash(super.hashCode, _version);
  }

  /// 添加监听器
  ///
  /// 当模型变化时，[listener]会被调用
  ///
  /// [listener] 监听器回调函数
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// 移除监听器
  ///
  /// 模型变化时，[listener]不会再被调用
  ///
  /// [listener] 要移除的监听器回调函数
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// 获取监听器数量
  ///
  /// 返回监听此模型的监听器数量
  int get listenerCount => _listeners.length;

  /// 获取版本号
  ///
  /// 用于判断是否需要重建
  ///
  /// 返回模型的版本号
  int get version => _version;

  /// 刷新Model，触发监听器通知
  ///
  /// [force] 是否强制刷新，即使hashCode没有变化也会通知监听器
  /// 如果[force]为false，则正常调用[notifyListeners]，由hashCode检查逻辑决定是否通知
  void refresh({bool force = false}) {
    if (force) {
      // 强制刷新：更新版本号，但不更新_lastHashCode，确保下次调用notifyListeners时能正常检查
      _version++;
      _microtaskVersion = _version;

      // 直接通知监听器，不经过微任务
      // 注意：不更新_lastHashCode，这样下次调用notifyListeners时仍然会检查hashCode
      _listeners.toList().forEach((VoidCallback listener) => listener());
    } else {
      // 正常刷新：调用notifyListeners，由hashCode检查逻辑决定是否通知
      notifyListeners();
    }
  }

  /// 通知所有监听器
  ///
  /// 仅当模型变化时由[Model]调用
  /// 只有在hashCode真正变化时才会通知监听器
  ///
  /// 此方法由子类在数据变化时调用，用于触发监听器回调
  @protected
  void notifyListeners() {
    // 如果已销毁，不通知监听器
    if (_disposed) {
      return;
    }

    // 计算当前的hashCode
    final currentHashCode = hashCode;

    // 如果hashCode没有变化，则不通知监听器
    if (_lastHashCode != null &&
        _lastHashCode == currentHashCode &&
        _version != _microtaskVersion) {
      return;
    }

    // 调度一个微任务来处理多个同时发生的变化，防止重复通知
    if (_microtaskVersion == _version) {
      _microtaskVersion++;
      scheduleMicrotask(() {
        // 再次检查是否已销毁
        if (_disposed) {
          return;
        }

        // 再次检查hashCode是否真的变化了（防止在微任务执行期间又调用了notifyListeners）
        final finalHashCode = hashCode;
        if (_lastHashCode != null && _lastHashCode == finalHashCode) {
          // hashCode没有变化，回退版本号
          _microtaskVersion = _version;
          return;
        }

        // 更新版本号和hashCode
        _version++;
        _microtaskVersion = _version;
        _lastHashCode = finalHashCode;

        // 在执行每个监听器之前，将Set转换为List。
        // 这样可以防止在调用过程中监听器自行移除时可能出现的错误！
        _listeners.toList().forEach((VoidCallback listener) => listener());
      });
    }
  }

  /// 转换为Reactive
  ///
  /// [extractor] 从Model中提取数据的函数
  ///
  /// 返回[Reactive]<T>，当Model变化时会自动更新
  Reactive<T> toReactive<T>(T Function() extractor) {
    final controller = StreamController<T>.broadcast();

    // 初始值
    controller.emit(extractor());

    // 监听模型变化
    void listener() => controller.emit(extractor());
    addListener(listener);

    // 取消订阅时清理
    controller.onCancel = () => removeListener(listener);

    return controller.asReactive();
  }
}
