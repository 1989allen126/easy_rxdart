import 'dart:async';
import 'package:flutter/material.dart';
import 'model.dart';
import '../../extensions/stream/stream_controller_extensions.dart';

/// 通过[InheritedWidget]将[model]提供给其子[Widget]树。
/// 当[version]变化时，所有请求（通过[BuildContext.dependOnInheritedWidgetOfExactType]）
/// 在模型变化时重建的后代都会这样做
class _InheritedModel<T extends Model> extends InheritedWidget {
  /// Model实例
  final T model;

  /// 版本号
  final int version;

  /// 构造函数
  _InheritedModel({
    super.key,
    required super.child,
    required this.model,
  }) : version = model.version;

  /// 当版本变化时，通知依赖此InheritedWidget的Widget重建
  @override
  bool updateShouldNotify(_InheritedModel<T> oldWidget) =>
      (oldWidget.version != version);
}

/// 向此Widget的所有后代提供[Model]
///
/// 后代Widget可以通过[EasyModelDescendant] Widget访问模型，
/// 该Widget会在每次模型变化时重建，或者直接通过[EasyModel.watch]静态方法访问
///
/// 若要向所有屏幕提供Model，请将[EasyModel] Widget放在Widget树中
/// [WidgetsApp]或[MaterialApp]的上方
///
/// ### 示例
///
/// ```
/// EasyModel<CounterModel>(
///   model: CounterModel(),
///   child: EasyModelDescendant<CounterModel>(
///     builder: (context, child, model) => Text(model.counter.toString()),
///   ),
/// );
/// ```
class EasyModel<T extends Model> extends StatelessWidget {
  /// 要提供给[child]及其后代的[Model]
  final T model;

  /// [model]可用于的[Widget]
  final Widget child;

  /// 构造函数
  const EasyModel({
    super.key,
    required this.model,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 使用AnimatedBuilder监听model变化，变化时重建_InheritedModel
    return AnimatedBuilder(
      animation: model,
      builder: (context, _) => _InheritedModel<T>(
        model: model,
        child: child,
      ),
    );
  }

  /// 内部方法，不对外暴露
  /// 如果未找到Model，返回null
  static T? _ofOrNull<T extends Model>(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) {
    // 根据是否需要重建，决定使用dependOnInheritedWidgetOfExactType还是getElementForInheritedWidgetOfExactType
    var widget = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_InheritedModel<T>>()
        : context
            .getElementForInheritedWidgetOfExactType<_InheritedModel<T>>()
            ?.widget;

    if (widget == null) {
      return null;
    } else {
      return (widget as _InheritedModel<T>).model;
    }
  }

  /// 监听Model变化（会触发重建）
  ///
  /// 类似于Riverpod的`watch`方法，当Model变化时会自动重建Widget
  ///
  /// 如果未找到Model，返回null而不是抛出异常
  ///
  /// ### 示例
  ///
  /// ```
  /// class CounterWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final counter = EasyModel.watch<CounterModel>(context);
  ///     if (counter == null) {
  ///       return Text('Model not found');
  ///     }
  ///     return Text('${counter.count}');
  ///   }
  /// }
  /// ```
  ///
  /// 或者使用扩展方法：
  ///
  /// ```
  /// final counter = context.watch<CounterModel>();
  /// ```
  static T? watch<T extends Model>(BuildContext context) {
    return _ofOrNull<T>(context, rebuildOnChange: true);
  }

  /// 读取Model（不会触发重建）
  ///
  /// 类似于Riverpod的`read`方法，获取Model实例但不会监听变化
  ///
  /// 如果未找到Model，返回null而不是抛出异常
  ///
  /// ### 示例
  ///
  /// ```
  /// void onButtonPressed(BuildContext context) {
  ///   final counter = EasyModel.read<CounterModel>(context);
  ///   if (counter != null) {
  ///     counter.increment();
  ///   }
  /// }
  /// ```
  ///
  /// 或者使用扩展方法：
  ///
  /// ```
  /// final counter = context.read<CounterModel>();
  /// ```
  static T? read<T extends Model>(BuildContext context) {
    return _ofOrNull<T>(context, rebuildOnChange: false);
  }

  /// 监听Model变化（用于副作用，不会触发重建）
  ///
  /// 类似于Riverpod的`listen`方法，用于在Model变化时执行副作用操作
  ///
  /// ### 示例
  ///
  /// ```
  /// class CounterWidget extends StatefulWidget {
  ///   @override
  ///   State<CounterWidget> createState() => _CounterWidgetState();
  /// }
  ///
  /// class _CounterWidgetState extends State<CounterWidget> {
  ///   StreamSubscription? _subscription;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     _subscription = EasyModel.listen<CounterModel>(
  ///       context,
  ///       (counter) {
  ///         // 执行副作用，例如显示SnackBar
  ///         ScaffoldMessenger.of(context).showSnackBar(
  ///           SnackBar(content: Text('Counter: ${counter.count}')),
  ///         );
  ///       },
  ///     );
  ///   }
  ///
  ///   @override
  ///   void dispose() {
  ///     _subscription?.cancel();
  ///     super.dispose();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final counter = EasyModel.read<CounterModel>(context);
  ///     return Text('${counter.count}');
  ///   }
  /// }
  /// ```
  static StreamSubscription<T> listen<T extends Model>(
    BuildContext context,
    void Function(T model) callback,
  ) {
    final model = _ofOrNull<T>(context, rebuildOnChange: false);
    if (model == null) {
      // 如果未找到Model，返回一个空的StreamSubscription
      return Stream<T>.empty().listen((_) {});
    }
    final controller = StreamController<T>.broadcast();

    // 初始值
    controller.emit(model);

    // 监听模型变化
    void listener() => controller.emit(model);
    model.addListener(listener);

    // 取消订阅时清理
    controller.onCancel = () => model.removeListener(listener);

    return controller.stream.listen(callback);
  }
}
