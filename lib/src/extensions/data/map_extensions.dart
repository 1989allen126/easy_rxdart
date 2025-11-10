import 'dart:async';

import 'string_naming_conversion_extensions.dart';

/// Map扩展
extension MapExtensions<K, V> on Map<K, V> {
  /// 转换为Stream
  ///
  /// [mapper] 映射函数，将键值对转换为T
  /// 返回Stream<T>
  Stream<T> toStream<T>(T Function(K, V) mapper) {
    return Stream.fromIterable(
      entries.map((entry) => mapper(entry.key, entry.value)),
    );
  }

  /// 跳过前N个条目
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的前N个条目
  /// 返回跳过后的Map
  Map<K, V> skipFirstN(int count, [bool Function(K, V)? predicate]) {
    if (count <= 0) {
      return this;
    }
    final entries = this.entries.toList();
    if (predicate != null) {
      int skippedCount = 0;
      return Map.fromEntries(
        entries.where((entry) {
          if (skippedCount < count && predicate(entry.key, entry.value)) {
            skippedCount++;
            return false;
          }
          return true;
        }),
      );
    }
    if (count >= entries.length) {
      return <K, V>{};
    }
    return Map.fromEntries(entries.sublist(count));
  }

  /// 跳过后N个条目
  ///
  /// [count] 跳过的数量
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的后N个条目
  /// 返回跳过后的Map
  Map<K, V> skipLastN(int count, [bool Function(K, V)? predicate]) {
    if (count <= 0) {
      return this;
    }
    final entries = this.entries.toList();
    if (predicate != null) {
      // 从后往前找到满足条件的N个条目
      final indicesToSkip = <int>[];
      for (int i = entries.length - 1;
          i >= 0 && indicesToSkip.length < count;
          i--) {
        if (predicate(entries[i].key, entries[i].value)) {
          indicesToSkip.add(i);
        }
      }
      return Map.fromEntries(
        entries
            .where((entry) => !indicesToSkip.contains(entries.indexOf(entry))),
      );
    }
    if (count >= entries.length) {
      return <K, V>{};
    }
    return Map.fromEntries(entries.sublist(0, entries.length - count));
  }

  /// 跳过第一个条目
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的第一个条目
  /// 返回跳过第一个条目后的Map
  Map<K, V> skipFirst([bool Function(K, V)? predicate]) {
    if (predicate != null) {
      bool skipped = false;
      return Map.fromEntries(
        entries.where((entry) {
          if (!skipped && predicate(entry.key, entry.value)) {
            skipped = true;
            return false;
          }
          return true;
        }),
      );
    }
    return skipFirstN(1);
  }

  /// 跳过最后一个条目
  ///
  /// [predicate] 可选的过滤条件函数，如果提供则只跳过满足条件的最后一个条目
  /// 返回跳过最后一个条目后的Map
  Map<K, V> skipLast([bool Function(K, V)? predicate]) {
    if (predicate != null) {
      final entries = this.entries.toList();
      // 从后往前找到第一个满足条件的条目
      for (int i = entries.length - 1; i >= 0; i--) {
        if (predicate(entries[i].key, entries[i].value)) {
          return Map.fromEntries(
            entries.where((entry) => entries.indexOf(entry) != i),
          );
        }
      }
      return this;
    }
    return skipLastN(1);
  }

  /// 过滤条目
  ///
  /// [predicate] 过滤条件函数
  /// 返回过滤后的Map
  Map<K, V> filter(bool Function(K, V) predicate) {
    return Map.fromEntries(
      entries.where((entry) => predicate(entry.key, entry.value)),
    );
  }
}

/// Map<String, V> 命名规则转换扩展
extension MapStringKeyExtensions<V> on Map<String, V> {
  /// 递归转换值的辅助方法
  ///
  /// [value] 要转换的值
  /// [keyConverter] key转换函数
  /// 返回转换后的值
  dynamic _convertValueDeep(
      dynamic value, String Function(String) keyConverter) {
    if (value is Map<String, dynamic>) {
      // 递归处理嵌套的Map
      final result = <String, dynamic>{};
      for (final entry in value.entries) {
        final newKey = keyConverter(entry.key);
        result[newKey] = _convertValueDeep(entry.value, keyConverter);
      }
      return result;
    } else if (value is List) {
      // 递归处理List中的元素
      return value
          .map((item) => _convertValueDeep(item, keyConverter))
          .toList();
    } else {
      // 其他类型直接返回
      return value;
    }
  }

