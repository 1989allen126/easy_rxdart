import 'dart:async';
import '../../core/reactive.dart';

/// StreamController扩展
extension StreamControllerX<T> on StreamController<T> {
  /// 转换为Reactive
  Reactive<T> asReactive() => Reactive(stream);

  /// 安全发射数据
  void emit(T data) {
    if (!isClosed) {
      add(data);
    }
  }

  /// 发射错误
  void emitError(Object error, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(error, stackTrace);
    }
  }
}
