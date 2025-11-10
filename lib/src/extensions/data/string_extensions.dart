import 'dart:async';

import '../../utils/string_formatter_utils.dart';
import '../../utils/string_validator_utils.dart';

/// String扩展
extension StringExtensions on String {
  /// 转换为Stream（按字符）
  ///
  /// 返回Stream<String>
  Stream<String> toStream() {
    return Stream.fromIterable(split(''));
  }

  /// 转换为Stream（按行）
  ///
  /// 返回Stream<String>
  Stream<String> toStreamByLines() {
    return Stream.fromIterable(split('\n'));
  }

  /// 跳过前N个字符
  ///
  /// [count] 跳过的数量
  /// 返回跳过后的String
  String skipFirstN(int count) {
    if (count <= 0) {
      return this;
    }
    if (count >= length) {
      return '';
    }
    return substring(count);
  }

  /// 跳过后N个字符
  ///
  /// [count] 跳过的数量
  /// 返回跳过后的String
  String skipLastN(int count) {
    if (count <= 0) {
      return this;
    }
    if (count >= length) {
      return '';
    }
    return substring(0, length - count);
  }

  /// 跳过第一个字符
  ///
  /// 返回跳过第一个字符后的String
  String skipFirst() {
    return skipFirstN(1);
  }

  /// 跳过最后一个字符
  ///
  /// 返回跳过最后一个字符后的String
  String skipLast() {
    return skipLastN(1);
  }

  /// 跳过满足条件的字符
  ///
  /// [predicate] 跳过条件函数
  /// 返回跳过满足条件字符后的String
  String skipWhile(bool Function(String) predicate) {
    int skipCount = 0;
    for (int i = 0; i < length; i++) {
      if (!predicate(this[i])) {
        break;
      }
      skipCount++;
    }
    return substring(skipCount);
  }

  /// 跳过直到满足条件的字符
  ///
  /// [predicate] 条件函数
  /// 返回跳过直到满足条件字符后的String
  String skipUntil(bool Function(String) predicate) {
    int skipCount = 0;
    for (int i = 0; i < length; i++) {
      if (predicate(this[i])) {
        break;
      }
      skipCount++;
    }
    return substring(skipCount);
  }

  /// 过滤字符
  ///
  /// [predicate] 过滤条件函数
  /// 返回过滤后的String
  String filter(bool Function(String) predicate) {
    return split('').where(predicate).join();
  }

  // ========== 格式化相关扩展 ==========

  /// 格式化手机号（中间4位用*代替）
  ///
  /// 返回格式化后的手机号
  String formatPhone() {
    return StringFormatterUtils.formatPhone(this);
  }

  /// 格式化身份证号（中间用*代替）
  ///
  /// 返回格式化后的身份证号
  String formatIdCard() {
    return StringFormatterUtils.formatIdCard(this);
  }

  /// 格式化银行卡号（中间用*代替）
  ///
  /// 返回格式化后的银行卡号
  String formatBankCard() {
    return StringFormatterUtils.formatBankCard(this);
  }

  /// 格式化文件大小
  ///
  /// 返回格式化后的文件大小
  String formatFileSize() {
    final bytes = int.tryParse(this);
    return StringFormatterUtils.formatFileSize(bytes);
  }

  /// 格式化数字（添加千分位）
  ///
  /// 返回格式化后的数字
  String formatNumber() {
    final number = num.tryParse(this);
    return StringFormatterUtils.formatNumber(number);
  }

  /// 格式化百分比
  ///
  /// [decimals] 小数位数
  /// 返回格式化后的百分比
  String formatPercent({int decimals = 2}) {
    final value = double.tryParse(this);
    return StringFormatterUtils.formatPercent(value, decimals: decimals);
  }

  /// 格式化日期时间字符串
  ///
  /// [format] 格式模式
  /// 返回格式化后的日期时间字符串
  String formatDateTime(String format) {
    return StringFormatterUtils.formatDateTime(this, format);
  }

  /// 截断字符串
  ///
  /// [maxLength] 最大长度
  /// [ellipsis] 省略号
  /// 返回截断后的字符串
  String truncate(int maxLength, {String ellipsis = '...'}) {
    return StringFormatterUtils.truncate(this, maxLength, ellipsis: ellipsis);
  }

