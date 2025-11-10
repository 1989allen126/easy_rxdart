import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../core/reactive.dart';
import '../extensions/stream/stream_extensions.dart';
import '../extensions/stream/stream_operators_extensions.dart';
import 'debounce_utils.dart';
import 'distinct_utils.dart';
import 'throttle_utils.dart';

/// Rx工具类
///
/// 提供RxDart所有静态方法的统一封装，以及utils工具方法的通用版本
class RxUtils {
  // ==================== Rx静态方法封装 ====================

  /// 创建空Stream
  static Stream<T> empty<T>() => Stream<T>.empty();

  /// 创建单值Stream（just）
  static Stream<T> just<T>(T value) => Stream<T>.value(value);

  /// 创建错误Stream
  static Stream<T> error<T>(Object error, [StackTrace? stackTrace]) =>
      Stream<T>.error(error, stackTrace);

  /// 创建延迟Stream
  static Stream<T> delayed<T>(T value, Duration duration) =>
      TimerStream(value, duration);

  /// 创建周期性Stream
  static Stream<T> periodic<T>(T value, Duration period) =>
      Stream.periodic(period, (_) => value);

  /// 合并多个Stream
  static Stream<T> merge<T>(List<Stream<T>> streams) => Rx.merge(streams);

  /// 连接多个Stream
  static Stream<T> concat<T>(List<Stream<T>> streams) => Rx.concat(streams);

  /// 组合多个Stream的最新值
  static Stream<List<T>> combineLatest<T>(List<Stream<T>> streams) =>
      CombineLatestStream.list(streams);

