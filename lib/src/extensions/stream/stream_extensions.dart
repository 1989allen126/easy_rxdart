import 'dart:async';
import 'package:rxdart/rxdart.dart';

/// Stream事件类型
class StreamEvent<T> {
  final T? value;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isData;
  final bool isError;
  final bool isDone;

  StreamEvent._({
    this.value,
    this.error,
    this.stackTrace,
    required this.isData,
    required this.isError,
    required this.isDone,
  });

  /// 创建数据事件
  factory StreamEvent.data(T value) {
    return StreamEvent._(
      value: value,
      isData: true,
      isError: false,
      isDone: false,
    );
  }

  /// 创建错误事件
  factory StreamEvent.error(Object error, StackTrace? stackTrace) {
    return StreamEvent._(
      error: error,
      stackTrace: stackTrace,
      isData: false,
      isError: true,
      isDone: false,
    );
  }

  /// 创建完成事件
  factory StreamEvent.done() {
    return StreamEvent._(
      isData: false,
      isError: false,
      isDone: true,
    );
  }
}

/// Stream扩展操作符
extension StreamExtensions<T> on Stream<T> {
  /// 防抖操作符
  ///
  /// 在指定时间内，只发出最后一个值
  ///
  /// [duration] 防抖时间间隔
  /// 返回防抖后的Stream
  Stream<T> debounceTime(Duration duration) {
    return debounce((_) => TimerStream<T>(_, duration));
  }

  /// 节流操作符
  ///
  /// 在指定时间内，只发出第一个值
  ///
  /// [duration] 节流时间间隔
  /// 返回节流后的Stream
  Stream<T> throttleTime(Duration duration) {
    return throttle((_) => TimerStream<T>(_, duration));
  }

  /// 去重操作符
  ///
  /// 过滤掉连续重复的值（使用==比较）
  ///
  /// 返回去重后的Stream
  Stream<T> distinctUntilChanged() {
    T? lastValue;
    return where((value) {
      if (lastValue == null) {
        lastValue = value;
        return true;
      }
      final isEqual = lastValue == value;
      if (!isEqual) {
        lastValue = value;
        return true;
      }
      return false;
    });
  }

  /// 去重操作符（带自定义比较函数）
  ///
  /// 过滤掉连续重复的值
  ///
  /// [equals] 相等性比较函数
  /// 返回去重后的Stream
  Stream<T> distinctUntilChangedBy(bool Function(T, T) equals) {
    T? lastValue;
    return where((value) {
      if (lastValue == null) {
        lastValue = value;
        return true;
      }
      final isEqual = equals(lastValue!, value);
      if (!isEqual) {
        lastValue = value;
        return true;
      }
      return false;
    });
  }

  /// 延迟操作符
  ///
  /// 延迟发出所有值
  ///
  /// [duration] 延迟时间
  /// 返回延迟后的Stream
  Stream<T> delayTime(Duration duration) {
    return delay(duration);
  }

  /// 超时操作符
  ///
  /// 如果Stream在指定时间内没有发出值，则抛出超时异常
  ///
  /// [duration] 超时时间
  /// [onTimeout] 超时时的回调函数
  /// 返回带超时的Stream
  Stream<T> timeoutTime(
    Duration duration, {
    void Function(EventSink<T>)? onTimeout,
  }) {
    return timeout(duration, onTimeout: onTimeout);
  }

  /// 重试操作符
  ///
  /// 当Stream发生错误时，自动重试指定次数
  ///
  /// [count] 重试次数
  /// [delay] 重试延迟时间
  /// 返回带重试的Stream
  Stream<T> retryWithDelay({
    int count = 3,
    Duration delay = const Duration(seconds: 1),
  }) {
    Stream<T> retryStream(Stream<T> source, int remaining) {
      return source.handleError((error, stackTrace) {
        if (remaining > 0) {
          return Future.delayed(delay)
              .asStream()
              .asyncExpand((_) => retryStream(this, remaining - 1));
        }
        return Stream<T>.error(error, stackTrace);
      });
    }
    return retryStream(this, count);
  }

