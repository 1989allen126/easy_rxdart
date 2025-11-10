import 'package:flutter/material.dart';
import 'easy_state_model.dart';
import 'easy_state.dart';
import 'easy_state_status.dart';
import 'easy_model_widget.dart';
import 'easy_model_error.dart';

/// Consumer State Builder，根据状态自动构建不同的UI
///
/// 提供对EasyStateModel的访问，并根据状态（initial、loading、hasData、noData、error）自动构建不同的UI
///
/// 推荐使用细化的构建器（initialBuilder、loadingBuilder、dataBuilder、noDataBuilder、errorBuilder），
/// 这样代码更清晰，每个状态的UI处理更明确。
///
/// 如果没有提供对应状态的细化构建器，会使用通用的[builder]函数作为兜底。
///
/// ### 示例
///
/// ```
/// EasyConsumerStateBuilder<UserStateModel, User>(
///   initialBuilder: (context, child) => Text('初始状态'),
///   loadingBuilder: (context, child) => CircularProgressIndicator(),
///   dataBuilder: (context, user, child) => Text('${user.name}'),
///   noDataBuilder: (context, child) => Text('无数据'),
///   errorBuilder: (context, error, child) => Text('错误: $error'),
/// )
/// ```
///
/// 或者使用通用构建器：
///
/// ```
/// EasyConsumerStateBuilder<UserStateModel, User>(
///   builder: (context, state, child) {
///     // 完全自定义所有状态的UI处理逻辑
///     switch (state.status) {
///       case EasyStateStatus.initial:
///         return Text('初始状态');
///       case EasyStateStatus.loading:
///         return CircularProgressIndicator();
///       case EasyStateStatus.hasData:
///         return Text('${state.data?.name}');
///       case EasyStateStatus.noData:
///         return Text('无数据');
///       case EasyStateStatus.error:
///         return Text('错误: ${state.error}');
///     }
///   },
/// )
/// ```
class EasyConsumerStateBuilder<T extends EasyStateModel<D>, D>
    extends StatelessWidget {
  /// 通用构建器函数
  ///
  /// 作为兜底使用，当没有提供对应状态的细化构建器时，会使用此函数构建UI
  /// [state] 当前状态
  final Widget Function(BuildContext context, EasyState<D> state, Widget? child)?
      builder;

  /// 初始状态构建器
  final Widget Function(BuildContext context, Widget? child)? initialBuilder;

  /// 加载中状态构建器
  final Widget Function(BuildContext context, Widget? child)? loadingBuilder;

  /// 有数据状态构建器
  ///
  /// [data] 数据
  final Widget Function(BuildContext context, D data, Widget? child)?
      dataBuilder;

  /// 无数据状态构建器
  final Widget Function(BuildContext context, Widget? child)? noDataBuilder;

  /// 错误状态构建器
  ///
  /// [error] 错误信息
  final Widget Function(BuildContext context, Object error, Widget? child)?
      errorBuilder;

  /// 当未找到Model时构建错误Widget
  ///
  /// [error] 错误信息，通常是EasyModelError
  final Widget Function(BuildContext context, Error error, Widget? child)?
      modelErrorBuilder;

  /// 可选的子Widget，不会在Model变化时重建
  final Widget? child;

  /// 构造函数
  const EasyConsumerStateBuilder({
    super.key,
    this.builder,
    this.initialBuilder,
    this.loadingBuilder,
    this.dataBuilder,
    this.noDataBuilder,
    this.errorBuilder,
    this.modelErrorBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final model = EasyModel.watch<T>(context);
    if (model == null) {
      // 如果未找到Model，使用modelErrorBuilder或返回空Widget
      if (modelErrorBuilder != null) {
        return modelErrorBuilder!(context, EasyModelError(), child);
      }
      return const SizedBox.shrink();
    }

    final state = model.state;

    // 根据状态选择对应的构建器，优先使用细化的构建器
    switch (state.status) {
      case EasyStateStatus.initial:
        if (initialBuilder != null) {
          return initialBuilder!(context, child);
        }
        // 如果没有提供细化构建器，使用通用构建器作为兜底
        if (builder != null) {
          return builder!(context, state, child);
        }
        return const SizedBox.shrink();

      case EasyStateStatus.loading:
        if (loadingBuilder != null) {
          return loadingBuilder!(context, child);
        }
        // 如果没有提供细化构建器，使用通用构建器作为兜底
        if (builder != null) {
          return builder!(context, state, child);
        }
        return const Center(child: CircularProgressIndicator());

      case EasyStateStatus.hasData:
        if (dataBuilder != null && state.data != null) {
          return dataBuilder!(context, state.data!, child);
        }
        // 如果没有提供细化构建器，使用通用构建器作为兜底
        if (builder != null) {
          return builder!(context, state, child);
        }
        return const SizedBox.shrink();

      case EasyStateStatus.noData:
        if (noDataBuilder != null) {
          return noDataBuilder!(context, child);
        }
        // 如果没有提供细化构建器，使用通用构建器作为兜底
        if (builder != null) {
          return builder!(context, state, child);
        }
        return const Center(child: Text('无数据'));

      case EasyStateStatus.error:
        if (errorBuilder != null && state.error != null) {
          return errorBuilder!(context, state.error!, child);
        }
        // 如果没有提供细化构建器，使用通用构建器作为兜底
        if (builder != null) {
          return builder!(context, state, child);
        }
        return Center(
          child: Text('错误: ${state.error ?? "未知错误"}'),
        );
    }
  }
}
