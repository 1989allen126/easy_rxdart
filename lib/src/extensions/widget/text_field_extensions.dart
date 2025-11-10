import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/debounce_utils.dart';
import '../../utils/throttle_utils.dart';
import '../../utils/distinct_utils.dart';
import '../../core/reactive.dart';

/// TextField 防抖、限流、去重和订阅扩展
extension TextFieldX on TextField {
  /// 创建带防抖onChanged的TextField
  ///
  /// [onChanged] 文本变化回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖onChanged的TextField
  static TextField debounce({
    required ValueChanged<String>? onChanged,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final debouncedOnChanged = onChanged != null
        ? DebounceUtils.debounceFunction<String>(onChanged, debounceDuration)
        : null;
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: debouncedOnChanged,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带限流onChanged的TextField
  ///
  /// [onChanged] 文本变化回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流onChanged的TextField
  static TextField throttle({
    required ValueChanged<String>? onChanged,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final throttledOnChanged = onChanged != null
        ? ThrottleUtils.throttleFunction<String>(onChanged, throttleDuration)
        : null;
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: throttledOnChanged,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带去重onChanged的TextField
  ///
  /// [onChanged] 文本变化回调
  /// [equals] 相等性比较函数
  /// 返回带去重onChanged的TextField
  static TextField distinct({
    required ValueChanged<String>? onChanged,
    bool Function(String, String)? equals,
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final distinctOnChanged = onChanged != null
        ? DistinctUtils.distinctFunction<String>(onChanged, equals: equals)
        : null;
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: distinctOnChanged,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带订阅onChanged的TextField
  ///
  /// [onChanged] 文本变化回调
  /// [reactive] Reactive对象
  /// 返回带订阅onChanged的TextField
  static TextField subscribe({
    required ValueChanged<String>? onChanged,
    required Reactive<String> reactive,
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    if (onChanged != null) {
      reactive.listen((value) => onChanged(value));
    }
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }
}

/// TextFormField 防抖、限流、去重和订阅扩展
extension TextFormFieldX on TextFormField {
  /// 创建带防抖onChanged的TextFormField
  ///
  /// [onChanged] 文本变化回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖onChanged的TextFormField
  static TextFormField debounce({
    required ValueChanged<String>? onChanged,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final debouncedOnChanged = onChanged != null
        ? DebounceUtils.debounceFunction<String>(onChanged, debounceDuration)
        : null;
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: debouncedOnChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带限流onChanged的TextFormField
  ///
  /// [onChanged] 文本变化回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流onChanged的TextFormField
  static TextFormField throttle({
    required ValueChanged<String>? onChanged,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final throttledOnChanged = onChanged != null
        ? ThrottleUtils.throttleFunction<String>(onChanged, throttleDuration)
        : null;
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: throttledOnChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带去重onChanged的TextFormField
  ///
  /// [onChanged] 文本变化回调
  /// [equals] 相等性比较函数
  /// 返回带去重onChanged的TextFormField
  static TextFormField distinct({
    required ValueChanged<String>? onChanged,
    bool Function(String, String)? equals,
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    final distinctOnChanged = onChanged != null
        ? DistinctUtils.distinctFunction<String>(onChanged, equals: equals)
        : null;
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: distinctOnChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }

  /// 创建带订阅onChanged的TextFormField
  ///
  /// [onChanged] 文本变化回调
  /// [reactive] Reactive对象
  /// 返回带订阅onChanged的TextFormField
  static TextFormField subscribe({
    required ValueChanged<String>? onChanged,
    required Reactive<String> reactive,
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool autofocus = false,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
  }) {
    if (onChanged != null) {
      reactive.listen((value) => onChanged(value));
    }
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }
}

/// 文本输入工具类
class TextFieldUtils {
  /// 创建防抖onChanged
  ///
  /// [onChanged] 文本变化回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回防抖后的onChanged
  static ValueChanged<String> debounceOnChanged(
    ValueChanged<String> onChanged,
    Duration debounceDuration,
  ) {
    return DebounceUtils.debounceFunction<String>(onChanged, debounceDuration);
  }

  /// 创建限流onChanged
  ///
  /// [onChanged] 文本变化回调
  /// [throttleDuration] 限流时间间隔
  /// 返回限流后的onChanged
  static ValueChanged<String> throttleOnChanged(
    ValueChanged<String> onChanged,
    Duration throttleDuration,
  ) {
    return ThrottleUtils.throttleFunction<String>(onChanged, throttleDuration);
  }

  /// 创建去重onChanged
  ///
  /// [onChanged] 文本变化回调
  /// [equals] 相等性比较函数
  /// 返回去重后的onChanged
  static ValueChanged<String> distinctOnChanged(
    ValueChanged<String> onChanged, {
    bool Function(String, String)? equals,
  }) {
    return DistinctUtils.distinctFunction<String>(onChanged, equals: equals);
  }

  /// 创建组合onChanged（防抖+去重）
  ///
  /// [onChanged] 文本变化回调
  /// [debounceDuration] 防抖时间间隔
  /// [equals] 相等性比较函数
  /// 返回组合后的onChanged
  static ValueChanged<String> debounceDistinctOnChanged(
    ValueChanged<String> onChanged,
    Duration debounceDuration, {
    bool Function(String, String)? equals,
  }) {
    return DistinctUtils.distinctFunction<String>(
      DebounceUtils.debounceFunction<String>(onChanged, debounceDuration),
      equals: equals,
    );
  }

  /// 创建组合onChanged（限流+去重）
  ///
  /// [onChanged] 文本变化回调
  /// [throttleDuration] 限流时间间隔
  /// [equals] 相等性比较函数
  /// 返回组合后的onChanged
  static ValueChanged<String> throttleDistinctOnChanged(
    ValueChanged<String> onChanged,
    Duration throttleDuration, {
    bool Function(String, String)? equals,
  }) {
    return DistinctUtils.distinctFunction<String>(
      ThrottleUtils.throttleFunction<String>(onChanged, throttleDuration),
      equals: equals,
    );
  }
}
