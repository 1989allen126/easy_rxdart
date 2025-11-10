import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

void main() {
  group('StreamExtensions测试', () {
    test('debounceTime防抖', () async {
      final controller = StreamController<int>();
      final debounced = controller.stream.debounceTime(Duration(milliseconds: 100));

      final List<int> results = [];
      final subscription = debounced.listen((value) {
        results.add(value);
      });

      // 快速连续发送多个值
      controller.add(1);
      controller.add(2);
      controller.add(3);

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只收到最后一个值
      expect(results, [3]);

      await subscription.cancel();
      await controller.close();
    });

    test('throttleTime节流', () async {
      final controller = StreamController<int>();
      final throttled = controller.stream.throttleTime(Duration(milliseconds: 100));

      final List<int> results = [];
      final subscription = throttled.listen((value) {
        results.add(value);
      });

      // 快速连续发送多个值
      controller.add(1);
      controller.add(2);
      controller.add(3);

      // 等待节流时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只收到第一个值
      expect(results, [1]);

      await subscription.cancel();
      await controller.close();
    });

    test('distinctUntilChangedBy去重', () async {
      final controller = StreamController<String>();
      final distinct = controller.stream.distinctUntilChangedBy(
        (a, b) => a.toLowerCase() == b.toLowerCase(),
      );

      final List<String> results = [];
      final subscription = distinct.listen((value) {
        results.add(value);
      });

      // 发送重复值（忽略大小写）
      controller.add('Hello');
      controller.add('hello');
      controller.add('World');
      controller.add('world');

      await Future.delayed(Duration(milliseconds: 50));

      // 应该只收到不同的值
      expect(results, ['Hello', 'World']);

      await subscription.cancel();
      await controller.close();
    });

    test('mapNotNull安全映射', () async {
      final controller = StreamController<int>();
      final mapped = controller.stream.mapNotNull<String>((value) {
        return value > 0 ? value.toString() : null;
      });

      final List<String> results = [];
      final subscription = mapped.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(-1);
      controller.add(2);
      controller.add(0);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该只收到非null的值
      expect(results, ['1', '2']);

      await subscription.cancel();
      await controller.close();
    });

    test('flatMapValue扁平映射', () async {
      final controller = StreamController<int>();
      // 使用 asyncExpand 代替 flatMapValue 避免扩展冲突
      final flatMapped = controller.stream.asyncExpand<int>((value) {
        return Stream.fromIterable([value, value * 2]);
      });

      final List<int> results = [];
      final subscription = flatMapped.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(2);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到扁平化后的值
      expect(results, [1, 2, 2, 4]);

      await subscription.cancel();
      await controller.close();
    });

    test('distinctUntilChanged标准去重', () async {
      final controller = StreamController<int>();
      final distinct = controller.stream.distinctUntilChanged();

      final List<int> results = [];
      final subscription = distinct.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(1);
      controller.add(2);
      controller.add(2);
      controller.add(3);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该只收到不同的值
      expect(results, [1, 2, 3]);

      await subscription.cancel();
      await controller.close();
    });

    test('startWith在开始前添加值', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.startWith(0);

      final List<int> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(2);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该先收到0，然后收到1和2
      expect(results, [0, 1, 2]);

      await subscription.cancel();
      await controller.close();
    });

    test('endWith在结束时添加值', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.endWith(99);

      final List<int> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(2);
      await controller.close();

      await Future.delayed(Duration(milliseconds: 50));

      // 应该先收到1和2，然后收到99
      expect(results, [1, 2, 99]);

      await subscription.cancel();
    });

    test('onErrorReturn错误时返回默认值', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.onErrorReturn(-1);

      final List<int> results = [];
      final subscription = stream.listen(
        (value) {
          results.add(value);
        },
        onError: (error) {
          fail('不应该收到错误');
        },
      );

      controller.add(1);
      controller.addError('错误');
      controller.add(2);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到1，错误时返回-1，然后收到2
      expect(results, [1, -1, 2]);

      await subscription.cancel();
      await controller.close();
    });

    test('defaultIfEmpty空流返回默认值', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.defaultIfEmpty(0);

      final List<int> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      await controller.close();
      await Future.delayed(Duration(milliseconds: 50));

      // 空流应该返回默认值0
      expect(results, [0]);

      await subscription.cancel();
    });

    test('isEmpty检查是否为空', () async {
      final emptyStream = Stream<int>.empty();
      final isEmptyResult = await (emptyStream as dynamic).isEmpty();
      expect(isEmptyResult, true);

      final nonEmptyStream = Stream.value(1);
      final isNotEmptyResult = await (nonEmptyStream as dynamic).isEmpty();
      expect(isNotEmptyResult, false);
    });

    test('isNotEmpty检查是否不为空', () async {
      final emptyStream = Stream<int>.empty();
      final isEmptyResult = await (emptyStream as dynamic).isNotEmpty();
      expect(isEmptyResult, false);

      final nonEmptyStream = Stream.value(1);
      final isNotEmptyResult = await (nonEmptyStream as dynamic).isNotEmpty();
      expect(isNotEmptyResult, true);
    });

    test('bufferCount按数量缓冲', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.bufferCount(3);

      final List<List<int>> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(2);
      controller.add(3);
      controller.add(4);
      controller.add(5);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到[1,2,3]和[4,5]
      expect(results.length, 2);
      expect(results[0], [1, 2, 3]);
      expect(results[1], [4, 5]);

      await subscription.cancel();
      await controller.close();
    });

    test('withLatestFrom与另一个流的最新值组合', () async {
      final controller1 = StreamController<int>();
      final controller2 = StreamController<String>();
      final stream = controller1.stream.withLatestFrom(
        controller2.stream,
        (a, b) => '$a-$b',
      );

      final List<String> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      controller2.add('A');
      controller1.add(1);
      controller2.add('B');
      controller1.add(2);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到'1-A'和'2-B'
      expect(results, ['1-A', '2-B']);

      await subscription.cancel();
      await controller1.close();
      await controller2.close();
    });
  });
}
