# Easy RxDart

Easy RxDart扩展组件库，提供常用的Stream操作符和工具类封装，简化响应式编程。

## 功能特性

- **Stream操作符扩展**：提供丰富的Stream操作符，简化响应式编程
- **EasyModel状态管理**：类似Riverpod的状态管理方案，支持watch、read、listen
- **Widget扩展**：为GestureDetector、TextField等Widget提供防抖、限流、去重功能
- **数据转换扩展**：提供List、Iterable等数据结构的便捷转换方法
- **Reactive扩展**：为Dio、Riverpod、Permission等第三方库提供响应式封装
- **工具类封装**：提供防抖、限流、去重等常用工具类
- **生命周期Mixin**：提供App生命周期和路由生命周期监听功能
- **类型安全的API设计**：完善的类型定义和文档注释

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  easy_rxdart: ^0.1.0
```

然后运行：

```bash
flutter pub get
```

## 快速开始

### 1. Stream操作符扩展

```dart
import 'package:easy_rxdart/easy_rxdart.dart';

// 防抖和去重
stream
  .debounceTime(Duration(seconds: 1))
  .distinctUntilChanged()
  .listen((data) {
    print('处理数据: $data');
  });

// 过滤和映射
stream
  .filter((value) => value > 0)
  .map((value) => value * 2)
  .listen((value) {
    print('结果: $value');
  });
```

### 2. EasyModel状态管理

#### 定义Model

```dart
class CounterModel extends Model {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
```

#### 使用EasyModel

```dart
// 在Widget树中提供Model
EasyModel<CounterModel>(
  model: CounterModel(),
  child: MyApp(),
)

// 方式1：使用watch监听变化（会触发重建）
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = EasyModel.watch<CounterModel>(context);
    return Text('${counter.count}');
  }
}

// 方式2：使用扩展方法
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterModel>();
    return Text('${counter.count}');
  }
}

// 方式3：使用EasyConsumerWidget
class CounterWidget extends EasyConsumerWidget {
  @override
  Widget buildWithRef(BuildContext context, EasyConsumerRef ref) {
    final counter = ref.watch<CounterModel>();
    return Text('${counter.count}');
  }
}

// 方式4：使用EasyConsumer
EasyConsumer(
  builder: (context, ref, child) {
    final counter = ref.watch<CounterModel>();
    return Text('${counter.count}');
  },
)

// 读取Model（不会触发重建）
void onButtonPressed(BuildContext context) {
  final counter = EasyModel.read<CounterModel>(context);
  counter.increment();
}

// 监听Model变化（用于副作用）
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = EasyModel.listen<CounterModel>(
      context,
      (counter) {
        // 执行副作用，例如显示SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Counter: ${counter.count}')),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counter = EasyModel.read<CounterModel>(context);
    return Text('${counter.count}');
  }
}
```

### 3. Widget防抖、限流、去重

#### GestureDetector扩展

```dart
// 防抖点击
GestureDetector.debounce(
  onTap: () {
    print('防抖点击');
  },
  debounceDuration: Duration(milliseconds: 300),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)

// 限流点击
GestureDetector.throttle(
  onTap: () {
    print('限流点击');
  },
  throttleDuration: Duration(milliseconds: 500),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
)

// 去重点击
GestureDetector.distinct(
  onTap: () {
    print('去重点击');
  },
  child: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
)
```

#### TextField扩展

```dart
// 防抖输入
TextField.debounce(
  onChanged: (value) {
    print('防抖输入: $value');
  },
  debounceDuration: Duration(milliseconds: 500),
  decoration: InputDecoration(
    labelText: '输入文本',
    border: OutlineInputBorder(),
  ),
)

// 限流输入
TextField.throttle(
  onChanged: (value) {
    print('限流输入: $value');
  },
  throttleDuration: Duration(milliseconds: 300),
  decoration: InputDecoration(
    labelText: '输入文本',
    border: OutlineInputBorder(),
  ),
)
```

### 4. 数据转换扩展

```dart
// List转Stream
final list = [1, 2, 3, 4, 5];
list.toStream().listen((value) {
  print('值: $value');
});

// Iterable扩展
final iterable = [1, 2, 3, 4, 5];
iterable
  .filter((value) => value > 2)
  .map((value) => value * 2)
  .toStream()
  .listen((value) {
    print('结果: $value');
  });

