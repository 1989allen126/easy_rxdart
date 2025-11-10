import '../../utils/string_mask_utils.dart';

/// 字符串脱敏扩展
extension StringDesensitizationExtension on String {
  /// 脱敏手机号
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 3
  /// [keepEnd] 保留后几位，默认为 4
  String maskPhone({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 3,
    int keepEnd = 4,
  }) {
    return StringMaskUtils.maskPhone(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }

  /// 脱敏身份证号
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 6
  /// [keepEnd] 保留后几位，默认为 4
  String maskIdCard({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 6,
    int keepEnd = 4,
  }) {
    return StringMaskUtils.maskIdCard(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }

  /// 脱敏银行卡号
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 4
  /// [keepEnd] 保留后几位，默认为 4
  String maskBankCard({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 4,
    int keepEnd = 4,
  }) {
    return StringMaskUtils.maskBankCard(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }

  /// 脱敏邮箱
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 2
  String maskEmail({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 2,
  }) {
    return StringMaskUtils.maskEmail(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
    );
  }

  /// 脱敏姓名
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 1
  /// [keepEnd] 保留后几位，默认为 0
  String maskName({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 1,
    int keepEnd = 0,
  }) {
    return StringMaskUtils.maskName(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }

  /// 自定义脱敏
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位
  /// [keepEnd] 保留后几位
  /// [minLength] 最小长度，如果文本长度小于此值，不进行脱敏
  String maskCustom({
    String maskChar = StringMaskUtils.defaultMaskChar,
    required int keepStart,
    required int keepEnd,
    int minLength = 4,
  }) {
    return StringMaskUtils.maskCustom(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
      minLength: minLength,
    );
  }

  /// 脱敏中间部分
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位
  /// [keepEnd] 保留后几位
  /// [maskLength] 脱敏字符数量，如果为null则自动计算
  String maskMiddle({
    String maskChar = StringMaskUtils.defaultMaskChar,
    required int keepStart,
    required int keepEnd,
    int? maskLength,
  }) {
    return StringMaskUtils.maskMiddle(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
      maskLength: maskLength,
    );
  }

  /// 脱敏全部（只保留首尾）
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 1
  /// [keepEnd] 保留后几位，默认为 1
  String maskAll({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 1,
    int keepEnd = 1,
  }) {
    return StringMaskUtils.maskAll(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }

  /// 脱敏车牌号
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  String maskPlateNumber({
    String maskChar = StringMaskUtils.defaultMaskChar,
  }) {
    return StringMaskUtils.maskPlateNumber(
      this,
      maskChar: maskChar,
    );
  }

  /// 脱敏地址
  ///
  /// [maskChar] 脱敏字符，默认为 '*'
  /// [keepStart] 保留前几位，默认为 3
  /// [keepEnd] 保留后几位，默认为 3
  String maskAddress({
    String maskChar = StringMaskUtils.defaultMaskChar,
    int keepStart = 3,
    int keepEnd = 3,
  }) {
    return StringMaskUtils.maskAddress(
      this,
      maskChar: maskChar,
      keepStart: keepStart,
      keepEnd: keepEnd,
    );
  }
}
