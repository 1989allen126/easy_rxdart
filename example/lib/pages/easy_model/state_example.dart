import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

/// 状态管理示例
class StateExamplePage extends StatelessWidget {
  const StateExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyStateModel示例'),
      ),
      body: EasyModel<UserStateModel>(
        model: UserStateModel(),
        child: const _StateExampleContent(),
      ),
    );
  }
}

/// 状态示例内容
class _StateExampleContent extends StatelessWidget {
  const _StateExampleContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'EasyConsumerStateBuilder示例',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: EasyConsumerStateBuilder<UserStateModel, User>(
              initialBuilder: (context, child) => const Center(
                child: Text('初始状态，点击按钮加载数据'),
              ),
              loadingBuilder: (context, child) => const Center(
                child: CircularProgressIndicator(),
              ),
              dataBuilder: (context, user, child) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '用户信息',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('ID: ${user.id}'),
                      Text('姓名: ${user.name}'),
                      Text('邮箱: ${user.email}'),
                    ],
                  ),
                ),
              ),
              noDataBuilder: (context, child) => const Center(
                child: Text('无数据'),
              ),
              errorBuilder: (context, error, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      '错误: $error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildControlButtons(context),
        ],
      ),
    );
  }

  /// 控制按钮
  Widget _buildControlButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            EasyModel.read<UserStateModel>(context)?.loadUser();
          },
          child: const Text('加载用户'),
        ),
        ElevatedButton(
          onPressed: () {
            EasyModel.read<UserStateModel>(context)?.setNoData();
          },
          child: const Text('设置无数据'),
        ),
        ElevatedButton(
          onPressed: () {
            EasyModel.read<UserStateModel>(context)?.setError('模拟错误');
          },
          child: const Text('模拟错误'),
        ),
        ElevatedButton(
          onPressed: () {
            EasyModel.read<UserStateModel>(context)?.reset();
          },
          child: const Text('重置'),
        ),
      ],
    );
  }
}

/// 用户数据模型
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

/// 用户状态管理Model
class UserStateModel extends EasyStateModel<User> {
  /// 加载用户数据
  Future<void> loadUser() async {
    setLoading();
    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 模拟随机成功或失败
      if (DateTime.now().millisecond % 3 == 0) {
        // 模拟无数据
        setNoData();
      } else {
        // 模拟成功
        final user = User(
          id: 1,
          name: '张三',
          email: 'zhangsan@example.com',
        );
        setData(user);
      }
    } catch (e) {
      setError(e);
    }
  }
}
