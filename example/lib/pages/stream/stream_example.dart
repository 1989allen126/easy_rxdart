import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_rxdart/easy_rxdart.dart';

/// Stream操作符示例页面
class StreamExamplePage extends StatelessWidget {
  const StreamExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream操作符扩展'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _StreamExampleWidget(),
      ),
    );
  }
}

/// Stream示例Widget
class _StreamExampleWidget extends StatefulWidget {
  const _StreamExampleWidget();

  @override
  State<_StreamExampleWidget> createState() => _StreamExampleWidgetState();
}

class _StreamExampleWidgetState extends State<_StreamExampleWidget> {
  final _controller = StreamController<String>();
  String _output = '';

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    _controller.stream
        .debounceTime(const Duration(milliseconds: 500))
        .distinctBy()
        .listen((value) {
      setState(() {
        _output = '输出: $value';
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Stream防抖和去重',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: '输入文本（带防抖和去重）',
            border: OutlineInputBorder(),
            hintText: '输入相同内容不会触发',
          ),
          onChanged: (value) {
            _controller.add(value);
          },
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
