import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../extensions/stream/stream_operators_extensions.dart';

/// 响应式核心类，包装Stream提供链式操作
class Reactive<T> {
  final Stream<T> _stream;

  Reactive(this._stream);

  /// 获取内部流（用于工具类访问）
  Stream<T> get stream => _stream;

  /// 转换数据（map）
  Reactive<R> map<R>(R Function(T) transform) {
    return Reactive(_stream.map(transform));
  }

  /// 扁平化转换（flatMap）
  Reactive<R> flatMap<R>(Stream<R> Function(T) transform) {
    return Reactive(_stream.asyncExpand(transform));
  }

  /// 过滤数据
  Reactive<T> where(bool Function(T) test) {
    return Reactive(_stream.where(test));
  }

  /// 扩展过滤操作（支持多个条件）
  ///
  /// [predicates] 过滤条件函数列表，使用OR逻辑（满足任一条件即为matched）
  /// 返回WhereExResult对象，可以调用asList()或asMap()获取分组结果
  WhereExResult<T> whereEx(List<bool Function(T)> predicates) {
    return _stream.whereEx(predicates);
  }

  /// 延迟发射
  Reactive<T> delay(Duration duration) {
    return Reactive(_stream.delay(duration));
  }

  /// 执行Future后继续（then）
  Reactive<R> then<R>(Future<R> Function(T) next) {
    return Reactive(_stream.asyncMap(next));
  }

  /// 合并多个同类型流
  static Reactive<T> merge<T>(List<Reactive<T>> reactives) {
    return Reactive(Rx.merge(reactives.map((r) => r._stream)));
  }

  /// 组合多个流的最新数据
  static Reactive<List<T>> combineLatest<T>(List<Reactive<T>> reactives) {
    return Reactive(
      Rx.combineLatest(
        reactives.map((r) => r._stream).toList(),
        (List<T> values) => values,
      ),
    );
  }

  /// 组合两个流的最新数据
  ///
  /// [a] 第一个流
  /// [b] 第二个流
  /// [combiner] 组合函数
  /// 返回组合后的Reactive
  static Reactive<R> combineLatest2<A, B, R>(
    Reactive<A> a,
    Reactive<B> b,
    R Function(A, B) combiner,
  ) {
    return Reactive(Rx.combineLatest2(a._stream, b._stream, combiner));
  }

  /// 组合三个流的最新数据
  ///
  /// [a] 第一个流
  /// [b] 第二个流
  /// [c] 第三个流
  /// [combiner] 组合函数
  /// 返回组合后的Reactive
  static Reactive<R> combineLatest3<A, B, C, R>(
    Reactive<A> a,
    Reactive<B> b,
    Reactive<C> c,
    R Function(A, B, C) combiner,
  ) {
    return Reactive(Rx.combineLatest3(a._stream, b._stream, c._stream, combiner));
  }

  /// 压缩多个流的数据
  ///
  /// [reactives] 要压缩的流列表
  /// [combiner] 压缩函数
  /// 返回压缩后的Reactive
  static Reactive<R> zip<T, R>(
    List<Reactive<T>> reactives,
    R Function(List<T>) combiner,
  ) {
    return Reactive(
      ZipStream.list(reactives.map((r) => r._stream).toList()).map(combiner),
    );
  }

  /// 压缩两个流的数据
  ///
  /// [a] 第一个流
  /// [b] 第二个流
  /// [combiner] 压缩函数
  /// 返回压缩后的Reactive
  static Reactive<R> zip2<A, B, R>(
    Reactive<A> a,
    Reactive<B> b,
    R Function(A, B) combiner,
  ) {
    return Reactive(Rx.zip2(a._stream, b._stream, combiner));
  }

  /// 压缩三个流的数据
  ///
  /// [a] 第一个流
  /// [b] 第二个流
  /// [c] 第三个流
  /// [combiner] 压缩函数
  /// 返回压缩后的Reactive
  static Reactive<R> zip3<A, B, C, R>(
    Reactive<A> a,
    Reactive<B> b,
    Reactive<C> c,
    R Function(A, B, C) combiner,
  ) {
    return Reactive(Rx.zip3(a._stream, b._stream, c._stream, combiner));
  }

  /// 连接多个流（按顺序执行）
  ///
  /// [reactives] 要连接的流列表
  /// 返回连接后的Reactive
  static Reactive<T> concat<T>(List<Reactive<T>> reactives) {
    return Reactive(Rx.concat(reactives.map((r) => r._stream)));
  }

  /// 订阅流
  StreamSubscription<T> listen(
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 转换为Future（取第一个数据）
  Future<T> toFuture() => _stream.first;

  /// 从Future创建Reactive
  static Reactive<T> fromFuture<T>(Future<T> future) {
    return Reactive(Stream.fromFuture(future));
  }

  /// 从值创建Reactive
  static Reactive<T> fromValue<T>(T value) {
    return Reactive(Stream.value(value));
  }

  /// 创建单值Reactive（just的别名）
  ///
  /// [value] 要发出的值
  /// 返回包含单个值的Reactive
  static Reactive<T> just<T>(T value) {
    return fromValue(value);
  }

  /// 从Iterable创建Reactive
  static Reactive<T> fromIterable<T>(Iterable<T> iterable) {
    return Reactive(Stream.fromIterable(iterable));
  }

  /// 创建空Reactive
  ///
  /// 返回一个立即完成的空Reactive
  static Reactive<T> empty<T>() {
    return Reactive(Stream<T>.empty());
  }

  /// 创建错误Reactive
  ///
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// 返回包含错误的Reactive
  static Reactive<T> error<T>(Object error, [StackTrace? stackTrace]) {
    return Reactive(Stream<T>.error(error, stackTrace));
  }

  /// 创建延迟Reactive
  ///
  /// [value] 要发出的值
  /// [duration] 延迟时间
  /// 返回延迟后发出值的Reactive
  static Reactive<T> delayed<T>(T value, Duration duration) {
    return Reactive(TimerStream(value, duration));
  }

  /// 创建周期性Reactive
  ///
  /// [value] 要发出的值
  /// [period] 周期时间
  /// 返回周期性发出值的Reactive
  static Reactive<T> periodic<T>(T value, Duration period) {
    return Reactive(Stream.periodic(period, (_) => value));
  }
}
