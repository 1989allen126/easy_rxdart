import 'dart:async';

import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// Widget绑定扩展示例页面
class WidgetBindExamplePage extends StatefulWidget {
  const WidgetBindExamplePage({super.key});

  @override
  State<WidgetBindExamplePage> createState() => _WidgetBindExamplePageState();
}

class _WidgetBindExamplePageState extends State<WidgetBindExamplePage> {
  // 创建StreamController用于演示
  late final StreamController<int> _counterController;
  late final StreamController<String> _textController;
  late final StreamController<bool> _toggleController;

  // 创建Reactive对象用于演示
  late final Reactive<int> _counterReactive;
  late final Reactive<String> _textReactive;
  late final Reactive<bool> _toggleReactive;

  // 当前值
  int _counterValue = 0;
  String _textValue = 'Hello';
  bool _toggleValue = false;

  // 创建Model对象用于演示
  late final CounterModel _counterModel;
  late final UserModel _userModel;

  @override
  void initState() {
    super.initState();
    // 初始化StreamController
    _counterController = StreamController<int>.broadcast();
    _textController = StreamController<String>.broadcast();
    _toggleController = StreamController<bool>.broadcast();

    // 初始化Reactive对象
    _counterReactive = _counterController.asReactive();
    _textReactive = _textController.asReactive();
    _toggleReactive = _toggleController.asReactive();

    // 发送初始值
    _counterController.add(_counterValue);
    _textController.add(_textValue);
    _toggleController.add(_toggleValue);

    // 初始化Model对象
    _counterModel = CounterModel();
    _userModel = UserModel(name: '张三', age: 25);
  }

  @override
  void dispose() {
    _counterController.close();
    _textController.close();
    _toggleController.close();
    _counterModel.dispose();
    _userModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget绑定扩展示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildReactiveBindExample(),
          const SizedBox(height: 16),
          _buildModelBindExample(),
          const SizedBox(height: 16),
          _buildMultipleReactiveBindExample(),
          const SizedBox(height: 16),
          _buildMultipleModelBindExample(),
          const SizedBox(height: 16),
          _buildWidgetBindUtilsExample(),
          const SizedBox(height: 16),
          _buildSelectorExample(),
        ],
      ),
    );
  }

  /// 绑定到Reactive示例
  Widget _buildReactiveBindExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '绑定到Reactive（自动更新）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用Widget扩展方法bind绑定到Reactive，当Reactive值变化时自动更新Widget',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // 使用扩展方法绑定
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  const SizedBox().bind<int>(
                    _counterReactive,
                    (context, value, reactive) => Text(
                      '计数器: $value',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _counterValue--;
                          _counterController.add(_counterValue);
                        },
                        child: const Text('-'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          _counterValue++;
                          _counterController.add(_counterValue);
                        },
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: const SizedBox().bind<String>(
                _textReactive,
                (context, value, reactive) => Column(
                  children: [
                    Text(
                      '文本内容',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      value,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: '输入文本',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _textValue = value;
                _textController.add(_textValue);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 绑定到Model示例
  Widget _buildModelBindExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '绑定到Model（自动更新）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用Widget扩展方法bindModel绑定到Model，当Model变化时自动更新Widget',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                children: [
                  const SizedBox().bindModel<CounterModel, int>(
                    _counterModel,
                    (model) => model.count,
                    (context, value) => Text(
                      '计数器: $value',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _counterModel.decrement(),
                        child: const Text('-'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _counterModel.increment(),
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: const SizedBox().bindModel<UserModel, String>(
                _userModel,
                (model) => '${model.name} (${model.age}岁)',
                (context, value) => Column(
                  children: [
                    Text(
                      '用户信息',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      value,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _userModel.updateAge(_userModel.age + 1),
                    child: const Text('年龄+1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _userModel.updateName('李四'),
                    child: const Text('更改姓名'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 绑定到多个Reactive示例
  Widget _buildMultipleReactiveBindExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '绑定到多个Reactive（自动更新）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用WidgetBindUtils.bindAll绑定到多个Reactive，当任意Reactive值变化时自动更新Widget',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal[200]!),
              ),
              child: WidgetBindUtils.bindAll<int>(
                [_counterReactive, _counterReactive],
                (context, values) {
                  final sum = values[0] + values[1];
                  return Column(
                    children: [
                      Text(
                        '值1: ${values[0]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '值2: ${values[1]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '总和: $sum',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 绑定到多个Model示例
  Widget _buildMultipleModelBindExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '绑定到多个Model（自动更新）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用WidgetBindUtils.bindAllModels绑定到多个Model，当任意Model变化时自动更新Widget',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo[200]!),
              ),
              child: WidgetBindUtils.bindAllModels<Model, String>(
                [_counterModel, _userModel],
                [
                  (model) => (model as CounterModel).count.toString(),
                  (model) => (model as UserModel).name,
                ],
                (context, values) => Column(
                  children: [
                    Text(
                      '计数器: ${values[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '用户名: ${values[1]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// WidgetBindUtils工具类示例
  Widget _buildWidgetBindUtilsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'WidgetBindUtils工具类',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用WidgetBindUtils工具类进行绑定，提供更灵活的绑定方式',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: WidgetBindUtils.bind<bool>(
                _toggleReactive,
                (context, value) => Column(
                  children: [
                    Text(
                      value ? '已开启' : '已关闭',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: value ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Switch(
                      value: value,
                      onChanged: (newValue) {
                        _toggleValue = newValue;
                        _toggleController.add(_toggleValue);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.cyan[200]!),
              ),
              child: WidgetBindUtils.bindModel<CounterModel, int>(
                _counterModel,
                (model) => model.count,
                (context, value) => Text(
                  '使用WidgetBindUtils绑定: $value',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Selector示例
  Widget _buildSelectorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selector绑定（只监听特定属性）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用WidgetBindUtils.selector只监听Model的特定属性，只有当该属性真正变化时才重建Widget',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    '只监听count属性',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  WidgetBindUtils.selector<CounterModel, int>(
                    _counterModel,
                    (model) => model.count,
                    (context, count) => Text(
                      '计数器: $count',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _counterModel.decrement(),
                        child: const Text('-'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _counterModel.increment(),
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.pink[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    '只监听name属性（使用自定义相等性比较）',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  WidgetBindUtils.selector<UserModel, String>(
                    _userModel,
                    (model) => model.name,
                    (context, name) => Text(
                      '用户名: $name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _userModel.updateName('李四'),
                          child: const Text('更改姓名'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _userModel.updateAge(_userModel.age + 1),
                          child: const Text('年龄+1'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '注意：更改年龄不会触发重建，因为只监听了name属性',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    '只监听age属性',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  WidgetBindUtils.selector<UserModel, int>(
                    _userModel,
                    (model) => model.age,
                    (context, age) => Text(
                      '年龄: $age',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _userModel.updateName('王五'),
                          child: const Text('更改姓名'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _userModel.updateAge(_userModel.age + 1),
                          child: const Text('年龄+1'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '注意：更改姓名不会触发重建，因为只监听了age属性',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 计数器模型
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

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

/// 用户模型
class UserModel extends Model {
  String _name;
  int _age;

  UserModel({required String name, required int age})
      : _name = name,
        _age = age;

  String get name => _name;
  int get age => _age;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateAge(int age) {
    _age = age;
    notifyListeners();
  }
}