  /// 将 key 从下划线命名转换为小驼峰命名（snake_case -> camelCase）
  ///
  /// 只处理当前一级的key，不递归处理嵌套的Map和List
  /// 示例：{'user_name': 'test'} -> {'userName': 'test'}
  /// 返回转换后的Map
  Map<String, V> get toCamelCaseKeys {
    final result = <String, V>{};
    for (final entry in entries) {
      final newKey = entry.key.toCamelCase;
      result[newKey] = entry.value;
    }
    return result;
  }

  /// 将 key 从下划线命名转换为大驼峰命名（snake_case -> PascalCase）
  ///
  /// 只处理当前一级的key，不递归处理嵌套的Map和List
  /// 示例：{'user_name': 'test'} -> {'UserName': 'test'}
  /// 返回转换后的Map
  Map<String, V> get toPascalCaseKeys {
    final result = <String, V>{};
    for (final entry in entries) {
      final newKey = entry.key.toPascalCase;
      result[newKey] = entry.value;
    }
    return result;
  }

  /// 将 key 从驼峰命名转换为下划线命名（camelCase/PascalCase -> snake_case）
  ///
  /// 只处理当前一级的key，不递归处理嵌套的Map和List
  /// 示例：{'userName': 'test'} -> {'user_name': 'test'}, {'UserName': 'test'} -> {'user_name': 'test'}
  /// 返回转换后的Map
  Map<String, V> get toSnakeCaseKeys {
    final result = <String, V>{};
    for (final entry in entries) {
      final newKey = entry.key.toSnakeCase;
      result[newKey] = entry.value;
    }
    return result;
  }

  /// 将 key 首字母大写
  ///
  /// 只处理当前一级的key，不递归处理嵌套的Map和List
  /// 示例：{'hello': 'test'} -> {'Hello': 'test'}
  /// 返回转换后的Map
  Map<String, V> get capitalizeKeys {
    final result = <String, V>{};
    for (final entry in entries) {
      final newKey = entry.key.capitalize;
      result[newKey] = entry.value;
    }
    return result;
  }

  /// 深度转换：将 key 从下划线命名转换为小驼峰命名（snake_case -> camelCase）
  ///
  /// 支持多级嵌套的Map和List，递归处理所有层级的key
  /// 示例：{'user_name': 'test', 'nested_map': {'inner_key': 'value'}} -> {'userName': 'test', 'nestedMap': {'innerKey': 'value'}}
  /// 返回转换后的Map
  Map<String, dynamic> get toDeepCamelCaseKeys {
    final result = <String, dynamic>{};
    for (final entry in entries) {
      final newKey = entry.key.toCamelCase;
      result[newKey] = _convertValueDeep(entry.value, (key) => key.toCamelCase);
    }
    return result;
  }

  /// 深度转换：将 key 从下划线命名转换为大驼峰命名（snake_case -> PascalCase）
  ///
  /// 支持多级嵌套的Map和List，递归处理所有层级的key
  /// 示例：{'user_name': 'test', 'nested_map': {'inner_key': 'value'}} -> {'UserName': 'test', 'NestedMap': {'InnerKey': 'value'}}
  /// 返回转换后的Map
  Map<String, dynamic> get toDeepPascalCaseKeys {
    final result = <String, dynamic>{};
    for (final entry in entries) {
      final newKey = entry.key.toPascalCase;
      result[newKey] =
          _convertValueDeep(entry.value, (key) => key.toPascalCase);
    }
    return result;
  }

  /// 深度转换：将 key 从驼峰命名转换为下划线命名（camelCase/PascalCase -> snake_case）
  ///
  /// 支持多级嵌套的Map和List，递归处理所有层级的key
  /// 示例：{'userName': 'test', 'nestedMap': {'innerKey': 'value'}} -> {'user_name': 'test', 'nested_map': {'inner_key': 'value'}}
  /// 返回转换后的Map
  Map<String, dynamic> get toDeepSnakeCaseKeys {
    final result = <String, dynamic>{};
    for (final entry in entries) {
      final newKey = entry.key.toSnakeCase;
      result[newKey] = _convertValueDeep(entry.value, (key) => key.toSnakeCase);
    }
    return result;
  }

  /// 深度转换：将 key 首字母大写
  ///
  /// 支持多级嵌套的Map和List，递归处理所有层级的key
  /// 示例：{'hello': 'test', 'nested': {'inner': 'value'}} -> {'Hello': 'test', 'Nested': {'Inner': 'value'}}
  /// 返回转换后的Map
  Map<String, dynamic> get toDeepCapitalizeKeys {
    final result = <String, dynamic>{};
    for (final entry in entries) {
      final newKey = entry.key.capitalize;
      result[newKey] = _convertValueDeep(entry.value, (key) => key.capitalize);
    }
    return result;
  }
}
