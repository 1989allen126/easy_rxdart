import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 去重工具类示例页面
class DistinctUtilsExamplePage extends StatefulWidget {
  const DistinctUtilsExamplePage({super.key});

  @override
  State<DistinctUtilsExamplePage> createState() =>
      _DistinctUtilsExamplePageState();
}

class _DistinctUtilsExamplePageState extends State<DistinctUtilsExamplePage> {
  int _clickCount = 0;
  int _executedCount = 0;
  final List<String> _logs = [];
  DistinctController<int>? _controller;
  int _lastValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = DistinctUtils.createController<int>();
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
        title: const Text('去重工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. distinctVoid - 去重函数（无参数）'),
          _buildDistinctVoidExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. distinctFunction - 去重函数（有参数）'),
          _buildDistinctFunctionExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. distinctAsync - 去重异步函数'),
          _buildDistinctAsyncExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. DistinctController - 去重控制器'),
          _buildDistinctControllerExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 自定义相等性比较'),
          _buildCustomEqualsExample(),
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

  Widget _buildDistinctVoidExample() {
    int clickCount = 0;
    int executedCount = 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '连续点击按钮，只有第一次点击会执行',
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
                final distinct = DistinctUtils.distinctVoid(
                  () {
                    setState(() {
                      executedCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('去重执行成功！'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                );
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      clickCount++;
                    });
                    distinct();
                  },
                  child: const Text('连续点击我'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistinctFunctionExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '输入框去重，相同值不会重复触发',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '输入值（相同值不会触发）',
                border: OutlineInputBorder(),
              ),
              onChanged: DistinctUtils.distinctFunction<String>(
                (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('值变化: $value'),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistinctAsyncExample() {
    final distinctAsync = DistinctUtils.distinctAsync<int>(
      (value) async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('异步去重执行: $value'),
            ),
          );
        }
      },
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '异步去重函数示例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => distinctAsync(1),
                  child: const Text('触发值1'),
                ),
                ElevatedButton(
                  onPressed: () => distinctAsync(2),
                  child: const Text('触发值2'),
                ),
                ElevatedButton(
                  onPressed: () => distinctAsync(1),
                  child: const Text('再次触发值1（不会执行）'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistinctControllerExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用DistinctController控制去重',
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
                      _lastValue = _clickCount % 3; // 值在0,1,2之间循环
                    });
                    _controller?.trigger(_lastValue);
                  },
                  child: const Text('触发去重'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller?.reset();
                    setState(() {
                      _logs.add(
                          '${DateTime.now().toString().substring(11, 19)}: 重置去重');
                      if (_logs.length > 10) {
                        _logs.removeAt(0);
                      }
                    });
                  },
                  child: const Text('重置去重'),
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

  Widget _buildCustomEqualsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '自定义相等性比较函数',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '输入数字（绝对值相同视为相等）',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: DistinctUtils.distinctFunction<String>(
                (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('值变化: $value'),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                equals: (a, b) {
                  final numA = int.tryParse(a) ?? 0;
                  final numB = int.tryParse(b) ?? 0;
                  return numA.abs() == numB.abs();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
