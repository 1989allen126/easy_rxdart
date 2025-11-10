import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

void main() {
  group('DebounceUtils测试', () {
    test('debounce Stream防抖', () async {
      final controller = StreamController<int>();
      final debounced = DebounceUtils.debounce(
        controller.stream,
        Duration(milliseconds: 100),
      );

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

    test('debounceFunction防抖函数', () async {
      final List<int> results = [];
      final debounced = DebounceUtils.debounceFunction<int>(
        (value) {
          results.add(value);
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      debounced(1);
      debounced(2);
      debounced(3);

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只执行最后一次
      expect(results, [3]);
    });

    test('debounceVoid防抖无参数函数', () async {
      int callCount = 0;
      final debounced = DebounceUtils.debounceVoid(
        () {
          callCount++;
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      debounced();
      debounced();
      debounced();

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只执行一次
      expect(callCount, 1);
    });

    test('debounceAsync防抖异步函数', () async {
      final List<int> results = [];
      final debounced = DebounceUtils.debounceAsync<int>(
        (value) async {
          await Future.delayed(Duration(milliseconds: 10));
          results.add(value);
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      debounced(1);
      debounced(2);
      debounced(3);

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只执行最后一次
      expect(results, [3]);
    });

    test('debounceAsyncVoid防抖异步无参数函数', () async {
      int callCount = 0;
      final debounced = DebounceUtils.debounceAsyncVoid(
        () async {
          await Future.delayed(Duration(milliseconds: 10));
          callCount++;
        },
        Duration(milliseconds: 100),
      );

      // 快速连续调用
      debounced();
      debounced();
      debounced();

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只执行一次
      expect(callCount, 1);
    });

    test('DebounceController防抖控制器', () async {
      final List<int> results = [];
      final controller = DebounceUtils.createController<int>(
        Duration(milliseconds: 100),
      );

      controller.setCallback((value) {
        results.add(value);
      });

      // 快速连续触发
      controller.trigger(1);
      controller.trigger(2);
      controller.trigger(3);

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该只执行最后一次
      expect(results, [3]);

      controller.dispose();
    });

    test('DebounceController cancel取消', () async {
      final List<int> results = [];
      final controller = DebounceUtils.createController<int>(
        Duration(milliseconds: 100),
      );

      controller.setCallback((value) {
        results.add(value);
      });

      controller.trigger(1);
      controller.cancel();

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // 应该没有执行
      expect(results, isEmpty);

      controller.dispose();
    });

    test('DebounceController flush立即执行', () async {
      final List<int> results = [];
      final controller = DebounceUtils.createController<int>(
        Duration(milliseconds: 100),
      );

      controller.setCallback((value) {
        results.add(value);
      });

      controller.trigger(1);
      controller.flush();

      // 等待防抖时间
      await Future.delayed(Duration(milliseconds: 150));

      // flush会取消定时器，但不会执行回调
      expect(results, isEmpty);

      controller.dispose();
    });
  });
}
