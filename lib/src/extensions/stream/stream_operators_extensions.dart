import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// Stream常用操作符扩展
extension StreamOperatorsExtensions<T> on Stream<T> {
  /// 过滤操作符（别名where）
  ///
  /// [predicate] 过滤条件函数
  /// 返回过滤后的Stream
  Stream<T> filter(bool Function(T) predicate) {
    return where(predicate);
  }

  /// 紧凑映射（过滤null值）
  ///
  /// [mapper] 映射函数，返回可空类型
  /// 返回过滤null后的Stream
  Stream<R> compactMap<R>(R? Function(T) mapper) {
    return map(mapper).where((value) => value != null).cast<R>();
  }

  /// 扁平映射
  ///
  /// [mapper] 映射函数，返回Stream
  /// 返回扁平化后的Stream
  Stream<R> flatMapValue<R>(Stream<R> Function(T) mapper) {
    return flatMap(mapper);
  }

  /// 归约操作
  ///
  /// [initialValue] 初始值
  /// [combine] 归约函数
  /// 返回归约结果的Future
  Future<R> reduceValue<R>(
    R initialValue,
    R Function(R, T) combine,
  ) {
    return fold(initialValue, combine);
  }

  /// 合并多个Stream
  ///
  /// [other] 要合并的Stream
  /// 返回合并后的Stream
  Stream<T> mergeWith(Stream<T> other) {
    return Rx.merge([this, other]);
  }

  /// 分割Stream
  ///
  /// [predicate] 分割条件函数
  /// 返回分割后的Stream列表
  Stream<List<T>> splitBy(bool Function(T) predicate) {
    List<T> currentList = [];
    return map((value) {
      if (predicate(value)) {
        final result = currentList.isEmpty ? null : List<T>.from(currentList);
        currentList.clear();
        return result;
      } else {
        currentList.add(value);
        return null;
      }
    })
        .where((list) => list != null)
        .cast<List<T>>()
        .asyncExpand((list) => Stream.value(list));
  }

  /// 获取第一个值
  ///
  /// [orElse] 如果没有值时的默认值
  /// 返回第一个值的Future
  Future<T> firstValue([T? orElse]) {
    if (orElse != null) {
      return first.then((value) => value, onError: (_) => orElse);
    }
    return first;
  }

  /// 获取最后一个值
  ///
  /// [orElse] 如果没有值时的默认值
  /// 返回最后一个值的Future
  Future<T> lastValue([T? orElse]) {
    if (orElse != null) {
      return last.then((value) => value, onError: (_) => orElse);
    }
    return last;
  }

  /// 分组操作
  ///
  /// [keySelector] 键选择函数
  /// 返回分组后的Map的Future
  Future<Map<K, List<T>>> groupByKey<K>(K Function(T) keySelector) {
    return fold<Map<K, List<T>>>(
      <K, List<T>>{},
      (map, value) {
        final key = keySelector(value);
        map.putIfAbsent(key, () => <T>[]).add(value);
        return map;
      },
    );
  }

