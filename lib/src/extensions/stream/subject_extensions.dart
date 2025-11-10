import 'package:rxdart/rxdart.dart';
import '../../core/easy_subject.dart';

/// Subject扩展操作符
extension SubjectExtensions<T> on Subject<T> {
  /// 安全添加值
  ///
  /// 如果Subject已关闭，则不添加值
  ///
  /// [value] 要添加的值
  /// 返回是否成功添加
  bool safeAdd(T value) {
    if (isClosed) {
      return false;
    }
    add(value);
    return true;
  }

  /// 安全添加错误
  ///
  /// 如果Subject已关闭，则不添加错误
  ///
  /// [error] 要添加的错误
  /// [stackTrace] 堆栈跟踪
  /// 返回是否成功添加
  bool safeAddError(Object error, [StackTrace? stackTrace]) {
    if (isClosed) {
      return false;
    }
    addError(error, stackTrace);
    return true;
  }

  /// 安全关闭
  ///
  /// 如果Subject已关闭，则不执行任何操作
  ///
  /// 返回是否成功关闭
  bool safeClose() {
    if (isClosed) {
      return false;
    }
    close();
    return true;
  }

  /// 重置Subject
  ///
  /// 关闭当前Subject并创建新的EasyBehaviorSubject
  ///
  /// 返回新的EasyBehaviorSubject
  EasyBehaviorSubject<T> reset() {
    if (!isClosed) {
      close();
    }
    return EasyBehaviorSubject<T>();
  }
}

/// BehaviorSubject扩展
extension BehaviorSubjectExtensions<T> on BehaviorSubject<T> {
  /// 获取当前值
  ///
  /// 如果Subject没有值，返回null
  ///
  /// 返回当前值或null
  T? get currentValue {
    try {
      return value;
    } catch (e) {
      return null;
    }
  }

  /// 获取当前值或默认值
  ///
  /// 如果Subject没有值，返回默认值
  ///
  /// [defaultValue] 默认值
  /// 返回当前值或默认值
  T getValueOrDefault(T defaultValue) {
    try {
      return value;
    } catch (e) {
      return defaultValue;
    }
  }
}

/// ReplaySubject扩展
extension ReplaySubjectExtensions<T> on ReplaySubject<T> {
  /// 获取所有缓存的值
  ///
  /// 返回所有缓存的值列表
  List<T> get cachedValues {
    return values.toList();
  }

  /// 清空缓存
  ///
  /// 清空所有缓存的值
  /// 注意：ReplaySubject没有直接清空缓存的方法，需要外部重新创建
  void clearCache() {
    // ReplaySubject没有直接清空缓存的方法
    // 需要外部重新创建
    close();
  }
}
