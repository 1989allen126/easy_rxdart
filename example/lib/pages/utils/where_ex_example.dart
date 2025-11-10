import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// WhereEx使用示例
class WhereExExample extends StatefulWidget {
  const WhereExExample({super.key});

  @override
  State<WhereExExample> createState() => _WhereExExampleState();
}

class _WhereExExampleState extends State<WhereExExample> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    _runExample();
  }

  Future<void> _runExample() async {
    // 示例1: Stream whereEx - asList
    final stream1 = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final result1 = await stream1.whereEx([
      (value) => value % 2 == 0, // 偶数
      (value) => value > 7, // 大于7
    ]).asList();

    // 示例2: Stream whereEx - asMap
    final stream2 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final result2 = await stream2.whereEx([
      (value) => value % 2 == 0, // 偶数
    ]).asMap();

    // 示例3: Reactive whereEx
    final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
    final result3 = await reactive.whereEx([
      (value) => value > 3,
    ]).asList();

    // 示例4: RxUtils whereEx
    final stream4 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final result4 = await RxUtils.whereEx<int>(stream4, [
      (value) => value % 2 == 0,
    ]).asList();

    setState(() {
      _result = '''
示例1 - Stream whereEx asList:
  满足条件: ${result1.matched}
  不满足条件: ${result1.unmatched}
  总数: ${result1.total}

示例2 - Stream whereEx asMap:
  满足条件: ${result2[true]}
  不满足条件: ${result2[false]}

示例3 - Reactive whereEx:
  满足条件: ${result3.matched}
  不满足条件: ${result3.unmatched}

示例4 - RxUtils whereEx:
  满足条件: ${result4.matched}
  不满足条件: ${result4.unmatched}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhereEx示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WhereEx功能说明:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. whereEx([条件1, 条件2]) - 支持多个过滤条件，使用OR逻辑（满足任一条件即为matched）\n'
              '2. asList() - 返回包含matched和unmatched两个列表的对象\n'
              '3. asMap() - 返回Map，key为true/false，value为对应的列表\n'
              '4. 支持Stream、Reactive和RxUtils工具方法',
            ),
            const SizedBox(height: 16),
            const Text(
              '运行结果:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _result.isEmpty ? '加载中...' : _result,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
