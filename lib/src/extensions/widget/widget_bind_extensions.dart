import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/easy_model/easy_model.dart';
import '../../core/reactive.dart';

/// Widget绑定扩展
extension WidgetBindExtension on Widget {
  /// 绑定到Reactive（自动更新）
  ///
  /// [reactive] Reactive对象
  /// [builder] 构建函数，参数为当前值和Reactive对象
  /// 返回自动更新的Widget
  Widget bind<T>(
    Reactive<T> reactive,
    Widget Function(BuildContext context, T value, Reactive<T> reactive)
        builder,
  ) {
    return _ReactiveBuilder<T>(
      reactive: reactive,
      builder: builder,
    );
  }

  /// 绑定到Model（自动更新）
  ///
  /// [model] Model对象
  /// [extractor] 数据提取函数
  /// [builder] 构建函数，参数为当前值
  /// 返回自动更新的Widget
  Widget bindModel<TModel extends Model, TValue>(
    TModel model,
    TValue Function(TModel) extractor,
    Widget Function(BuildContext context, TValue value) builder,
  ) {
    return _ModelBuilder<TModel, TValue>(
      model: model,
      extractor: extractor,
      builder: builder,
    );
  }
}

/// Reactive构建器（内部使用）
class _ReactiveBuilder<T> extends StatefulWidget {
  final Reactive<T> reactive;
  final Widget Function(BuildContext context, T value, Reactive<T> reactive)
      builder;

  const _ReactiveBuilder({
    required this.reactive,
    required this.builder,
  });

  @override
  State<_ReactiveBuilder<T>> createState() => _ReactiveBuilderState<T>();
}

