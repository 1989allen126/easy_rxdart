import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../extensions/stream/stream_extensions.dart';

/// Stream工具类
class StreamUtils {
  /// 创建空Stream
  ///
  /// 返回一个立即完成的空Stream
  static Stream<T> empty<T>() {
    return Stream<T>.empty();
  }

  /// 创建单值Stream
  ///
  /// [value] 要发出的值
  /// 返回包含单个值的Stream
  static Stream<T> just<T>(T value) {
    return Stream<T>.value(value);
  }

  /// 创建错误Stream
  ///
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// 返回包含错误的Stream
  static Stream<T> error<T>(Object error, [StackTrace? stackTrace]) {
    return Stream<T>.error(error, stackTrace);
  }

  /// 创建延迟Stream
  ///
  /// [value] 要发出的值
  /// [duration] 延迟时间
  /// 返回延迟后发出值的Stream
  static Stream<T> delayed<T>(T value, Duration duration) {
    return TimerStream(value, duration);
  }

  /// 创建周期性Stream
  ///
  /// [value] 要发出的值
  /// [period] 周期时间
  /// 返回周期性发出值的Stream
  static Stream<T> periodic<T>(T value, Duration period) {
    return Stream.periodic(period, (_) => value);
  }

  /// 合并多个Stream
  ///
  /// [streams] 要合并的Stream列表
  /// 返回合并后的Stream
  static Stream<T> mergeAll<T>(List<Stream<T>> streams) {
    return Rx.merge(streams);
  }

  /// 连接多个Stream
  ///
  /// [streams] 要连接的Stream列表
  /// 返回连接后的Stream
  static Stream<T> concatAll<T>(List<Stream<T>> streams) {
    return Rx.concat(streams);
  }

  /// 组合多个Stream
  ///
  /// [streams] 要组合的Stream列表
  /// [combiner] 组合函数
  /// 返回组合后的Stream
  static Stream<R> combineAll<T, R>(
    List<Stream<T>> streams,
    R Function(List<T>) combiner,
  ) {
    return CombineLatestStream.list(streams).map(combiner);
  }

  /// 压缩多个Stream
  ///
  /// [streams] 要压缩的Stream列表
  /// [combiner] 压缩函数
  /// 返回压缩后的Stream
  static Stream<R> zipAll<T, R>(
    List<Stream<T>> streams,
    R Function(List<T>) combiner,
  ) {
    return ZipStream.list(streams).map(combiner);
  }

  /// 创建可取消的Stream
  ///
  /// [stream] 源Stream
  /// [cancelToken] 取消令牌
  /// 返回可取消的Stream
  static Stream<T> cancellable<T>(
    Stream<T> stream,
    Stream<void> cancelToken,
  ) {
    return stream.takeUntil(cancelToken);
  }

  /// 创建可暂停的Stream
  ///
  /// [stream] 源Stream
  /// [pauseToken] 暂停令牌
  /// 返回可暂停的Stream
  static Stream<T> pausable<T>(
    Stream<T> stream,
    Stream<bool> pauseToken,
  ) {
    bool? lastValue;
    // 使用RxDart的startWith扩展方法，明确指定使用RxDart的扩展
    return Rx.concat([Stream.value(false), pauseToken]).where((isPaused) {
      if (lastValue == null || lastValue != isPaused) {
        lastValue = isPaused;
        return true;
      }
      return false;
    }).switchMap((isPaused) {
      if (isPaused) {
        return Stream<T>.empty();
      }
      return stream;
    });
  }

