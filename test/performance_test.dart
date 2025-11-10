import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';
import 'test_utils.dart';

void main() {
  group('性能测试', () {
    test('Stream操作符性能测试', () async {
      final result = await TestUtils.measurePerformance(() async {
        final controller = StreamController<int>();
        final stream = controller.stream
            .debounceTime(Duration(milliseconds: 10))
            .throttleTime(Duration(milliseconds: 10))
            .distinctUntilChanged();

        final subscription = stream.listen((_) {});

        for (int i = 0; i < 1000; i++) {
          controller.add(i);
        }

        await Future.delayed(Duration(milliseconds: 100));
        await subscription.cancel();
        await controller.close();
      }, iterations: 10);

      print('Stream操作符性能: $result');
      expect(result.averageDuration.inMilliseconds, lessThan(1000));
    });

    test('Reactive类性能测试', () async {
      final result = await TestUtils.measurePerformance(() async {
        final reactive1 = Reactive.fromIterable(List.generate(100, (i) => i));
        final reactive2 = Reactive.fromIterable(List.generate(100, (i) => i));
        final combined = Reactive.combineLatest2(
          reactive1,
          reactive2,
          (a, b) => a + b,
        );

        await combined.listen((_) {}).asFuture();
      }, iterations: 10);

      print('Reactive类性能: $result');
      expect(result.averageDuration.inMilliseconds, lessThan(1000));
    });

    test('EasyModel性能测试', () async {
      final result = await TestUtils.measurePerformance(() async {
        final model = TestCounterModel();
        int callCount = 0;

        model.addListener(() {
          callCount++;
        });

        for (int i = 0; i < 100; i++) {
          model.increment();
        }

        await TestUtils.waitForAsyncOperations();
        model.dispose();
      }, iterations: 10);

      print('EasyModel性能: $result');
      expect(result.averageDuration.inMilliseconds, lessThan(500));
    });
  });

  group('内存泄漏检测', () {
    test('Stream订阅内存泄漏检测', () async {
      final result = await TestUtils.detectMemoryLeak<StreamSubscription>(
        setup: () => Future.value(),
        createObject: () {
          final controller = StreamController<int>();
          return controller.stream.listen((_) {});
        },
        dispose: (subscription) async {
          await subscription.cancel();
        },
        test: () async {
          await Future.delayed(Duration(milliseconds: 10));
        },
        iterations: 10,
      );

      print('Stream订阅内存泄漏检测: $result');
      // 注意：这是一个简化的检测，实际需要更复杂的实现
    });

    test('StreamController内存泄漏检测', () async {
      final result = await TestUtils.detectMemoryLeak<StreamController<int>>(
        setup: () => Future.value(),
        createObject: () => StreamController<int>(),
        dispose: (controller) async {
          await controller.close();
        },
        test: () async {
          await Future.delayed(Duration(milliseconds: 10));
        },
        iterations: 10,
      );

      print('StreamController内存泄漏检测: $result');
    });

    test('EasyModel内存泄漏检测', () async {
      final result = await TestUtils.detectMemoryLeak<TestCounterModel>(
        setup: () => Future.value(),
        createObject: () {
          final model = TestCounterModel();
          model.addListener(() {});
          return model;
        },
        dispose: (model) async {
          model.dispose();
          await TestUtils.waitForAsyncOperations();
        },
        test: () async {
          await Future.delayed(Duration(milliseconds: 10));
        },
        iterations: 10,
      );

      print('EasyModel内存泄漏检测: $result');
    });
  });

  group('资源清理验证', () {
    test('验证Stream订阅被正确取消', () async {
      final controller = StreamController<int>();
      final subscription = controller.stream.listen((_) {});

      final isCancelled = await TestUtils.verifySubscriptionCancelled(
        subscription,
      );
      expect(isCancelled, true);

      await controller.close();
    });

    test('验证StreamController被正确关闭', () {
      final controller = StreamController<int>();
      controller.close();

      final isClosed = TestUtils.verifyControllerClosed(controller);
      expect(isClosed, true);
    });

    test('验证EasyModel被正确dispose', () {
      final model = TestCounterModel();
      model.dispose();

      expect(model.isDisposed, true);
      expect(model.listenerCount, 0);
    });
  });
}

/// 测试用的计数器Model
class TestCounterModel extends Model {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

