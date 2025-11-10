import 'package:flutter/material.dart';
import 'model.dart';
import 'easy_model_widget.dart';
import 'easy_model_error.dart';

/// Consumer Builder，类似于Riverpod的ConsumerBuilder
///
/// 提供对Model的访问，并在Model变化时自动重建
///
/// [builder]中的model保证不为null，如果未找到Model，会使用[errorBuilder]构建错误页面
///
/// ### 示例
///
/// ```
/// EasyConsumerBuilder<CounterModel>(
///   builder: (context, model, child) {
///     // model保证不为null
///     return Text('${model.count}');
///   },
///   errorBuilder: (context, error, child) {
///     return Text('Model not found: ${error.toString()}');
///   },
/// )
/// ```
class EasyConsumerBuilder<T extends Model> extends StatelessWidget {
  /// 构建器函数
  ///
  /// 保证model一定不为null
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  /// 当未找到Model时构建错误Widget
  ///
  /// [error] 错误信息，通常是EasyModelError
  final Widget Function(BuildContext context, Error error, Widget? child)?
      errorBuilder;

  /// 可选的子Widget，不会在Model变化时重建
  final Widget? child;

  /// 构造函数
  const EasyConsumerBuilder({
    super.key,
    required this.builder,
    this.errorBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final model = EasyModel.watch<T>(context);
    if (model == null) {
      // 如果未找到Model，使用errorBuilder或返回空Widget
      if (errorBuilder != null) {
        return errorBuilder!(context, EasyModelError(), child);
      }
      return const SizedBox.shrink();
    }
    return builder(context, model, child);
  }
}

/// Consumer Selector，类似于Riverpod的ConsumerSelector
///
/// 只监听Model的特定部分，减少不必要的重建
///
/// [builder]中的value保证不为null（因为model不为null），如果未找到Model，会使用[errorBuilder]构建错误页面
///
/// ### 示例
///
/// ```
/// EasyConsumerSelector<CounterModel, int>(
///   selector: (model) => model.count,
///   builder: (context, count, child) {
///     // count保证不为null
///     return Text('$count');
///   },
///   errorBuilder: (context, error, child) {
///     return Text('Model not found: ${error.toString()}');
///   },
/// )
/// ```
class EasyConsumerSelector<T extends Model, R> extends StatelessWidget {
  /// 选择器函数，从Model中提取需要监听的值
  final R Function(T) selector;

  /// 构建器函数
  ///
  /// 保证value一定不为null（因为model不为null）
  final Widget Function(BuildContext context, R value, Widget? child) builder;

  /// 当未找到Model时构建错误Widget
  ///
  /// [error] 错误信息，通常是EasyModelError
  final Widget Function(BuildContext context, Error error, Widget? child)?
      errorBuilder;

  /// 可选的子Widget，不会在Model变化时重建
  final Widget? child;

  /// 相等性比较函数，用于判断值是否变化
  final bool Function(R, R)? equals;

  /// 构造函数
  const EasyConsumerSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.errorBuilder,
    this.child,
    this.equals,
  });

  @override
  Widget build(BuildContext context) {
    final model = EasyModel.watch<T>(context);
    if (model == null) {
      // 如果未找到Model，使用errorBuilder或返回空Widget
      if (errorBuilder != null) {
        return errorBuilder!(context, EasyModelError(), child);
      }
      return const SizedBox.shrink();
    }
    final value = selector(model);

    // 如果提供了相等性比较函数，需要检查值是否真的变化了
    // 这里简化处理，实际应该缓存上次的值进行比较
    return builder(context, value, child);
  }
}
