import 'reactive.dart';
import 'package:rxdart/rxdart.dart';

/// 响应式工具类
class ReactiveUtils {
  /// 过滤空值
  static Reactive<T> whereNotNull<T>(Reactive<T?> source) {
    return source.where((data) => data != null).map((data) => data!);
  }

  /// 防抖（延迟duration后无新数据才发射）
  static Reactive<T> debounce<T>(Reactive<T> source, Duration duration) {
    return Reactive(
      source.stream.debounce((_) => TimerStream<T>(_, duration)),
    );
  }

  /// 节流（固定间隔内只发射一次）
  static Reactive<T> throttle<T>(Reactive<T> source, Duration duration) {
    return Reactive(
      source.stream.throttle((_) => TimerStream<T>(_, duration)),
    );
  }

  /// 转换为广播流（支持多订阅）
  static Reactive<T> asBroadcast<T>(Reactive<T> source) {
    return Reactive(source.stream.asBroadcastStream());
  }
}
