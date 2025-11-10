/// 字符串验证工具类
class StringValidatorUtils {
  /// 验证是否为空
  ///
  /// [value] 要验证的字符串
  /// 返回是否为空
  static bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// 验证是否不为空
  ///
  /// [value] 要验证的字符串
  /// 返回是否不为空
  static bool isNotEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// 验证是否为空白
  ///
  /// [value] 要验证的字符串
  /// 返回是否为空白
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// 验证是否不为空白
  ///
  /// [value] 要验证的字符串
  /// 返回是否不为空白
  static bool isNotBlank(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// 验证是否为邮箱
  ///
  /// [value] 要验证的字符串
  /// 返回是否为邮箱
  static bool isEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value);
  }

  /// 验证是否为手机号
  ///
  /// [value] 要验证的字符串
  /// 返回是否为手机号
  static bool isPhone(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(value);
  }

  /// 验证是否为URL
  ///
  /// [value] 要验证的字符串
  /// 返回是否为URL
  static bool isUrl(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    try {
      final uri = Uri.parse(value);
      return uri.hasScheme && (uri.hasAuthority || uri.path.isNotEmpty);
    } catch (e) {
      return false;
    }
  }

  /// 验证是否为数字
  ///
  /// [value] 要验证的字符串
  /// 返回是否为数字
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  /// 验证是否为整数
  ///
  /// [value] 要验证的字符串
  /// 返回是否为整数
  static bool isInteger(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return int.tryParse(value) != null;
  }

  /// 验证长度
  ///
  /// [value] 要验证的字符串
  /// [min] 最小长度
  /// [max] 最大长度
  /// 返回长度是否在范围内
  static bool hasLength(String? value, {int? min, int? max}) {
    if (value == null) {
      return false;
    }
    final length = value.length;
    if (min != null && length < min) {
      return false;
    }
    if (max != null && length > max) {
      return false;
    }
    return true;
  }

  /// 验证是否匹配正则表达式
  ///
  /// [value] 要验证的字符串
  /// [pattern] 正则表达式模式
  /// 返回是否匹配
  static bool matches(String? value, String pattern) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  /// 验证是否包含
  ///
  /// [value] 要验证的字符串
  /// [substring] 子字符串
  /// 返回是否包含
  static bool contains(String? value, String substring) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.contains(substring);
  }

  /// 验证是否以指定字符串开头
  ///
  /// [value] 要验证的字符串
  /// [prefix] 前缀
  /// 返回是否以指定字符串开头
  static bool startsWith(String? value, String prefix) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.startsWith(prefix);
  }

  /// 验证是否以指定字符串结尾
  ///
  /// [value] 要验证的字符串
  /// [suffix] 后缀
  /// 返回是否以指定字符串结尾
  static bool endsWith(String? value, String suffix) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.endsWith(suffix);
  }

  /// 验证是否为身份证号
  ///
  /// [value] 要验证的字符串
  /// 返回是否为身份证号
  static bool isIdCard(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    // 18位身份证号
    if (value.length == 18) {
      final idCardRegex = RegExp(r'^\d{17}[\dXx]$');
      return idCardRegex.hasMatch(value);
    }
    // 15位身份证号
    if (value.length == 15) {
      final idCardRegex = RegExp(r'^\d{15}$');
      return idCardRegex.hasMatch(value);
    }
    return false;
  }

  /// 验证是否为银行卡号
  ///
  /// [value] 要验证的字符串
  /// 返回是否为银行卡号
  static bool isBankCard(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final bankCardRegex = RegExp(r'^\d{16,19}$');
    return bankCardRegex.hasMatch(value);
  }

  /// 验证是否为IP地址
  ///
  /// [value] 要验证的字符串
  /// 返回是否为IP地址
  static bool isIpAddress(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(value);
  }

  /// 验证是否为中文
  ///
  /// [value] 要验证的字符串
  /// 返回是否为中文
  static bool isChinese(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final chineseRegex = RegExp(r'^[\u4e00-\u9fa5]+$');
    return chineseRegex.hasMatch(value);
  }

  /// 验证是否包含中文
  ///
  /// [value] 要验证的字符串
  /// 返回是否包含中文
  static bool containsChinese(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final chineseRegex = RegExp(r'[\u4e00-\u9fa5]');
    return chineseRegex.hasMatch(value);
  }
}