// Stream转List
final stream = Stream.fromIterable([1, 2, 3]);
final list = await stream.toArray();
print('列表: $list');
```

### 5. Reactive扩展

#### Dio响应式请求

```dart
final dio = Dio();

// GET请求
dio.getX<User>('/api/user')
  .mapData((data) => User.fromJson(data))
  .listen((user) {
    print('用户: ${user.name}');
  });

// POST请求
dio.postX<User>('/api/user', data: userData)
  .mapData((data) => User.fromJson(data))
  .listen((user) {
    print('创建用户: ${user.name}');
  });
```

#### Permission响应式请求

```dart
final permission = Permission.camera;

// 申请权限
permission.requestX().listen((status) {
  if (status.isGranted) {
    print('权限已授予');
  }
});

// 检查权限
permission.isGrantedX().listen((isGranted) {
  print('权限状态: $isGranted');
});
```

### 6. RxUtils工具类

RxUtils 提供了 Stream 和 Reactive 的静态工具方法封装，简化响应式编程。

```dart
import 'package:easy_rxdart/easy_rxdart.dart';

// Stream操作符
final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
final filtered = RxUtils.filterStream(stream, (v) => v % 2 == 0);
final grouped = await RxUtils.groupByKeyStream(stream, (v) => v % 2 == 0 ? 'even' : 'odd');

// Reactive操作符
final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
final mapped = RxUtils.mapReactive(reactive, (v) => v * 2);
final filtered = RxUtils.whereReactive(reactive, (v) => v > 3);

// WhereEx多条件过滤
final whereExResult = await RxUtils.whereEx<int>(stream, [
  (v) => v % 2 == 0, // 偶数
  (v) => v > 7, // 大于7
]).asList();
// whereExResult.matched: 满足条件的元素
// whereExResult.unmatched: 不满足条件的元素
```

更多详细信息请参考 [RxUtils 使用手册](./doc/rx_utils_manual.md)。

### 7. WhereEx多条件过滤

WhereEx 提供了多条件过滤功能，支持将元素根据条件分组为两种类型的数组或 Map。

```dart
import 'package:easy_rxdart/easy_rxdart.dart';

// 使用Stream扩展
final stream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
final result = await stream.whereEx([
  (value) => value % 2 == 0, // 偶数
  (value) => value > 7, // 大于7
]).asList();

// result.matched: [2, 4, 6, 8, 9, 10] - 满足任一条件的元素
// result.unmatched: [1, 3, 5, 7] - 不满足所有条件的元素

// 转换为Map
final mapResult = await stream.whereEx([
  (value) => value % 2 == 0,
]).asMap();
// mapResult[true]: [2, 4, 6, 8, 10] - 满足条件的元素
// mapResult[false]: [1, 3, 5, 7, 9] - 不满足条件的元素

// 使用Reactive
final reactive = Reactive.fromIterable([1, 2, 3, 4, 5]);
final reactiveResult = await reactive.whereEx([
  (value) => value > 3,
]).asList();
```

### 8. 生命周期Mixin

#### App生命周期Mixin

```dart
import 'package:easy_rxdart/easy_rxdart.dart';

class _MyPageState extends State<MyPage> with AppLifecycleMixin {
  @override
  void initState() {
    super.initState();
    // 监听应用生命周期变化
    listenAppLifecycle(
      onData: (state) {
        print('应用状态: $state');
        if (state == AppLifecycleState.paused) {
          // 应用进入后台
        } else if (state == AppLifecycleState.resumed) {
          // 应用回到前台
        }
      },
    );
  }
}
```

#### 路由生命周期Mixin

```dart
import 'package:easy_rxdart/easy_rxdart.dart';

// 1. 在 MaterialApp 中配置全局观察器
MaterialApp(
  navigatorObservers: [LifecycleUtils.globalRouteObserver],
  ...
)

// 2. 在路由页面中使用 Mixin
class _MyPageState extends State<MyPage> with RouteLifecycleMixin {
  // 方式1: 通过 override 方法（推荐）
  @override
  void onRoutePushed() {
    super.onRoutePushed();
    print('路由已推送 - 当前页面被推送到导航栈');
  }

  @override
  void onRoutePopNext() {
    super.onRoutePopNext();
    print('回到当前页面 - 从下一个页面返回到当前页面');
  }

