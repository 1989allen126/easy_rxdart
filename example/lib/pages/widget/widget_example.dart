import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

/// Widget防抖、限流、去重示例页面
class WidgetExamplePage extends StatelessWidget {
  const WidgetExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget防抖、限流、去重'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGestureExample(context),
          const SizedBox(height: 24),
          _buildTextFieldExample(),
        ],
      ),
    );
  }

  /// Gesture防抖、限流、去重示例
  Widget _buildGestureExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '按钮防抖、限流、去重',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButtonX.debounce(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('防抖按钮点击')),
                    );
                  },
                  debounceDuration: const Duration(milliseconds: 500),
                  child: const Text('防抖'),
                ),
                ElevatedButtonX.throttle(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('限流按钮点击')),
                    );
                  },
                  throttleDuration: const Duration(milliseconds: 300),
                  child: const Text('限流'),
                ),
                ElevatedButtonX.distinct(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('去重按钮点击')),
                    );
                  },
                  child: const Text('去重'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '提示：快速点击按钮查看效果',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// TextField防抖输入示例
  Widget _buildTextFieldExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'TextField防抖输入',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const _TextFieldExampleWidget(),
          ],
        ),
      ),
    );
  }
}

/// TextField示例Widget
class _TextFieldExampleWidget extends StatefulWidget {
  const _TextFieldExampleWidget();

  @override
  State<_TextFieldExampleWidget> createState() => _TextFieldExampleWidgetState();
}

class _TextFieldExampleWidgetState extends State<_TextFieldExampleWidget> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFieldX.debounce(
          onChanged: (value) {
            setState(() {
              _output = '防抖输入: $value';
            });
          },
          debounceDuration: const Duration(milliseconds: 500),
          decoration: const InputDecoration(
            labelText: '输入文本（带防抖）',
            border: OutlineInputBorder(),
            hintText: '停止输入500ms后触发',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _output.isEmpty ? '等待输入...' : _output,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