  /// 缓存最后一个值
  ///
  /// 缓存Stream发出的最后一个值，新订阅者可以立即获得该值
  ///
  /// [bufferSize] 缓冲区大小
  /// [refCount] 是否使用引用计数（暂不支持）
  /// 返回带缓存的Stream
  Stream<T> shareReplayValue({int bufferSize = 1, bool refCount = true}) {
    return this.shareReplay();
  }

  /// 条件过滤
  ///
  /// 根据条件过滤值
  ///
  /// [condition] 过滤条件函数
  /// 返回过滤后的Stream
  Stream<T> whereIf(bool Function(T) condition) {
    return where(condition);
  }

  /// 安全映射
  ///
  /// 映射值，如果映射函数返回null则跳过该值
  ///
  /// [mapper] 映射函数
  /// 返回映射后的Stream
  Stream<R> mapNotNull<R>(R? Function(T) mapper) {
    return map(mapper).where((value) => value != null).cast<R>();
  }

  /// 异步映射
  ///
  /// 异步映射值
  ///
  /// [mapper] 异步映射函数
  /// 返回异步映射后的Stream
  Stream<R> flatMapValue<R>(Stream<R> Function(T) mapper) {
    return flatMap(mapper);
  }

  /// 合并多个Stream
  ///
  /// 将当前Stream与另一个Stream合并
  ///
  /// [other] 要合并的Stream
  /// 返回合并后的Stream
  Stream<T> mergeWith(Stream<T> other) {
    return Rx.merge([this, other]);
  }

  /// 连接多个Stream
  ///
  /// 将当前Stream与另一个Stream连接
  ///
  /// [other] 要连接的Stream
  /// 返回连接后的Stream
  Stream<T> concatWithStream(Stream<T> other) {
    return Rx.concat([this, other]);
  }

  /// 切换到另一个Stream
  ///
  /// 当源Stream发出值时，切换到另一个Stream
  ///
  /// [mapper] 返回新Stream的函数
  /// 返回切换后的Stream
  Stream<R> switchMapValue<R>(Stream<R> Function(T) mapper) {
    return switchMap(mapper);
  }

  /// 组合值
  ///
  /// 将当前Stream与另一个Stream的值组合
  ///
  /// [other] 要组合的Stream
  /// [combiner] 组合函数
  /// 返回组合后的Stream
  Stream<R> combineWith<U, R>(
    Stream<U> other,
    R Function(T, U) combiner,
  ) {
    return Rx.combineLatest2(this, other, combiner);
  }

  /// 压缩值
  ///
  /// 将当前Stream与另一个Stream的值压缩
  ///
  /// [other] 要压缩的Stream
  /// [combiner] 压缩函数
  /// 返回压缩后的Stream
  Stream<R> zipWith<U, R>(
    Stream<U> other,
    R Function(T, U) combiner,
  ) {
    return Rx.zip2(this, other, combiner);
  }

  /// 连接值（concatWith的别名，与concatWithStream保持一致）
  ///
  /// 将当前Stream与另一个Stream连接（按顺序执行）
  ///
  /// [other] 要连接的Stream
  /// 返回连接后的Stream
  Stream<T> concatWith(Stream<T> other) {
    return concatWithStream(other);
  }

  /// 采样操作符
  ///
  /// 根据另一个Stream的发出时机采样当前Stream的值
  ///
  /// [sampler] 采样Stream
  /// 返回采样后的Stream
  Stream<T> sampleWith(Stream<void> sampler) {
    return sample(sampler);
  }

  /// 缓冲操作符
  ///
  /// 将值缓冲到列表中，当满足条件时发出
  ///
  /// [bufferStream] 触发缓冲的Stream
  /// 返回缓冲后的Stream
  Stream<List<T>> bufferWith(Stream<void> bufferStream) {
    return buffer(bufferStream);
  }