  /// 创建可重试的Stream
  ///
  /// [streamFactory] Stream工厂函数
  /// [retryCount] 重试次数
  /// [retryDelay] 重试延迟
  /// 返回可重试的Stream
  static Stream<T> retryable<T>({
    required Stream<T> Function() streamFactory,
    int retryCount = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) {
    Stream<T> retryStream(int remaining) {
      return streamFactory().handleError((error, stackTrace) {
        if (remaining > 0) {
          return Future.delayed(retryDelay)
              .asStream()
              .asyncExpand((_) => retryStream(remaining - 1));
        }
        return Stream<T>.error(error, stackTrace);
      });
    }

    return retryStream(retryCount);
  }

  /// 创建带超时的Stream
  ///
  /// [stream] 源Stream
  /// [timeout] 超时时间
  /// [onTimeout] 超时回调
  /// 返回带超时的Stream
  static Stream<T> withTimeout<T>(
    Stream<T> stream,
    Duration timeout, {
    void Function(EventSink<T>)? onTimeout,
  }) {
    return stream.timeout(timeout, onTimeout: onTimeout);
  }

  /// 创建带缓存的Stream
  ///
  /// [stream] 源Stream
  /// [bufferSize] 缓冲区大小
  /// [refCount] 是否使用引用计数
  /// 返回带缓存的Stream
  static Stream<T> withCache<T>(
    Stream<T> stream, {
    int bufferSize = 1,
    bool refCount = true,
  }) {
    return stream.shareReplayValue(bufferSize: bufferSize, refCount: refCount);
  }

  /// 创建带防抖的Stream
  ///
  /// [stream] 源Stream
  /// [duration] 防抖时间
  /// 返回带防抖的Stream
  static Stream<T> withDebounce<T>(
    Stream<T> stream,
    Duration duration,
  ) {
    return stream.debounce((_) => TimerStream<T>(_, duration));
  }

  /// 创建带节流的Stream
  ///
  /// [stream] 源Stream
  /// [duration] 节流时间
  /// 返回带节流的Stream
  static Stream<T> withThrottle<T>(
    Stream<T> stream,
    Duration duration,
  ) {
    return stream.throttle((_) => TimerStream<T>(_, duration));
  }

  /// 创建带去重的Stream
  ///
  /// [stream] 源Stream
  /// [equals] 相等性比较函数
  /// 返回带去重的Stream
  static Stream<T> withDistinct<T>(
    Stream<T> stream, {
    bool Function(T, T)? equals,
  }) {
    T? lastValue;
    return stream.where((value) {
      if (lastValue == null) {
        lastValue = value;
        return true;
      }
      final isEqual =
          equals != null ? equals(lastValue!, value) : lastValue == value;
      if (!isEqual) {
        lastValue = value;
        return true;
      }
      return false;
    });
  }

  /// 创建带延迟的Stream
  ///
  /// [stream] 源Stream
  /// [duration] 延迟时间
  /// 返回带延迟的Stream
  static Stream<T> withDelay<T>(
    Stream<T> stream,
    Duration duration,
  ) {
    return stream.delayTime(duration);
  }

  /// 创建带采样的Stream
  ///
  /// [stream] 源Stream
  /// [sampler] 采样Stream
  /// 返回带采样的Stream
  static Stream<T> withSample<T>(
    Stream<T> stream,
    Stream<void> sampler,
  ) {
    return stream.sampleWith(sampler);
  }

  /// 创建带缓冲的Stream
  ///
  /// [stream] 源Stream
  /// [bufferStream] 缓冲触发Stream
  /// 返回带缓冲的Stream
  static Stream<List<T>> withBuffer<T>(
    Stream<T> stream,
    Stream<void> bufferStream,
  ) {
    return stream.bufferWith(bufferStream);
  }

  /// 创建带窗口的Stream
  ///
  /// [stream] 源Stream
  /// [windowStream] 窗口触发Stream
  /// 返回带窗口的Stream
  static Stream<Stream<T>> withWindow<T>(
    Stream<T> stream,
    Stream<void> windowStream,
  ) {
    return stream.windowWith(windowStream);
  }

  /// 创建带扫描的Stream
  ///
  /// [stream] 源Stream
  /// [accumulator] 累积函数
  /// [seed] 初始值
  /// 返回带扫描的Stream
  static Stream<R> withScan<T, R>(
    Stream<T> stream,
    R Function(R, T) accumulator,
    R seed,
  ) {
    return stream.scanValue(accumulator, seed);
  }

  /// 创建带分组的Stream
  ///
  /// [stream] 源Stream
  /// [keySelector] 键选择函数
  /// 返回带分组的Stream
  static Stream<GroupedStream<K, T>> withGroupBy<K, T>(
    Stream<T> stream,
    K Function(T) keySelector,
  ) {
    return stream.groupByValue(keySelector);
  }

  /// 创建带切换的Stream
  ///
  /// [stream] 源Stream
  /// [mapper] 映射函数
  /// 返回带切换的Stream
  static Stream<R> withSwitchMap<T, R>(
    Stream<T> stream,
    Stream<R> Function(T) mapper,
  ) {
    return stream.switchMapValue(mapper);
  }

  /// 创建带扁平化的Stream
  ///
  /// [stream] 源Stream
  /// [mapper] 映射函数
  /// 返回带扁平化的Stream
  static Stream<R> withFlatMap<T, R>(
    Stream<T> stream,
    Stream<R> Function(T) mapper,
  ) {
    return stream.flatMapValue(mapper);
  }

  /// 创建带组合的Stream
  ///
  /// [stream1] 第一个Stream
  /// [stream2] 第二个Stream
  /// [combiner] 组合函数
  /// 返回带组合的Stream
  static Stream<R> withCombine<T, U, R>(
    Stream<T> stream1,
    Stream<U> stream2,
    R Function(T, U) combiner,
  ) {
    return stream1.combineWith(stream2, combiner);
  }

  /// 创建带合并的Stream
  ///
  /// [stream1] 第一个Stream
  /// [stream2] 第二个Stream
  /// 返回带合并的Stream
  static Stream<T> withMerge<T>(
    Stream<T> stream1,
    Stream<T> stream2,
  ) {
    return Rx.merge([stream1, stream2]);
  }

  /// 创建带连接的Stream
  ///
  /// [stream1] 第一个Stream
  /// [stream2] 第二个Stream
  /// 返回带连接的Stream
  static Stream<T> withConcat<T>(
    Stream<T> stream1,
    Stream<T> stream2,
  ) {
    return stream1.concatWithStream(stream2);
  }
}
