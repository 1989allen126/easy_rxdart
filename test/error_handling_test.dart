import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

void main() {
  group('错误处理测试', () {
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

    test('onErrorReturnItem错误时返回指定值', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.onErrorReturnItem(999);

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

      expect(results, [1, 999, 2]);

      await subscription.cancel();
      await controller.close();
    });

    test('onErrorResumeNext错误时切换到另一个流', () async {
      final controller1 = StreamController<int>();
      final controller2 = StreamController<int>();
      final stream = controller1.stream.onErrorResumeNext(controller2.stream);

      final List<int> results = [];
      final subscription = stream.listen(
        (value) {
          results.add(value);
        },
        onError: (error) {
          fail('不应该收到错误');
        },
      );

      controller1.add(1);
      controller1.addError('错误');
      controller2.add(2);
      controller2.add(3);

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到1，然后切换到controller2，收到2和3
      expect(results, containsAll([1, 2, 3]));

      await subscription.cancel();
      await controller1.close();
      await controller2.close();
    });

    test('retryWithDelay重试机制', () async {
      int attemptCount = 0;
      final controller = StreamController<int>();

      final stream = controller.stream.retryWithDelay(
        count: 3,
        delay: Duration(milliseconds: 50),
      );

      final List<int> results = [];
      final subscription = stream.listen(
        (value) {
          results.add(value);
        },
        onError: (error) {
          // 重试3次后仍然失败，应该收到错误
        },
      );

      // 模拟前两次失败，第三次成功
      attemptCount++;
      if (attemptCount <= 2) {
        controller.addError('错误');
      } else {
        controller.add(42);
      }

      await Future.delayed(Duration(milliseconds: 200));

      await subscription.cancel();
      await controller.close();
    });

    test('timeoutTime超时处理', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.timeoutTime(
        Duration(milliseconds: 100),
        onTimeout: (sink) {
          sink.add(-1);
        },
      );

      final List<int> results = [];
      final subscription = stream.listen(
        (value) {
          results.add(value);
        },
        onError: (error) {
          // 超时错误
        },
      );

      // 不发送任何值，等待超时
      await Future.delayed(Duration(milliseconds: 150));

      await subscription.cancel();
      await controller.close();
    });

    test('materialize包装事件', () async {
      final controller = StreamController<int>();
      final stream = controller.stream.materialize();

      final List<StreamEvent<int>> results = [];
      final subscription = stream.listen((event) {
        results.add(event);
      });

      controller.add(1);
      controller.add(2);
      controller.addError('错误');
      await controller.close();

      await Future.delayed(Duration(milliseconds: 50));

      // 应该收到数据事件和错误事件
      expect(results.length, greaterThanOrEqualTo(2));
      expect(results[0].isData, true);
      expect(results[0].value, 1);

      await subscription.cancel();
    });

    test('dematerialize解包事件', () async {
      final controller = StreamController<int>();
      final materialized = controller.stream.materialize();
      // dematerialize需要在Stream<StreamEvent<T>>上调用
      final stream = materialized.dematerialize<int>();

      final List<int> results = [];
      final subscription = stream.listen(
        (value) {
          results.add(value);
        },
        onError: (error) {
          // 错误会被解包
        },
      );

      controller.add(1);
      controller.add(2);
      controller.addError('错误');
      await controller.close();

      await Future.delayed(Duration(milliseconds: 50));

      expect(results, [1, 2]);

      await subscription.cancel();
    });
  });
}

