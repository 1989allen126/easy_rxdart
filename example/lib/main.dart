import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

import 'pages/connectivity/connectivity_example.dart';
import 'pages/easy_model/counter_example.dart';
import 'pages/easy_model/easy_model_manager_example.dart' hide CounterModel;
import 'pages/easy_model/state_example.dart';
import 'pages/stream/stream_example.dart';
import 'pages/timer/timer_example.dart';
import 'pages/utils/date_time_utils_example.dart';
import 'pages/utils/debounce_utils_example.dart';
import 'pages/utils/distinct_utils_example.dart';
import 'pages/utils/map_extensions_example.dart';
import 'pages/utils/permission_chain_example.dart';
import 'pages/utils/string_extensions_example.dart';
import 'pages/utils/string_formatter_utils_example.dart';
import 'pages/utils/string_mask_utils_example.dart';
import 'pages/utils/string_validator_utils_example.dart';
import 'pages/utils/throttle_utils_example.dart';
import 'pages/utils/utils_example.dart';
import 'pages/utils/rx_utils_example.dart';
import 'pages/utils/where_ex_example.dart';
import 'pages/widget/widget_bind_example.dart' hide CounterModel;
import 'pages/widget/widget_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy RxDart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

/// 示例首页
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy RxDart Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExampleCard(
            context,
            title: '1. EasyModel状态管理',
            description: '使用EasyModel进行状态管理',
            icon: Icons.model_training,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EasyModel<CounterModel>(
                    model: CounterModel(),
                    child: const CounterExamplePage(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '1.1. EasyStateModel状态管理',
            description:
                '使用EasyStateModel进行状态管理（initial、loading、hasData、noData、error）',
            icon: Icons.dynamic_form,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StateExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '1.2. EasyModelManager全局模型管理',
            description: '使用EasyModelManager进行全局单例模型管理（lazyPut、get、put）',
            icon: Icons.storage,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EasyModelManagerExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '2. Stream操作符扩展',
            description: 'Stream防抖和去重',
            icon: Icons.stream,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StreamExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '3. Widget防抖、限流、去重',
            description: '按钮和输入框的防抖、限流、去重',
            icon: Icons.widgets,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '3.1. Widget绑定扩展',
            description: 'Widget绑定到Reactive和Model，自动更新',
            icon: Icons.link,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetBindExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4. 工具类使用',
            description: '防抖、限流、去重工具类',
            icon: Icons.build,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.1. 防抖工具类',
            description: 'DebounceUtils 防抖工具类示例',
            icon: Icons.timer_off,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DebounceUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.2. 限流工具类',
            description: 'ThrottleUtils 限流工具类示例',
            icon: Icons.speed,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThrottleUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.3. 去重工具类',
            description: 'DistinctUtils 去重工具类示例',
            icon: Icons.filter_alt,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DistinctUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.4. 字符串格式化工具类',
            description: 'StringFormatterUtils 字符串格式化工具类示例',
            icon: Icons.text_fields,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StringFormatterUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.5. 字符串验证工具类',
            description: 'StringValidatorUtils 字符串验证工具类示例',
            icon: Icons.verified,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StringValidatorUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.6. 字符串脱敏工具类',
            description: 'StringMaskUtils 字符串脱敏工具类示例',
            icon: Icons.security,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StringMaskUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.7. 日期时间工具类',
            description: 'DateTimeUtils 日期时间工具类示例',
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DateTimeUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.8. 字符串扩展示例',
            description: 'StringExtensions 字符串扩展示例',
            icon: Icons.text_snippet,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StringExtensionsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.9. Map扩展示例',
            description: 'MapExtensions Map扩展示例',
            icon: Icons.map,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MapExtensionsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.10. Permission链式调用示例',
            description: 'Permission链式调用扩展示例（API演示）',
            icon: Icons.security,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PermissionChainExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '5. 定时器使用',
            description: '定时器组管理器',
            icon: Icons.timer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimerExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.11. RxUtils工具类',
            description: 'RxUtils Stream和Reactive工具方法示例',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RxUtilsExamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '4.12. WhereEx多条件过滤',
            description: 'WhereEx多条件过滤和分组示例',
            icon: Icons.filter_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WhereExExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: '6. 网络监听使用',
            description: '网络状态监听',
            icon: Icons.wifi,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConnectivityExamplePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
