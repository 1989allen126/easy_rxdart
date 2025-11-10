# Easy RxDart 示例应用

这是 Easy RxDart 库的示例应用，展示了如何使用 Easy RxDart 的各种功能。

## 运行示例

```bash
# 进入示例目录
cd example

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

## 功能示例

示例应用包含以下功能演示：

1. **EasyModel状态管理** - 使用 EasyModel 进行状态管理
2. **EasyStateModel状态管理** - 使用 EasyStateModel 进行状态管理（initial、loading、hasData、noData、error）
3. **EasyModelManager全局模型管理** - 使用 EasyModelManager 进行全局单例模型管理
4. **Stream操作符扩展** - Stream 防抖和去重
5. **Widget防抖、限流、去重** - 按钮和输入框的防抖、限流、去重
6. **Widget绑定扩展** - Widget 绑定到 Reactive 和 Model，自动更新
7. **工具类使用** - 防抖、限流、去重工具类
8. **定时器使用** - 定时器组管理器
9. **网络监听使用** - 网络状态监听

## 注意事项

- 示例应用需要 Flutter 3.0.0 或更高版本
- 某些功能（如权限请求）需要在真实设备上运行
- Android 插件警告可以忽略，因为 easy_rxdart 是一个库而非插件
