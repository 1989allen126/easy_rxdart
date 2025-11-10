import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

/// EasyModelManager示例页面
class EasyModelManagerExamplePage extends StatefulWidget {
  const EasyModelManagerExamplePage({super.key});

  @override
  State<EasyModelManagerExamplePage> createState() =>
      _EasyModelManagerExamplePageState();
}

class _EasyModelManagerExamplePageState
    extends State<EasyModelManagerExamplePage> {
  @override
  void initState() {
    super.initState();
    // 懒加载注册模型
    EasyModelManager.lazyPut<CounterModel>(() => CounterModel());
    EasyModelManager.lazyPut<UserModel>(
        () => UserModel(name: '默认用户', age: 18));
  }

  @override
  void dispose() {
    // 清理模型
    EasyModelManager.delete<CounterModel>();
    EasyModelManager.delete<UserModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyModelManager示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLazyPutExample(),
          const SizedBox(height: 16),
          _buildGetExample(),
          const SizedBox(height: 16),
          _buildPutExample(),
          const SizedBox(height: 16),
          _buildDeleteExample(),
          const SizedBox(height: 16),
          _buildIsRegisteredExample(),
          const SizedBox(height: 16),
          _buildResetExample(),
        ],
      ),
    );
  }

  Widget _buildLazyPutExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '懒加载注册模型',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用lazyPut注册模型，模型只会在第一次调用get时创建',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.lazyPut<CounterModel>(() => CounterModel());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('CounterModel已注册为懒加载'),
                  ),
                );
              },
              child: const Text('注册CounterModel（懒加载）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '获取模型实例',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用get获取模型，如果不存在则创建',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  final counter = EasyModelManager.get<CounterModel>();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('获取CounterModel成功，count: ${counter.count}'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('获取失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('获取CounterModel'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                try {
                  final user = EasyModelManager.get<UserModel>(
                    () => UserModel(name: '新用户', age: 20),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('获取UserModel成功，name: ${user.name}, age: ${user.age}'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('获取失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('获取UserModel（提供创建器）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPutExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '直接设置模型实例',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用put直接设置模型实例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.put<CounterModel>(CounterModel());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('CounterModel已设置'),
                  ),
                );
              },
              child: const Text('设置CounterModel'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.put<UserModel>(
                  UserModel(name: '张三', age: 25),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('UserModel已设置'),
                  ),
                );
              },
              child: const Text('设置UserModel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '删除模型实例',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用delete删除模型实例',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.delete<CounterModel>();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('CounterModel已删除'),
                  ),
                );
              },
              child: const Text('删除CounterModel'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.delete<UserModel>();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('UserModel已删除'),
                  ),
                );
              },
              child: const Text('删除UserModel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIsRegisteredExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '检查模型是否已注册',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用isRegistered检查模型是否已注册',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final isRegistered =
                    EasyModelManager.isRegistered<CounterModel>();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'CounterModel${isRegistered ? '已' : '未'}注册'),
                  ),
                );
              },
              child: const Text('检查CounterModel是否已注册'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final isRegistered = EasyModelManager.isRegistered<UserModel>();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('UserModel${isRegistered ? '已' : '未'}注册'),
                  ),
                );
              },
              child: const Text('检查UserModel是否已注册'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '重置所有模型',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用reset重置所有模型实例和懒加载创建器',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                EasyModelManager.reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('所有模型已重置'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('重置所有模型'),
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

