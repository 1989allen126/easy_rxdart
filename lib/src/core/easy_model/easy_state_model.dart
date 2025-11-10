import 'model.dart';
import 'easy_state.dart';
import 'easy_state_status.dart';

/// EasyStateModel状态管理基类
///
/// 提供通用的状态管理功能，包括initial、loading、hasData、noData、error等状态
///
/// ### 示例
///
/// ```
/// class UserStateModel extends EasyStateModel<User> {
///   Future<void> loadUser() async {
///     setLoading();
///     try {
///       final user = await api.getUser();
///       setData(user);
///     } catch (e) {
///       setError(e);
///     }
///   }
/// }
/// ```
abstract class EasyStateModel<T> extends Model {
  /// 当前状态
  EasyState<T> _state = EasyState<T>.initial();

  /// 获取当前状态
  EasyState<T> get state => _state;

  /// 获取当前状态枚举
  EasyStateStatus get status => _state.status;

  /// 获取数据
  T? get data => _state.data;

  /// 获取错误信息
  Object? get error => _state.error;

  /// 是否处于初始状态
  bool get isInitial => _state.isInitial;

  /// 是否正在加载
  bool get isLoading => _state.isLoading;

  /// 是否有数据
  bool get hasData => _state.hasData;

  /// 是否无数据
  bool get isNoData => _state.isNoData;

  /// 是否有错误
  bool get hasError => _state.hasError;

  /// 是否有值
  bool get hasValue => _state.hasValue;

  /// 设置初始状态
  void setInitial() {
    _state = EasyState<T>.initial();
    notifyListeners();
  }

  /// 设置加载中状态
  void setLoading() {
    _state = EasyState<T>.loading();
    notifyListeners();
  }

  /// 设置有数据状态
  void setData(T data) {
    _state = EasyState<T>.hasData(data);
    notifyListeners();
  }

  /// 设置无数据状态
  void setNoData() {
    _state = EasyState<T>.noData();
    notifyListeners();
  }

  /// 设置错误状态
  void setError(Object error, {T? data}) {
    _state = EasyState<T>.error(error, data: data);
    notifyListeners();
  }

  /// 更新状态
  void updateState(EasyState<T> newState) {
    _state = newState;
    notifyListeners();
  }

  /// 更新数据（保持当前状态）
  void updateData(T data) {
    _state = _state.copyWith(data: data);
    notifyListeners();
  }

  /// 清除错误（如果有数据则恢复hasData状态，否则恢复initial状态）
  void clearError() {
    if (_state.data != null) {
      _state = EasyState<T>.hasData(_state.data!);
    } else {
      _state = EasyState<T>.initial();
    }
    notifyListeners();
  }

  /// 重置状态
  void reset() {
    _state = EasyState<T>.initial();
    notifyListeners();
  }

  @override
  void dispose() {
    _state = EasyState<T>.initial();
    super.dispose();
  }
}
