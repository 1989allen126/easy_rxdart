/// EasyModel错误类
///
/// 如果在Widget树中找不到EasyModel，将抛出此错误
class EasyModelError extends Error {
  EasyModelError();

  @override
  String toString() {
    return '''错误: 找不到正确的EasyModel。
修复方法:
  * 为EasyModel<MyModel>提供类型
  * 为EasyModelDescendant<MyModel>提供类型
  * 为EasyModel.of<MyModel>()提供类型
  * 始终使用包导入。例如: `import 'package:my_app/my_model.dart';
  ''';
  }
}
