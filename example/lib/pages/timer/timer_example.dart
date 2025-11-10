import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 定时器示例页面
class TimerExamplePage extends StatelessWidget {
  const TimerExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定时器使用'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _TimerExampleWidget(),
      ),
    );
  }
}

/// 定时器示例Widget
class _TimerExampleWidget extends StatefulWidget {
  const _TimerExampleWidget();

  @override
  State<_TimerExampleWidget> createState() => _TimerExampleWidgetState();
}

class _TimerExampleWidgetState extends State<_TimerExampleWidget> {
  EasyTimer? _timer;
  int _count = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) {
      return; // 定时器已启动
    }

    _timer = EasyTimer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _count++;
        });
        // 最多执行10次
        if (_count >= 10) {
          _stopTimer();
        }
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _count = 0;
    });
  }

  void _pauseTimer() {
    _timer?.pause();
  }

  void _resumeTimer() {
    _timer?.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'EasyTimer 定时器示例',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Text(
          '定时器计数: $_count',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '定时器状态: ${_timer?.isRunning == true ? "运行中" : _timer?.isActive == true ? "已暂停" : "已停止"}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _timer == null ? _startTimer : null,
              child: const Text('启动定时器'),
            ),
            ElevatedButton(
              onPressed: _timer?.isRunning == true ? _pauseTimer : null,
              child: const Text('暂停定时器'),
            ),
            ElevatedButton(
              onPressed: _timer?.isActive == true ? _resumeTimer : null,
              child: const Text('恢复定时器'),
            ),
            ElevatedButton(
              onPressed: _timer != null ? _stopTimer : null,
              child: const Text('停止定时器'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '提示：定时器每秒触发一次，最多执行10次',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'EasyTimer API 说明',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          '• EasyTimer(duration, callback) - 创建单次定时器\n'
          '• EasyTimer.periodic(duration, callback) - 创建周期性定时器\n'
          '• timer.cancel() - 取消定时器\n'
          '• timer.pause() - 暂停定时器\n'
          '• timer.resume() - 恢复定时器\n'
          '• timer.isActive - 检查定时器是否激活\n'
          '• timer.isRunning - 检查定时器是否正在运行',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