  /// 分组并转换值
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map的Future
  Future<Map<K, List<V>>> groupByKeyAndValue<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return fold<Map<K, List<V>>>(
      <K, List<V>>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map.putIfAbsent(key, () => <V>[]).add(val);
        return map;
      },
    );
  }

  /// 去重操作
  ///
  /// [equals] 相等性比较函数
  /// 返回去重后的Stream
  Stream<T> distinctBy([bool Function(T, T)? equals]) {
    T? lastValue;
    return where((value) {
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

  /// 排序操作
  ///
  /// [compare] 比较函数
  /// 返回排序后的Stream
  Stream<T> sorted([int Function(T, T)? compare]) {
    return toList()
        .then((list) {
          if (compare != null) {
            list.sort(compare);
          } else {
            list.sort();
          }
          return Stream.fromIterable(list);
        })
        .asStream()
        .asyncExpand((stream) => stream);
  }

  /// 反转操作
  ///
  /// 返回反转后的Stream
  Stream<T> reversed() {
    return toList()
        .then((list) {
          return Stream.fromIterable(list.reversed);
        })
        .asStream()
        .asyncExpand((stream) => stream);
  }

  /// 分页操作
  ///
  /// [pageSize] 每页大小
  /// [page] 页码（从0开始）
  /// 返回分页后的Stream
  Stream<T> paginate(int pageSize, int page) {
    return toList()
        .then((list) {
          final start = page * pageSize;
          final end = (start + pageSize).clamp(0, list.length);
          return Stream.fromIterable(list.sublist(start, end));
        })
        .asStream()
        .asyncExpand((stream) => stream);
  }

  /// 限制数量
  ///
  /// [limit] 限制数量
  /// 返回限制后的Stream
  Stream<T> limitCount(int limit) {
    return take(limit);
  }

  /// 跳过数量
  ///
  /// [count] 跳过数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的值
  /// 返回跳过后的Stream
  Stream<T> skipCount(int count, [bool Function(T)? predicate]) {
    if (predicate != null) {
      return where((value) => !predicate(value) || count <= 0)
          .skip(count)
          .where((value) => !predicate(value));
    }
    return skip(count);
  }

  /// 跳过第一个值
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的第一个值
  /// 返回跳过第一个值后的Stream
  Stream<T> skipFirst([bool Function(T)? predicate]) {
    if (predicate != null) {
      bool skipped = false;
      return where((value) {
        if (!skipped && predicate(value)) {
          skipped = true;
          return false;
        }
        return true;
      });
    }
    return skip(1);
  }

  /// 跳过最后一个值
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的最后一个值
  /// 返回跳过最后一个值后的Stream
  Stream<T> skipLast([bool Function(T)? predicate]) {
    if (predicate != null) {
      return toList()
          .then((list) {
            if (list.isEmpty) {
              return Stream<T>.empty();
            }
            // 从后往前找到第一个满足条件的值
            int lastIndex = -1;
            for (int i = list.length - 1; i >= 0; i--) {
              if (predicate(list[i])) {
                lastIndex = i;
                break;
              }
            }
            if (lastIndex == -1) {
              return Stream.fromIterable(list);
            }
            return Stream.fromIterable(
              list.where((value) => list.indexOf(value) != lastIndex).toList(),
            );
          })
          .asStream()
          .asyncExpand((stream) => stream);
    }
    return toList()
        .then((list) {
          if (list.isEmpty) {
            return Stream<T>.empty();
          }
          return Stream.fromIterable(list.sublist(0, list.length - 1));
        })
        .asStream()
        .asyncExpand((stream) => stream);
  }

  /// 跳过前N个值
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的前N个值
  /// 返回跳过前N个值后的Stream
  Stream<T> skipFirstN(int count, [bool Function(T)? predicate]) {
    if (predicate != null) {
      int skippedCount = 0;
      return where((value) {
        if (skippedCount < count && predicate(value)) {
          skippedCount++;
          return false;
        }
        return true;
      });
    }
    return skip(count);
  }

  /// 跳过后N个值
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的后N个值
  /// 返回跳过后N个值后的Stream
  Stream<T> skipLastN(int count, [bool Function(T)? predicate]) {
    if (predicate != null) {
      return toList()
          .then((list) {
            if (list.isEmpty || count >= list.length) {
              return Stream<T>.empty();
            }
            // 从后往前找到满足条件的N个值
            final indicesToSkip = <int>[];
            for (int i = list.length - 1;
                i >= 0 && indicesToSkip.length < count;
                i--) {
              if (predicate(list[i])) {
                indicesToSkip.add(i);
              }
            }
            return Stream.fromIterable(
              list
                  .where(
                      (value) => !indicesToSkip.contains(list.indexOf(value)))
                  .toList(),
            );
          })
          .asStream()
          .asyncExpand((stream) => stream);
    }
    return toList()
        .then((list) {
          if (list.isEmpty || count >= list.length) {
            return Stream<T>.empty();
          }
          return Stream.fromIterable(list.sublist(0, list.length - count));
        })
        .asStream()
        .asyncExpand((stream) => stream);
  }

  /// 跳过满足条件的值
  ///
  /// [predicate] 跳过条件函数
  /// 返回跳过满足条件值后的Stream
  Stream<T> skipWhileValue(bool Function(T) predicate) {
    return skipWhile(predicate);
  }

  /// 跳过直到满足条件的值
  ///
  /// [predicate] 条件函数
  /// 返回跳过直到满足条件值后的Stream
  Stream<T> skipUntilValue(bool Function(T) predicate) {
    return skipWhile((value) => !predicate(value));
  }

  /// 连接操作
  ///
  /// [separator] 分隔符
  /// [mapper] 映射函数，将T转换为字符串
  /// 返回连接后的字符串的Future
  Future<String> joinValue(String separator, String Function(T) mapper) {
    return toList().then((list) => list.map(mapper).join(separator));
  }

  /// 统计操作
  ///
  /// 返回统计信息的Future
  Future<StreamStatistics<T>> statistics() {
    return toList().then((list) {
      if (list.isEmpty) {
        return StreamStatistics<T>(
          count: 0,
          isEmpty: true,
          isNotEmpty: false,
        );
      }
      return StreamStatistics<T>(
        count: list.length,
        isEmpty: false,
        isNotEmpty: true,
        first: list.first,
        last: list.last,
      );
    });
  }

  /// 扩展过滤操作（支持多个条件）
  ///
  /// [predicates] 过滤条件函数列表，使用OR逻辑（满足任一条件即为matched）
  /// 返回WhereExResult对象，可以调用asList()或asMap()获取分组结果
  WhereExResult<T> whereEx(List<bool Function(T)> predicates) {
    return WhereExResult<T>(this, predicates);
  }
}

/// Stream统计信息
class StreamStatistics<T> {
  /// 数量
  final int count;

  /// 是否为空
  final bool isEmpty;

  /// 是否不为空
  final bool isNotEmpty;

  /// 第一个值
  final T? first;

  /// 最后一个值
  final T? last;

  /// 构造函数
  StreamStatistics({
    required this.count,
    required this.isEmpty,
    required this.isNotEmpty,
    this.first,
    this.last,
  });
}

/// WhereEx过滤结果
///
/// 用于存储根据多个条件过滤后的结果，支持转换为List或Map
class WhereExResult<T> {
  final Stream<T> _stream;
  final List<bool Function(T)> _predicates;

  WhereExResult(this._stream, this._predicates);

  /// 检查元素是否满足任一条件
  bool _matchesAny(T value) {
    for (final predicate in _predicates) {
      if (predicate(value)) {
        return true;
      }
    }
    return false;
  }

  /// 转换为分组列表
  ///
  /// 返回包含两个列表的对象：matched（满足条件的元素）和unmatched（不满足条件的元素）
  Future<WhereExListResult<T>> asList() async {
    final list = await _stream.toList();
    final matched = <T>[];
    final unmatched = <T>[];

    for (final value in list) {
      if (_matchesAny(value)) {
        matched.add(value);
      } else {
        unmatched.add(value);
      }
    }

    return WhereExListResult<T>(
      matched: matched,
      unmatched: unmatched,
    );
  }

  /// 转换为分组Map
  ///
  /// 返回Map，key为true表示满足条件，false表示不满足条件
  Future<Map<bool, List<T>>> asMap() async {
    final list = await _stream.toList();
    final result = <bool, List<T>>{
      true: <T>[],
      false: <T>[],
    };

    for (final value in list) {
      if (_matchesAny(value)) {
        result[true]!.add(value);
      } else {
        result[false]!.add(value);
      }
    }

    return result;
  }
}

/// WhereEx列表结果
///
/// 包含满足条件和不满足条件的两个列表
class WhereExListResult<T> {
  /// 满足条件的元素列表
  final List<T> matched;

  /// 不满足条件的元素列表
  final List<T> unmatched;

  /// 构造函数
  WhereExListResult({
    required this.matched,
    required this.unmatched,
  });

  /// 获取所有元素（matched + unmatched）
  List<T> get all => [...matched, ...unmatched];

  /// 获取总数
  int get total => matched.length + unmatched.length;
}