  /// 移除空白字符
  ///
  /// 返回移除空白字符后的字符串
  String get removeWhitespace {
    return StringFormatterUtils.removeWhitespace(this);
  }

  /// 移除指定字符
  ///
  /// [characters] 要移除的字符
  /// 返回移除指定字符后的字符串
  String removeCharacters(String characters) {
    return StringFormatterUtils.removeCharacters(this, characters);
  }

  /// 填充字符串
  ///
  /// [length] 目标长度
  /// [padding] 填充字符
  /// [padLeft] 是否左填充
  /// 返回填充后的字符串
  String pad(int length, String padding, {bool padLeft = true}) {
    return StringFormatterUtils.pad(this, length, padding, padLeft: padLeft);
  }

  // ========== 验证相关扩展 ==========

  /// 验证是否为空
  ///
  /// 返回是否为空
  bool get isEmptyValue => StringValidatorUtils.isEmpty(this);

  /// 验证是否不为空
  ///
  /// 返回是否不为空
  bool get isNotEmptyValue => StringValidatorUtils.isNotEmpty(this);

  /// 验证是否为空白
  ///
  /// 返回是否为空白
  bool get isBlank => StringValidatorUtils.isBlank(this);

  /// 验证是否不为空白
  ///
  /// 返回是否不为空白
  bool get isNotBlank => StringValidatorUtils.isNotBlank(this);

  /// 验证是否为邮箱
  ///
  /// 返回是否为邮箱
  bool get isEmail => StringValidatorUtils.isEmail(this);

  /// 验证是否为手机号
  ///
  /// 返回是否为手机号
  bool get isPhone => StringValidatorUtils.isPhone(this);

  /// 验证是否为URL
  ///
  /// 返回是否为URL
  bool get isUrl => StringValidatorUtils.isUrl(this);

  /// 验证是否为数字
  ///
  /// 返回是否为数字
  bool get isNumeric => StringValidatorUtils.isNumeric(this);

  /// 验证是否为整数
  ///
  /// 返回是否为整数
  bool get isInteger => StringValidatorUtils.isInteger(this);

  /// 验证长度
  ///
  /// [min] 最小长度
  /// [max] 最大长度
  /// 返回长度是否在范围内
  bool hasLength({int? min, int? max}) {
    return StringValidatorUtils.hasLength(this, min: min, max: max);
  }

  /// 验证是否匹配正则表达式
  ///
  /// [pattern] 正则表达式模式
  /// 返回是否匹配
  bool matches(String pattern) {
    return StringValidatorUtils.matches(this, pattern);
  }

  /// 验证是否包含
  ///
  /// [substring] 子字符串
  /// 返回是否包含
  bool containsValue(String substring) {
    return StringValidatorUtils.contains(this, substring);
  }

  /// 验证是否以指定字符串开头
  ///
  /// [prefix] 前缀
  /// 返回是否以指定字符串开头
  bool startsWithValue(String prefix) {
    return StringValidatorUtils.startsWith(this, prefix);
  }

  /// 验证是否以指定字符串结尾
  ///
  /// [suffix] 后缀
  /// 返回是否以指定字符串结尾
  bool endsWithValue(String suffix) {
    return StringValidatorUtils.endsWith(this, suffix);
  }

  /// 验证是否为身份证号
  ///
  /// 返回是否为身份证号
  bool get isIdCard => StringValidatorUtils.isIdCard(this);

  /// 验证是否为银行卡号
  ///
  /// 返回是否为银行卡号
  bool get isBankCard => StringValidatorUtils.isBankCard(this);

  /// 验证是否为IP地址
  ///
  /// 返回是否为IP地址
  bool get isIpAddress => StringValidatorUtils.isIpAddress(this);

  /// 验证是否为中文
  ///
  /// 返回是否为中文
  bool get isChinese => StringValidatorUtils.isChinese(this);

  /// 验证是否包含中文
  ///
  /// 返回是否包含中文
  bool get containsChinese => StringValidatorUtils.containsChinese(this);
}
