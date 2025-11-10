import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

void main() {
  group('ThrottleUtils测试', () {
    test('throttleFunction限流函数', () {
      final List<int> results = [];
      final throttled = ThrottleUtils.throttleFunction<int>(
        (value) {
          results.add(value);
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      throttled(1);
      throttled(2);
      throttled(3);

      // 应该只执行第一次
      expect(results, [1]);
    });

    test('throttleFunction间隔调用', () async {
      final List<int> results = [];
      final throttled = ThrottleUtils.throttleFunction<int>(
        (value) {
          results.add(value);
        },
        Duration(milliseconds: 100),
      );

      // 第一次调用
      throttled(1);
      expect(results, [1]);

      // 立即再次调用，应该被限流
      throttled(2);
      expect(results, [1]);

      // 等待限流时间后调用
      await Future.delayed(Duration(milliseconds: 150));
      throttled(3);
      expect(results, [1, 3]);
    });

    test('throttleVoid限流无参数函数', () {
      int callCount = 0;
      final throttled = ThrottleUtils.throttleVoid(
        () {
          callCount++;
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      throttled();
      throttled();
      throttled();

      // 应该只执行一次
      expect(callCount, 1);
    });

    test('throttleAsync限流异步函数', () async {
      final List<int> results = [];
      final throttled = ThrottleUtils.throttleAsync<int>(
        (value) async {
          await Future.delayed(Duration(milliseconds: 10));
          results.add(value);
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      await throttled(1);
      await throttled(2);
      await throttled(3);

      // 应该只执行第一次
      expect(results, [1]);
    });

    test('throttleAsyncVoid限流异步无参数函数', () async {
      int callCount = 0;
      final throttled = ThrottleUtils.throttleAsyncVoid(
        () async {
          await Future.delayed(Duration(milliseconds: 10));
          callCount++;
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      await throttled();
      await throttled();
      await throttled();

      // 应该只执行一次
      expect(callCount, 1);
    });

    test('ThrottleController限流控制器', () {
      final List<int> results = [];
      final controller = ThrottleUtils.createController<int>(
        Duration(milliseconds: 100),
      );

      controller.setCallback((value) {
        results.add(value);
      });

      // 快速连续触发
      controller.trigger(1);
      controller.trigger(2);
      controller.trigger(3);

      // 应该只执行第一次
      expect(results, [1]);

      controller.dispose();
    });

    test('ThrottleController reset重置', () async {
      final List<int> results = [];
      final controller = ThrottleUtils.createController<int>(
        Duration(milliseconds: 100),
      );

      controller.setCallback((value) {
        results.add(value);
      });

      // 第一次触发
      controller.trigger(1);
      expect(results, [1]);

      // 立即再次触发，应该被限流
      controller.trigger(2);
      expect(results, [1]);

      // 重置后可以立即触发
      controller.reset();
      controller.trigger(3);
      expect(results, [1, 3]);

      controller.dispose();
    });
  });
}
