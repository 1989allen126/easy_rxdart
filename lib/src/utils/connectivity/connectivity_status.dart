import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络连接状态
enum ConnectivityStatus {
  /// WiFi连接
  wifi('wifi'),
  /// 移动数据连接
  mobile('mobile'),
  /// 以太网连接
  ethernet('ethernet'),
  /// 无网络连接
  none('none'),
  /// 其他连接类型
  other('other');

  /// 状态名称
  final String name;

  /// 构造函数
  const ConnectivityStatus(this.name);

  /// 从ConnectivityResult创建
  factory ConnectivityStatus.fromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case ConnectivityResult.mobile:
        return ConnectivityStatus.mobile;
      case ConnectivityResult.ethernet:
        return ConnectivityStatus.ethernet;
      case ConnectivityResult.none:
        return ConnectivityStatus.none;
      case ConnectivityResult.other:
        return ConnectivityStatus.other;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        return ConnectivityStatus.other;
    }
  }

  /// 转换为ConnectivityResult
  ConnectivityResult toResult() {
    switch (this) {
      case ConnectivityStatus.wifi:
        return ConnectivityResult.wifi;
      case ConnectivityStatus.mobile:
        return ConnectivityResult.mobile;
      case ConnectivityStatus.ethernet:
        return ConnectivityResult.ethernet;
      case ConnectivityStatus.none:
        return ConnectivityResult.none;
      case ConnectivityStatus.other:
        return ConnectivityResult.other;
    }
  }

  /// 是否已连接
  bool get isConnected => this != ConnectivityStatus.none;

  /// 是否使用WiFi
  bool get isWifi => this == ConnectivityStatus.wifi;

  /// 是否使用移动数据
  bool get isMobile => this == ConnectivityStatus.mobile;

  /// 从名称创建
  static ConnectivityStatus? fromName(String name) {
    for (final status in ConnectivityStatus.values) {
      if (status.name == name) {
        return status;
      }
    }
    return null;
  }
}

/// 网络状态信息
class NetworkInfo {
  /// 连接状态
  final ConnectivityStatus status;

  /// 原始ConnectivityResult
  final ConnectivityResult result;

  /// 是否已连接
  final bool isConnected;

  /// 是否使用WiFi
  bool get isWifi => status.isWifi;

  /// 是否使用移动数据
  bool get isMobile => status.isMobile;

  /// 连接时间戳
  final DateTime timestamp;

  /// 构造函数
  NetworkInfo({
    required this.status,
    required this.result,
    required this.isConnected,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 从ConnectivityResult创建
  factory NetworkInfo.fromResult(ConnectivityResult result) {
    final status = ConnectivityStatus.fromResult(result);
    return NetworkInfo(
      status: status,
      result: result,
      isConnected: status.isConnected,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'result': result.toString(),
      'isConnected': isConnected,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// 从Map创建
  factory NetworkInfo.fromMap(Map<String, dynamic> map) {
    return NetworkInfo(
      status: ConnectivityStatus.fromName(map['status'] as String) ??
          ConnectivityStatus.none,
      result: ConnectivityResult.values.firstWhere(
        (e) => e.toString() == map['result'],
        orElse: () => ConnectivityResult.none,
      ),
      isConnected: map['isConnected'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int,
      ),
    );
  }

  @override
  String toString() {
    return 'NetworkInfo(status: ${status.name}, isConnected: $isConnected)';
  }
}