  /// 组合两个Stream的最新值
  static Stream<R> combineLatest2<A, B, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    R Function(A, B) combiner,
  ) =>
      Rx.combineLatest2(streamA, streamB, combiner);

  /// 组合三个Stream的最新值
  static Stream<R> combineLatest3<A, B, C, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    R Function(A, B, C) combiner,
  ) =>
      Rx.combineLatest3(streamA, streamB, streamC, combiner);

  /// 压缩多个Stream
  static Stream<List<T>> zip<T>(List<Stream<T>> streams) =>
      ZipStream.list(streams);

  /// 压缩两个Stream
  static Stream<R> zip2<A, B, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    R Function(A, B) combiner,
  ) =>
      Rx.zip2(streamA, streamB, combiner);

  /// 压缩三个Stream
  static Stream<R> zip3<A, B, C, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    R Function(A, B, C) combiner,
  ) =>
      Rx.zip3(streamA, streamB, streamC, combiner);

  /// 从Iterable创建Stream
  static Stream<T> fromIterable<T>(Iterable<T> iterable) =>
      Stream.fromIterable(iterable);

  /// 从Future创建Stream
  static Stream<T> fromFuture<T>(Future<T> future) => Stream.fromFuture(future);

  /// 从值创建Stream
  static Stream<T> fromValue<T>(T value) => Stream.value(value);

  /// 从多个Future创建Stream（等待所有完成）
  static Stream<List<T>> fromFuturesWait<T>(List<Future<T>> futures) =>
      Stream.fromFuture(Future.wait(futures));

  /// 从多个Future创建Stream（任意一个完成即可）
  static Stream<T> fromFuturesAny<T>(List<Future<T>> futures) {
    final controller = StreamController<T>.broadcast();
    for (final future in futures) {
      future.then((value) => controller.add(value));
    }
    return controller.stream;
  }

  /// 创建可重试的Stream
  static Stream<T> retry<T>({
    required Stream<T> Function() streamFactory,
    int count = 3,
    Duration delay = const Duration(seconds: 1),
  }) {
    Stream<T> retryStream(int remaining) {
      return streamFactory().handleError((error, stackTrace) {
        if (remaining > 0) {
          return Future.delayed(delay)
              .asStream()
              .asyncExpand((_) => retryStream(remaining - 1));
        }
        return Stream<T>.error(error, stackTrace);
      });
    }

    return retryStream(count);
  }

  /// 创建带超时的Stream
  static Stream<T> timeout<T>(
    Stream<T> stream,
    Duration timeout, {
    void Function(EventSink<T>)? onTimeout,
  }) =>
      stream.timeout(timeout, onTimeout: onTimeout);

  /// 创建带缓存的Stream
  static Stream<T> shareReplay<T>(
    Stream<T> stream, {
    int bufferSize = 1,
    bool refCount = true,
  }) =>
      stream.shareReplayValue(bufferSize: bufferSize, refCount: refCount);

  // ==================== 防抖工具方法 ====================

  /// 防抖Stream
  static Stream<T> debounceStream<T>(
    Stream<T> stream,
    Duration duration,
  ) {
    return stream.debounce((_) => TimerStream<T>(_, duration));
  }

  /// 防抖函数
  static void Function(T) debounceFunction<T>(
    void Function(T) callback,
    Duration duration,
  ) =>
      DebounceUtils.debounceFunction(callback, duration);

  /// 防抖函数（无参数）
  static VoidCallback debounceVoid(
    VoidCallback callback,
    Duration duration,
  ) =>
      DebounceUtils.debounceVoid(callback, duration);

  /// 防抖异步函数
  static Future<void> Function(T) debounceAsync<T>(
    Future<void> Function(T) callback,
    Duration duration,
  ) =>
      DebounceUtils.debounceAsync(callback, duration);

  /// 防抖异步函数（无参数）
  static Future<void> Function() debounceAsyncVoid(
    Future<void> Function() callback,
    Duration duration,
  ) =>
      DebounceUtils.debounceAsyncVoid(callback, duration);

  /// 防抖Reactive
  static Reactive<T> debounceReactive<T>(
    Reactive<T> reactive,
    Duration duration,
  ) {
    return Reactive(
        reactive.stream.debounce((_) => TimerStream<T>(_, duration)));
  }

  /// 防抖（自动识别类型）
  ///
  /// 支持Stream、Reactive、函数等多种类型
  static T debounce<T>(
    T source,
    Duration duration,
  ) {
    if (source is Stream) {
      return debounceStream(source, duration) as T;
    } else if (source is Reactive) {
      return debounceReactive(source, duration) as T;
    } else if (source is Function) {
      // 尝试推断函数类型
      if (source is void Function()) {
        return debounceVoid(source as VoidCallback, duration) as T;
      } else if (source is void Function(dynamic)) {
        return debounceFunction(source as void Function(dynamic), duration)
            as T;
      }
    }
    throw ArgumentError('不支持的类型: ${source.runtimeType}');
  }

  // ==================== 限流工具方法 ====================

  /// 限流Stream
  static Stream<T> throttleStream<T>(
    Stream<T> stream,
    Duration duration,
  ) {
    return stream.throttle((_) => TimerStream<T>(_, duration));
  }

  /// 限流函数
  static void Function(T) throttleFunction<T>(
    void Function(T) callback,
    Duration duration,
  ) =>
      ThrottleUtils.throttleFunction(callback, duration);

  /// 限流函数（无参数）
  static VoidCallback throttleVoid(
    VoidCallback callback,
    Duration duration,
  ) =>
      ThrottleUtils.throttleVoid(callback, duration);

  /// 限流异步函数
  static Future<void> Function(T) throttleAsync<T>(
    Future<void> Function(T) callback,
    Duration duration,
  ) =>
      ThrottleUtils.throttleAsync(callback, duration);

  /// 限流异步函数（无参数）
  static Future<void> Function() throttleAsyncVoid(
    Future<void> Function() callback,
    Duration duration,
  ) =>
      ThrottleUtils.throttleAsyncVoid(callback, duration);

  /// 限流Reactive
  static Reactive<T> throttleReactive<T>(
    Reactive<T> reactive,
    Duration duration,
  ) {
    return Reactive(
        reactive.stream.throttle((_) => TimerStream<T>(_, duration)));
  }

  /// 限流（自动识别类型）
  ///
  /// 支持Stream、Reactive、函数等多种类型
  static T throttle<T>(
    T source,
    Duration duration,
  ) {
    if (source is Stream) {
      return throttleStream(source, duration) as T;
    } else if (source is Reactive) {
      return throttleReactive(source, duration) as T;
    } else if (source is Function) {
      // 尝试推断函数类型
      if (source is void Function()) {
        return throttleVoid(source as VoidCallback, duration) as T;
      } else if (source is void Function(dynamic)) {
        return throttleFunction(source as void Function(dynamic), duration)
            as T;
      }
    }
    throw ArgumentError('不支持的类型: ${source.runtimeType}');
  }

  // ==================== 去重工具方法（万金油版本）====================

  /// 去重Stream
  static Stream<T> distinctStream<T>(
    Stream<T> stream, {
    bool Function(T, T)? equals,
  }) {
    if (equals != null) {
      return stream.distinctUntilChangedBy(equals);
    }
    return stream.distinctBy();
  }

  /// 去重函数
  static void Function(T) distinctFunction<T>(
    void Function(T) callback, {
    bool Function(T, T)? equals,
  }) =>
      DistinctUtils.distinctFunction(callback, equals: equals);

  /// 去重函数（无参数）
  static VoidCallback distinctVoid(
    VoidCallback callback,
  ) =>
      DistinctUtils.distinctVoid(callback);

  /// 去重异步函数
  static Future<void> Function(T) distinctAsync<T>(
    Future<void> Function(T) callback, {
    bool Function(T, T)? equals,
  }) =>
      DistinctUtils.distinctAsync(callback, equals: equals);

  /// 去重Reactive
  static Reactive<T> distinctReactive<T>(
    Reactive<T> reactive, {
    bool Function(T, T)? equals,
  }) =>
      Reactive(distinctStream(reactive.stream, equals: equals));

  /// 去重（自动识别类型）
  ///
  /// 支持Stream、Reactive、函数等多种类型
  static T distinct<T>(
    T source, {
    bool Function(dynamic, dynamic)? equals,
  }) {
    if (source is Stream) {
      return distinctStream(source, equals: equals) as T;
    } else if (source is Reactive) {
      return distinctReactive(source, equals: equals) as T;
    } else if (source is Function) {
      // 尝试推断函数类型
      if (source is void Function()) {
        return distinctVoid(source as VoidCallback) as T;
      } else if (source is void Function(dynamic)) {
        return distinctFunction(
          source as void Function(dynamic),
          equals: equals,
        ) as T;
      }
    }
    throw ArgumentError('不支持的类型: ${source.runtimeType}');
  }

  // ==================== 组合工具方法 ====================

  /// 组合防抖和去重
  static T debounceDistinct<T>(
    T source,
    Duration debounceDuration, {
    bool Function(dynamic, dynamic)? equals,
  }) {
    final debounced = debounce(source, debounceDuration);
    return distinct(debounced, equals: equals);
  }

  /// 组合限流和去重
  static T throttleDistinct<T>(
    T source,
    Duration throttleDuration, {
    bool Function(dynamic, dynamic)? equals,
  }) {
    final throttled = throttle(source, throttleDuration);
    return distinct(throttled, equals: equals);
  }

  /// 组合防抖和限流（先防抖后限流）
  static T debounceThrottle<T>(
    T source,
    Duration debounceDuration,
    Duration throttleDuration,
  ) {
    final debounced = debounce(source, debounceDuration);
    return throttle(debounced, throttleDuration);
  }

  /// 组合限流和防抖（先限流后防抖）
  static T throttleDebounce<T>(
    T source,
    Duration throttleDuration,
    Duration debounceDuration,
  ) {
    final throttled = throttle(source, throttleDuration);
    return debounce(throttled, debounceDuration);
  }

  // ==================== WhereEx工具方法 ====================

  /// WhereEx过滤Stream
  ///
  /// [stream] 要过滤的Stream
  /// [predicates] 过滤条件函数列表，使用OR逻辑（满足任一条件即为matched）
  /// 返回WhereExResult对象，可以调用asList()或asMap()获取分组结果
  static WhereExResult<T> whereExStream<T>(
    Stream<T> stream,
    List<bool Function(T)> predicates,
  ) {
    return stream.whereEx(predicates);
  }

  /// WhereEx过滤Reactive
  ///
  /// [reactive] 要过滤的Reactive
  /// [predicates] 过滤条件函数列表，使用OR逻辑（满足任一条件即为matched）
  /// 返回WhereExResult对象，可以调用asList()或asMap()获取分组结果
  static WhereExResult<T> whereExReactive<T>(
    Reactive<T> reactive,
    List<bool Function(T)> predicates,
  ) {
    return reactive.whereEx(predicates);
  }

  /// WhereEx过滤（自动识别类型）
  ///
  /// 支持Stream、Reactive等多种类型
  /// [source] 要过滤的数据源
  /// [predicates] 过滤条件函数列表，使用OR逻辑（满足任一条件即为matched）
  /// 返回WhereExResult对象，可以调用asList()或asMap()获取分组结果
  static WhereExResult<T> whereEx<T>(
    dynamic source,
    List<bool Function(T)> predicates,
  ) {
    if (source is Stream<T>) {
      return whereExStream(source, predicates);
    } else if (source is Reactive<T>) {
      return whereExReactive(source, predicates);
    }
    throw ArgumentError('不支持的类型: ${source.runtimeType}');
  }

  // ==================== Stream操作符工具方法 ====================

  /// 过滤Stream
  ///
  /// [stream] 要过滤的Stream
  /// [predicate] 过滤条件函数
  /// 返回过滤后的Stream
  static Stream<T> filterStream<T>(
    Stream<T> stream,
    bool Function(T) predicate,
  ) {
    return stream.filter(predicate);
  }

  /// 过滤Reactive
  ///
  /// [reactive] 要过滤的Reactive
  /// [predicate] 过滤条件函数
  /// 返回过滤后的Reactive
  static Reactive<T> filterReactive<T>(
    Reactive<T> reactive,
    bool Function(T) predicate,
  ) {
    return reactive.where(predicate);
  }

  /// 紧凑映射Stream（过滤null值）
  ///
  /// [stream] 要映射的Stream
  /// [mapper] 映射函数，返回可空类型
  /// 返回过滤null后的Stream
  static Stream<R> compactMapStream<T, R>(
    Stream<T> stream,
    R? Function(T) mapper,
  ) {
    return stream.compactMap(mapper);
  }

  /// 扁平映射Stream
  ///
  /// [stream] 要映射的Stream
  /// [mapper] 映射函数，返回Stream
  /// 返回扁平化后的Stream
  static Stream<R> flatMapStream<T, R>(
    Stream<T> stream,
    Stream<R> Function(T) mapper,
  ) {
    return stream.asyncExpand(mapper);
  }

  /// 扁平映射Reactive
  ///
  /// [reactive] 要映射的Reactive
  /// [mapper] 映射函数，返回Stream
  /// 返回扁平化后的Reactive
  static Reactive<R> flatMapReactive<T, R>(
    Reactive<T> reactive,
    Stream<R> Function(T) mapper,
  ) {
    return reactive.flatMap(mapper);
  }

  /// 归约Stream
  ///
  /// [stream] 要归约的Stream
  /// [initialValue] 初始值
  /// [combine] 归约函数
  /// 返回归约结果的Future
  static Future<R> reduceStream<T, R>(
    Stream<T> stream,
    R initialValue,
    R Function(R, T) combine,
  ) {
    return stream.reduceValue(initialValue, combine);
  }

  /// 分组Stream
  ///
  /// [stream] 要分组的Stream
  /// [keySelector] 键选择函数
  /// 返回分组后的Map的Future
  static Future<Map<K, List<T>>> groupByKeyStream<T, K>(
    Stream<T> stream,
    K Function(T) keySelector,
  ) {
    return stream.groupByKey(keySelector);
  }

  /// 分组并转换值Stream
  ///
  /// [stream] 要分组的Stream
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map的Future
  static Future<Map<K, List<V>>> groupByKeyAndValueStream<T, K, V>(
    Stream<T> stream,
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.groupByKeyAndValue(keySelector, valueSelector);
  }

  /// 获取第一个值Stream
  ///
  /// [stream] 要获取的Stream
  /// [orElse] 如果没有值时的默认值
  /// 返回第一个值的Future
  static Future<T> firstValueStream<T>(
    Stream<T> stream, [
    T? orElse,
  ]) {
    return stream.firstValue(orElse);
  }

  /// 获取最后一个值Stream
  ///
  /// [stream] 要获取的Stream
  /// [orElse] 如果没有值时的默认值
  /// 返回最后一个值的Future
  static Future<T> lastValueStream<T>(
    Stream<T> stream, [
    T? orElse,
  ]) {
    return stream.lastValue(orElse);
  }

  /// 排序Stream
  ///
  /// [stream] 要排序的Stream
  /// [compare] 比较函数
  /// 返回排序后的Stream
  static Stream<T> sortedStream<T>(
    Stream<T> stream, [
    int Function(T, T)? compare,
  ]) {
    return stream.sorted(compare);
  }

  /// 反转Stream
  ///
  /// [stream] 要反转的Stream
  /// 返回反转后的Stream
  static Stream<T> reversedStream<T>(Stream<T> stream) {
    return stream.reversed();
  }

  /// 分页Stream
  ///
  /// [stream] 要分页的Stream
  /// [pageSize] 每页大小
  /// [page] 页码（从0开始）
  /// 返回分页后的Stream
  static Stream<T> paginateStream<T>(
    Stream<T> stream,
    int pageSize,
    int page,
  ) {
    return stream.paginate(pageSize, page);
  }

  /// 统计Stream
  ///
  /// [stream] 要统计的Stream
  /// 返回统计信息的Future
  static Future<StreamStatistics<T>> statisticsStream<T>(
    Stream<T> stream,
  ) {
    return stream.statistics();
  }

  // ==================== Reactive操作符工具方法 ====================

  /// 映射Reactive
  ///
  /// [reactive] 要映射的Reactive
  /// [transform] 转换函数
  /// 返回映射后的Reactive
  static Reactive<R> mapReactive<T, R>(
    Reactive<T> reactive,
    R Function(T) transform,
  ) {
    return reactive.map(transform);
  }

  /// 过滤Reactive（where的别名）
  ///
  /// [reactive] 要过滤的Reactive
  /// [test] 过滤条件函数
  /// 返回过滤后的Reactive
  static Reactive<T> whereReactive<T>(
    Reactive<T> reactive,
    bool Function(T) test,
  ) {
    return reactive.where(test);
  }

  /// 延迟Reactive
  ///
  /// [reactive] 要延迟的Reactive
  /// [duration] 延迟时间
  /// 返回延迟后的Reactive
  static Reactive<T> delayReactive<T>(
    Reactive<T> reactive,
    Duration duration,
  ) {
    return reactive.delay(duration);
  }

  /// 执行Future后继续Reactive
  ///
  /// [reactive] 要处理的Reactive
  /// [next] Future处理函数
  /// 返回处理后的Reactive
  static Reactive<R> thenReactive<T, R>(
    Reactive<T> reactive,
    Future<R> Function(T) next,
  ) {
    return reactive.then(next);
  }
}
