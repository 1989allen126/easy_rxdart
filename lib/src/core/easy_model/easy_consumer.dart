import 'package:flutter/material.dart';
import 'easy_consumer_ref.dart';

/// Consumer构建器函数
typedef Widget EasyConsumerBuilderFunc(
  BuildContext context,
  EasyConsumerRef ref,
  Widget? child,
);

/// Consumer Widget，类似于Riverpod的Consumer
///
/// 提供对Model的访问，并在Model变化时自动重建
///
/// ### 示例
///
/// ```
/// EasyConsumer(
///   builder: (context, ref, child) {
///     final counter = ref.watch<CounterModel>();
///     return Text('${counter.count}');
///   },
/// )
/// ```
class EasyConsumer extends StatelessWidget {
  /// 构建器函数
  final EasyConsumerBuilderFunc builder;

  /// 可选的子Widget，不会在Model变化时重建
  final Widget? child;

  /// 构造函数
  const EasyConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, EasyConsumerRef(context), child);
  }
}
