import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

void main() {
  group('IterableExtensions测试', () {
    test('toStream转换为Stream', () async {
      final list = [1, 2, 3];
      final stream = list.toStream();

      final List<int> results = [];
      await for (final value in stream) {
        results.add(value);
      }

      expect(results, [1, 2, 3]);
    });

    test('skipFirstN跳过前N个元素', () {
      final list = [1, 2, 3, 4, 5];
      final skipped = list.skipFirstN(2);

      expect(skipped.toList(), [3, 4, 5]);
    });

    test('skipFirstN带条件跳过', () {
      final list = [1, 2, 3, 4, 5];
      final skipped = list.skipFirstN(2, (value) => value % 2 == 0);

      // 跳过前2个偶数（2和4），所以结果是[1, 3, 5]
      expect(skipped.toList(), [1, 3, 5]);
    });

    test('skipLastN跳过后N个元素', () {
      final list = [1, 2, 3, 4, 5];
      final skipped = list.skipLastN(2);

      expect(skipped.toList(), [1, 2, 3]);
    });

    test('skipFirst跳过第一个元素', () {
      final list = [1, 2, 3, 4, 5];
      final skipped = list.skipFirst();

      expect(skipped.toList(), [2, 3, 4, 5]);
    });

    test('skipLast跳过最后一个元素', () {
      final list = [1, 2, 3, 4, 5];
      final skipped = list.skipLast();

      expect(skipped.toList(), [1, 2, 3, 4]);
    });

    test('compactMap紧凑映射', () {
      final list = [1, 2, 3, 4, 5];
      final mapped = list.compactMap<int>((value) {
        return value % 2 == 0 ? value * 2 : null;
      });

      expect(mapped.toList(), [4, 8]);
    });

    test('flatMap扁平映射', () {
      final list = [1, 2, 3];
      final flatMapped = list.flatMap<int>((value) {
        return [value, value * 2];
      });

      expect(flatMapped.toList(), [1, 2, 2, 4, 3, 6]);
    });

    test('forEachIndexed遍历带索引', () {
      final list = ['a', 'b', 'c'];
      final results = <int, String>{};

      list.forEachIndexed((index, value) {
        results[index] = value;
      });

      expect(results, {0: 'a', 1: 'b', 2: 'c'});
    });

    test('everyValue检查所有元素', () {
      final list = [2, 4, 6, 8];
      final allEven = list.everyValue((value) => value % 2 == 0);

      expect(allEven, true);
    });

    test('anyValue检查是否有元素', () {
      final list = [1, 2, 3, 4];
      final hasEven = list.anyValue((value) => value % 2 == 0);

      expect(hasEven, true);
    });

    test('distinct去重', () {
      final list = [1, 2, 2, 3, 3, 3, 4];
      final distinct = list.distinct();

      expect(distinct.toList(), [1, 2, 3, 4]);
    });

    test('subscribe订阅', () async {
      final list = [1, 2, 3];
      final results = <int>[];

      final subscription = list.subscribe(onData: (value) {
        results.add(value);
      });

      // 等待Stream完成
      await subscription.asFuture();

      expect(results, [1, 2, 3]);
    });
  });
}
