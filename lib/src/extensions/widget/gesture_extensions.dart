import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utils/debounce_utils.dart';
import '../../utils/throttle_utils.dart';
import '../../utils/distinct_utils.dart';
import '../../core/reactive.dart';

/// GestureDetector 防抖、限流、去重和订阅扩展
extension GestureDetectorX on GestureDetector {
  /// 创建带防抖的 GestureDetector
  ///
  /// [onTap] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 GestureDetector
  static GestureDetector debounce({
    required VoidCallback? onTap,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) {
    final debouncedOnTap =
        onTap != null ? DebounceUtils.debounceVoid(onTap, debounceDuration) : null;
    return GestureDetector(
      key: key,
      onTap: debouncedOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: child,
    );
  }

  /// 创建带限流的 GestureDetector
  ///
  /// [onTap] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 GestureDetector
  static GestureDetector throttle({
    required VoidCallback? onTap,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) {
    final throttledOnTap = onTap != null
        ? ThrottleUtils.throttleVoid(onTap, throttleDuration)
        : null;
    return GestureDetector(
      key: key,
      onTap: throttledOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: child,
    );
  }

  /// 创建带去重的 GestureDetector
  ///
  /// [onTap] 点击回调
  /// 返回带去重的 GestureDetector
  static GestureDetector distinct({
    required VoidCallback? onTap,
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) {
    final distinctOnTap = onTap != null
        ? DistinctUtils.distinctVoid(onTap)
        : null;
    return GestureDetector(
      key: key,
      onTap: distinctOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: child,
    );
  }

  /// 创建带订阅的 GestureDetector
  ///
  /// [onTap] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 GestureDetector
  static GestureDetector subscribe({
    required VoidCallback? onTap,
    required Reactive<void> reactive,
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) {
    if (onTap != null) {
      reactive.listen((_) => onTap());
    }
    return GestureDetector(
      key: key,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: child,
    );
  }
}

/// InkWell 防抖和限流扩展
extension InkWellX on InkWell {
  /// 创建带防抖的 InkWell
  ///
  /// [onTap] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 InkWell
  static InkWell debounce({
    required VoidCallback? onTap,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autofocus = false,
    MouseCursor? mouseCursor,
  }) {
    final debouncedOnTap =
        onTap != null ? DebounceUtils.debounceVoid(onTap, debounceDuration) : null;
    return InkWell(
      key: key,
      onTap: debouncedOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      child: child,
    );
  }

  /// 创建带限流的 InkWell
  ///
  /// [onTap] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 InkWell
  static InkWell throttle({
    required VoidCallback? onTap,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autofocus = false,
    MouseCursor? mouseCursor,
  }) {
    final throttledOnTap = onTap != null
        ? ThrottleUtils.throttleVoid(onTap, throttleDuration)
        : null;
    return InkWell(
      key: key,
      onTap: throttledOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      child: child,
    );
  }

  /// 创建带去重的 InkWell
  ///
  /// [onTap] 点击回调
  /// 返回带去重的 InkWell
  static InkWell distinct({
    required VoidCallback? onTap,
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autofocus = false,
    MouseCursor? mouseCursor,
  }) {
    final distinctOnTap = onTap != null
        ? DistinctUtils.distinctVoid(onTap)
        : null;
    return InkWell(
      key: key,
      onTap: distinctOnTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      child: child,
    );
  }

  /// 创建带订阅的 InkWell
  ///
  /// [onTap] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 InkWell
  static InkWell subscribe({
    required VoidCallback? onTap,
    required Reactive<void> reactive,
    Key? key,
    Widget? child,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autofocus = false,
    MouseCursor? mouseCursor,
  }) {
    if (onTap != null) {
      reactive.listen((_) => onTap());
    }
    return InkWell(
      key: key,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      child: child,
    );
  }
}

/// Button 防抖和限流扩展
extension ButtonX on Widget {
  /// 包装 Widget 并添加防抖点击事件
  ///
  /// [onTap] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 Widget
  Widget debounceTap({
    required VoidCallback? onTap,
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    if (onTap == null) {
      return this;
    }
    final debouncedOnTap = DebounceUtils.debounceVoid(onTap, debounceDuration);
    return GestureDetector(
      onTap: debouncedOnTap,
      child: this,
    );
  }

  /// 包装 Widget 并添加限流点击事件
  ///
  /// [onTap] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 Widget
  Widget throttleTap({
    required VoidCallback? onTap,
    Duration throttleDuration = const Duration(milliseconds: 300),
  }) {
    if (onTap == null) {
      return this;
    }
    final throttledOnTap =
        ThrottleUtils.throttleVoid(onTap, throttleDuration);
    return GestureDetector(
      onTap: throttledOnTap,
      child: this,
    );
  }

  /// 包装 Widget 并添加去重点击事件
  ///
  /// [onTap] 点击回调
  /// 返回带去重的 Widget
  Widget distinctTap({
    required VoidCallback? onTap,
  }) {
    if (onTap == null) {
      return this;
    }
    final distinctOnTap = DistinctUtils.distinctVoid(onTap);
    return GestureDetector(
      onTap: distinctOnTap,
      child: this,
    );
  }

  /// 包装 Widget 并添加订阅点击事件
  ///
  /// [onTap] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 Widget
  Widget subscribeTap({
    required VoidCallback? onTap,
    required Reactive<void> reactive,
  }) {
    if (onTap == null) {
      return this;
    }
    reactive.listen((_) => onTap());
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}

/// ElevatedButton 防抖、限流、去重和订阅扩展
extension ElevatedButtonX on ElevatedButton {
  /// 创建带防抖的 ElevatedButton
  ///
  /// [onPressed] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 ElevatedButton
  static ElevatedButton debounce({
    required VoidCallback? onPressed,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final debouncedOnPressed = onPressed != null
        ? DebounceUtils.debounceVoid(onPressed, debounceDuration)
        : null;
    return ElevatedButton(
      key: key,
      onPressed: debouncedOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带限流的 ElevatedButton
  ///
  /// [onPressed] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 ElevatedButton
  static ElevatedButton throttle({
    required VoidCallback? onPressed,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final throttledOnPressed = onPressed != null
        ? ThrottleUtils.throttleVoid(onPressed, throttleDuration)
        : null;
    return ElevatedButton(
      key: key,
      onPressed: throttledOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带去重的 ElevatedButton
  ///
  /// [onPressed] 点击回调
  /// 返回带去重的 ElevatedButton
  static ElevatedButton distinct({
    required VoidCallback? onPressed,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final distinctOnPressed = onPressed != null
        ? DistinctUtils.distinctVoid(onPressed)
        : null;
    return ElevatedButton(
      key: key,
      onPressed: distinctOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带订阅的 ElevatedButton
  ///
  /// [onPressed] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 ElevatedButton
  static ElevatedButton subscribe({
    required VoidCallback? onPressed,
    required Reactive<void> reactive,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    if (onPressed != null) {
      reactive.listen((_) => onPressed());
    }
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// TextButton 防抖、限流、去重和订阅扩展
extension TextButtonX on TextButton {
  /// 创建带防抖的 TextButton
  ///
  /// [onPressed] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 TextButton
  static TextButton debounce({
    required VoidCallback? onPressed,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final debouncedOnPressed = onPressed != null
        ? DebounceUtils.debounceVoid(onPressed, debounceDuration)
        : null;
    return TextButton(
      key: key,
      onPressed: debouncedOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带限流的 TextButton
  ///
  /// [onPressed] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 TextButton
  static TextButton throttle({
    required VoidCallback? onPressed,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final throttledOnPressed = onPressed != null
        ? ThrottleUtils.throttleVoid(onPressed, throttleDuration)
        : null;
    return TextButton(
      key: key,
      onPressed: throttledOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带去重的 TextButton
  ///
  /// [onPressed] 点击回调
  /// 返回带去重的 TextButton
  static TextButton distinct({
    required VoidCallback? onPressed,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final distinctOnPressed = onPressed != null
        ? DistinctUtils.distinctVoid(onPressed)
        : null;
    return TextButton(
      key: key,
      onPressed: distinctOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带订阅的 TextButton
  ///
  /// [onPressed] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 TextButton
  static TextButton subscribe({
    required VoidCallback? onPressed,
    required Reactive<void> reactive,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    if (onPressed != null) {
      reactive.listen((_) => onPressed());
    }
    return TextButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// OutlinedButton 防抖、限流、去重和订阅扩展
extension OutlinedButtonX on OutlinedButton {
  /// 创建带防抖的 OutlinedButton
  ///
  /// [onPressed] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 OutlinedButton
  static OutlinedButton debounce({
    required VoidCallback? onPressed,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final debouncedOnPressed = onPressed != null
        ? DebounceUtils.debounceVoid(onPressed, debounceDuration)
        : null;
    return OutlinedButton(
      key: key,
      onPressed: debouncedOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带限流的 OutlinedButton
  ///
  /// [onPressed] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 OutlinedButton
  static OutlinedButton throttle({
    required VoidCallback? onPressed,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final throttledOnPressed = onPressed != null
        ? ThrottleUtils.throttleVoid(onPressed, throttleDuration)
        : null;
    return OutlinedButton(
      key: key,
      onPressed: throttledOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带去重的 OutlinedButton
  ///
  /// [onPressed] 点击回调
  /// 返回带去重的 OutlinedButton
  static OutlinedButton distinct({
    required VoidCallback? onPressed,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    final distinctOnPressed = onPressed != null
        ? DistinctUtils.distinctVoid(onPressed)
        : null;
    return OutlinedButton(
      key: key,
      onPressed: distinctOnPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// 创建带订阅的 OutlinedButton
  ///
  /// [onPressed] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 OutlinedButton
  static OutlinedButton subscribe({
    required VoidCallback? onPressed,
    required Reactive<void> reactive,
    Key? key,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
  }) {
    if (onPressed != null) {
      reactive.listen((_) => onPressed());
    }
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// IconButton 防抖、限流、去重和订阅扩展
extension IconButtonX on IconButton {
  /// 创建带防抖的 IconButton
  ///
  /// [onPressed] 点击回调
  /// [debounceDuration] 防抖时间间隔
  /// 返回带防抖的 IconButton
  static IconButton debounce({
    required VoidCallback? onPressed,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget icon,
    Widget? selectedIcon,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
    double? iconSize,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? disabledColor,
    double? splashRadius,
    bool isSelected = false,
    AlignmentGeometry alignment = Alignment.center,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    bool? enableFeedback,
    MouseCursor? mouseCursor,
  }) {
    final debouncedOnPressed = onPressed != null
        ? DebounceUtils.debounceVoid(onPressed, debounceDuration)
        : null;
    return IconButton(
      key: key,
      onPressed: debouncedOnPressed,
      icon: icon,
      selectedIcon: selectedIcon,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      disabledColor: disabledColor,
      splashRadius: splashRadius,
      isSelected: isSelected,
      alignment: alignment,
      visualDensity: visualDensity,
      padding: padding,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
    );
  }

  /// 创建带限流的 IconButton
  ///
  /// [onPressed] 点击回调
  /// [throttleDuration] 限流时间间隔
  /// 返回带限流的 IconButton
  static IconButton throttle({
    required VoidCallback? onPressed,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    required Widget icon,
    Widget? selectedIcon,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
    double? iconSize,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? disabledColor,
    double? splashRadius,
    bool isSelected = false,
    AlignmentGeometry alignment = Alignment.center,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    bool? enableFeedback,
    MouseCursor? mouseCursor,
  }) {
    final throttledOnPressed = onPressed != null
        ? ThrottleUtils.throttleVoid(onPressed, throttleDuration)
        : null;
    return IconButton(
      key: key,
      onPressed: throttledOnPressed,
      icon: icon,
      selectedIcon: selectedIcon,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      disabledColor: disabledColor,
      splashRadius: splashRadius,
      isSelected: isSelected,
      alignment: alignment,
      visualDensity: visualDensity,
      padding: padding,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
    );
  }

  /// 创建带去重的 IconButton
  ///
  /// [onPressed] 点击回调
  /// 返回带去重的 IconButton
  static IconButton distinct({
    required VoidCallback? onPressed,
    Key? key,
    required Widget icon,
    Widget? selectedIcon,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
    double? iconSize,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? disabledColor,
    double? splashRadius,
    bool isSelected = false,
    AlignmentGeometry alignment = Alignment.center,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    bool? enableFeedback,
    MouseCursor? mouseCursor,
  }) {
    final distinctOnPressed = onPressed != null
        ? DistinctUtils.distinctVoid(onPressed)
        : null;
    return IconButton(
      key: key,
      onPressed: distinctOnPressed,
      icon: icon,
      selectedIcon: selectedIcon,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      disabledColor: disabledColor,
      splashRadius: splashRadius,
      isSelected: isSelected,
      alignment: alignment,
      visualDensity: visualDensity,
      padding: padding,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
    );
  }

  /// 创建带订阅的 IconButton
  ///
  /// [onPressed] 点击回调
  /// [reactive] Reactive对象
  /// 返回带订阅的 IconButton
  static IconButton subscribe({
    required VoidCallback? onPressed,
    required Reactive<void> reactive,
    Key? key,
    required Widget icon,
    Widget? selectedIcon,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
    double? iconSize,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? disabledColor,
    double? splashRadius,
    bool isSelected = false,
    AlignmentGeometry alignment = Alignment.center,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    bool? enableFeedback,
    MouseCursor? mouseCursor,
  }) {
    if (onPressed != null) {
      reactive.listen((_) => onPressed());
    }
    return IconButton(
      key: key,
      onPressed: onPressed,
      icon: icon,
      selectedIcon: selectedIcon,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      disabledColor: disabledColor,
      splashRadius: splashRadius,
      isSelected: isSelected,
      alignment: alignment,
      visualDensity: visualDensity,
      padding: padding,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
    );
  }
}
