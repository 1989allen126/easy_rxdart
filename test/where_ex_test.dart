import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:test/test.dart';

void main() {
  group('WhereEx测试', () {
    test('Stream whereEx - asList', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      final result = await stream.whereEx([
        (value) => value % 2 == 0, // 偶数
        (value) => value > 7, // 大于7
      ]).asList();

      expect(result.matched, containsAll([2, 4, 6, 8, 9, 10]));
      expect(result.unmatched, containsAll([1, 3, 5, 7]));
      expect(result.total, equals(10));
    });

    test('Stream whereEx - asMap', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
      final result = await stream.whereEx([
        (value) => value % 2 == 0, // 偶数
      ]).asMap();

      expect(result[true], containsAll([2, 4]));
      expect(result[false], containsAll([1, 3, 5]));
    });

    test('Reactive whereEx - asList', () async {
      final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
      final result = await reactive.whereEx([
        (value) => value > 3,
      ]).asList();

      expect(result.matched, containsAll([4, 5]));
      expect(result.unmatched, containsAll([1, 2, 3]));
    });

    test('Reactive whereEx - asMap', () async {
      final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
      final result = await reactive.whereEx([
        (value) => value > 3,
      ]).asMap();

      expect(result[true], containsAll([4, 5]));
      expect(result[false], containsAll([1, 2, 3]));
    });

    test('RxUtils whereEx - Stream', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
      final result = await RxUtils.whereExStream<int>(stream, [
        (value) => value % 2 == 0,
      ]).asList();

      expect(result.matched, containsAll([2, 4]));
      expect(result.unmatched, containsAll([1, 3, 5]));
    });

    test('RxUtils whereEx - Reactive', () async {
      final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
      final result = await RxUtils.whereExReactive<int>(reactive, [
        (value) => value % 2 == 0,
      ]).asList();

      expect(result.matched, containsAll([2, 4]));
      expect(result.unmatched, containsAll([1, 3, 5]));
    });

    test('RxUtils whereEx - 自动识别类型', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
      final result = await RxUtils.whereEx<int>(stream, [
        (value) => value % 2 == 0,
      ]).asList();

      expect(result.matched, containsAll([2, 4]));
      expect(result.unmatched, containsAll([1, 3, 5]));
    });

    test('多个条件 - OR逻辑', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      final result = await stream.whereEx([
        (value) => value < 3, // 小于3
        (value) => value > 8, // 大于8
      ]).asList();

      // 满足任一条件：1, 2, 9, 10
      expect(result.matched, containsAll([1, 2, 9, 10]));
      expect(result.unmatched, containsAll([3, 4, 5, 6, 7, 8]));
    });

    test('空条件列表', () async {
      final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
      final result = await stream.whereEx([]).asList();

      // 没有条件，所有元素都不匹配
      expect(result.matched, isEmpty);
      expect(result.unmatched, containsAll([1, 2, 3, 4, 5]));
    });

    test('空Stream', () async {
      final stream = Stream<int>.empty();
      final result = await stream.whereEx([
        (value) => value > 0,
      ]).asList();

      expect(result.matched, isEmpty);
      expect(result.unmatched, isEmpty);
      expect(result.total, equals(0));
    });
  });
}
