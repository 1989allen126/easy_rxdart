import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

/// 防抖工具类示例页面
class DebounceUtilsExamplePage extends StatefulWidget {
  const DebounceUtilsExamplePage({super.key});

  @override
  State<DebounceUtilsExamplePage> createState() =>
      _DebounceUtilsExamplePageState();
}

class _DebounceUtilsExamplePageState extends State<DebounceUtilsExamplePage> {
  int _clickCount = 0;
  int _executedCount = 0;
  final List<String> _logs = [];
  StreamSubscription<int>? _subscription;
  DebounceController<int>? _controller;

  @override
  void initState() {
    super.initState();
    _controller = DebounceUtils.createController<int>(
      const Duration(milliseconds: 500),
    );
    _controller!.setCallback((value) {
      setState(() {
        _executedCount++;
        _logs.add('${DateTime.now().toString().substring(11, 19)}: 执行回调，值=$value');
        if (_logs.length > 10) {
          _logs.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('防抖工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. debounceVoid - 防抖函数（无参数）'),
          _buildDebounceVoidExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. debounceFunction - 防抖函数（有参数）'),
          _buildDebounceFunctionExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. debounceAsync - 防抖异步函数'),
          _buildDebounceAsyncExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. DebounceController - 防抖控制器'),
          _buildDebounceControllerExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. debounce - Stream防抖'),
          _buildDebounceStreamExample(),
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

  Widget _buildDebounceVoidExample() {
    int clickCount = 0;
    int executedCount = 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '快速点击按钮，只有最后一次点击后500ms才会执行',
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
                final debounced = DebounceUtils.debounceVoid(
                  () {
                    setState(() {
                      executedCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('防抖执行成功！'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  const Duration(milliseconds: 500),
                );
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      clickCount++;
                    });
                    debounced();
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

  Widget _buildDebounceFunctionExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '输入框防抖搜索，输入停止500ms后执行搜索',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '搜索关键词',
                border: OutlineInputBorder(),
              ),
              onChanged: DebounceUtils.debounceFunction<String>(
                (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('搜索: $value'),
                      duration: const Duration(milliseconds: 500),
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

  Widget _buildDebounceAsyncExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '异步防抖函数示例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: DebounceUtils.debounceAsyncVoid(
                () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('异步防抖执行成功！'),
                      ),
                    );
                  }
                },
                const Duration(milliseconds: 500),
              ),
              child: const Text('异步防抖按钮'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebounceControllerExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用DebounceController控制防抖',
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
                  child: const Text('触发防抖'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller?.cancel();
                    setState(() {
                      _logs.add('${DateTime.now().toString().substring(11, 19)}: 取消防抖');
                      if (_logs.length > 10) {
                        _logs.removeAt(0);
                      }
                    });
                  },
                  child: const Text('取消防抖'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller?.flush();
                    setState(() {
                      _logs.add('${DateTime.now().toString().substring(11, 19)}: 立即执行');
                      if (_logs.length > 10) {
                        _logs.removeAt(0);
                      }
                    });
                  },
                  child: const Text('立即执行'),
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

  Widget _buildDebounceStreamExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Stream防抖示例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final controller = StreamController<int>();
                final debouncedStream = DebounceUtils.debounce<int>(
                  controller.stream,
                  const Duration(milliseconds: 500),
                );
                _subscription?.cancel();
                _subscription = debouncedStream.listen((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Stream防抖值: $value'),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                });
                for (int i = 1; i <= 5; i++) {
                  controller.add(i);
                }
                controller.close();
              },
              child: const Text('触发Stream防抖'),
            ),
          ],
        ),
      ),
    );
  }
}

