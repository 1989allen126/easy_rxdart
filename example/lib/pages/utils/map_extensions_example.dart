import 'package:flutter/material.dart';
import 'package:easy_rxdart/easy_rxdart.dart';

/// Map扩展示例页面
class MapExtensionsExamplePage extends StatelessWidget {
  const MapExtensionsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map扩展示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 一级转换 - toCamelCaseKeys'),
          _buildCamelCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 一级转换 - toPascalCaseKeys'),
          _buildPascalCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 一级转换 - toSnakeCaseKeys'),
          _buildSnakeCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. 一级转换 - capitalizeKeys'),
          _buildCapitalizeKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 深度转换 - toDeepCamelCaseKeys'),
          _buildDeepCamelCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. 深度转换 - toDeepPascalCaseKeys'),
          _buildDeepPascalCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('7. 深度转换 - toDeepSnakeCaseKeys'),
          _buildDeepSnakeCaseKeysExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('8. 深度转换 - toDeepCapitalizeKeys'),
          _buildDeepCapitalizeKeysExample(),
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

  Widget _buildCamelCaseKeysExample() {
    final map = {
      'user_name': 'test',
      'user_age': 25,
      'nested_map': {'inner_key': 'value'}
    };
    final result = map.toCamelCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
            const SizedBox(height: 8),
            const Text(
              '注意：嵌套的Map不会被转换',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPascalCaseKeysExample() {
    final map = {
      'user_name': 'test',
      'user_age': 25,
    };
    final result = map.toPascalCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
          ],
        ),
      ),
    );
  }

  Widget _buildSnakeCaseKeysExample() {
    final map = {
      'userName': 'test',
      'userAge': 25,
      'nestedMap': {'innerKey': 'value'}
    };
    final result = map.toSnakeCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
            const SizedBox(height: 8),
            const Text(
              '注意：嵌套的Map不会被转换',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapitalizeKeysExample() {
    final map = {
      'hello': 'test',
      'world': 'value',
    };
    final result = map.capitalizeKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepCamelCaseKeysExample() {
    final map = {
      'user_name': 'test',
      'user_info': {
        'first_name': 'John',
        'last_name': 'Doe',
        'addresses': [
          {'street_name': 'Main St', 'city_name': 'NYC'}
        ]
      }
    };
    final result = map.toDeepCamelCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
            const SizedBox(height: 8),
            const Text(
              '注意：递归处理所有层级的key，包括List中的Map',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepPascalCaseKeysExample() {
    final map = {
      'user_name': 'test',
      'nested_map': {'inner_key': 'value'}
    };
    final result = map.toDeepPascalCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepSnakeCaseKeysExample() {
    final map = {
      'userName': 'test',
      'nestedMap': {'innerKey': 'value', 'anotherKey': 123}
    };
    final result = map.toDeepSnakeCaseKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepCapitalizeKeysExample() {
    final map = {
      'hello': 'test',
      'nested': {'inner': 'value', 'another': 123}
    };
    final result = map.toDeepCapitalizeKeys;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMapRow('输入', map),
            _buildMapRow('输出', result),
          ],
        ),
      ),
    );
  }

  Widget _buildMapRow(String label, Map<String, dynamic> map) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatMap(map),
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMap(Map<String, dynamic> map) {
    final buffer = StringBuffer();
    buffer.writeln('{');
    map.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('  $key: ${_formatMap(value as Map<String, dynamic>)}');
      } else if (value is List) {
        buffer.writeln('  $key: [');
        for (final item in value) {
          if (item is Map) {
            buffer.writeln('    ${_formatMap(item as Map<String, dynamic>)}');
          } else {
            buffer.writeln('    $item');
          }
        }
        buffer.writeln('  ]');
      } else {
        buffer.writeln('  $key: $value');
      }
    });
    buffer.write('}');
    return buffer.toString();
  }
}

