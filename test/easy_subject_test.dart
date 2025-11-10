import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:test/test.dart';

void main() {
  group('EasyBehaviorSubject测试', () {
    test('创建和添加值', () {
      final subject = EasyBehaviorSubject<int>();
      expect(subject.isClosed, false);
      expect(subject.hasValue, false);
      expect(subject.valueOrNull, null);

      subject.add(1);
      expect(subject.hasValue, true);
      expect(subject.valueOrNull, 1);
      expect(subject.value, 1);
    });

    test('创建时设置初始值', () {
      final subject = EasyBehaviorSubject<int>(seedValue: 10);
      expect(subject.hasValue, true);
      expect(subject.value, 10);
    });

    test('获取默认值', () {
      final subject = EasyBehaviorSubject<int>();
      expect(subject.getValueOrDefault(100), 100);

      subject.add(50);
      expect(subject.getValueOrDefault(100), 50);
    });

    test('监听Stream', () async {
      final subject = EasyBehaviorSubject<int>();
      final values = <int>[];

      final subscription = subject.listen((value) {
        values.add(value);
      });

      subject.add(1);
      subject.add(2);
      subject.add(3);

      await Future.delayed(Duration(milliseconds: 10));
      expect(values, [1, 2, 3]);

      await subscription.cancel();
    });

    test('安全添加值', () {
      final subject = EasyBehaviorSubject<int>();
      expect(subject.safeAdd(1), true);
      expect(subject.value, 1);

      subject.close();
      expect(subject.safeAdd(2), false);
    });

    test('关闭Subject', () async {
      final subject = EasyBehaviorSubject<int>();
      subject.add(1);

      await subject.close();
      expect(subject.isClosed, true);
      expect(subject.safeAdd(2), false);
    });
  });

  group('EasyReplaySubject测试', () {
    test('创建和添加值', () {
      final subject = EasyReplaySubject<int>();
      expect(subject.isClosed, false);
      expect(subject.hasValue, false);
      expect(subject.cacheSize, 0);

      subject.add(1);
      subject.add(2);
      subject.add(3);

      expect(subject.hasValue, true);
      expect(subject.cacheSize, 3);
      expect(subject.cachedValues, [1, 2, 3]);
    });

    test('监听Stream - 重放缓存值', () async {
      final subject = EasyReplaySubject<int>();
      subject.add(1);
      subject.add(2);

      final values = <int>[];
      final subscription = subject.listen((value) {
        values.add(value);
      });

      // 新订阅者应该立即收到所有缓存的值
      await Future.delayed(Duration(milliseconds: 10));
      expect(values, [1, 2]);

      subject.add(3);
      await Future.delayed(Duration(milliseconds: 10));
      expect(values, [1, 2, 3]);

      await subscription.cancel();
    });

    test('多个订阅者', () async {
      final subject = EasyReplaySubject<int>();
      subject.add(1);
      subject.add(2);

      final values1 = <int>[];
      final values2 = <int>[];

      final sub1 = subject.listen((value) => values1.add(value));
      final sub2 = subject.listen((value) => values2.add(value));

      await Future.delayed(Duration(milliseconds: 10));
      expect(values1, [1, 2]);
      expect(values2, [1, 2]);

      subject.add(3);
      await Future.delayed(Duration(milliseconds: 10));
      expect(values1, [1, 2, 3]);
      expect(values2, [1, 2, 3]);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('安全添加值', () {
      final subject = EasyReplaySubject<int>();
      expect(subject.safeAdd(1), true);
      expect(subject.cacheSize, 1);

      subject.close();
      expect(subject.safeAdd(2), false);
      expect(subject.cacheSize, 1);
    });

    test('关闭Subject', () async {
      final subject = EasyReplaySubject<int>();
      subject.add(1);
      subject.add(2);

      await subject.close();
      expect(subject.isClosed, true);
      expect(subject.safeAdd(3), false);
      expect(subject.cacheSize, 2);
    });
  });
}

