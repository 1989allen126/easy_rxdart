import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'reactive.dart';

/// Easy StreamController
///
/// 提供链式调用的onData、onError、onComplete方法
/// 支持broadcast广播模式
/// 兼容RxDart风格的使用
/// 提供安全的dispose方法
class EasyStreamController<T> {
  StreamController<T>? _controller;
  StreamSubscription<T>? _subscription;
  bool _isDisposed = false;
  final bool _sync;

  /// 是否支持广播模式
  final bool broadcast;

  /// 数据回调
  void Function(T)? _onData;

  /// 错误回调
  void Function(Object, StackTrace)? _onError;

  /// 完成回调
  void Function()? _onDone;

  /// BehaviorSubject 包装对象列表
  final List<StreamControllerBehaviorSubject<T>> _behaviorSubjects = [];

  /// PublishSubject 包装对象列表
  final List<StreamControllerPublishSubject<T>> _publishSubjects = [];

  /// 构造函数
  ///
  /// [broadcast] 是否支持广播模式，默认为false
  /// [sync] 是否同步，默认为false
  EasyStreamController({
    this.broadcast = false,
    bool? sync,
  }) : _sync = sync ?? false {
    _controller = StreamController<T>(
      onListen: _onListen,
      onCancel: _onCancel,
      sync: _sync,
    );
  }

