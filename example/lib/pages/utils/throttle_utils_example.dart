import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 限流工具类示例页面
class ThrottleUtilsExamplePage extends StatefulWidget {
  const ThrottleUtilsExamplePage({super.key});

  @override
  State<ThrottleUtilsExamplePage> createState() =>
      _ThrottleUtilsExamplePageState();
}

class _ThrottleUtilsExamplePageState extends State<ThrottleUtilsExamplePage> {
  int _clickCount = 0;
  int _executedCount = 0;
  final List<String> _logs = [];
  ThrottleController<int>? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ThrottleUtils.createController<int>(
      const Duration(milliseconds: 1000),
    );
    _controller!.setCallback((value) {
      setState(() {
        _executedCount++;
        _logs.add(
            '${DateTime.now().toString().substring(11, 19)}: 执行回调，值=$value');
        if (_logs.length > 10) {
          _logs.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('限流工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. throttleVoid - 限流函数（无参数）'),
          _buildThrottleVoidExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. throttleFunction - 限流函数（有参数）'),
          _buildThrottleFunctionExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. throttleAsync - 限流异步函数'),
          _buildThrottleAsyncExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. ThrottleController - 限流控制器'),
          _buildThrottleControllerExample(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThrottleVoidExample() {
    int clickCount = 0;
    int executedCount = 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '快速点击按钮，每1秒最多执行一次',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('点击次数: $clickCount'),
                Text('执行次数: $executedCount'),
              ],
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) {
                final throttled = ThrottleUtils.throttleVoid(
                  () {
                    setState(() {
                      executedCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('限流执行成功！'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  const Duration(milliseconds: 1000),
                );
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      clickCount++;
                    });
                    throttled();
                  },
                  child: const Text('快速点击我'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThrottleFunctionExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '限流函数示例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '输入值（每500ms最多触发一次）',
                border: OutlineInputBorder(),
              ),
              onChanged: ThrottleUtils.throttleFunction<String>(
                (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('限流触发: $value'),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                const Duration(milliseconds: 500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThrottleAsyncExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '异步限流函数示例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ThrottleUtils.throttleAsyncVoid(
                () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('异步限流执行成功！'),
                      ),
                    );
                  }
                },
                const Duration(milliseconds: 1000),
              ),
              child: const Text('异步限流按钮'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThrottleControllerExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用ThrottleController控制限流',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('点击次数: $_clickCount'),
                Text('执行次数: $_executedCount'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _clickCount++;
                    });
                    _controller?.trigger(_clickCount);
                  },
                  child: const Text('触发限流'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller?.reset();
                    setState(() {
                      _logs.add(
                          '${DateTime.now().toString().substring(11, 19)}: 重置限流');
                      if (_logs.length > 10) {
                        _logs.removeAt(0);
                      }
                    });
                  },
                  child: const Text('重置限流'),
                ),
              ],
            ),
            if (_logs.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '执行日志:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(maxHeight: 150),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
