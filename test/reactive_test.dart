import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

void main() {
  group('Reactive类测试', () {
    test('从值创建Reactive', () async {
      final reactive = Reactive.fromValue(42);
      final result = await reactive.toFuture();
      expect(result, 42);
    });

    test('从Future创建Reactive', () async {
      final future = Future.value('test');
      final reactive = Reactive.fromFuture(future);
      final result = await reactive.toFuture();
      expect(result, 'test');
    });

    test('从Iterable创建Reactive', () async {
      final reactive = Reactive.fromIterable([1, 2, 3]);
      final results = <int>[];
      await reactive.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [1, 2, 3]);
    });

    test('创建空Reactive', () async {
      final reactive = Reactive.empty<int>();
      final results = <int>[];
      await reactive.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, isEmpty);
    });

    test('创建错误Reactive', () async {
      final reactive = Reactive.error<int>('测试错误');
      expect(
        () => reactive.toFuture(),
        throwsA('测试错误'),
      );
    });

    test('map转换', () async {
      final reactive = Reactive.fromIterable([1, 2, 3]);
      final mapped = reactive.map((x) => x * 2);
      final results = <int>[];
      await mapped.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [2, 4, 6]);
    });

    test('where过滤', () async {
      final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
      final filtered = reactive.where((x) => x > 3);
      final results = <int>[];
      await filtered.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [4, 5]);
    });

    test('flatMap扁平化', () async {
      final reactive = Reactive.fromIterable([1, 2]);
      final flatMapped = reactive.flatMap((x) => Stream.value(x * 2));
      final results = <int>[];
      await flatMapped.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [2, 4]);
    });

    test('merge合并多个流', () async {
      final reactive1 = Reactive.fromIterable([1, 2]);
      final reactive2 = Reactive.fromIterable([3, 4]);
      final merged = Reactive.merge([reactive1, reactive2]);
      final results = <int>[];
      await merged.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, containsAll([1, 2, 3, 4]));
    });

    test('combineLatest2组合两个流', () async {
      final reactive1 = Reactive.fromValue(1);
      final reactive2 = Reactive.fromValue(2);
      final combined = Reactive.combineLatest2(
        reactive1,
        reactive2,
        (a, b) => a + b,
      );
      final result = await combined.toFuture();
      expect(result, 3);
    });

    test('zip2压缩两个流', () async {
      final reactive1 = Reactive.fromIterable([1, 2]);
      final reactive2 = Reactive.fromIterable([3, 4]);
      final zipped = Reactive.zip2(
        reactive1,
        reactive2,
        (a, b) => a + b,
      );
      final results = <int>[];
      await zipped.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [4, 6]);
    });

    test('concat连接多个流', () async {
      final reactive1 = Reactive.fromIterable([1, 2]);
      final reactive2 = Reactive.fromIterable([3, 4]);
      final concatenated = Reactive.concat([reactive1, reactive2]);
      final results = <int>[];
      await concatenated.listen((value) {
        results.add(value);
      }).asFuture();
      expect(results, [1, 2, 3, 4]);
    });

    test('delay延迟', () async {
      final reactive = Reactive.fromValue(42);
      final delayed = reactive.delay(Duration(milliseconds: 100));
      final startTime = DateTime.now();
      await delayed.toFuture();
      final endTime = DateTime.now();
      expect(endTime.difference(startTime).inMilliseconds, greaterThanOrEqualTo(90));
    });

    test('then执行Future', () async {
      final reactive = Reactive.fromValue(2);
      final then = reactive.then((x) => Future.value(x * 3));
      final result = await then.toFuture();
      expect(result, 6);
    });
  });
}

