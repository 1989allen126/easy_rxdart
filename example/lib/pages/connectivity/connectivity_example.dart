import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_rxdart/easy_rxdart.dart';

/// 网络监听示例页面
class ConnectivityExamplePage extends StatelessWidget {
  const ConnectivityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络监听使用'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _ConnectivityExampleWidget(),
      ),
    );
  }
}

/// 网络监听示例Widget
class _ConnectivityExampleWidget extends StatefulWidget {
  const _ConnectivityExampleWidget();

  @override
  State<_ConnectivityExampleWidget> createState() => _ConnectivityExampleWidgetState();
}

class _ConnectivityExampleWidgetState extends State<_ConnectivityExampleWidget> {
  NetworkInfo? _networkInfo;
  StreamSubscription<NetworkInfo>? _subscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription = ConnectivityUtils.watch()
        .distinctByStatus()
        .listen((info) {
      setState(() {
        _networkInfo = info;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String _getStatusText(NetworkInfo? info) {
    if (info == null) {
      return '检测中...';
    }
    return '网络状态: ${info.status.name}\n'
        '是否连接: ${info.isConnected ? "是" : "否"}\n'
        '连接类型: ${info.isWifi ? "WiFi" : info.isMobile ? "移动数据" : "无网络"}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '网络状态监听',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _networkInfo?.isConnected == true
                ? Colors.green.shade50
                : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _networkInfo?.isConnected == true
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          child: Text(
            _getStatusText(_networkInfo),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final info = await ConnectivityUtils.current.toFuture();
                setState(() {
                  _networkInfo = info;
                });
              },
              child: const Text('刷新状态'),
            ),
            ElevatedButton(
              onPressed: () {
                ConnectivityUtils.watchWifi()
                    .listen((isWifi) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('WiFi状态: ${isWifi ? "已连接" : "未连接"}'),
                    ),
                  );
                });
              },
              child: const Text('监听WiFi'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '提示：网络状态变化时会自动更新',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
