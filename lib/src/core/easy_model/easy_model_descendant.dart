import 'package:flutter/material.dart';
import 'model.dart';
import 'easy_model_widget.dart';
import 'easy_model_error.dart';

/// 为[EasyModelDescendant]构建子Widget
typedef Widget EasyModelDescendantBuilder<T extends Model>(
  BuildContext context,
  Widget? child,
  T model,
);

/// 查找由[EasyModel] Widget提供的特定[Model]，并在[Model]变化时重建
///
/// 提供了一个选项，可在[Model]变化时禁用重建
///
/// 如果构建器内的某些部分不依赖于[Model]且不应重建，
/// 则提供一个常量[child] Widget
///
/// [builder]中的model保证不为null，如果未找到Model，会使用[errorBuilder]构建错误页面
///
/// ### 示例
///
/// ```
/// EasyModel<CounterModel>(
///   model: CounterModel(),
///   child: EasyModelDescendant<CounterModel>(
///     child: Text('Button has been pressed:'),
///     builder: (context, child, model) {
///       // model保证不为null
///       return Column(
///         children: [
///           child,
///           Text('${model.counter}'),
///         ],
///       );
///     },
///     errorBuilder: (context, error, child) {
///       return Text('Model not found: ${error.toString()}');
///     },
///   ),
/// );
/// ```
class EasyModelDescendant<T extends Model> extends StatelessWidget {
  /// 当Widget首次创建时以及每当[Model]变化时（如果[rebuildOnChange]设置为`true`）构建一个Widget
  final EasyModelDescendantBuilder<T> builder;

  /// 当未找到Model时构建错误Widget
  ///
  /// [error] 错误信息，通常是EasyModelError
  final Widget Function(BuildContext context, Error error, Widget? child)?
      errorBuilder;

  /// 一个可选的常量子Widget，不依赖于模型。这将作为[builder]的子Widget传递
  final Widget? child;

  /// 一个可选值，用于确定当模型变化时Widget是否重建
  final bool rebuildOnChange;

  /// 创建EasyModelDescendant
  const EasyModelDescendant({
    super.key,
    required this.builder,
    this.errorBuilder,
    this.child,
    this.rebuildOnChange = true,
  });

  @override
  Widget build(BuildContext context) {
    final model = rebuildOnChange
        ? EasyModel.watch<T>(context)
        : EasyModel.read<T>(context);
    if (model == null) {
      // 如果未找到Model，使用errorBuilder或返回空Widget
      if (errorBuilder != null) {
        return errorBuilder!(context, EasyModelError(), child);
      }
      return const SizedBox.shrink();
    }
    return builder(context, child, model);
  }
}