  // 方式2: 通过 Reactive Stream（支持链式操作）
  @override
  void initState() {
    super.initState();
    // 监听路由推送事件
    listenRoutePushed(onData: () {
      print('路由已推送');
    });

    // 监听路由返回事件
    listenRoutePopNext(onData: () {
      print('回到当前页面');
    });

    // 监听路由进入事件（推送或返回）
    listenRouteEntered(onData: () {
      print('进入当前页面');
    });

    // 监听路由退出事件（进入下一页或弹出）
    listenRouteExited(onData: () {
      print('退出当前页面');
    });
  }
}
```

### 9. 工具类使用

```dart
// 防抖函数
final debouncedFunction = DebounceUtils.debounceFunction<String>(
  (value) {
    print('防抖输出: $value');
  },
  Duration(milliseconds: 500),
);

debouncedFunction('测试');

// 限流函数
final throttledFunction = ThrottleUtils.throttleFunction<String>(
  (value) {
    print('限流输出: $value');
  },
  Duration(milliseconds: 300),
);

throttledFunction('测试');

// 去重函数
final distinctFunction = DistinctUtils.distinctFunction<String>(
  (value) {
    print('去重输出: $value');
  },
);

distinctFunction('测试');
distinctFunction('测试'); // 不会输出
```

## 目录结构

```
lib/
  ├── easy_rxdart.dart               # 主入口文件
  └── src/
      ├── core/                       # 核心类
      │   ├── reactive.dart           # Reactive类
      │   ├── reactive_utils.dart    # Reactive工具类
      │   └── easy_model.dart        # EasyModel状态管理
      ├── extensions/                # 扩展操作符
      │   ├── stream/                 # Stream相关扩展
      │   ├── widget/                 # Widget相关扩展
      │   ├── data/                   # 数据相关扩展
      │   ├── reactive/               # Reactive相关扩展
      │   ├── string/                 # String相关扩展
      │   └── third_party/            # 第三方库相关扩展
      ├── utils/                      # 工具类
      │   ├── debounce_utils.dart     # 防抖工具类
      │   ├── throttle_utils.dart     # 限流工具类
      │   ├── distinct_utils.dart    # 去重工具类
      │   └── ...
      └── mixins/                     # Mixin类
          ├── stream_mixins.dart      # Stream Mixin
          ├── app_lifecycle_mixin.dart # 应用生命周期Mixin
          └── route_lifecycle_mixin.dart # 路由生命周期Mixin
```

## API文档

### EasyModel

#### 静态方法

- `watch<T>(BuildContext context)`: 监听Model变化（会触发重建）
- `read<T>(BuildContext context)`: 读取Model（不会触发重建）
- `listen<T>(BuildContext context, void Function(T model) callback)`: 监听Model变化（用于副作用）

#### 扩展方法

- `context.watch<T extends Model>()`: 监听Model变化
- `context.read<T extends Model>()`: 读取Model
- `context.listen<T extends Model>(void Function(T model) callback)`: 监听Model变化

### Stream扩展

- `debounceTime(Duration duration)`: 防抖
- `throttleTime(Duration duration)`: 限流
- `distinctUntilChanged()`: 去重
- `filter(bool Function(T) predicate)`: 过滤
- `compactMap<R>(R? Function(T) mapper)`: 紧凑映射
- `flatMapValue<R>(Stream<R> Function(T) mapper)`: 扁平映射

### Widget扩展

- `GestureDetector.debounce(...)`: 防抖点击
- `GestureDetector.throttle(...)`: 限流点击
- `GestureDetector.distinct(...)`: 去重点击
- `TextField.debounce(...)`: 防抖输入
- `TextField.throttle(...)`: 限流输入

## 最佳实践

1. **使用EasyModel进行状态管理**：对于需要状态管理的场景，推荐使用EasyModel
2. **合理使用防抖和限流**：对于频繁触发的事件（如搜索输入、按钮点击），使用防抖或限流
3. **使用Reactive扩展**：对于网络请求、权限申请等异步操作，使用Reactive扩展简化代码
4. **使用生命周期Mixin**：对于需要监听应用或路由生命周期的场景，使用`AppLifecycleMixin`或`RouteLifecycleMixin`，订阅会自动管理
5. **及时取消订阅**：使用`listen`方法时，记得在`dispose`中取消订阅（Mixin会自动管理）

## 许可证

MIT License
