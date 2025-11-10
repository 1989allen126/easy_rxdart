/// EasyState状态枚举
///
/// 用于表示数据加载的不同状态
enum EasyStateStatus {
  /// 初始状态，尚未开始加载
  initial,

  /// 加载中
  loading,

  /// 有数据
  hasData,

  /// 无数据
  noData,

  /// 错误状态
  error,
}
