import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

/// 工具类使用示例页面
class UtilsExamplePage extends StatelessWidget {
  const UtilsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具类使用'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '防抖、限流、去重工具类',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final debounced = DebounceUtils.debounceVoid(
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('防抖工具类')),
                        );
                      },
                      const Duration(milliseconds: 500),
                    );
                    debounced();
                  },
                  child: const Text('防抖工具'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final throttled = ThrottleUtils.throttleVoid(
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('限流工具类')),
                        );
                      },
                      const Duration(milliseconds: 300),
                    );
                    throttled();
                  },
                  child: const Text('限流工具'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final distinct = DistinctUtils.distinctVoid(
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('去重工具类')),
                        );
                      },
                    );
                    distinct();
                    distinct(); // 第二次调用不会触发
                  },
                  child: const Text('去重工具'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
