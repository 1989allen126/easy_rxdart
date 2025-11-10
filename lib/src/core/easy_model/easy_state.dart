import 'easy_state_status.dart';

/// EasyState状态类
///
/// 封装数据加载的状态和数据
///
/// ### 示例
///
/// ```
/// final state = EasyState<int>(
///   status: EasyStateStatus.loading,
///   data: null,
///   error: null,
/// );
/// ```
class EasyState<T> {
  /// 状态
  final EasyStateStatus status;

  /// 数据
  final T? data;

  /// 错误信息
  final Object? error;

  /// 构造函数
  const EasyState({
    required this.status,
    this.data,
    this.error,
  });

  /// 创建初始状态
  factory EasyState.initial() {
    return const EasyState(
      status: EasyStateStatus.initial,
      data: null,
      error: null,
    );
  }

  /// 创建加载中状态
  factory EasyState.loading() {
    return const EasyState(
      status: EasyStateStatus.loading,
      data: null,
      error: null,
    );
  }

  /// 创建有数据状态
  factory EasyState.hasData(T data) {
    return EasyState(
      status: EasyStateStatus.hasData,
      data: data,
      error: null,
    );
  }

  /// 创建无数据状态
  factory EasyState.noData() {
    return const EasyState(
      status: EasyStateStatus.noData,
      data: null,
      error: null,
    );
  }

  /// 创建错误状态
  factory EasyState.error(Object error, {T? data}) {
    return EasyState(
      status: EasyStateStatus.error,
      data: data,
      error: error,
    );
  }

  /// 是否处于初始状态
  bool get isInitial => status == EasyStateStatus.initial;

  /// 是否正在加载
  bool get isLoading => status == EasyStateStatus.loading;

  /// 是否有数据
  bool get hasData => status == EasyStateStatus.hasData;

  /// 是否无数据
  bool get isNoData => status == EasyStateStatus.noData;

  /// 是否有错误
  bool get hasError => status == EasyStateStatus.error;

  /// 是否有值（有数据或错误但有数据）
  bool get hasValue => data != null;

  /// 复制并更新状态
  EasyState<T> copyWith({
    EasyStateStatus? status,
    T? data,
    Object? error,
  }) {
    return EasyState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EasyState<T> &&
        other.status == status &&
        other.data == data &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(status, data, error);

  @override
  String toString() {
    return 'EasyState(status: $status, data: $data, error: $error)';
  }
}
