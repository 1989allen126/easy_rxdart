import '../../utils/string_formatter_utils.dart';

/// 字符串命名转换扩展
extension StringNamingConversionExtension on String {
  /// 首字母大写
  ///
  /// 返回首字母大写的字符串
  String get capitalize {
    return StringFormatterUtils.capitalize(this);
  }

  /// 每个单词首字母大写
  ///
  /// 返回每个单词首字母大写的字符串
  String get capitalizeWords {
    return StringFormatterUtils.capitalizeWords(this);
  }

  /// 下划线转小驼峰（snake_case -> camelCase）
  ///
  /// 示例：user_name -> userName, user_name_test -> userNameTest
  /// 返回转换后的字符串
  String get toCamelCase {
    if (isEmpty) {
      return this;
    }
    final parts = split('_');
    if (parts.isEmpty || parts.every((part) => part.isEmpty)) {
      return this;
    }
    final result = StringBuffer();
    bool isFirst = true;
    for (final part in parts) {
      if (part.isNotEmpty) {
        if (isFirst) {
          result.write(part.toLowerCase());
          isFirst = false;
        } else {
          result.write(part[0].toUpperCase());
          if (part.length > 1) {
            result.write(part.substring(1).toLowerCase());
          }
        }
      }
    }
    return result.toString();
  }

  /// 下划线转大驼峰（snake_case -> PascalCase）
  ///
  /// 示例：user_name -> UserName, user_name_test -> UserNameTest
  /// 返回转换后的字符串
  String get toPascalCase {
    if (isEmpty) {
      return this;
    }
    final parts = split('_');
    if (parts.isEmpty || parts.every((part) => part.isEmpty)) {
      return this;
    }
    final result = StringBuffer();
    for (final part in parts) {
      if (part.isNotEmpty) {
        result.write(part[0].toUpperCase());
        if (part.length > 1) {
          result.write(part.substring(1).toLowerCase());
        }
      }
    }
    return result.toString();
  }

  /// 驼峰转下划线（camelCase/PascalCase -> snake_case）
  ///
  /// 示例：userName -> user_name, UserName -> user_name, userNameTest -> user_name_test
  /// 返回转换后的字符串
  String get toSnakeCase {
    if (isEmpty) {
      return this;
    }
    final result = StringBuffer();
    for (int i = 0; i < length; i++) {
      final char = this[i];
      if (char == char.toUpperCase() && char != char.toLowerCase()) {
        // 是大写字母
        if (i > 0) {
          result.write('_');
        }
        result.write(char.toLowerCase());
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }
}
