import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';
import 'dart:async';

/// 计数器Model示例
class CounterModel extends Model {
  int _count = 0;
  String _status = 'idle';

  int get count => _count;
  String get status => _status;

  void increment() {
    _count++;
    _status = 'incremented';
    notifyListeners();
  }

  void decrement() {
    _count--;
    _status = 'decremented';
    notifyListeners();
  }

  void reset() {
    _count = 0;
    _status = 'reset';
    notifyListeners();
  }

  void setCount(int value) {
    if (_count != value) {
      _count = value;
      _status = 'set';
      notifyListeners();
    }
  }

  void forceRefresh() {
    refresh(force: true);
  }
}

/// EasyModel示例页面
class CounterExamplePage extends StatelessWidget {
  const CounterExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyModel状态管理'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. EasyConsumerBuilder'),
          _buildConsumerBuilderExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. EasyConsumerSelector'),
          _buildConsumerSelectorExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. EasyConsumer'),
          _buildConsumerExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. EasyConsumerWidget'),
          const _CounterConsumerWidget(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. EasyConsumerStatefulWidget'),
          const _CounterConsumerStatefulWidget(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. watch、read、listen方法'),
          _buildWatchReadListenExample(context),
          const SizedBox(height: 24),
          _buildSectionTitle('7. refresh方法'),
          _buildRefreshExample(context),
          const SizedBox(height: 24),
          _buildSectionTitle('8. 状态监听'),
          _buildListenExample(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// EasyConsumerBuilder示例
  Widget _buildConsumerBuilderExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用EasyConsumerBuilder监听Model变化',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            EasyConsumerBuilder<CounterModel>(
              builder: (context, model, child) {
                // model保证不为null
                return Column(
                  children: [
                    Text(
                      '计数: ${model.count}',
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '状态: ${model.status}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              },
              errorBuilder: (context, error, child) {
                return Text(
                  'Model未找到: ${error.toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 16),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  /// EasyConsumerSelector示例
  Widget _buildConsumerSelectorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用EasyConsumerSelector只监听count变化',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            EasyConsumerSelector<CounterModel, int>(
              selector: (model) => model.count,
              builder: (context, count, child) {
                // count保证不为null
                return Text(
                  '计数: $count',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                );
              },
              errorBuilder: (context, error, child) {
                return Text(
                  'Model未找到: ${error.toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              '提示：只有count变化时才会重建，status变化不会重建',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// EasyConsumer示例
  Widget _buildConsumerExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用EasyConsumer访问Model',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            EasyConsumer(
              builder: (context, ref, child) {
                final counter = ref.watch<CounterModel>();
                if (counter == null) {
                  return const Text('Model未找到');
                }
                return Column(
                  children: [
                    Text(
                      '计数: ${counter.count}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // 使用read不会触发重建
                        ref.read<CounterModel>()?.increment();
                      },
                      child: const Text('使用read增加'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// watch、read、listen方法示例
  Widget _buildWatchReadListenExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用watch、read、listen方法',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _WatchReadListenWidget(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // read不会触发重建
                    EasyModel.read<CounterModel>(context)?.increment();
                  },
                  child: const Text('read增加'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // watch会触发重建
                    EasyModel.watch<CounterModel>(context)?.decrement();
                  },
                  child: const Text('watch减少'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// refresh方法示例
  Widget _buildRefreshExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用refresh强制刷新',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            EasyConsumerBuilder<CounterModel>(
              builder: (context, model, child) {
                // model保证不为null
                return Text(
                  '计数: ${model.count}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                );
              },
              errorBuilder: (context, error, child) {
                return Text(
                  'Model未找到: ${error.toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 强制刷新，即使数据没有变化也会触发notifyListeners
                EasyModel.read<CounterModel>(context)?.forceRefresh();
              },
              child: const Text('强制刷新'),
            ),
          ],
        ),
      ),
    );
  }

  /// 状态监听示例
  Widget _buildListenExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用listen监听Model变化（不触发重建）',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _ListenWidget(),
          ],
        ),
      ),
    );
  }

  /// 控制按钮
  Widget _buildControlButtons() {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                EasyModel.read<CounterModel>(context)?.decrement();
              },
              child: const Text('-'),
            ),
            ElevatedButton(
              onPressed: () {
                EasyModel.read<CounterModel>(context)?.reset();
              },
              child: const Text('重置'),
            ),
            ElevatedButton(
              onPressed: () {
                EasyModel.read<CounterModel>(context)?.increment();
              },
              child: const Text('+'),
            ),
          ],
        );
      },
    );
  }
}

