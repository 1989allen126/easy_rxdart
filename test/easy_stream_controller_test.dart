import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyStreamController基础功能测试', () {
    test('链式调用onData、onError、onComplete', () async {
      final controller = EasyStreamController<String>();
      final List<String> dataList = [];
      final List<String> errorList = [];
      bool isDone = false;

      controller.onData((data) {
        dataList.add(data);
      }).onError((error, stackTrace) {
        errorList.add(error.toString());
      }).onComplete(() {
        isDone = true;
      });

      // 等待订阅建立
      await Future.delayed(Duration(milliseconds: 10));

      controller.add('test1');
      controller.add('test2');
      controller.addError('error1');
      await controller.close();

      await Future.delayed(Duration(milliseconds: 50));

      expect(dataList, ['test1', 'test2']);
      expect(errorList, ['error1']);
      expect(isDone, true);
    });

    test('支持broadcast广播模式', () async {
      final controller = EasyStreamController<String>.broadcast();
      final List<String> dataList1 = [];
      final List<String> dataList2 = [];

      controller.onData((data) {
        dataList1.add(data);
      });

      // 第二个监听者
      controller.stream.listen((data) {
        dataList2.add(data);
      });

      controller.add('test1');
      controller.add('test2');

      await Future.delayed(Duration(milliseconds: 50));

      expect(dataList1, ['test1', 'test2']);
      expect(dataList2, ['test1', 'test2']);

      await controller.dispose();
    });

    test('安全的dispose不会抛异常', () async {
      final controller = EasyStreamController<int>();

      controller
          .onData((data) {})
          .onError((error, stackTrace) {})
          .onComplete(() {});

      controller.add(1);
      controller.add(2);

      // 多次调用dispose应该不会抛异常
      final result1 = await controller.dispose();
      final result2 = await controller.dispose();
      final result3 = await controller.dispose();

      expect(result1, true);
      expect(result2, true);
      expect(result3, true);
      expect(controller.isDisposed, true);
      expect(controller.isClosed, true);
    });

    test('dispose后调用add不会抛异常', () async {
      final controller = EasyStreamController<String>();

      controller.onData((data) {});

      await controller.dispose();

      // dispose后调用add应该返回false，不会抛异常
      final result = controller.add('test');
      expect(result, false);
    });

    test('dispose后调用addError不会抛异常', () async {
      final controller = EasyStreamController<String>();

      controller.onError((error, stackTrace) {});

      await controller.dispose();

      // dispose后调用addError应该返回false，不会抛异常
      final result = controller.addError('error');
      expect(result, false);
    });

    test('dispose后调用close不会抛异常', () async {
      final controller = EasyStreamController<String>();

      await controller.dispose();

      // dispose后调用close应该不会抛异常
      await controller.close();
    });

    test('转换为Reactive（RxDart风格）', () async {
      final controller = EasyStreamController<int>();
      final reactive = controller.asReactive();

      final List<int> results = [];
      final subscription = reactive.listen((value) {
        results.add(value);
      });

      controller.add(1);
      controller.add(2);
      controller.add(3);

      await Future.delayed(Duration(milliseconds: 50));

      expect(results, [1, 2, 3]);

      await subscription.cancel();
      await controller.dispose();
    });

    test('转换为Stream（RxDart风格）', () async {
      final controller = EasyStreamController<String>();
      final stream = controller.asStream();

      final List<String> results = [];
      final subscription = stream.listen((value) {
        results.add(value);
      });

      controller.add('a');
      controller.add('b');
      controller.add('c');

      await Future.delayed(Duration(milliseconds: 50));

      expect(results, ['a', 'b', 'c']);

      await subscription.cancel();
      await controller.dispose();
    });

    test('转换为BehaviorSubject（RxDart风格）', () async {
      final controller = EasyStreamController<int>();
      final subject = controller.asBehaviorSubject();

      final List<int> results = [];
      final subscription = subject.stream.listen((value) {
        results.add(value);
      });

      // 等待订阅建立
      await Future.delayed(Duration(milliseconds: 10));

      controller.add(1);
      controller.add(2);

      await Future.delayed(Duration(milliseconds: 50));

      expect(results, [1, 2]);

      await subscription.cancel();
      await controller.dispose();
    });

    test('转换为PublishSubject（RxDart风格）', () async {
      final controller = EasyStreamController<String>();
      final subject = controller.asPublishSubject();

      final List<String> results = [];
      final subscription = subject.stream.listen((value) {
        results.add(value);
      });

      // 等待订阅建立
      await Future.delayed(Duration(milliseconds: 10));

      controller.add('x');
      controller.add('y');

      await Future.delayed(Duration(milliseconds: 50));

      expect(results, ['x', 'y']);

      await subscription.cancel();
      await controller.dispose();
    });

    test('多次快速调用dispose', () async {
      final controller = EasyStreamController<int>();

      // 并发调用dispose应该不会抛异常
      final futures = List.generate(10, (_) => controller.dispose());
      final results = await Future.wait(futures);

      expect(results.every((r) => r == true), true);
      expect(controller.isDisposed, true);

      // 确保所有资源都已清理
      await Future.delayed(Duration(milliseconds: 10));
    });

    test('dispose后设置回调不会生效', () async {
      final controller = EasyStreamController<String>();
      await controller.dispose();

      final List<String> dataList = [];

      // dispose后设置回调应该不会生效
      controller.onData((data) {
        dataList.add(data);
      });

      controller.add('test');

      // 不需要等待，因为 dispose 后不会触发回调
      expect(dataList, isEmpty);
    });

    test('链式调用顺序', () async {
      final controller =
          EasyStreamController<int>.broadcast(); // 使用广播模式避免多次监听问题
      int dataCount = 0;
      int errorCount = 0;
      int doneCount = 0;

      // 链式调用顺序应该不影响功能
      controller.onComplete(() {
        doneCount++;
      }).onError((error, stackTrace) {
        errorCount++;
      }).onData((data) {
        dataCount++;
      });

      controller.add(1);
      controller.add(2);
      controller.addError('error');
      await controller.close();

      await Future.delayed(Duration(milliseconds: 50));

      expect(dataCount, 2); // 两个add调用
      expect(errorCount, 1);
      expect(doneCount, 1);

      await controller.dispose();
    });

    test('broadcast模式下多个监听者', () async {
      final controller = EasyStreamController<String>.broadcast();
      final List<String> results1 = [];
      final List<String> results2 = [];
      final List<String> results3 = [];

      // 第一个监听者通过onData
      controller.onData((data) {
        results1.add(data);
      });

      // 第二个监听者直接监听stream
      controller.stream.listen((data) {
        results2.add(data);
      });

      // 第三个监听者通过asStream
      controller.asStream().listen((data) {
        results3.add(data);
      });

      controller.add('test1');
      controller.add('test2');

      await Future.delayed(Duration(milliseconds: 50));

      expect(results1, ['test1', 'test2']);
      expect(results2, ['test1', 'test2']);
      expect(results3, ['test1', 'test2']);

      await controller.dispose();
    });
  });
}
