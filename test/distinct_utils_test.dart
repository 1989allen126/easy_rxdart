import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

void main() {
  group('DistinctUtils测试', () {
    test('distinctFunction去重函数', () {
      final List<int> results = [];
      final distinct = DistinctUtils.distinctFunction<int>(
        (value) {
          results.add(value);
        },
      );

      // 连续调用相同值
      distinct(1);
      distinct(1);
      distinct(2);
      distinct(2);
      distinct(3);

      // 应该只执行不同的值
      expect(results, [1, 2, 3]);
    });

    test('distinctFunction自定义比较函数', () {
      final List<String> results = [];
      final distinct = DistinctUtils.distinctFunction<String>(
        (value) {
          results.add(value);
        },
        equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      );

      // 连续调用相同值（忽略大小写）
      distinct('Hello');
      distinct('hello');
      distinct('World');
      distinct('world');

      // 应该只执行不同的值（忽略大小写）
      expect(results, ['Hello', 'World']);
    });

    test('distinctVoid去重无参数函数', () {
      int callCount = 0;
      final distinct = DistinctUtils.distinctVoid(
        () {
          callCount++;
        },
      );

      // 连续调用
      distinct();
      distinct();
      distinct();

      // 应该只执行一次
      expect(callCount, 1);
    });

    test('distinctAsync去重异步函数', () async {
      final List<int> results = [];
      final distinct = DistinctUtils.distinctAsync<int>(
        (value) async {
          await Future.delayed(Duration(milliseconds: 10));
          results.add(value);
        },
      );

      // 连续调用相同值
      await distinct(1);
      await distinct(1);
      await distinct(2);
      await distinct(2);

      // 应该只执行不同的值
      expect(results, [1, 2]);
    });

    test('DistinctController去重控制器', () {
      final List<int> results = [];
      final controller = DistinctUtils.createController<int>();

      controller.setCallback((value) {
        results.add(value);
      });

      // 连续触发相同值
      controller.trigger(1);
      controller.trigger(1);
      controller.trigger(2);
      controller.trigger(2);
      controller.trigger(3);

      // 应该只执行不同的值
      expect(results, [1, 2, 3]);

      controller.dispose();
    });

    test('DistinctController自定义比较函数', () {
      final List<String> results = [];
      final controller = DistinctUtils.createController<String>(
        equals: (a, b) => a.length == b.length,
      );

      controller.setCallback((value) {
        results.add(value);
      });

      // 连续触发相同长度的值
      controller.trigger('hi');
      controller.trigger('ok');
      controller.trigger('hello');
      controller.trigger('world');

      // 应该只执行不同长度的值
      expect(results, ['hi', 'hello']);

      controller.dispose();
    });

    test('DistinctController reset重置', () {
      final List<int> results = [];
      final controller = DistinctUtils.createController<int>();

      controller.setCallback((value) {
        results.add(value);
      });

      // 第一次触发
      controller.trigger(1);
      expect(results, [1]);

      // 再次触发相同值，应该被过滤
      controller.trigger(1);
      expect(results, [1]);

      // 重置后可以再次触发相同值
      controller.reset();
      controller.trigger(1);
      expect(results, [1, 1]);

      controller.dispose();
    });
  });
}