/// EasyConsumerWidget示例
class _CounterConsumerWidget extends EasyConsumerWidget {
  const _CounterConsumerWidget();

  @override
  Widget buildWithRef(BuildContext context, EasyConsumerRef ref) {
    final counter = ref.watch<CounterModel>();
    if (counter == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Model未找到'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用EasyConsumerWidget',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              '计数: ${counter.count}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '状态: ${counter.status}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// EasyConsumerStatefulWidget示例
class _CounterConsumerStatefulWidget extends EasyConsumerStatefulWidget {
  const _CounterConsumerStatefulWidget();

  @override
  EasyConsumerState<_CounterConsumerStatefulWidget> createState() =>
      _CounterConsumerStatefulWidgetState();
}

class _CounterConsumerStatefulWidgetState
    extends EasyConsumerState<_CounterConsumerStatefulWidget> {
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    // 使用listen监听变化（不触发重建）
    ref.listen<CounterModel>((model) {
      debugPrint('Model变化: count=${model.count}, status=${model.status}');
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    _buildCount++;
    final counter = ref.watch<CounterModel>();
    if (counter == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Model未找到'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '使用EasyConsumerStatefulWidget',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              '计数: ${counter.count}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '构建次数: $_buildCount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read<CounterModel>()?.increment();
              },
              child: const Text('增加计数'),
            ),
          ],
        ),
      ),
    );
  }
}

/// watch、read、listen方法示例Widget
class _WatchReadListenWidget extends StatefulWidget {
  const _WatchReadListenWidget();

  @override
  State<_WatchReadListenWidget> createState() => _WatchReadListenWidgetState();
}

class _WatchReadListenWidgetState extends State<_WatchReadListenWidget> {
  String _listenLog = '';
  StreamSubscription<CounterModel>? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 使用listen监听变化
    _subscription?.cancel();
    _subscription = EasyModel.listen<CounterModel>(
      context,
      (model) {
        setState(() {
          _listenLog = '监听: count=${model.count}, status=${model.status}';
        });
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
    // 使用watch监听变化（会触发重建）
    final counter = EasyModel.watch<CounterModel>(context);
    if (counter == null) {
      return const Text('Model未找到');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '计数: ${counter.count}',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (_listenLog.isNotEmpty)
          Text(
            _listenLog,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

/// 状态监听示例Widget
class _ListenWidget extends StatefulWidget {
  const _ListenWidget();

  @override
  State<_ListenWidget> createState() => _ListenWidgetState();
}

class _ListenWidgetState extends State<_ListenWidget> {
  final List<String> _logs = [];
  StreamSubscription<CounterModel>? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription?.cancel();
    _subscription = EasyModel.listen<CounterModel>(
      context,
      (model) {
        setState(() {
          _logs.add('${DateTime.now().toString().substring(11, 19)}: count=${model.count}, status=${model.status}');
          if (_logs.length > 5) {
            _logs.removeAt(0);
          }
        });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '状态变化日志（使用listen，不触发重建）:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxHeight: 150),
          child: _logs.isEmpty
              ? const Text(
                  '等待状态变化...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _logs.clear();
            });
          },
          child: const Text('清空日志'),
        ),
      ],
    );
  }
}
