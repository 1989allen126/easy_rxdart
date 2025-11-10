import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// Easy BehaviorSubject 包装类
///
/// 封装 BehaviorSubject，提供独立的创建和使用方式
/// 外部可以不引入 rxdart 就能使用
class EasyBehaviorSubject<T> {
  final BehaviorSubject<T> _subject;

  /// 创建 EasyBehaviorSubject
  ///
  /// [seedValue] 初始值（可选）
  EasyBehaviorSubject({T? seedValue})
      : _subject = seedValue != null
            ? BehaviorSubject<T>.seeded(seedValue)
            : BehaviorSubject<T>();

  /// 获取 Stream
  Stream<T> get stream => _subject.stream;

  /// 获取当前值（如果存在）
  ///
  /// 如果 Subject 没有值，返回 null
  T? get valueOrNull {
    try {
      return _subject.value;
    } catch (e) {
      return null;
    }
  }

  /// 获取当前值
  ///
  /// 如果 Subject 没有值，会抛出异常
  T get value => _subject.value;

  /// 获取当前值或默认值
  ///
  /// [defaultValue] 默认值
  /// 返回当前值或默认值
  T getValueOrDefault(T defaultValue) {
    try {
      return _subject.value;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 是否已关闭
  bool get isClosed => _subject.isClosed;

  /// 是否有值
  bool get hasValue => _subject.hasValue;

  /// 是否有错误
  ///
  /// ReplaySubject 不直接提供 hasError 属性
  /// 需要通过监听错误事件来判断
  bool get hasError => false;

  /// 错误对象
  ///
  /// ReplaySubject 不直接提供 error 属性
  /// 需要通过监听错误事件来获取
  Object? get error => null;

  /// 添加值
  ///
  /// [value] 要添加的值
  void add(T value) {
    if (!_subject.isClosed) {
      _subject.add(value);
    }
  }

  /// 添加错误
  ///
  /// [error] 要添加的错误
  /// [stackTrace] 堆栈跟踪（可选）
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_subject.isClosed) {
      _subject.addError(error, stackTrace);
    }
  }

  /// 安全添加值
  ///
  /// 如果 Subject 已关闭，则不添加值
  ///
  /// [value] 要添加的值
  /// 返回是否成功添加
  bool safeAdd(T value) {
    if (_subject.isClosed) {
      return false;
    }
    _subject.add(value);
    return true;
  }

  /// 安全添加错误
  ///
  /// 如果 Subject 已关闭，则不添加错误
  ///
  /// [error] 要添加的错误
  /// [stackTrace] 堆栈跟踪（可选）
  /// 返回是否成功添加
  bool safeAddError(Object error, [StackTrace? stackTrace]) {
    if (_subject.isClosed) {
      return false;
    }
    _subject.addError(error, stackTrace);
    return true;
  }

  /// 订阅 Stream
  ///
  /// [onData] 数据回调
  /// [onError] 错误回调（可选）
  /// [onDone] 完成回调（可选）
  /// [cancelOnError] 是否在错误时取消订阅（可选）
  /// 返回 StreamSubscription
  StreamSubscription<T> listen(
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _subject.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 关闭 Subject
  ///
  /// 关闭后不能再添加值
  Future<void> close() async {
    if (!_subject.isClosed) {
      await _subject.close();
    }
  }

  /// 安全关闭
  ///
  /// 如果 Subject 已关闭，则不执行任何操作
  ///
  /// 返回是否成功关闭
  Future<bool> safeClose() async {
    if (_subject.isClosed) {
      return false;
    }
    await _subject.close();
    return true;
  }
}

/// Easy ReplaySubject 包装类
///
/// 封装 ReplaySubject，提供独立的创建和使用方式
/// 外部可以不引入 rxdart 就能使用
class EasyReplaySubject<T> {
  final ReplaySubject<T> _subject;

  /// 创建 EasyReplaySubject
  ///
  /// 注意：ReplaySubject 默认缓存所有值，没有最大缓存数量限制
  /// 如果需要限制缓存数量，建议使用 EasyBehaviorSubject
  EasyReplaySubject() : _subject = ReplaySubject<T>();

  /// 获取 Stream
  Stream<T> get stream => _subject.stream;

  /// 获取所有缓存的值
  ///
  /// 返回所有缓存的值列表
  List<T> get cachedValues => _subject.values.toList();

  /// 获取缓存值的数量
  int get cacheSize => _subject.values.length;

  /// 是否已关闭
  bool get isClosed => _subject.isClosed;

  /// 是否有值
  bool get hasValue => _subject.values.isNotEmpty;

  /// 是否有错误
  ///
  /// ReplaySubject 不直接提供 hasError 属性
  /// 需要通过监听错误事件来判断
  bool get hasError => false;

  /// 错误对象
  ///
  /// ReplaySubject 不直接提供 error 属性
  /// 需要通过监听错误事件来获取
  Object? get error => null;

  /// 添加值
  ///
  /// [value] 要添加的值
  void add(T value) {
    if (!_subject.isClosed) {
      _subject.add(value);
    }
  }

  /// 添加错误
  ///
  /// [error] 要添加的错误
  /// [stackTrace] 堆栈跟踪（可选）
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_subject.isClosed) {
      _subject.addError(error, stackTrace);
    }
  }

  /// 安全添加值
  ///
  /// 如果 Subject 已关闭，则不添加值
  ///
  /// [value] 要添加的值
  /// 返回是否成功添加
  bool safeAdd(T value) {
    if (_subject.isClosed) {
      return false;
    }
    _subject.add(value);
    return true;
  }

  /// 安全添加错误
  ///
  /// 如果 Subject 已关闭，则不添加错误
  ///
  /// [error] 要添加的错误
  /// [stackTrace] 堆栈跟踪（可选）
  /// 返回是否成功添加
  bool safeAddError(Object error, [StackTrace? stackTrace]) {
    if (_subject.isClosed) {
      return false;
    }
    _subject.addError(error, stackTrace);
    return true;
  }

  /// 订阅 Stream
  ///
  /// [onData] 数据回调
  /// [onError] 错误回调（可选）
  /// [onDone] 完成回调（可选）
  /// [cancelOnError] 是否在错误时取消订阅（可选）
  /// 返回 StreamSubscription
  StreamSubscription<T> listen(
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _subject.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 关闭 Subject
  ///
  /// 关闭后不能再添加值
  Future<void> close() async {
    if (!_subject.isClosed) {
      await _subject.close();
    }
  }

  /// 安全关闭
  ///
  /// 如果 Subject 已关闭，则不执行任何操作
  ///
  /// 返回是否成功关闭
  Future<bool> safeClose() async {
    if (_subject.isClosed) {
      return false;
    }
    await _subject.close();
    return true;
  }
}