  /// 窗口操作符
  ///
  /// 将值分组到窗口中
  ///
  /// [windowStream] 触发窗口的Stream
  /// 返回窗口化的Stream
  Stream<Stream<T>> windowWith(Stream<void> windowStream) {
    return window(windowStream);
  }

  /// 分组操作符
  ///
  /// 根据键函数将值分组
  ///
  /// [keySelector] 键选择函数
  /// 返回分组后的Stream
  Stream<GroupedStream<K, T>> groupByValue<K>(K Function(T) keySelector) {
    return this.groupBy(keySelector).map((group) => group as GroupedStream<K, T>);
  }

  /// 扫描操作符
  ///
  /// 累积值并发出每个中间结果
  ///
  /// [accumulator] 累积函数
  /// [seed] 初始值
  /// 返回扫描后的Stream
  Stream<R> scanValue<R>(R Function(R, T) accumulator, R seed) {
    R current = seed;
    return map((value) {
      current = accumulator(current, value);
      return current;
    });
  }

  /// 开始和结束配对
  ///
  /// 将开始事件和结束事件配对
  ///
  /// [startMapper] 开始事件映射函数
  /// [endMapper] 结束事件映射函数
  /// 返回配对后的Stream
  Stream<R> pairWith<R>(
    Stream<R> Function(T) startMapper,
    Stream<R> Function(T) endMapper,
  ) {
    return flatMap((value) {
      return startMapper(value)
          .takeUntil(endMapper(value))
          .concatWithStream(endMapper(value).take(1));
    });
  }

  /// 在流开始前添加初始值
  ///
  /// [value] 要添加的初始值
  /// 返回添加初始值后的Stream
  Stream<T> startWith(T value) {
    return Rx.concat([Stream.value(value), this]);
  }

  /// 在流结束时添加值
  ///
  /// [value] 要添加的结束值
  /// 返回添加结束值后的Stream
  Stream<T> endWith(T value) {
    return Rx.concat([this, Stream.value(value)]);
  }

  /// 跳过直到某个条件
  ///
  /// [trigger] 触发开始接收的Stream
  /// 返回跳过后的Stream
  Stream<T> skipUntil(Stream<void> trigger) {
    bool started = false;
    return trigger.take(1).asyncExpand((_) {
      started = true;
      return Stream<T>.empty();
    }).concatWithStream(this.skipWhile((_) => !started));
  }

  /// 错误时切换到另一个流
  ///
  /// [resumeStream] 错误时切换到的Stream
  /// 返回错误恢复后的Stream
  Stream<T> onErrorResumeNext(Stream<T> resumeStream) {
    return handleError((error, stackTrace) {
      // 忽略错误，切换到resumeStream
    }).concatWithStream(resumeStream);
  }

  /// 错误时返回默认值
  ///
  /// [defaultValue] 默认值
  /// 返回错误恢复后的Stream
  Stream<T> onErrorReturn(T defaultValue) {
    return handleError((error, stackTrace) {
      return Stream.value(defaultValue);
    });
  }

  /// 错误时返回指定值
  ///
  /// [fallbackValue] 指定值
  /// 返回错误恢复后的Stream
  Stream<T> onErrorReturnItem(T fallbackValue) {
    return onErrorReturn(fallbackValue);
  }

  /// 将事件包装为StreamEvent
  ///
  /// 返回包装后的Stream
  Stream<StreamEvent<T>> materialize() {
    final controller = StreamController<StreamEvent<T>>();
    listen(
      (value) {
        controller.add(StreamEvent<T>.data(value));
      },
      onError: (error, stackTrace) {
        controller.add(StreamEvent<T>.error(error, stackTrace));
      },
      onDone: () {
        controller.add(StreamEvent<T>.done());
        controller.close();
      },
    );
    return controller.stream;
  }

