import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../../core/reactive.dart';
import '../../core/reactive_utils.dart';
import '../stream/stream_controller_extensions.dart';

/// 图片选择器响应式扩展
extension ImagePickerReactiveX on ImagePicker {
  /// 选择图片（响应式）
  Reactive<XFile> pickImageX(
    ImageSource source, {
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    final controller = StreamController<XFile?>.broadcast();

    pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    ).then((file) {
      controller.emit(file);
      controller.close();
    });

    return ReactiveUtils.whereNotNull(controller.asReactive());
  }

  /// 选择视频（响应式）
  Reactive<XFile> pickVideoX(
    ImageSource source, {
    Duration? maxDuration,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    final controller = StreamController<XFile?>.broadcast();

    pickVideo(
      source: source,
      maxDuration: maxDuration,
      preferredCameraDevice: preferredCameraDevice,
    ).then((file) {
      controller.emit(file);
      controller.close();
    });

    return ReactiveUtils.whereNotNull(controller.asReactive());
  }
}
