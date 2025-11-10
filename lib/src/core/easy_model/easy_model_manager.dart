import 'model.dart';

/// EasyModel全局模型管理器
///
/// 提供全局单例模型管理功能，类似于GetX的依赖注入机制
///
/// ### 示例
///
/// ```dart
/// // 懒加载注册
/// EasyModelManager.lazyPut<CounterModel>(() => CounterModel());
///
/// // 获取模型
/// final counter = EasyModelManager.get<CounterModel>();
///
/// // 直接设置模型
/// EasyModelManager.put<CounterModel>(CounterModel());
///
/// // 删除模型
/// EasyModelManager.delete<CounterModel>();
///
/// // 重置所有模型
/// EasyModelManager.reset();
/// ```
class EasyModelManager {
  EasyModelManager._();

  /// 存储模型实例的Map
  static final Map<Type, Model> _instances = {};

  /// 存储懒加载创建器的Map
  static final Map<Type, Model Function()> _lazyCreators = {};

  /// 懒加载注册模型
  ///
  /// 模型只会在第一次调用[get]时创建
  ///
  /// [creator] 创建模型的函数
  ///
  /// ### 示例
  ///
  /// ```dart
  /// EasyModelManager.lazyPut<CounterModel>(() => CounterModel());
  /// ```
  static void lazyPut<T extends Model>(T Function() creator) {
    _lazyCreators[T] = creator as Model Function();
    // 如果已经存在实例，先删除
    if (_instances.containsKey(T)) {
      _instances[T]?.dispose();
      _instances.remove(T);
    }
  }

  /// 获取模型实例
  ///
  /// 如果模型不存在，会使用[creator]创建实例
  /// 如果已注册懒加载，会使用懒加载创建器创建实例
  ///
  /// [creator] 创建模型的函数（可选，如果已注册懒加载则不需要）
  ///
  /// 返回模型实例
  ///
  /// ### 示例
  ///
  /// ```dart
  /// // 使用懒加载
  /// EasyModelManager.lazyPut<CounterModel>(() => CounterModel());
  /// final counter = EasyModelManager.get<CounterModel>();
  ///
  /// // 或直接提供创建器
  /// final counter = EasyModelManager.get<CounterModel>(() => CounterModel());
  /// ```
  static T get<T extends Model>([T Function()? creator]) {
    // 如果已存在实例，直接返回
    if (_instances.containsKey(T)) {
      return _instances[T] as T;
    }

    // 如果已注册懒加载，使用懒加载创建器
    if (_lazyCreators.containsKey(T)) {
      final instance = _lazyCreators[T]!() as T;
      _instances[T] = instance;
      return instance;
    }

    // 如果提供了创建器，使用创建器创建
    if (creator != null) {
      final instance = creator();
      _instances[T] = instance;
      return instance;
    }

    // 如果都没有，抛出异常
    throw Exception(
        'Model of type $T not found. Use lazyPut or provide a creator.');
  }

  /// 直接设置模型实例
  ///
  /// [instance] 模型实例
  ///
  /// ### 示例
  ///
  /// ```dart
  /// EasyModelManager.put<CounterModel>(CounterModel());
  /// ```
  static void put<T extends Model>(T instance) {
    // 如果已存在实例，先销毁
    if (_instances.containsKey(T)) {
      _instances[T]?.dispose();
    }
    // 移除懒加载创建器（如果存在）
    _lazyCreators.remove(T);
    // 设置新实例
    _instances[T] = instance;
  }

  /// 删除模型实例
  ///
  /// 会销毁模型实例并移除懒加载创建器
  ///
  /// ### 示例
  ///
  /// ```dart
  /// EasyModelManager.delete<CounterModel>();
  /// ```
  static void delete<T extends Model>() {
    // 销毁实例
    if (_instances.containsKey(T)) {
      _instances[T]?.dispose();
      _instances.remove(T);
    }
    // 移除懒加载创建器
    _lazyCreators.remove(T);
  }

  /// 检查模型是否存在
  ///
  /// 返回模型是否存在
  ///
  /// ### 示例
  ///
  /// ```dart
  /// if (EasyModelManager.isRegistered<CounterModel>()) {
  ///   final counter = EasyModelManager.get<CounterModel>();
  /// }
  /// ```
  static bool isRegistered<T extends Model>() {
    return _instances.containsKey(T) || _lazyCreators.containsKey(T);
  }

  /// 重置所有模型
  ///
  /// 会销毁所有模型实例并清除所有懒加载创建器
  ///
  /// ### 示例
  ///
  /// ```dart
  /// EasyModelManager.reset();
  /// ```
  static void reset() {
    // 销毁所有实例
    for (final instance in _instances.values) {
      instance.dispose();
    }
    _instances.clear();
    _lazyCreators.clear();
  }

  /// 获取所有已注册的模型类型
  ///
  /// 返回已注册的模型类型列表
  ///
  /// ### 示例
  ///
  /// ```dart
  /// final types = EasyModelManager.registeredTypes();
  /// ```
  static List<Type> registeredTypes() {
    return [
      ..._instances.keys,
      ..._lazyCreators.keys,
    ].toSet().toList();
  }
}
