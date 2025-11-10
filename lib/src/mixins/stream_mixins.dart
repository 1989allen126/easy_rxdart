import 'dart:async';

/// Stream Mixin
///
/// 提供Stream相关的混入功能
mixin StreamMixin<T> {
  /// 获取Stream
  Stream<T> get stream;

  /// 订阅Stream
  ///
  /// [onData] 数据回调
  /// [onError] 错误回调
  /// [onDone] 完成回调
  /// [cancelOnError] 是否在错误时取消
  /// 返回StreamSubscription
  StreamSubscription<T> listen({
    void Function(T)? onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 转换为Future
  ///
  /// 返回Stream的第一个值作为Future
  Future<T> get first => stream.first;

  /// 转换为Future（最后一个值）
  ///
  /// 返回Stream的最后一个值作为Future
  Future<T> get last => stream.last;

  /// 转换为Future（单个值）
  ///
  /// 如果Stream有多个值，则抛出异常
  Future<T> get single => stream.single;

  /// 转换为List
  ///
  /// 收集Stream的所有值到列表中
  Future<List<T>> toList() {
    return stream.toList();
  }

  /// 转换为Set
  ///
  /// 收集Stream的所有值到集合中
  Future<Set<T>> toSet() {
    return stream.toSet();
  }

  /// 转换为Map
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回Map
  Future<Map<K, V>> toMapValue<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }

  /// 转换为Map（值相同）
  ///
  /// [keySelector] 键选择函数
  /// 返回Map
  Future<Map<K, T>> toMapByKey<K>(K Function(T) keySelector) {
    return stream.fold<Map<K, T>>(
      <K, T>{},
      (map, value) {
        final key = keySelector(value);
        map[key] = value;
        return map;
      },
    );
  }

  /// 转换为Map（键相同）
  ///
  /// [valueSelector] 值选择函数
  /// 返回Map
  Future<Map<T, V>> toMapByValue<V>(V Function(T) valueSelector) {
    return stream.fold<Map<T, V>>(
      <T, V>{},
      (map, value) {
        final val = valueSelector(value);
        map[value] = val;
        return map;
      },
    );
  }

  /// 转换为Map（分组）
  ///
  /// [keySelector] 键选择函数
  /// 返回分组后的Map
  Future<Map<K, List<T>>> toGroupedMap<K>(K Function(T) keySelector) {
    return stream.fold<Map<K, List<T>>>(
      <K, List<T>>{},
      (map, value) {
        final key = keySelector(value);
        map.putIfAbsent(key, () => <T>[]).add(value);
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map
  Future<Map<K, List<V>>> toGroupedMapWithValue<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, List<V>>>(
      <K, List<V>>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map.putIfAbsent(key, () => <V>[]).add(val);
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值）
  Future<Map<K, V>> toMapWithValue<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，覆盖）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，后值覆盖前值）
  Future<Map<K, V>> toMapWithValueOverwrite<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，不覆盖）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，前值保留）
  Future<Map<K, V>> toMapWithValueKeepFirst<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        if (!map.containsKey(key)) {
          final val = valueSelector(value);
          map[key] = val;
        }
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，保留最后一个）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，后值保留）
  Future<Map<K, V>> toMapWithValueKeepLast<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，保留最后一个，但只在键不存在时添加）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，只在键不存在时添加）
  Future<Map<K, V>> toMapWithValueKeepLastIfNotExists<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        if (!map.containsKey(key)) {
          final val = valueSelector(value);
          map[key] = val;
        }
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，保留最后一个，但只在键存在时更新）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，只在键存在时更新）
  Future<Map<K, V>> toMapWithValueKeepLastIfExists<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        if (map.containsKey(key)) {
          final val = valueSelector(value);
          map[key] = val;
        }
        return map;
      },
    );
  }

  /// 转换为Map（分组并转换值，单个值，保留最后一个，但只在键存在时更新，否则添加）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回分组后的Map（每个键对应单个值，键存在时更新，否则添加）
  Future<Map<K, V>> toMapWithValueKeepLastAlways<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return stream.fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }
}
