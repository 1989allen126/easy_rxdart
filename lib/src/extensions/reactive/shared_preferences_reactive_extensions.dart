import 'package:shared_preferences/shared_preferences.dart';
import '../../core/reactive.dart';

/// SharedPreferences响应式扩展
extension StorageReactiveX on SharedPreferences {
  /// 保存字符串
  Reactive<bool> setStringX(String key, String value) {
    return Reactive.fromFuture(setString(key, value));
  }

  /// 获取字符串
  Reactive<String?> getStringX(String key) {
    return Reactive.fromFuture(Future.value(getString(key)));
  }

  /// 保存布尔值
  Reactive<bool> setBoolX(String key, bool value) {
    return Reactive.fromFuture(setBool(key, value));
  }

  /// 获取布尔值
  Reactive<bool?> getBoolX(String key) {
    return Reactive.fromFuture(Future.value(getBool(key)));
  }

  /// 删除键值对
  Reactive<bool> removeX(String key) {
    return Reactive.fromFuture(remove(key));
  }
}

/// 初始化SharedPreferences
Reactive<SharedPreferences> initStorageX() {
  return Reactive.fromFuture(SharedPreferences.getInstance());
}
