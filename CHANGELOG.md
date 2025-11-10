# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-XX

### Added
- **Stream操作符扩展**：提供丰富的Stream操作符，包括防抖、限流、去重、过滤、映射等
- **EasyModel状态管理**：类似Riverpod的状态管理方案，支持watch、read、listen
- **Widget扩展**：为GestureDetector、TextField等Widget提供防抖、限流、去重功能
- **数据转换扩展**：提供List、Iterable等数据结构的便捷转换方法
- **Reactive扩展**：为Dio、Riverpod、Permission等第三方库提供响应式封装
- **工具类封装**：提供防抖、限流、去重等常用工具类
- **App生命周期Mixin**：`AppLifecycleMixin` 提供应用生命周期监听功能
- **路由生命周期Mixin**：`RouteLifecycleMixin` 提供路由生命周期监听功能，支持两种使用方式
  - 通过 override 方法（推荐）
  - 通过 Reactive Stream（支持链式操作）
- **RxUtils工具类**：提供Stream和Reactive的静态工具方法封装
- **WhereEx多条件过滤**：支持将元素根据条件分组为两种类型的数组或Map
- **类型安全的API设计**：完善的类型定义和文档注释

### Features
- 自动管理订阅和清理，避免内存泄漏
- 支持链式操作，代码简洁易读
- 完善的文档注释和使用示例
- 全面的单元测试覆盖

