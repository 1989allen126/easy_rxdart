import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../../core/reactive.dart';
import '../stream/stream_controller_extensions.dart';

/// 权限响应式扩展
extension PermissionReactiveX on Permission {
  /// 申请权限并返回Reactive
  Reactive<PermissionStatus> requestX() {
    final controller = StreamController<PermissionStatus>.broadcast();

    request().then((status) {
      controller.emit(status);
      controller.close();
    });

    return controller.asReactive();
  }

  /// 检查权限是否授予
  Reactive<bool> isGrantedX() {
    return Reactive.fromFuture(status).map((status) => status.isGranted);
  }

  /// 检查权限是否永久拒绝
  Reactive<bool> isPermanentlyDeniedX() {
    return Reactive.fromFuture(status)
        .map((status) => status.isPermanentlyDenied);
  }
}
