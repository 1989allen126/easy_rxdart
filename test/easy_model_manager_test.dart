import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

void main() {
  group('EasyModelManager', () {
    setUp(() {
      // 每个测试前重置
      EasyModelManager.reset();
    });

    tearDown(() {
      // 每个测试后清理
      EasyModelManager.reset();
    });

    test('lazyPut应该注册懒加载创建器', () {
      EasyModelManager.lazyPut<TestModel>(() => TestModel());
      expect(EasyModelManager.isRegistered<TestModel>(), true);
    });

    test('get应该返回已存在的实例', () {
      final model1 = TestModel();
      EasyModelManager.put<TestModel>(model1);
      final model2 = EasyModelManager.get<TestModel>();
      expect(model2, same(model1));
    });

    test('get应该使用懒加载创建器创建实例', () {
      var created = false;
      EasyModelManager.lazyPut<TestModel>(() {
        created = true;
        return TestModel();
      });
      expect(created, false);
      final model = EasyModelManager.get<TestModel>();
      expect(created, true);
      expect(model, isA<TestModel>());
    });

    test('get应该使用提供的创建器创建实例', () {
      var created = false;
      final model = EasyModelManager.get<TestModel>(() {
        created = true;
        return TestModel();
      });
      expect(created, true);
      expect(model, isA<TestModel>());
    });

    test('get应该在没有注册时抛出异常', () {
      expect(
        () => EasyModelManager.get<TestModel>(),
        throwsA(isA<Exception>()),
      );
    });

    test('put应该设置模型实例', () {
      final model = TestModel();
      EasyModelManager.put<TestModel>(model);
      final retrieved = EasyModelManager.get<TestModel>();
      expect(retrieved, same(model));
    });

    test('put应该替换已存在的实例', () {
      final model1 = TestModel();
      final model2 = TestModel();
      EasyModelManager.put<TestModel>(model1);
      EasyModelManager.put<TestModel>(model2);
      final retrieved = EasyModelManager.get<TestModel>();
      expect(retrieved, same(model2));
      expect(retrieved, isNot(same(model1)));
    });

    test('put应该移除懒加载创建器', () {
      EasyModelManager.lazyPut<TestModel>(() => TestModel());
      final model = TestModel();
      EasyModelManager.put<TestModel>(model);
      final retrieved = EasyModelManager.get<TestModel>();
      expect(retrieved, same(model));
    });

    test('delete应该删除模型实例', () {
      final model = TestModel();
      EasyModelManager.put<TestModel>(model);
      EasyModelManager.delete<TestModel>();
      expect(EasyModelManager.isRegistered<TestModel>(), false);
    });

    test('delete应该移除懒加载创建器', () {
      EasyModelManager.lazyPut<TestModel>(() => TestModel());
      EasyModelManager.delete<TestModel>();
      expect(EasyModelManager.isRegistered<TestModel>(), false);
    });

    test('isRegistered应该返回true如果实例存在', () {
      EasyModelManager.put<TestModel>(TestModel());
      expect(EasyModelManager.isRegistered<TestModel>(), true);
    });

    test('isRegistered应该返回true如果懒加载创建器存在', () {
      EasyModelManager.lazyPut<TestModel>(() => TestModel());
      expect(EasyModelManager.isRegistered<TestModel>(), true);
    });

    test('isRegistered应该返回false如果未注册', () {
      expect(EasyModelManager.isRegistered<TestModel>(), false);
    });

    test('reset应该清除所有实例和懒加载创建器', () {
      EasyModelManager.put<TestModel>(TestModel());
      EasyModelManager.lazyPut<AnotherTestModel>(() => AnotherTestModel());
      EasyModelManager.reset();
      expect(EasyModelManager.isRegistered<TestModel>(), false);
      expect(EasyModelManager.isRegistered<AnotherTestModel>(), false);
    });

    test('registeredTypes应该返回所有已注册的类型', () {
      EasyModelManager.put<TestModel>(TestModel());
      EasyModelManager.lazyPut<AnotherTestModel>(() => AnotherTestModel());
      final types = EasyModelManager.registeredTypes();
      expect(types.length, 2);
      expect(types, contains(TestModel));
      expect(types, contains(AnotherTestModel));
    });

    test('get应该返回同一个实例（单例）', () {
      EasyModelManager.lazyPut<TestModel>(() => TestModel());
      final model1 = EasyModelManager.get<TestModel>();
      final model2 = EasyModelManager.get<TestModel>();
      expect(model1, same(model2));
    });

    test('put应该销毁已存在的实例', () {
      final model1 = TestModel();
      EasyModelManager.put<TestModel>(model1);
      final model2 = TestModel();
      EasyModelManager.put<TestModel>(model2);
      expect(model1.isDisposed, true);
    });

    test('delete应该销毁实例', () {
      final model = TestModel();
      EasyModelManager.put<TestModel>(model);
      EasyModelManager.delete<TestModel>();
      expect(model.isDisposed, true);
    });

    test('reset应该销毁所有实例', () {
      final model1 = TestModel();
      final model2 = AnotherTestModel();
      EasyModelManager.put<TestModel>(model1);
      EasyModelManager.put<AnotherTestModel>(model2);
      EasyModelManager.reset();
      expect(model1.isDisposed, true);
      expect(model2.isDisposed, true);
    });
  });
}

/// 测试模型
class TestModel extends Model {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }
}

/// 另一个测试模型
class AnotherTestModel extends Model {
  String _name = '';

  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}

