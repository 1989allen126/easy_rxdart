import 'dart:async';

import '../../core/easy_subject.dart';
import '../../core/reactive.dart';

/// Iterable扩展
extension IterableExtensions<T> on Iterable<T> {
  /// 转换为Stream
  ///
  /// 返回Stream<T>
  Stream<T> toStream() {
    return Stream.fromIterable(this);
  }

  /// 转换为EasyBehaviorSubject
  ///
  /// 返回EasyBehaviorSubject<T>
  EasyBehaviorSubject<T> toBehaviorSubject() {
    final subject = EasyBehaviorSubject<T>();
    for (final item in this) {
      subject.add(item);
    }
    return subject;
  }

  /// 转换为EasyReplaySubject
  ///
  /// 返回EasyReplaySubject<T>
  EasyReplaySubject<T> toReplaySubject() {
    final subject = EasyReplaySubject<T>();
    for (final item in this) {
      subject.add(item);
    }
    return subject;
  }

  /// 跳过前N个元素
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数
  /// 返回跳过后的Iterable
  Iterable<T> skipFirstN(int count, [bool Function(T)? predicate]) {
    if (count <= 0) {
      return this;
    }
    if (predicate != null) {
      int skippedCount = 0;
      return where((element) {
        if (skippedCount < count && predicate(element)) {
          skippedCount++;
          return false;
        }
        return true;
      });
    }
    return skip(count);
  }

  /// 跳过后N个元素
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数
  /// 返回跳过后的Iterable
  Iterable<T> skipLastN(int count, [bool Function(T)? predicate]) {
    if (count <= 0) {
      return this;
    }
    final list = toList();
    if (predicate != null) {
      // 从后往前找到满足条件的N个元素
      final indicesToSkip = <int>[];
      for (int i = list.length - 1;
          i >= 0 && indicesToSkip.length < count;
          i--) {
        if (predicate(list[i])) {
          indicesToSkip.add(i);
        }
      }
      return list
          .where((element) => !indicesToSkip.contains(list.indexOf(element)));
    }
    if (count >= list.length) {
      return <T>[];
    }
    return list.sublist(0, list.length - count);
  }

  /// 跳过第一个元素
  ///
  /// [predicate] 可选的过滤条件函数
  /// 返回跳过第一个元素后的Iterable
  Iterable<T> skipFirst([bool Function(T)? predicate]) {
    if (predicate != null) {
      bool skipped = false;
      return where((element) {
        if (!skipped && predicate(element)) {
          skipped = true;
          return false;
        }
        return true;
      });
    }
    return skip(1);
  }

  /// 跳过最后一个元素
  ///
  /// [predicate] 可选的过滤条件函数
  /// 返回跳过最后一个元素后的Iterable
  Iterable<T> skipLast([bool Function(T)? predicate]) {
    final list = toList();
    if (predicate != null) {
      // 从后往前找到第一个满足条件的元素
      for (int i = list.length - 1; i >= 0; i--) {
        if (predicate(list[i])) {
          return list.where((element) => list.indexOf(element) != i);
        }
      }
      return this;
    }
    if (list.isEmpty) {
      return <T>[];
    }
    return list.sublist(0, list.length - 1);
  }

  /// 过滤元素
  ///
  /// [predicate] 过滤条件函数
  /// 返回过滤后的Iterable
  Iterable<T> filter(bool Function(T) predicate) {
    return where(predicate);
  }

  /// 紧凑映射（过滤null值）
  ///
  /// [mapper] 映射函数，返回可空类型
  /// 返回过滤null后的Iterable
  Iterable<R> compactMap<R>(R? Function(T) mapper) {
    return map(mapper).where((value) => value != null).cast<R>();
  }

  /// 扁平映射
  ///
  /// [mapper] 映射函数，返回Iterable
  /// 返回扁平化后的Iterable
  Iterable<R> flatMap<R>(Iterable<R> Function(T) mapper) {
    return expand(mapper);
  }

  /// 归约操作
  ///
  /// [initialValue] 初始值
  /// [combine] 归约函数
  /// 返回归约结果
  R reduceValue<R>(R initialValue, R Function(R, T) combine) {
    return fold(initialValue, combine);
  }

  /// 遍历元素（forEach）
  ///
  /// [action] 对每个元素执行的操作
  void forEachValue(void Function(T) action) {
    forEach(action);
  }

  /// 遍历元素（带索引）
  ///
  /// [action] 对每个元素执行的操作，参数为索引和元素
  void forEachIndexed(void Function(int, T) action) {
    int index = 0;
    for (final element in this) {
      action(index++, element);
    }
  }

  /// 检查所有元素是否满足条件（every）
  ///
  /// [test] 测试条件函数
  /// 返回是否所有元素都满足条件
  bool everyValue(bool Function(T) test) {
    return every(test);
  }

  /// 检查是否有元素满足条件（any）
  ///
  /// [test] 测试条件函数
  /// 返回是否有元素满足条件
  bool anyValue(bool Function(T) test) {
    return any(test);
  }

  /// 检查是否包含元素
  ///
  /// [element] 要检查的元素
  /// 返回是否包含该元素
  bool containsValue(T element) {
    return contains(element);
  }

  /// 查找第一个满足条件的元素
  ///
  /// [test] 测试条件函数
  /// 返回第一个满足条件的元素，如果没有则返回null
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 查找最后一个满足条件的元素
  ///
  /// [test] 测试条件函数
  /// 返回最后一个满足条件的元素，如果没有则返回null
  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 查找满足条件的元素索引
  ///
  /// [test] 测试条件函数
  /// [start] 起始索引
  /// 返回第一个满足条件的元素索引，如果没有则返回-1
  int indexWhereValue(bool Function(T) test, [int start = 0]) {
    final list = toList();
    if (start >= list.length) {
      return -1;
    }
    for (int i = start; i < list.length; i++) {
      if (test(list[i])) {
        return i;
      }
    }
    return -1;
  }

