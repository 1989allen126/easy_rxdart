import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/reactive.dart';
import '../stream/stream_controller_extensions.dart';

/// ChangeNotifier转换为Reactive
extension ChangeNotifierX on ChangeNotifier {
  /// 转换为Reactive（需要指定数据提取逻辑）
  Reactive<T> toReactive<T>(T Function() extractor) {
    final controller = StreamController<T>.broadcast();

    void listener() => controller.emit(extractor());
    addListener(listener);

    controller.onCancel = () => removeListener(listener);

    return controller.asReactive();
  }
}
