import 'dart:async';

/// List扩展
extension ListExtensions<T> on List<T> {
  /// 转换为Stream
  ///
  /// 返回Stream<T>
  Stream<T> toStream() {
    return Stream.fromIterable(this);
  }

  /// 跳过前N个元素
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的前N个元素
  /// 返回跳过后的List
  List<T> skipFirstN(int count, [bool Function(T)? predicate]) {
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
      }).toList();
    }
    if (count >= length) {
      return <T>[];
    }
    return sublist(count);
  }

  /// 跳过后N个元素
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的后N个元素
  /// 返回跳过后的List
  List<T> skipLastN(int count, [bool Function(T)? predicate]) {
    if (count <= 0) {
      return this;
    }
    if (predicate != null) {
      // 从后往前找到满足条件的N个元素
      final indicesToSkip = <int>[];
      for (int i = length - 1; i >= 0 && indicesToSkip.length < count; i--) {
        if (predicate(this[i])) {
          indicesToSkip.add(i);
        }
      }
      return where((element) => !indicesToSkip.contains(indexOf(element)))
          .toList();
    }
    if (count >= length) {
      return <T>[];
    }
    return sublist(0, length - count);
  }

  /// 跳过第一个元素
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的第一个元素
  /// 返回跳过第一个元素后的List
  List<T> skipFirst([bool Function(T)? predicate]) {
    if (predicate != null) {
      bool skipped = false;
      return where((element) {
        if (!skipped && predicate(element)) {
          skipped = true;
          return false;
        }
        return true;
      }).toList();
    }
    return skipFirstN(1);
  }

  /// 跳过最后一个元素
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的最后一个元素
  /// 返回跳过最后一个元素后的List
  List<T> skipLast([bool Function(T)? predicate]) {
    if (predicate != null) {
      // 从后往前找到第一个满足条件的元素
      for (int i = length - 1; i >= 0; i--) {
        if (predicate(this[i])) {
          return where((element) => indexOf(element) != i).toList();
        }
      }
      return this;
    }
    return skipLastN(1);
  }

  /// 跳过满足条件的元素
  ///
  /// [predicate] 跳过条件函数
  /// 返回跳过满足条件元素后的List
  List<T> skipWhile(bool Function(T) predicate) {
    int skipCount = 0;
    for (final element in this) {
      if (!predicate(element)) {
        break;
      }
      skipCount++;
    }
    return sublist(skipCount);
  }

  /// 跳过直到满足条件的元素
  ///
  /// [predicate] 条件函数
  /// 返回跳过直到满足条件元素后的List
  List<T> skipUntil(bool Function(T) predicate) {
    int skipCount = 0;
    for (final element in this) {
      if (predicate(element)) {
        break;
      }
      skipCount++;
    }
    return sublist(skipCount);
  }

  /// 过滤元素
  ///
  /// [predicate] 过滤条件函数
  /// 返回过滤后的List
  List<T> filter(bool Function(T) predicate) {
    return where(predicate).toList();
  }

  /// 紧凑映射（过滤null值）
  ///
  /// [mapper] 映射函数，返回可空类型
  /// 返回过滤null后的List
  List<R> compactMap<R>(R? Function(T) mapper) {
    return map(mapper).where((value) => value != null).cast<R>().toList();
  }

  /// 扁平映射
  ///
  /// [mapper] 映射函数，返回List
  /// 返回扁平化后的List
  List<R> flatMap<R>(List<R> Function(T) mapper) {
    return expand(mapper).toList();
  }

  /// 归约操作
  ///
  /// [initialValue] 初始值
  /// [combine] 归约函数
  /// 返回归约结果
  R reduceValue<R>(R initialValue, R Function(R, T) combine) {
    return fold(initialValue, combine);
  }
}
