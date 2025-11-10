import 'package:flutter/material.dart';
import 'easy_consumer_ref.dart';

/// Consumer Widget，类似于Riverpod的ConsumerWidget
///
/// 继承此类可以访问Model，并在Model变化时自动重建
///
/// ### 示例
///
/// ```
/// class CounterWidget extends EasyConsumerWidget {
///   @override
///   Widget buildWithRef(BuildContext context, EasyConsumerRef ref) {
///     final counter = ref.watch<CounterModel>();
///     return Text('${counter.count}');
///   }
/// }
/// ```
abstract class EasyConsumerWidget extends StatelessWidget {
  /// 构造函数
  const EasyConsumerWidget({super.key});

  /// 构建方法，提供Consumer引用
  ///
  /// 子类需要实现此方法
  ///
  /// [context] BuildContext
  /// [ref] Consumer引用
  ///
  /// 返回构建的Widget
  Widget buildWithRef(BuildContext context, EasyConsumerRef ref);

  @override
  Widget build(BuildContext context) {
    return buildWithRef(context, EasyConsumerRef(context));
  }
}

/// Consumer StatefulWidget，类似于Riverpod的ConsumerStatefulWidget
///
/// 继承此类可以访问Model，并在Model变化时自动重建
///
/// ### 示例
///
/// ```
/// class CounterWidget extends EasyConsumerStatefulWidget {
///   @override
///   EasyConsumerState<CounterWidget> createState() => _CounterWidgetState();
/// }
///
/// class _CounterWidgetState extends EasyConsumerState<CounterWidget> {
///   @override
///   Widget buildWidget(BuildContext context) {
///     final counter = ref.watch<CounterModel>();
///     return Text('${counter.count}');
///   }
/// }
/// ```
abstract class EasyConsumerStatefulWidget extends StatefulWidget {
  /// 构造函数
  const EasyConsumerStatefulWidget({super.key});
}

/// Consumer State，配合EasyConsumerStatefulWidget使用
///
/// 提供Consumer引用，可以访问Model
abstract class EasyConsumerState<T extends EasyConsumerStatefulWidget>
    extends State<T> {
  /// Consumer引用
  late final EasyConsumerRef ref = EasyConsumerRef(context);

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  /// 构建方法，提供Consumer引用
  ///
  /// [context] BuildContext
  ///
  /// 返回构建的Widget
  Widget buildWidget(BuildContext context);
}
