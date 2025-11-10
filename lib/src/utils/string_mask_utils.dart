import '../type/string_mask_type.dart';

/// 字符串脱敏工具类
///
/// 提供手机号、身份证、银行卡等敏感信息的脱敏功能
class StringMaskUtils {
  /// 默认脱敏字符
  static const String defaultMaskChar = '*';

  /// 脱敏手机号
  ///
  /// [phone] 手机号
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 3
  /// [keepEnd] 保留后几位，默认为 4
  /// 返回脱敏后的手机号
  ///
  /// 示例：
  /// - 13812345678 -> 138****5678
  /// - 15912345678 -> 159****5678
  static String maskPhone(
    String? phone, {
    String maskChar = defaultMaskChar,
    int keepStart = 3,
    int keepEnd = 4,
  }) {
    if (phone == null || phone.isEmpty) {
      return '';
    }

    // 移除空格和特殊字符
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    // 验证手机号长度（11位）
    if (cleanPhone.length != 11) {
      return phone; // 如果不是11位，返回原值
    }

    // 验证是否为数字
    if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return phone; // 如果不是纯数字，返回原值
    }

    if (keepStart + keepEnd >= cleanPhone.length) {
      return phone; // 如果保留位数超过总长度，返回原值
    }

    final start = cleanPhone.substring(0, keepStart);
    final end = cleanPhone.substring(cleanPhone.length - keepEnd);
    final maskLength = cleanPhone.length - keepStart - keepEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 脱敏身份证号
  ///
  /// [idCard] 身份证号
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 6
  /// [keepEnd] 保留后几位，默认为 4
  /// 返回脱敏后的身份证号
  ///
  /// 示例：
  /// - 320123199001011234 -> 320123********1234
  /// - 320123900101123 -> 320123******123
  static String maskIdCard(
    String? idCard, {
    String maskChar = defaultMaskChar,
    int keepStart = 6,
    int keepEnd = 4,
  }) {
    if (idCard == null || idCard.isEmpty) {
      return '';
    }

    // 移除空格和特殊字符
    final cleanIdCard = idCard.replaceAll(RegExp(r'[\s-]'), '');

    // 验证身份证号长度（15位或18位）
    if (cleanIdCard.length != 15 && cleanIdCard.length != 18) {
      return idCard; // 如果不是15位或18位，返回原值
    }

    // 验证是否为数字或最后一位为X
    if (!RegExp(r'^\d+$').hasMatch(cleanIdCard) &&
        !RegExp(r'^\d+X$').hasMatch(cleanIdCard) &&
        !RegExp(r'^\d+x$').hasMatch(cleanIdCard)) {
      return idCard; // 如果格式不正确，返回原值
    }

    if (keepStart + keepEnd >= cleanIdCard.length) {
      return idCard; // 如果保留位数超过总长度，返回原值
    }

    final start = cleanIdCard.substring(0, keepStart);
    final end = cleanIdCard.substring(cleanIdCard.length - keepEnd);
    final maskLength = cleanIdCard.length - keepStart - keepEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 脱敏银行卡号
  ///
  /// [bankCard] 银行卡号
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 4
  /// [keepEnd] 保留后几位，默认为 4
  /// 返回脱敏后的银行卡号
  ///
  /// 示例：
  /// - 6222021234567890 -> 6222********7890
  /// - 6222021234567890123 -> 6222*************0123
  static String maskBankCard(
    String? bankCard, {
    String maskChar = defaultMaskChar,
    int keepStart = 4,
    int keepEnd = 4,
  }) {
    if (bankCard == null || bankCard.isEmpty) {
      return '';
    }

    // 移除空格和特殊字符
    final cleanBankCard = bankCard.replaceAll(RegExp(r'[\s-]'), '');

    // 验证银行卡号长度（至少8位）
    if (cleanBankCard.length < 8) {
      return bankCard; // 如果长度不足，返回原值
    }

    // 验证是否为数字
    if (!RegExp(r'^\d+$').hasMatch(cleanBankCard)) {
      return bankCard; // 如果不是纯数字，返回原值
    }

    if (keepStart + keepEnd >= cleanBankCard.length) {
      return bankCard; // 如果保留位数超过总长度，返回原值
    }

    final start = cleanBankCard.substring(0, keepStart);
    final end = cleanBankCard.substring(cleanBankCard.length - keepEnd);
    final maskLength = cleanBankCard.length - keepStart - keepEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 脱敏邮箱
  ///
  /// [email] 邮箱地址
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 2
  /// [keepEnd] 保留后几位（@后面的部分），默认为完整保留
  /// 返回脱敏后的邮箱
  ///
  /// 示例：
  /// - abc123@example.com -> ab***@example.com
  /// - test@example.com -> te**@example.com
  static String maskEmail(
    String? email, {
    String maskChar = defaultMaskChar,
    int keepStart = 2,
  }) {
    if (email == null || email.isEmpty) {
      return '';
    }

    // 验证邮箱格式
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      return email; // 如果格式不正确，返回原值
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return email;
    }

    final localPart = parts[0]; // @ 前面的部分
    final domainPart = parts[1]; // @ 后面的部分

    if (localPart.length <= keepStart) {
      // 如果本地部分太短，只保留第一个字符
      final mask = maskChar * (localPart.length - 1);
      return '${localPart[0]}$mask@$domainPart';
    }

    final start = localPart.substring(0, keepStart);
    final maskLength = localPart.length - keepStart;
    final mask = maskChar * maskLength;

    return '$start$mask@$domainPart';
  }

  /// 脱敏姓名
  ///
  /// [name] 姓名
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 1
  /// [keepEnd] 保留后几位，默认为 0（不保留）
  /// 返回脱敏后的姓名
  ///
  /// 示例：
  /// - 张三 -> 张*
  /// - 李四 -> 李*
  /// - 王五 -> 王*
  /// - 欧阳修 -> 欧**修
  static String maskName(
    String? name, {
    String maskChar = defaultMaskChar,
    int keepStart = 1,
    int keepEnd = 0,
  }) {
    if (name == null || name.isEmpty) {
      return '';
    }

    if (name.length <= keepStart + keepEnd) {
      // 如果姓名太短，只保留第一个字符
      final mask = maskChar * (name.length - keepStart);
      return '${name.substring(0, keepStart)}$mask';
    }

    final start = name.substring(0, keepStart);
    final end = keepEnd > 0 ? name.substring(name.length - keepEnd) : '';
    final maskLength = name.length - keepStart - keepEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 自定义脱敏
  ///
  /// [text] 要脱敏的文本
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位
  /// [keepEnd] 保留后几位
  /// [minLength] 最小长度，如果文本长度小于此值，不进行脱敏
  /// 返回脱敏后的文本
  ///
  /// 示例：
  /// - maskCustom('1234567890', keepStart: 2, keepEnd: 2) -> 12******90
  static String maskCustom(
    String? text, {
    String maskChar = defaultMaskChar,
    required int keepStart,
    required int keepEnd,
    int minLength = 4,
  }) {
    if (text == null || text.isEmpty) {
      return '';
    }

    if (text.length < minLength) {
      return text; // 如果长度不足，返回原值
    }

    if (keepStart + keepEnd >= text.length) {
      return text; // 如果保留位数超过总长度，返回原值
    }

    final start = text.substring(0, keepStart);
    final end = text.substring(text.length - keepEnd);
    final maskLength = text.length - keepStart - keepEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 脱敏中间部分
  ///
  /// [text] 要脱敏的文本
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位
  /// [keepEnd] 保留后几位
  /// [maskLength] 脱敏字符数量，如果为null则自动计算
  /// 返回脱敏后的文本
  ///
  /// 示例：
  /// - maskMiddle('1234567890', keepStart: 2, keepEnd: 2, maskLength: 4) -> 12****90
  static String maskMiddle(
    String? text, {
    String maskChar = defaultMaskChar,
    required int keepStart,
    required int keepEnd,
    int? maskLength,
  }) {
    if (text == null || text.isEmpty) {
      return '';
    }

    if (keepStart + keepEnd >= text.length) {
      return text; // 如果保留位数超过总长度，返回原值
    }

    final start = text.substring(0, keepStart);
    final end = text.substring(text.length - keepEnd);
    final length = maskLength ?? (text.length - keepStart - keepEnd);
    final mask = maskChar * length;

    return '$start$mask$end';
  }

  /// 脱敏全部（只保留首尾）
  ///
  /// [text] 要脱敏的文本
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 1
  /// [keepEnd] 保留后几位，默认为 1
  /// 返回脱敏后的文本
  ///
  /// 示例：
  /// - maskAll('1234567890', keepStart: 1, keepEnd: 1) -> 1********0
  static String maskAll(
    String? text, {
    String maskChar = defaultMaskChar,
    int keepStart = 1,
    int keepEnd = 1,
  }) {
    return maskCustom(
      text,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
      minLength: 1,
    );
  }

  /// 脱敏车牌号
  ///
  /// [plateNumber] 车牌号
  /// [maskChar] 脱敏字符，默认为 '*'
  /// 返回脱敏后的车牌号
  ///
  /// 示例：
  /// - 京A12345 -> 京A***45
  /// - 粤B12345 -> 粤B***45
  static String maskPlateNumber(
    String? plateNumber, {
    String maskChar = defaultMaskChar,
  }) {
    if (plateNumber == null || plateNumber.isEmpty) {
      return '';
    }

    // 移除空格
    final cleanPlate = plateNumber.replaceAll(' ', '');

    // 验证车牌号格式（通常为7-8位：省份+字母+数字）
    if (cleanPlate.length < 6 || cleanPlate.length > 8) {
      return plateNumber; // 如果长度不符合，返回原值
    }

    // 保留前2位（省份+字母），后2位（数字）
    if (cleanPlate.length <= 4) {
      return plateNumber; // 如果太短，返回原值
    }

    final start = cleanPlate.substring(0, 2);
    final end = cleanPlate.substring(cleanPlate.length - 2);
    final maskLength = cleanPlate.length - 4;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }

  /// 脱敏地址
  ///
  /// [address] 地址
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 3
  /// [keepEnd] 保留后几位，默认为 3
  /// 返回脱敏后的地址
  ///
  /// 示例：
  /// - 北京市朝阳区xxx街道xxx号 -> 北京市***xxx号
  static String maskAddress(
    String? address, {
    String maskChar = defaultMaskChar,
    int keepStart = 3,
    int keepEnd = 3,
  }) {
    return maskCustom(
      address,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
      minLength: keepStart + keepEnd,
    );
  }

  /// 根据类型自动脱敏
  ///
  /// [text] 要脱敏的文本
  /// [types] 脱敏类型列表，默认为 [StringMaskType.phone, StringMaskType.email]
  /// 返回脱敏后的文本
  ///
  /// 示例：
  /// - autoMask('13812345678') -> 138****5678
  /// - autoMask('abc123@example.com') -> ab***@example.com
  static String autoMask(
    String text, {
    List<StringMaskType> types = const [
      StringMaskType.phone,
      StringMaskType.email,
    ],
  }) {
    if (text.isEmpty) {
      return text;
    }

    // 遍历类型列表，按顺序检查文本是否匹配
    for (final type in types) {
      if (_isMatchType(text, type)) {
        return _maskByType(text, type);
      }
    }

    // 如果都不匹配，返回原值
    return text;
  }

  /// 判断文本是否匹配指定类型
  ///
  /// [text] 要判断的文本
  /// [type] 脱敏类型
  /// 返回是否匹配
  static bool _isMatchType(String text, StringMaskType type) {
    switch (type) {
      case StringMaskType.phone:
        final cleanPhone = text.replaceAll(RegExp(r'[\s-]'), '');
        return cleanPhone.length == 11 && RegExp(r'^\d+$').hasMatch(cleanPhone);

      case StringMaskType.email:
        return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(text);

      case StringMaskType.idCard:
        final cleanIdCard = text.replaceAll(RegExp(r'[\s-]'), '');
        if (cleanIdCard.length != 15 && cleanIdCard.length != 18) {
          return false;
        }
        return RegExp(r'^\d+$').hasMatch(cleanIdCard) ||
            RegExp(r'^\d+X$').hasMatch(cleanIdCard) ||
            RegExp(r'^\d+x$').hasMatch(cleanIdCard);

      case StringMaskType.bankCard:
        final cleanBankCard = text.replaceAll(RegExp(r'[\s-]'), '');
        return cleanBankCard.length >= 8 &&
            RegExp(r'^\d+$').hasMatch(cleanBankCard);

      case StringMaskType.name:
        // 姓名判断：通常为2-4个中文字符
        return RegExp(r'^[\u4e00-\u9fa5]{2,4}$').hasMatch(text);

      case StringMaskType.none:
        return false;
    }
  }

  /// 根据类型进行脱敏
  ///
  /// [text] 要脱敏的文本
  /// [type] 脱敏类型
  /// 返回脱敏后的文本
  static String _maskByType(String text, StringMaskType type) {
    final maskChar = type.mask.isEmpty ? defaultMaskChar : type.mask;
    switch (type) {
      case StringMaskType.phone:
        return maskPhone(text,
            maskChar: maskChar,
            keepStart: type.keepStart,
            keepEnd: type.keepEnd);

      case StringMaskType.email:
        return maskEmail(text, maskChar: maskChar, keepStart: type.keepStart);

      case StringMaskType.idCard:
        return maskIdCard(text,
            maskChar: maskChar,
            keepStart: type.keepStart,
            keepEnd: type.keepEnd);

      case StringMaskType.bankCard:
        return maskBankCard(text,
            maskChar: maskChar,
            keepStart: type.keepStart,
            keepEnd: type.keepEnd);

      case StringMaskType.name:
        return maskName(text,
            maskChar: maskChar,
            keepStart: type.keepStart,
            keepEnd: type.keepEnd);
      default:
        return text;
    }
  }
}
