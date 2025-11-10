import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';

/// 数据转换扩展
extension DataExtensions<T> on Stream<T> {
  /// 转换为数组（List）
  ///
  /// 收集Stream的所有值到列表中
  /// 返回包含所有值的Future
  Future<List<T>> toArray() {
    return toList();
  }

  /// 转换为字典（Map）
  ///
  /// [keySelector] 键选择函数
  /// [valueSelector] 值选择函数
  /// 返回Map的Future
  Future<Map<K, V>> toDictionary<K, V>(
    K Function(T) keySelector,
    V Function(T) valueSelector,
  ) {
    return fold<Map<K, V>>(
      <K, V>{},
      (map, value) {
        final key = keySelector(value);
        final val = valueSelector(value);
        map[key] = val;
        return map;
      },
    );
  }

  /// 转换为字典（值相同）
  ///
  /// [keySelector] 键选择函数
  /// 返回Map的Future
  Future<Map<K, T>> toDictionaryByKey<K>(K Function(T) keySelector) {
    return fold<Map<K, T>>(
      <K, T>{},
      (map, value) {
        final key = keySelector(value);
        map[key] = value;
        return map;
      },
    );
  }

  /// 转换为字符串
  ///
  /// [separator] 分隔符
  /// 返回字符串的Future
  Future<String> toStringValue([String separator = '']) {
    return toList().then((list) => list.join(separator));
  }

  /// 转换为JSON字符串
  ///
  /// 返回JSON字符串的Future
  Future<String> toJsonString() {
    return toList().then((list) => jsonEncode(list));
  }

  /// 转换为二进制数据（Uint8List）
  ///
  /// [encoder] 编码函数，将T转换为Uint8List
  /// 返回Uint8List的Future
  Future<Uint8List> toBinaryData(Uint8List Function(T) encoder) {
    return toList().then((list) {
      final buffer = <int>[];
      for (final item in list) {
        buffer.addAll(encoder(item));
      }
      return Uint8List.fromList(buffer);
    });
  }

  /// 从字符串解析
  ///
  /// [decoder] 解码函数，将字符串转换为T
  /// 返回Stream<T>
  static Stream<T> fromString<T>(
    String source,
    T Function(String) decoder,
  ) {
    return Stream.value(source).map(decoder);
  }

  /// 从JSON字符串解析
  ///
  /// [decoder] 解码函数，将JSON转换为T
  /// 返回Stream<T>
  static Stream<T> fromJsonString<T>(
    String jsonString,
    T Function(dynamic) decoder,
  ) {
    try {
      final decoded = jsonDecode(jsonString);
      return Stream.value(decoder(decoded));
    } catch (e) {
      return Stream.error(e);
    }
  }

  /// 从二进制数据解析
  ///
  /// [data] 二进制数据
  /// [decoder] 解码函数，将Uint8List转换为T
  /// 返回Stream<T>
  static Stream<T> fromBinaryData<T>(
    Uint8List data,
    T Function(Uint8List) decoder,
  ) {
    try {
      return Stream.value(decoder(data));
    } catch (e) {
      return Stream.error(e);
    }
  }

  /// 从数组创建Stream
  ///
  /// [list] 数组
  /// 返回Stream<T>
  static Stream<T> fromArray<T>(List<T> list) {
    return Stream.fromIterable(list);
  }

  /// 从字典创建Stream
  ///
  /// [map] 字典
  /// [mapper] 映射函数，将键值对转换为T
  /// 返回Stream<T>
  static Stream<T> fromDictionary<K, V, T>(
    Map<K, V> map,
    T Function(K, V) mapper,
  ) {
    return Stream.fromIterable(
      map.entries.map((entry) => mapper(entry.key, entry.value)),
    );
  }
}

/// 字符串扩展
extension StringDataExtensions on Stream<String> {
  /// 转换为二进制数据（UTF-8编码）
  ///
  /// 返回Uint8List的Future
  Future<Uint8List> toBinaryDataUtf8() {
    return toList().then((list) {
      final combined = list.join('');
      return Uint8List.fromList(utf8.encode(combined));
    });
  }

  /// 分割字符串
  ///
  /// [pattern] 分割模式
  /// 返回分割后的Stream
  Stream<String> split(String pattern) {
    return flatMap((str) {
      return Stream.fromIterable(str.split(pattern));
    });
  }

  /// 从二进制数据解析为字符串（UTF-8解码）
  ///
  /// [data] 二进制数据
  /// 返回Stream<String>
  static Stream<String> fromBinaryDataUtf8(Uint8List data) {
    try {
      return Stream.value(utf8.decode(data));
    } catch (e) {
      return Stream.error(e);
    }
  }
}

/// 二进制数据扩展
extension BinaryDataExtensions on Stream<Uint8List> {
  /// 转换为字符串（UTF-8解码）
  ///
  /// 返回字符串的Future
  Future<String> toStringUtf8() {
    return toList().then((list) {
      final combined = Uint8List.fromList(
        list.expand((element) => element).toList(),
      );
      return utf8.decode(combined);
    });
  }

  /// 转换为Base64字符串
  ///
  /// 返回Base64字符串的Future
  Future<String> toBase64String() {
    return toList().then((list) {
      final combined = Uint8List.fromList(
        list.expand((element) => element).toList(),
      );
      return base64Encode(combined);
    });
  }

  /// 从Base64字符串解析
  ///
  /// [base64String] Base64字符串
  /// 返回Stream<Uint8List>
  static Stream<Uint8List> fromBase64String(String base64String) {
    try {
      return Stream.value(base64Decode(base64String));
    } catch (e) {
      return Stream.error(e);
    }
  }
}