  /// 广播模式构造函数
  ///
  /// 创建一个支持广播的EasyStreamController
  EasyStreamController.broadcast({
    bool? sync,
  })  : broadcast = true,
        _sync = sync ?? false {
    _controller = StreamController<T>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
      sync: _sync,
    );
  }

  /// 获取内部的StreamController
  StreamController<T>? get controller => _controller;

  /// 获取Stream
  Stream<T> get stream {
    if (_isDisposed || _controller == null) {
      return Stream<T>.empty();
    }
    return _controller!.stream;
  }

  /// 是否已关闭
  bool get isClosed {
    if (_isDisposed) {
      return true;
    }
    return _controller?.isClosed ?? true;
  }

  /// 是否已dispose
  bool get isDisposed => _isDisposed;

  /// 链式调用：设置onData回调
  ///
  /// [onData] 数据回调函数
  /// 返回自身，支持链式调用
  EasyStreamController<T> onData(void Function(T) onData) {
    if (_isDisposed) {
      return this;
    }
    _onData = onData;
    _setupSubscription();
    return this;
  }

  /// 链式调用：设置onError回调
  ///
  /// [onError] 错误回调函数
  /// 返回自身，支持链式调用
  EasyStreamController<T> onError(
    void Function(Object error, StackTrace stackTrace) onError,
  ) {
    if (_isDisposed) {
      return this;
    }
    _onError = onError;
    _setupSubscription();
    return this;
  }

  /// 链式调用：设置onComplete回调
  ///
  /// [onDone] 完成回调函数
  /// 返回自身，支持链式调用
  EasyStreamController<T> onComplete(void Function() onDone) {
    if (_isDisposed) {
      return this;
    }
    _onDone = onDone;
    _setupSubscription();
    return this;
  }

  /// 设置订阅
  void _setupSubscription() {
    if (_isDisposed || _controller == null) {
      return;
    }

    // 如果已经有订阅，先取消
    _subscription?.cancel();
    _subscription = null;

    // 如果有回调，创建订阅
    // 注意：在非广播模式下，stream 只能被监听一次
    // 所以我们需要检查是否已经有监听者
    if (_onData != null || _onError != null || _onDone != null) {
      try {
        _subscription = _controller!.stream.listen(
          _onData,
          onError: _onError,
          onDone: _onDone,
          cancelOnError: false,
        );
      } catch (e) {
        // 如果 stream 已经被监听（非广播模式），忽略错误
        // 在非广播模式下，onListen 回调会处理这种情况
        _subscription = null;
      }
    }
  }

  /// 监听回调
  void _onListen() {
    // 当有新的监听者时，重新设置订阅（仅对非广播模式有效）
    // 注意：在非广播模式下，stream 只能被监听一次
    // 所以我们需要确保只有一个订阅
    if (!broadcast &&
        !_isDisposed &&
        (_onData != null || _onError != null || _onDone != null)) {
      // 如果还没有订阅，创建订阅
      if (_subscription == null) {
        _setupSubscription();
      }
    }
  }

  /// 取消回调
  void _onCancel() {
    // 当所有监听者取消时，取消订阅（仅对非广播模式有效）
    if (!broadcast && !_isDisposed) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  /// 添加数据
  ///
  /// [value] 要添加的值
  /// 返回是否成功添加
  bool add(T value) {
    if (_isDisposed || _controller == null || _controller!.isClosed) {
      return false;
    }
    try {
      _controller!.add(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 添加错误
  ///
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// 返回是否成功添加
  bool addError(Object error, [StackTrace? stackTrace]) {
    if (_isDisposed || _controller == null || _controller!.isClosed) {
      return false;
    }
    try {
      _controller!.addError(error, stackTrace);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 关闭Stream
  ///
  /// 返回是否成功关闭
  Future<void> close() async {
    if (_isDisposed) {
      return;
    }
    if (_controller == null || _controller!.isClosed) {
      return;
    }
    try {
      await _controller!.close();
    } catch (e) {
      // 忽略关闭时的异常
    }
  }

  /// 安全销毁
  ///
  /// 清理所有资源，不会抛出异常
  /// 返回是否成功销毁
  Future<bool> dispose() async {
    if (_isDisposed) {
      return true;
    }

    _isDisposed = true;

    try {
      // 取消订阅
      await _subscription?.cancel();
      _subscription = null;

      // 销毁所有 BehaviorSubject 包装对象
      for (final behaviorSubject in _behaviorSubjects) {
        await behaviorSubject._dispose();
      }
      _behaviorSubjects.clear();

      // 销毁所有 PublishSubject 包装对象
      for (final publishSubject in _publishSubjects) {
        await publishSubject._dispose();
      }
      _publishSubjects.clear();

      // 关闭controller
      if (_controller != null && !_controller!.isClosed) {
        await _controller!.close();
      }
      _controller = null;

      // 清理回调
      _onData = null;
      _onError = null;
      _onDone = null;

      return true;
    } catch (e) {
      // 即使出现异常，也标记为已销毁
      _controller = null;
      _subscription = null;
      _behaviorSubjects.clear();
      _publishSubjects.clear();
      _onData = null;
      _onError = null;
      _onDone = null;
      return false;
    }
  }

  /// 转换为Reactive（RxDart风格）
  ///
  /// 返回Reactive对象，支持链式操作
  Reactive<T> asReactive() {
    return Reactive(stream);
  }

  /// 转换为Stream（RxDart风格）
  ///
  /// 返回Stream对象
  Stream<T> asStream() {
    return stream;
  }

  /// 转换为StreamControllerBehaviorSubject（RxDart风格）
  ///
  /// 返回包装后的BehaviorSubject，不暴露close/dispose方法
  /// 生命周期由EasyStreamController统一管理
  /// 每次调用都会创建新的实例
  StreamControllerBehaviorSubject<T> asBehaviorSubject() {
    if (_isDisposed) {
      throw StateError('EasyStreamController已销毁');
    }

    // 创建新的包装对象
    final subject = BehaviorSubject<T>();
    final wrapper = StreamControllerBehaviorSubject<T>._internal(subject);
    _behaviorSubjects.add(wrapper);

    // 监听stream并转发到subject
    wrapper._listenTo(stream);

    return wrapper;
  }

  /// 转换为StreamControllerPublishSubject（RxDart风格）
  ///
  /// 返回包装后的PublishSubject，不暴露close/dispose方法
  /// 生命周期由EasyStreamController统一管理
  /// 每次调用都会创建新的实例
  StreamControllerPublishSubject<T> asPublishSubject() {
    if (_isDisposed) {
      throw StateError('EasyStreamController已销毁');
    }

    // 创建新的包装对象
    final subject = PublishSubject<T>();
    final wrapper = StreamControllerPublishSubject<T>._internal(subject);
    _publishSubjects.add(wrapper);

    // 监听stream并转发到subject
    wrapper._listenTo(stream);

    return wrapper;
  }
}

/// StreamController BehaviorSubject 包装类
///
/// 封装 BehaviorSubject，不暴露 close/dispose 方法给外部
/// 遵循"谁创建谁销毁"的原则
/// 仅用于 EasyStreamController 内部使用
class StreamControllerBehaviorSubject<T> {
  final BehaviorSubject<T> _subject;
  StreamSubscription<T>? _subscription;

  /// 内部构造函数（由 EasyStreamController 使用）
  StreamControllerBehaviorSubject._internal(this._subject);

  /// 获取 Stream
  Stream<T> get stream => _subject.stream;

  /// 获取当前值（如果存在）
  T? get valueOrNull {
    try {
      return _subject.value;
    } catch (e) {
      return null;
    }
  }

  /// 获取当前值或默认值
  T getValueOrDefault(T defaultValue) {
    try {
      return _subject.value;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 是否已关闭
  bool get isClosed => _subject.isClosed;

  /// 添加值
  void add(T value) {
    if (!_subject.isClosed) {
      _subject.add(value);
    }
  }

  /// 添加错误
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_subject.isClosed) {
      _subject.addError(error, stackTrace);
    }
  }

  /// 监听 Stream（内部使用，由 EasyStreamController 调用）
  void _listenTo(Stream<T> source) {
    _subscription?.cancel();
    _subscription = source.listen(
      (value) => _subject.add(value),
      onError: (error, stackTrace) => _subject.addError(error, stackTrace),
      onDone: () {
        // 不自动关闭，由 EasyStreamController 统一管理
      },
    );
  }

  /// 销毁（内部使用，由 EasyStreamController 调用）
  Future<void> _dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    if (!_subject.isClosed) {
      await _subject.close();
    }
  }
}

/// StreamController PublishSubject 包装类
///
/// 封装 PublishSubject，不暴露 close/dispose 方法给外部
/// 遵循"谁创建谁销毁"的原则
/// 仅用于 EasyStreamController 内部使用
class StreamControllerPublishSubject<T> {
  final PublishSubject<T> _subject;
  StreamSubscription<T>? _subscription;

  /// 内部构造函数（由 EasyStreamController 使用）
  StreamControllerPublishSubject._internal(this._subject);

  /// 获取 Stream
  Stream<T> get stream => _subject.stream;

  /// 是否已关闭
  bool get isClosed => _subject.isClosed;

  /// 添加值
  void add(T value) {
    if (!_subject.isClosed) {
      _subject.add(value);
    }
  }

  /// 添加错误
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_subject.isClosed) {
      _subject.addError(error, stackTrace);
    }
  }

  /// 监听 Stream（内部使用，由 EasyStreamController 调用）
  void _listenTo(Stream<T> source) {
    _subscription?.cancel();
    _subscription = source.listen(
      (value) => _subject.add(value),
      onError: (error, stackTrace) => _subject.addError(error, stackTrace),
      onDone: () {
        // 不自动关闭，由 EasyStreamController 统一管理
      },
    );
  }

  /// 销毁（内部使用，由 EasyStreamController 调用）
  Future<void> _dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    if (!_subject.isClosed) {
      await _subject.close();
    }
  }
}
