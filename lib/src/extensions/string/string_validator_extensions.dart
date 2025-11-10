import '../../core/reactive.dart';
import '../../utils/string_validator_utils.dart';

/// 字符串验证扩展（RxDart封装）
extension StringValidatorReactiveExtensions on String {
  /// 验证是否为空（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isEmptyReactive() {
    return Reactive.fromValue(StringValidatorUtils.isEmpty(this));
  }

  /// 验证是否不为空（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isNotEmptyReactive() {
    return Reactive.fromValue(StringValidatorUtils.isNotEmpty(this));
  }

  /// 验证是否为空白（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isBlankReactive() {
    return Reactive.fromValue(StringValidatorUtils.isBlank(this));
  }

  /// 验证是否不为空白（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isNotBlankReactive() {
    return Reactive.fromValue(StringValidatorUtils.isNotBlank(this));
  }

  /// 验证是否为邮箱（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isEmailReactive() {
    return Reactive.fromValue(StringValidatorUtils.isEmail(this));
  }

  /// 验证是否为手机号（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isPhoneReactive() {
    return Reactive.fromValue(StringValidatorUtils.isPhone(this));
  }

  /// 验证是否为URL（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isUrlReactive() {
    return Reactive.fromValue(StringValidatorUtils.isUrl(this));
  }

  /// 验证是否为数字（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isNumericReactive() {
    return Reactive.fromValue(StringValidatorUtils.isNumeric(this));
  }

  /// 验证是否为整数（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isIntegerReactive() {
    return Reactive.fromValue(StringValidatorUtils.isInteger(this));
  }

  /// 验证长度（响应式）
  ///
  /// [min] 最小长度
  /// [max] 最大长度
  /// 返回Reactive<bool>
  Reactive<bool> hasLengthReactive({int? min, int? max}) {
    return Reactive.fromValue(StringValidatorUtils.hasLength(this, min: min, max: max));
  }

  /// 验证是否匹配正则表达式（响应式）
  ///
  /// [pattern] 正则表达式模式
  /// 返回Reactive<bool>
  Reactive<bool> matchesReactive(String pattern) {
    return Reactive.fromValue(StringValidatorUtils.matches(this, pattern));
  }

  /// 验证是否包含（响应式）
  ///
  /// [substring] 子字符串
  /// 返回Reactive<bool>
  Reactive<bool> containsReactive(String substring) {
    return Reactive.fromValue(StringValidatorUtils.contains(this, substring));
  }

  /// 验证是否以指定字符串开头（响应式）
  ///
  /// [prefix] 前缀
  /// 返回Reactive<bool>
  Reactive<bool> startsWithReactive(String prefix) {
    return Reactive.fromValue(StringValidatorUtils.startsWith(this, prefix));
  }

  /// 验证是否以指定字符串结尾（响应式）
  ///
  /// [suffix] 后缀
  /// 返回Reactive<bool>
  Reactive<bool> endsWithReactive(String suffix) {
    return Reactive.fromValue(StringValidatorUtils.endsWith(this, suffix));
  }

  /// 验证是否为身份证号（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isIdCardReactive() {
    return Reactive.fromValue(StringValidatorUtils.isIdCard(this));
  }

  /// 验证是否为银行卡号（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isBankCardReactive() {
    return Reactive.fromValue(StringValidatorUtils.isBankCard(this));
  }

  /// 验证是否为IP地址（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isIpAddressReactive() {
    return Reactive.fromValue(StringValidatorUtils.isIpAddress(this));
  }

  /// 验证是否为中文（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> isChineseReactive() {
    return Reactive.fromValue(StringValidatorUtils.isChinese(this));
  }

  /// 验证是否包含中文（响应式）
  ///
  /// 返回Reactive<bool>
  Reactive<bool> containsChineseReactive() {
    return Reactive.fromValue(StringValidatorUtils.containsChinese(this));
  }
}