  /// 查找最后一个满足条件的元素索引
  ///
  /// [test] 测试条件函数
  /// [start] 起始索引
  /// 返回最后一个满足条件的元素索引，如果没有则返回-1
  int lastIndexWhereValue(bool Function(T) test, [int? start]) {
    final list = toList();
    final end = start ?? list.length - 1;
    if (end < 0 || end >= list.length) {
      return -1;
    }
    for (int i = end; i >= 0; i--) {
      if (test(list[i])) {
        return i;
      }
    }
    return -1;
  }

  /// 查找元素索引
  ///
  /// [element] 要查找的元素
  /// [start] 起始索引
  /// 返回元素索引，如果没有则返回-1
  int indexOfValue(T element, [int start = 0]) {
    return indexWhereValue((e) => e == element, start);
  }

  /// 查找最后一个元素索引
  ///
  /// [element] 要查找的元素
  /// [start] 起始索引
  /// 返回最后一个元素索引，如果没有则返回-1
  int lastIndexOfValue(T element, [int? start]) {
    return lastIndexWhereValue((e) => e == element, start);
  }

  /// 统计满足条件的元素数量
  ///
  /// [test] 测试条件函数
  /// 返回满足条件的元素数量
  int count(bool Function(T) test) {
    return where(test).length;
  }

  /// 分组操作
  ///
  /// [keySelector] 键选择函数
  /// 返回分组后的Map
  Map<K, List<T>> groupByKey<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => <T>[]).add(element);
    }
    return map;
  }

  /// 分组并转换值
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map
  Map<K, List<V>> groupByKeyAndValue<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    final map = <K, List<V>>{};
    for (final element in this) {
      final key = keySelector(element);
      final value = valueSelector(element);
      map.putIfAbsent(key, () => <V>[]).add(value);
    }
    return map;
  }

  /// 转换为Reactive
  ///
  /// 返回Reactive<T>
  Reactive<T> toReactive() {
    return Reactive.fromIterable(this);
  }

  /// 去重操作
  ///
  /// [equals] 可选的相等性比较函数，如果不提供则使用默认的相等性比较
  /// 返回去重后的Iterable
  Iterable<T> distinct([bool Function(T, T)? equals]) {
    final seen = <T>{};
    if (equals != null) {
      // 使用自定义比较函数
      final seenList = <T>[];
      return where((element) {
        for (final seenElement in seenList) {
          if (equals(seenElement, element)) {
            return false;
          }
        }
        seenList.add(element);
        return true;
      });
    } else {
      // 使用默认的相等性比较
      return where((element) => seen.add(element));
    }
  }

  /// 去重操作（基于键）
  ///
  /// [keySelector] 键选择函数，用于提取比较的键
  /// 返回去重后的Iterable（保留第一个出现的元素）
  Iterable<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((element) {
      final key = keySelector(element);
      return seen.add(key);
    });
  }

  /// 订阅到Stream
  ///
  /// [onData] 数据回调函数
  /// [onError] 错误回调函数
  /// [onDone] 完成回调函数
  /// [cancelOnError] 是否在错误时取消订阅
  /// 返回StreamSubscription
  StreamSubscription<T> subscribe({
    required void Function(T) onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return toStream().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 订阅到Reactive
  ///
  /// [onData] 数据回调函数
  /// [onError] 错误回调函数
  /// [onDone] 完成回调函数
  /// [cancelOnError] 是否在错误时取消订阅
  /// 返回StreamSubscription
  StreamSubscription<T> subscribeReactive({
    required void Function(T) onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return toReactive().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 订阅并执行操作
  ///
  /// [action] 对每个元素执行的操作
  /// 返回StreamSubscription
  StreamSubscription<T> subscribeAction(void Function(T) action) {
    return subscribe(onData: action);
  }

  /// 订阅并收集结果
  ///
  /// [collector] 收集器函数，用于收集元素
  /// 返回StreamSubscription
  StreamSubscription<T> subscribeCollect<R>(
    R Function(R, T) collector,
    R initialValue,
  ) {
    R result = initialValue;
    return subscribe(
      onData: (data) {
        result = collector(result, data);
      },
    );
  }

  /// 订阅并转换为列表
  ///
  /// [mapper] 可选的映射函数
  /// 返回包含所有元素的列表的Future
  Future<List<R>> subscribeToList<R>(R Function(T)? mapper) async {
    final list = <R>[];
    if (mapper != null) {
      await subscribe(onData: (data) => list.add(mapper(data)));
    } else {
      await subscribe(onData: (data) => list.add(data as R));
    }
    return list;
  }

  /// 订阅并转换为Map
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回包含所有元素的Map的Future
  Future<Map<K, V>> subscribeToMap<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) async {
    final map = <K, V>{};
    await subscribe(onData: (data) {
      final key = keySelector(data);
      final value = valueSelector(data);
      map[key] = value;
    });
    return map;
  }

  /// 订阅并等待完成
  ///
  /// [onData] 数据回调函数
  /// [onError] 错误回调函数
  /// 返回Future，在完成时resolve
  Future<void> subscribeAwait({
    required void Function(T) onData,
    Function? onError,
  }) async {
    final completer = Completer<void>();
    subscribe(
      onData: onData,
      onError: onError ??
          (error, stackTrace) {
            if (!completer.isCompleted) {
              completer.completeError(error, stackTrace);
            }
          },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );
    return completer.future;
  }
}
