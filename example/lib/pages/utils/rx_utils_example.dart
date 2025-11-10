import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// RxUtils工具类示例页面
class RxUtilsExamplePage extends StatefulWidget {
  const RxUtilsExamplePage({super.key});

  @override
  State<RxUtilsExamplePage> createState() => _RxUtilsExamplePageState();
}

class _RxUtilsExamplePageState extends State<RxUtilsExamplePage> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    _runExamples();
  }

  Future<void> _runExamples() async {
    final results = <String>[];

    // 示例1: Stream操作符 - filter
    final stream1 = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final filtered = RxUtils.filterStream(stream1, (v) => v % 2 == 0);
    final filteredList = await filtered.toList();
    results.add('1. filterStream - 过滤偶数: $filteredList');

    // 示例2: Stream操作符 - compactMap
    final stream2 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final compacted = RxUtils.compactMapStream(stream2, (v) => v % 2 == 0 ? v * 2 : null);
    final compactedList = await compacted.toList();
    results.add('2. compactMapStream - 过滤null并映射: $compactedList');

    // 示例3: Stream操作符 - flatMap
    final stream3 = Stream.fromIterable([1, 2, 3]);
    final flatMapped = RxUtils.flatMapStream(stream3, (v) => Stream.fromIterable([v, v * 2]));
    final flatMappedList = await flatMapped.toList();
    results.add('3. flatMapStream - 扁平映射: $flatMappedList');

    // 示例4: Stream操作符 - reduce
    final stream4 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final sum = await RxUtils.reduceStream(stream4, 0, (acc, v) => acc + v);
    results.add('4. reduceStream - 求和: $sum');

    // 示例5: Stream操作符 - groupByKey
    final stream5 = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final grouped = await RxUtils.groupByKeyStream(stream5, (v) => v % 2 == 0 ? 'even' : 'odd');
    results.add('5. groupByKeyStream - 按奇偶分组: $grouped');

    // 示例6: Stream操作符 - firstValue/lastValue
    final stream6 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final first = await RxUtils.firstValueStream(stream6);
    final last = await RxUtils.lastValueStream(stream6);
    results.add('6. firstValueStream/lastValueStream - 第一个值: $first, 最后一个值: $last');

    // 示例7: Stream操作符 - sorted
    final stream7 = Stream.fromIterable([5, 2, 8, 1, 9, 3]);
    final sorted = RxUtils.sortedStream(stream7);
    final sortedList = await sorted.toList();
    results.add('7. sortedStream - 排序: $sortedList');

    // 示例8: Stream操作符 - reversed
    final stream8 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final reversed = RxUtils.reversedStream(stream8);
    final reversedList = await reversed.toList();
    results.add('8. reversedStream - 反转: $reversedList');

    // 示例9: Stream操作符 - paginate
    final stream9 = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final paginated = RxUtils.paginateStream(stream9, 3, 1); // 每页3个，第2页（索引1）
    final paginatedList = await paginated.toList();
    results.add('9. paginateStream - 分页(每页3个，第2页): $paginatedList');

    // 示例10: Stream操作符 - statistics
    final stream10 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final stats = await RxUtils.statisticsStream(stream10);
    results.add('10. statisticsStream - 统计: 数量=${stats.count}, 第一个=${stats.first}, 最后一个=${stats.last}');

    // 示例11: Reactive操作符 - map
    final reactive1 = Reactive.fromIterable([1, 2, 3, 4, 5]);
    final mapped = RxUtils.mapReactive(reactive1, (v) => v * 2);
    final mappedList = await mapped.stream.toList();
    results.add('11. mapReactive - 映射: $mappedList');

    // 示例12: Reactive操作符 - where
    final reactive2 = Reactive.fromIterable([1, 2, 3, 4, 5]);
    final whereFiltered = RxUtils.whereReactive(reactive2, (v) => v > 3);
    final whereFilteredList = await whereFiltered.stream.toList();
    results.add('12. whereReactive - 过滤: $whereFilteredList');

    // 示例13: Reactive操作符 - delay
    final reactive3 = Reactive.fromIterable([1, 2, 3]);
    final delayed = RxUtils.delayReactive(reactive3, const Duration(milliseconds: 100));
    final delayedList = await delayed.stream.toList();
    results.add('13. delayReactive - 延迟: $delayedList');

    // 示例14: Reactive操作符 - then
    final reactive4 = Reactive.fromIterable([1, 2, 3]);
    final thenResult = RxUtils.thenReactive(reactive4, (v) => Future.value(v * 2));
    final thenList = await thenResult.stream.toList();
    results.add('14. thenReactive - Future处理: $thenList');

    // 示例15: WhereEx - asList
    final stream15 = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final whereExResult = await RxUtils.whereEx<int>(stream15, [
      (v) => v % 2 == 0,
      (v) => v > 7,
    ]).asList();
    results.add('15. whereEx - asList: 满足条件=${whereExResult.matched}, 不满足=${whereExResult.unmatched}');

    // 示例16: WhereEx - asMap
    final stream16 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final whereExMap = await RxUtils.whereEx<int>(stream16, [
      (v) => v % 2 == 0,
    ]).asMap();
    results.add('16. whereEx - asMap: 满足条件=${whereExMap[true]}, 不满足=${whereExMap[false]}');

    // 示例17: 防抖工具方法
    final stream17 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final debounced = RxUtils.debounceStream(stream17, const Duration(milliseconds: 100));
    final debouncedList = await debounced.toList();
    results.add('17. debounceStream - 防抖: $debouncedList');

    // 示例18: 限流工具方法
    final stream18 = Stream.fromIterable([1, 2, 3, 4, 5]);
    final throttled = RxUtils.throttleStream(stream18, const Duration(milliseconds: 100));
    final throttledList = await throttled.toList();
    results.add('18. throttleStream - 限流: $throttledList');

    // 示例19: 去重工具方法
    final stream19 = Stream.fromIterable([1, 1, 2, 2, 3, 3, 4, 4, 5, 5]);
    final distinct = RxUtils.distinctStream(stream19);
    final distinctList = await distinct.toList();
    results.add('19. distinctStream - 去重: $distinctList');

    setState(() {
      _result = results.join('\n\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RxUtils工具类示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RxUtils工具类说明:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'RxUtils提供了Stream和Reactive的静态工具方法封装，包括：\n'
              '1. Stream操作符：filter、compactMap、flatMap、reduce、groupByKey等\n'
              '2. Reactive操作符：map、where、delay、then等\n'
              '3. WhereEx工具：多条件过滤和分组\n'
              '4. 防抖、限流、去重工具方法',
            ),
            const SizedBox(height: 16),
            const Text(
              '运行结果:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _result.isEmpty ? '加载中...' : _result,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