/// Reactive构建器状态（内部使用）
class _ReactiveBuilderState<T> extends State<_ReactiveBuilder<T>> {
  T? _value;
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.reactive.listen(
      (value) {
        if (mounted) {
          setState(() {
            _value = value;
          });
        }
      },
    );
    // 获取初始值
    widget.reactive.toFuture().then((value) {
      if (mounted) {
        setState(() {
          _value = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_value == null) {
      return const SizedBox.shrink();
    }
    return widget.builder(context, _value!, widget.reactive);
  }
}

/// Model构建器（内部使用）
class _ModelBuilder<TModel extends Model, TValue> extends StatefulWidget {
  final TModel model;
  final TValue Function(TModel) extractor;
  final Widget Function(BuildContext context, TValue value) builder;

  const _ModelBuilder({
    required this.model,
    required this.extractor,
    required this.builder,
  });

  @override
  State<_ModelBuilder<TModel, TValue>> createState() =>
      _ModelBuilderState<TModel, TValue>();
}

/// Model构建器状态（内部使用）
class _ModelBuilderState<TModel extends Model, TValue>
    extends State<_ModelBuilder<TModel, TValue>> {
  late TValue _value;

  @override
  void initState() {
    super.initState();
    _value = widget.extractor(widget.model);
    widget.model.addListener(_onModelChanged);
  }

  @override
  void dispose() {
    widget.model.removeListener(_onModelChanged);
    super.dispose();
  }

  void _onModelChanged() {
    if (mounted) {
      setState(() {
        _value = widget.extractor(widget.model);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}

/// Widget绑定工具类
class WidgetBindUtils {
  /// 绑定到Reactive（自动更新）
  ///
  /// [reactive] Reactive对象
  /// [builder] 构建函数
  /// 返回自动更新的Widget
  static Widget bind<T>(
    Reactive<T> reactive,
    Widget Function(BuildContext context, T value) builder,
  ) {
    return _ReactiveBuilder<T>(
      reactive: reactive,
      builder: (context, value, _) => builder(context, value),
    );
  }

  /// 绑定到Model（自动更新）
  ///
  /// [model] Model对象
  /// [extractor] 数据提取函数
  /// [builder] 构建函数
  /// 返回自动更新的Widget
  static Widget bindModel<TModel extends Model, TValue>(
    TModel model,
    TValue Function(TModel) extractor,
    Widget Function(BuildContext context, TValue value) builder,
  ) {
    return _ModelBuilder<TModel, TValue>(
      model: model,
      extractor: extractor,
      builder: builder,
    );
  }

  /// 绑定到多个Reactive（自动更新）
  ///
  /// [reactives] Reactive对象列表
  /// [builder] 构建函数，参数为所有Reactive的值列表
  /// 返回自动更新的Widget
  static Widget bindAll<T>(
    List<Reactive<T>> reactives,
    Widget Function(BuildContext context, List<T> values) builder,
  ) {
    return _MultiReactiveBuilder<T>(
      reactives: reactives,
      builder: builder,
    );
  }

  /// 绑定到多个Model（自动更新）
  ///
  /// [models] Model对象列表
  /// [extractors] 数据提取函数列表
  /// [builder] 构建函数，参数为所有Model的值列表
  /// 返回自动更新的Widget
  static Widget bindAllModels<TModel extends Model, TValue>(
    List<TModel> models,
    List<TValue Function(TModel)> extractors,
    Widget Function(BuildContext context, List<TValue> values) builder,
  ) {
    return _MultiModelBuilder<TModel, TValue>(
      models: models,
      extractors: extractors,
      builder: builder,
    );
  }

  /// 使用Selector绑定到Model的特定属性（自动更新）
  ///
  /// 只有当selector返回的值真正变化时才重建Widget，减少不必要的重建
  ///
  /// [model] Model对象
  /// [selector] 选择器函数，从Model中提取需要监听的值
  /// [builder] 构建函数，参数为选择器返回的值
  /// [equals] 可选的相等性比较函数，用于判断值是否真的变化了
  /// 如果不提供，使用默认的相等性比较（==）
  /// 返回自动更新的Widget
  ///
  /// ### 示例
  ///
  /// ```dart
  /// WidgetBindUtils.selector<CounterModel, int>(
  ///   counterModel,
  ///   (model) => model.count,
  ///   (context, count) => Text('计数器: $count'),
  /// );
  ///
  /// // 使用自定义相等性比较
  /// WidgetBindUtils.selector<UserModel, String>(
  ///   userModel,
  ///   (model) => model.name,
  ///   (context, name) => Text('用户名: $name'),
  ///   equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
  /// );
  /// ```
  static Widget selector<TModel extends Model, TValue>(
    TModel model,
    TValue Function(TModel) selector,
    Widget Function(BuildContext context, TValue value) builder, {
    bool Function(TValue, TValue)? equals,
  }) {
    return _ModelSelectorBuilder<TModel, TValue>(
      model: model,
      selector: selector,
      builder: builder,
      equals: equals,
    );
  }
}

/// 多Reactive构建器（内部使用）
class _MultiReactiveBuilder<T> extends StatefulWidget {
  final List<Reactive<T>> reactives;
  final Widget Function(BuildContext context, List<T> values) builder;

  const _MultiReactiveBuilder({
    required this.reactives,
    required this.builder,
  });

  @override
  State<_MultiReactiveBuilder<T>> createState() =>
      _MultiReactiveBuilderState<T>();
}

/// 多Reactive构建器状态（内部使用）
class _MultiReactiveBuilderState<T> extends State<_MultiReactiveBuilder<T>> {
  final List<T?> _values = [];
  final List<StreamSubscription<T>?> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.reactives.length; i++) {
      _values.add(null);
      final index = i;
      _subscriptions.add(
        widget.reactives[i].listen(
          (value) {
            if (mounted) {
              setState(() {
                _values[index] = value;
              });
            }
          },
        ),
      );
      // 获取初始值
      widget.reactives[i].toFuture().then((value) {
        if (mounted) {
          setState(() {
            _values[index] = value;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否所有值都已加载
    if (_values.any((value) => value == null)) {
      return const SizedBox.shrink();
    }
    return widget.builder(context, _values.cast<T>());
  }
}

/// 多Model构建器（内部使用）
class _MultiModelBuilder<TModel extends Model, TValue> extends StatefulWidget {
  final List<TModel> models;
  final List<TValue Function(TModel)> extractors;
  final Widget Function(BuildContext context, List<TValue> values) builder;

  const _MultiModelBuilder({
    required this.models,
    required this.extractors,
    required this.builder,
  });

  @override
  State<_MultiModelBuilder<TModel, TValue>> createState() =>
      _MultiModelBuilderState<TModel, TValue>();
}

/// 多Model构建器状态（内部使用）
class _MultiModelBuilderState<TModel extends Model, TValue>
    extends State<_MultiModelBuilder<TModel, TValue>> {
  late List<TValue> _values;

  @override
  void initState() {
    super.initState();
    _values = widget.models
        .asMap()
        .map((index, model) => MapEntry(
              index,
              widget.extractors[index](model),
            ))
        .values
        .toList();
    for (final model in widget.models) {
      model.addListener(_onModelChanged);
    }
  }

  @override
  void dispose() {
    for (final model in widget.models) {
      model.removeListener(_onModelChanged);
    }
    super.dispose();
  }

  void _onModelChanged() {
    if (mounted) {
      setState(() {
        _values = widget.models
            .asMap()
            .map((index, model) => MapEntry(
                  index,
                  widget.extractors[index](model),
                ))
            .values
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _values);
  }
}

/// Model Selector构建器（内部使用）
class _ModelSelectorBuilder<TModel extends Model, TValue>
    extends StatefulWidget {
  final TModel model;
  final TValue Function(TModel) selector;
  final Widget Function(BuildContext context, TValue value) builder;
  final bool Function(TValue, TValue)? equals;

  const _ModelSelectorBuilder({
    required this.model,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<_ModelSelectorBuilder<TModel, TValue>> createState() =>
      _ModelSelectorBuilderState<TModel, TValue>();
}

/// Model Selector构建器状态（内部使用）
class _ModelSelectorBuilderState<TModel extends Model, TValue>
    extends State<_ModelSelectorBuilder<TModel, TValue>> {
  late TValue _value;

  @override
  void initState() {
    super.initState();
    _value = widget.selector(widget.model);
    widget.model.addListener(_onModelChanged);
  }

  @override
  void dispose() {
    widget.model.removeListener(_onModelChanged);
    super.dispose();
  }

  void _onModelChanged() {
    if (mounted) {
      final newValue = widget.selector(widget.model);
      // 使用相等性比较函数判断值是否真的变化了
      final hasChanged = widget.equals != null
          ? !widget.equals!(_value, newValue)
          : _value != newValue;

      if (hasChanged) {
        setState(() {
          _value = newValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}
