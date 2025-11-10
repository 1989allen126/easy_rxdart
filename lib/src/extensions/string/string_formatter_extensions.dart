import '../../core/reactive.dart';
import '../../utils/string_formatter_utils.dart';

/// 字符串格式化扩展（RxDart封装）
extension StringFormatterReactiveExtensions on String {
  /// 格式化手机号（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> formatPhoneReactive() {
    return Reactive.fromValue(StringFormatterUtils.formatPhone(this));
  }

  /// 格式化身份证号（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> formatIdCardReactive() {
    return Reactive.fromValue(StringFormatterUtils.formatIdCard(this));
  }

  /// 格式化银行卡号（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> formatBankCardReactive() {
    return Reactive.fromValue(StringFormatterUtils.formatBankCard(this));
  }

  /// 格式化文件大小（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> formatFileSizeReactive() {
    final bytes = int.tryParse(this);
    return Reactive.fromValue(StringFormatterUtils.formatFileSize(bytes));
  }

  /// 格式化数字（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> formatNumberReactive() {
    final number = num.tryParse(this);
    return Reactive.fromValue(StringFormatterUtils.formatNumber(number));
  }

  /// 格式化百分比（响应式）
  ///
  /// [decimals] 小数位数
  /// 返回Reactive<String>
  Reactive<String> formatPercentReactive({int decimals = 2}) {
    final value = double.tryParse(this);
    return Reactive.fromValue(StringFormatterUtils.formatPercent(value, decimals: decimals));
  }

  /// 格式化日期时间（响应式）
  ///
  /// [format] 格式模式
  /// 返回Reactive<String>
  Reactive<String> formatDateTimeReactive(String format) {
    return Reactive.fromValue(StringFormatterUtils.formatDateTime(this, format));
  }

  /// 截断字符串（响应式）
  ///
  /// [maxLength] 最大长度
  /// [ellipsis] 省略号
  /// 返回Reactive<String>
  Reactive<String> truncateReactive(int maxLength, {String ellipsis = '...'}) {
    return Reactive.fromValue(StringFormatterUtils.truncate(this, maxLength, ellipsis: ellipsis));
  }

  /// 首字母大写（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> capitalizeReactive() {
    return Reactive.fromValue(StringFormatterUtils.capitalize(this));
  }

  /// 每个单词首字母大写（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> capitalizeWordsReactive() {
    return Reactive.fromValue(StringFormatterUtils.capitalizeWords(this));
  }

  /// 移除空白字符（响应式）
  ///
  /// 返回Reactive<String>
  Reactive<String> removeWhitespaceReactive() {
    return Reactive.fromValue(StringFormatterUtils.removeWhitespace(this));
  }

  /// 移除指定字符（响应式）
  ///
  /// [characters] 要移除的字符
  /// 返回Reactive<String>
  Reactive<String> removeCharactersReactive(String characters) {
    return Reactive.fromValue(StringFormatterUtils.removeCharacters(this, characters));
  }

  /// 填充字符串（响应式）
  ///
  /// [length] 目标长度
  /// [padding] 填充字符
  /// [padLeft] 是否左填充
  /// 返回Reactive<String>
  Reactive<String> padReactive(int length, String padding, {bool padLeft = true}) {
    return Reactive.fromValue(StringFormatterUtils.pad(this, length, padding, padLeft: padLeft));
  }
}