  /// 将StreamEvent解包为事件
  ///
  /// 返回解包后的Stream
  /// 注意：此方法应在Stream<StreamEvent<T>>上调用
  Stream<R> dematerialize<R>() {
    final controller = StreamController<R>();
    listen(
      (event) {
        if (event is StreamEvent<R>) {
          if (event.isData && event.value != null) {
            controller.add(event.value!);
          } else if (event.isError && event.error != null) {
            controller.addError(event.error!, event.stackTrace);
          } else if (event.isDone) {
            controller.close();
          }
        }
      },
      onError: (error, stackTrace) {
        controller.addError(error, stackTrace);
      },
      onDone: () {
        controller.close();
      },
    );
    return controller.stream;
  }

  /// 按数量缓冲
  ///
  /// [count] 缓冲数量
  /// [startBufferEvery] 每次开始缓冲的数量（可选）
  /// 返回缓冲后的Stream
  Stream<List<T>> bufferCount(int count, [int? startBufferEvery]) {
    final controller = StreamController<List<T>>();
    List<T> buffer = [];

    listen(
      (value) {
        buffer.add(value);
        if (buffer.length >= count) {
          controller.add(List<T>.from(buffer));
          if (startBufferEvery != null && startBufferEvery != count) {
            buffer = buffer.sublist(startBufferEvery);
          } else {
            buffer.clear();
          }
        }
      },
      onError: (error, stackTrace) {
        if (buffer.isNotEmpty) {
          controller.add(List<T>.from(buffer));
        }
        controller.addError(error, stackTrace);
      },
      onDone: () {
        if (buffer.isNotEmpty) {
          controller.add(List<T>.from(buffer));
        }
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 按时间缓冲
  ///
  /// [duration] 缓冲时间
  /// [maxBufferSize] 最大缓冲数量（可选）
  /// 返回缓冲后的Stream
  Stream<List<T>> bufferTime(
    Duration duration, {
    int? maxBufferSize,
  }) {
    final controller = StreamController<List<T>>();
    List<T> buffer = [];
    Timer? timer;

    void emitBuffer() {
      if (buffer.isNotEmpty) {
        controller.add(List<T>.from(buffer));
        buffer.clear();
      }
    }

    listen(
      (value) {
        buffer.add(value);
        if (maxBufferSize != null && buffer.length >= maxBufferSize) {
          emitBuffer();
        } else {
          timer?.cancel();
          timer = Timer(duration, emitBuffer);
        }
      },
      onError: (error, stackTrace) {
        timer?.cancel();
        emitBuffer();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        timer?.cancel();
        emitBuffer();
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 按数量窗口
  ///
  /// [count] 窗口数量
  /// [startWindowEvery] 每次开始窗口的数量（可选）
  /// 返回窗口化后的Stream
  Stream<Stream<T>> windowCount(int count, [int? startWindowEvery]) {
    final controller = StreamController<Stream<T>>();
    StreamController<T>? windowController;
    int windowCount = 0;
    int skipCount = 0;

    void closeWindow() {
      if (windowController != null) {
        windowController!.close();
        windowController = null;
        windowCount = 0;
      }
    }

    void openWindow() {
      closeWindow();
      windowController = StreamController<T>();
      controller.add(windowController!.stream);
    }

    listen(
      (value) {
        if (windowController == null || windowCount >= count) {
          if (startWindowEvery != null && startWindowEvery != count) {
            if (skipCount >= startWindowEvery) {
              openWindow();
              skipCount = 0;
            } else {
              skipCount++;
            }
          } else {
            openWindow();
          }
        }
        if (windowController != null) {
          windowController!.add(value);
          windowCount++;
        }
      },
      onError: (error, stackTrace) {
        closeWindow();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        closeWindow();
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 按时间窗口
  ///
  /// [duration] 窗口时间
  /// 返回窗口化后的Stream
  Stream<Stream<T>> windowTime(Duration duration) {
    final controller = StreamController<Stream<T>>();
    StreamController<T>? windowController;
    Timer? timer;

    void closeWindow() {
      if (windowController != null) {
        windowController!.close();
        windowController = null;
      }
      timer?.cancel();
    }

    void openWindow() {
      closeWindow();
      windowController = StreamController<T>();
      controller.add(windowController!.stream);
      timer = Timer(duration, closeWindow);
    }

    listen(
      (value) {
        if (windowController == null) {
          openWindow();
        }
        windowController!.add(value);
      },
      onError: (error, stackTrace) {
        closeWindow();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        closeWindow();
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 审计时间操作符
  ///
  /// 在指定时间内，只发出最后一个值
  ///
  /// [duration] 审计时间间隔
  /// 返回审计后的Stream
  Stream<T> auditTime(Duration duration) {
    T? lastValue;
    Timer? timer;
    final controller = StreamController<T>();

    listen(
      (value) {
        lastValue = value;
        timer?.cancel();
        timer = Timer(duration, () {
          if (lastValue != null) {
            controller.add(lastValue!);
            lastValue = null;
          }
        });
      },
      onError: (error, stackTrace) {
        timer?.cancel();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        timer?.cancel();
        if (lastValue != null) {
          controller.add(lastValue!);
        }
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 按时间采样
  ///
  /// [duration] 采样时间间隔
  /// 返回采样后的Stream
  Stream<T> sampleTime(Duration duration) {
    T? lastValue;
    Timer? timer;
    final controller = StreamController<T>();

    timer = Timer.periodic(duration, (_) {
      if (lastValue != null) {
        controller.add(lastValue!);
      }
    });

    listen(
      (value) {
        lastValue = value;
      },
      onError: (error, stackTrace) {
        timer?.cancel();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        timer?.cancel();
        if (lastValue != null) {
          controller.add(lastValue!);
        }
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 耗尽映射
  ///
  /// 忽略新值直到当前映射完成
  ///
  /// [mapper] 映射函数
  /// 返回耗尽映射后的Stream
  Stream<R> exhaustMap<R>(Stream<R> Function(T) mapper) {
    bool isProcessing = false;
    final controller = StreamController<R>();

    listen(
      (value) {
        if (!isProcessing) {
          isProcessing = true;
          final mappedStream = mapper(value);
          mappedStream.listen(
            (mappedValue) {
              controller.add(mappedValue);
            },
            onError: (error, stackTrace) {
              controller.addError(error, stackTrace);
            },
            onDone: () {
              isProcessing = false;
            },
          );
        }
      },
      onError: (error, stackTrace) {
        controller.addError(error, stackTrace);
      },
      onDone: () {
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 与另一个流的最新值组合
  ///
  /// [other] 另一个Stream
  /// [combiner] 组合函数
  /// 返回组合后的Stream
  Stream<R> withLatestFrom<U, R>(
    Stream<U> other,
    R Function(T, U) combiner,
  ) {
    U? latestOther;
    StreamSubscription<U>? otherSubscription;
    final controller = StreamController<R>();

    otherSubscription = other.listen(
      (value) {
        latestOther = value;
      },
    );

    listen(
      (value) {
        if (latestOther != null) {
          controller.add(combiner(value, latestOther!));
        }
      },
      onError: (error, stackTrace) {
        otherSubscription?.cancel();
        controller.addError(error, stackTrace);
      },
      onDone: () {
        otherSubscription?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 如果为空则返回默认值
  ///
  /// [defaultValue] 默认值
  /// 返回带默认值的Stream
  Stream<T> defaultIfEmpty(T defaultValue) {
    bool hasValue = false;
    final controller = StreamController<T>();

    listen(
      (value) {
        hasValue = true;
        controller.add(value);
      },
      onError: (error, stackTrace) {
        controller.addError(error, stackTrace);
      },
      onDone: () {
        if (!hasValue) {
          controller.add(defaultValue);
        }
        controller.close();
      },
    );

    return controller.stream;
  }

  /// 检查是否为空
  ///
  /// 返回检查结果的Future
  Future<bool> isEmpty() {
    return first.then((_) => false, onError: (_) => true);
  }

  /// 检查是否不为空
  ///
  /// 返回检查结果的Future
  Future<bool> isNotEmpty() {
    return isEmpty().then((empty) => !empty);
  }
}
