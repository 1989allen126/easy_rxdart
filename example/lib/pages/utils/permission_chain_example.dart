import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission链式调用示例页面
class PermissionChainExamplePage extends StatefulWidget {
  const PermissionChainExamplePage({super.key});

  @override
  State<PermissionChainExamplePage> createState() =>
      _PermissionChainExamplePageState();
}

class _PermissionChainExamplePageState
    extends State<PermissionChainExamplePage> {
  String _log = '';

  void _addLog(String message) {
    setState(() {
      _log = '$_log${DateTime.now().toString().substring(11, 19)}: $message\n';
    });
  }

  void _clearLog() {
    setState(() {
      _log = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission链式调用示例'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLog,
            tooltip: '清空日志',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildBasicChainExample(),
          const SizedBox(height: 16),
          _buildConditionalChainExample(),
          const SizedBox(height: 16),
          _buildWhenExample(),
          const SizedBox(height: 16),
          _buildComplexChainExample(),
          const SizedBox(height: 16),
          _buildLogDisplay(),
        ],
      ),
    );
  }

  Widget _buildBasicChainExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '基础链式调用',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '检查权限状态并申请权限',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _addLog('开始检查相机权限状态...');
                try {
                  await Permission.camera.chain().checkStatus().then((chain) {
                    _addLog('相机权限状态: ${chain.status}');
                    _addLog('是否已授予: ${chain.isGranted}');
                    if (!chain.isGranted) {
                      _addLog('权限未授予，开始申请...');
                      Permission.camera.chain().request().then((chain) {
                        _addLog('申请结果: ${chain.status}');
                        _addLog('是否已授予: ${chain.isGranted}');
                      });
                    }
                  });
                } catch (e) {
                  _addLog('错误: $e');
                }
              },
              child: const Text('检查并申请相机权限'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionalChainExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '条件链式调用',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '根据权限状态执行不同的操作',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _addLog('开始申请存储权限...');
                try {
                  await Permission.storage.chain().request().then((chain) {
                    _addLog('存储权限状态: ${chain.status}');
                    chain.ifGranted(() {
                      _addLog('✅ 存储权限已授予，可以使用存储功能');
                    }).ifDenied(() {
                      _addLog('❌ 存储权限被拒绝，无法使用存储功能');
                    }).ifPermanentlyDenied(() {
                      _addLog('⚠️ 存储权限被永久拒绝，需要打开设置');
                      openAppSettings();
                    });
                  });
                } catch (e) {
                  _addLog('错误: $e');
                }
              },
              child: const Text('申请存储权限（条件判断）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhenExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'when方法链式调用',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用when方法根据权限状态执行不同操作',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _addLog('开始申请位置权限...');
                try {
                  await Permission.location.chain().request().then((chain) {
                    chain.when(
                      onGranted: () {
                        _addLog('✅ 位置权限已授予');
                      },
                      onDenied: () {
                        _addLog('❌ 位置权限被拒绝');
                      },
                      onPermanentlyDenied: () {
                        _addLog('⚠️ 位置权限被永久拒绝，打开设置');
                        openAppSettings();
                      },
                      onRestricted: () {
                        _addLog('⚠️ 位置权限受限');
                      },
                      onLimited: () {
                        _addLog('⚠️ 位置权限受限（iOS）');
                      },
                    );
                  });
                } catch (e) {
                  _addLog('错误: $e');
                }
              },
              child: const Text('申请位置权限（when方法）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplexChainExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '复杂链式调用',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '组合多个条件判断的链式调用',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _addLog('开始检查麦克风权限...');
                try {
                  await Permission.microphone
                      .chain()
                      .checkStatus()
                      .then((chain) {
                    if (chain.isGranted) {
                      _addLog('✅ 麦克风权限已授予');
                    } else {
                      _addLog('权限未授予，开始申请...');
                      Permission.microphone.chain().request().then((chain) {
                        chain.ifGranted(() {
                          _addLog('✅ 麦克风权限已授予');
                        }).ifNotGranted(() {
                          _addLog('❌ 麦克风权限未授予');
                          chain.ifPermanentlyDenied(() {
                            _addLog('⚠️ 权限被永久拒绝，打开设置');
                            openAppSettings();
                          }).ifDenied(() {
                            _addLog('❌ 权限被拒绝，可以稍后重试');
                          });
                        });
                      });
                    }
                  });
                } catch (e) {
                  _addLog('错误: $e');
                }
              },
              child: const Text('申请麦克风权限（复杂链式）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '日志',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _clearLog,
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _log.isEmpty ? '点击上方按钮测试权限功能' : _log,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
