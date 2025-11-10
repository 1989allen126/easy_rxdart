import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限链式调用包装类
class PermissionChain {
  final Permission _permission;
  PermissionStatus? _status;

  PermissionChain(this._permission);

  /// 获取权限实例
  Permission get permission => _permission;

  /// 获取当前状态
  PermissionStatus? get status => _status;

  /// 设置状态（用于测试）
  @visibleForTesting
  void setStatus(PermissionStatus status) {
    _status = status;
  }

  /// 检查权限状态
  ///
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .checkStatus()
  ///   .then((status) => print('状态: $status'));
  /// ```
  Future<PermissionChain> checkStatus() async {
    _status = await _permission.status;
    return this;
  }

  /// 申请权限
  ///
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .then((status) => print('状态: $status'));
  /// ```
  Future<PermissionChain> request() async {
    _status = await _permission.request();
    return this;
  }

  /// 如果权限已授予，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifGranted(() => print('权限已授予'));
  /// ```
  PermissionChain ifGranted(void Function() callback) {
    if (_status?.isGranted ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限未授予，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifNotGranted(() => print('权限未授予'));
  /// ```
  PermissionChain ifNotGranted(void Function() callback) {
    if (_status == null || !_status!.isGranted) {
      callback();
    }
    return this;
  }

  /// 如果权限被拒绝，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifDenied(() => print('权限被拒绝'));
  /// ```
  PermissionChain ifDenied(void Function() callback) {
    if (_status?.isDenied ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限被永久拒绝，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifPermanentlyDenied(() => openAppSettings());
  /// ```
  PermissionChain ifPermanentlyDenied(void Function() callback) {
    if (_status?.isPermanentlyDenied ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限受限，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifRestricted(() => print('权限受限'));
  /// ```
  PermissionChain ifRestricted(void Function() callback) {
    if (_status?.isRestricted ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限未确定，执行回调
  ///
  /// [callback] 回调函数
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifLimited(() => print('权限受限'));
  /// ```
  PermissionChain ifLimited(void Function() callback) {
    if (_status?.isLimited ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限已授予，执行回调并返回结果
  ///
  /// [callback] 回调函数，返回结果
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifGrantedThen(() => '已授予')
  ///   .then((result) => print('结果: $result'));
  /// ```
  PermissionChain ifGrantedThen<T>(T Function() callback) {
    if (_status?.isGranted ?? false) {
      callback();
    }
    return this;
  }

  /// 如果权限未授予，执行回调并返回结果
  ///
  /// [callback] 回调函数，返回结果
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifNotGrantedThen(() => '未授予')
  ///   .then((result) => print('结果: $result'));
  /// ```
  PermissionChain ifNotGrantedThen<T>(T Function() callback) {
    if (_status == null || !_status!.isGranted) {
      callback();
    }
    return this;
  }

  /// 根据权限状态执行不同的回调
  ///
  /// [onGranted] 权限已授予时的回调
  /// [onDenied] 权限被拒绝时的回调
  /// [onPermanentlyDenied] 权限被永久拒绝时的回调
  /// [onRestricted] 权限受限时的回调
  /// [onLimited] 权限受限时的回调
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .when(
  ///     onGranted: () => print('已授予'),
  ///     onDenied: () => print('被拒绝'),
  ///     onPermanentlyDenied: () => openAppSettings(),
  ///   );
  /// ```
  PermissionChain when({
    void Function()? onGranted,
    void Function()? onDenied,
    void Function()? onPermanentlyDenied,
    void Function()? onRestricted,
    void Function()? onLimited,
  }) {
    if (_status == null) return this;

    if (_status!.isGranted && onGranted != null) {
      onGranted();
    } else if (_status!.isDenied && onDenied != null) {
      onDenied();
    } else if (_status!.isPermanentlyDenied && onPermanentlyDenied != null) {
      onPermanentlyDenied();
    } else if (_status!.isRestricted && onRestricted != null) {
      onRestricted();
    } else if (_status!.isLimited && onLimited != null) {
      onLimited();
    }

    return this;
  }

  /// 打开应用设置
  ///
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .request()
  ///   .ifPermanentlyDenied(() => openAppSettings());
  /// ```
  Future<PermissionChain> openSettings() async {
    await openAppSettings();
    return this;
  }

  /// 检查权限是否已授予
  ///
  /// 返回是否已授予
  bool get isGranted => _status?.isGranted ?? false;

  /// 检查权限是否被拒绝
  ///
  /// 返回是否被拒绝
  bool get isDenied => _status?.isDenied ?? false;

  /// 检查权限是否被永久拒绝
  ///
  /// 返回是否被永久拒绝
  bool get isPermanentlyDenied => _status?.isPermanentlyDenied ?? false;

  /// 检查权限是否受限
  ///
  /// 返回是否受限
  bool get isRestricted => _status?.isRestricted ?? false;

  /// 检查权限是否受限
  ///
  /// 返回是否受限
  bool get isLimited => _status?.isLimited ?? false;
}

/// 权限链式调用扩展
extension PermissionChainX on Permission {
  /// 创建链式调用对象
  ///
  /// 返回链式调用对象，可以继续链式调用
  ///
  /// ### 示例
  ///
  /// ```dart
  /// Permission.camera
  ///   .chain()
  ///   .checkStatus()
  ///   .ifNotGranted(() => Permission.camera.chain().request())
  ///   .ifGranted(() => print('权限已授予'));
  /// ```
  PermissionChain chain() {
    return PermissionChain(this);
  }
}
