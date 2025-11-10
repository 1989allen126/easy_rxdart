import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 字符串扩展示例页面
class StringExtensionsExamplePage extends StatelessWidget {
  const StringExtensionsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字符串扩展示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 命名规则转换'),
          _buildNamingConversionExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 字符串格式化'),
          _buildFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 字符串验证'),
          _buildValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. 字符串脱敏'),
          _buildMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 字符串操作'),
          _buildStringOperationExample(),
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

  Widget _buildNamingConversionExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '命名规则转换',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildResultRow(
                'user_name', 'toCamelCase', 'user_name'.toCamelCase),
            _buildResultRow(
                'user_name', 'toPascalCase', 'user_name'.toPascalCase),
            _buildResultRow('userName', 'toSnakeCase', 'userName'.toSnakeCase),
            _buildResultRow('UserName', 'toSnakeCase', 'UserName'.toSnakeCase),
            _buildResultRow('hello', 'capitalize', 'hello'.capitalize),
            _buildResultRow('hello world', 'capitalizeWords',
                'hello world'.capitalizeWords),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '字符串格式化',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildResultRow(
                '13812345678', 'formatPhone', '13812345678'.formatPhone()),
            _buildResultRow('320123199001011234', 'formatIdCard',
                '320123199001011234'.formatIdCard()),
            _buildResultRow('6222021234567890', 'formatBankCard',
                '6222021234567890'.formatBankCard()),
            _buildResultRow('1024', 'formatFileSize', '1024'.formatFileSize()),
            _buildResultRow(
                '1234567', 'formatNumber', '1234567'.formatNumber()),
            _buildResultRow(
                '0.1234', 'formatPercent', '0.1234'.formatPercent()),
            _buildResultRow('2024-01-01 12:30:45', 'formatDateTime',
                '2024-01-01 12:30:45'.formatDateTime('yyyy-MM-dd')),
            _buildResultRow(
                '这是一个很长的字符串', 'truncate(10)', '这是一个很长的字符串'.truncate(10)),
            _buildResultRow('hello', 'capitalize', 'hello'.capitalize),
            _buildResultRow('hello world', 'capitalizeWords',
                'hello world'.capitalizeWords),
            _buildResultRow('hello world', 'removeWhitespace',
                'hello world'.removeWhitespace),
            _buildResultRow('hello-world', 'removeCharacters(-)',
                'hello-world'.removeCharacters('-')),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '字符串验证',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildValidationRow('', 'isEmptyValue', ''.isEmptyValue),
            _buildValidationRow(
                'hello', 'isNotEmptyValue', 'hello'.isNotEmptyValue),
            _buildValidationRow('   ', 'isBlank', '   '.isBlank),
            _buildValidationRow('hello', 'isNotBlank', 'hello'.isNotBlank),
            _buildValidationRow(
                'test@example.com', 'isEmail', 'test@example.com'.isEmail),
            _buildValidationRow(
                '13812345678', 'isPhone', '13812345678'.isPhone),
            _buildValidationRow('https://www.example.com', 'isUrl',
                'https://www.example.com'.isUrl),
            _buildValidationRow('123', 'isNumeric', '123'.isNumeric),
            _buildValidationRow('123', 'isInteger', '123'.isInteger),
            _buildValidationRow('320123199001011234', 'isIdCard',
                '320123199001011234'.isIdCard),
            _buildValidationRow('6222021234567890', 'isBankCard',
                '6222021234567890'.isBankCard),
            _buildValidationRow(
                '192.168.1.1', 'isIpAddress', '192.168.1.1'.isIpAddress),
            _buildValidationRow('中文', 'isChinese', '中文'.isChinese),
            _buildValidationRow(
                'hello中文', 'containsChinese', 'hello中文'.containsChinese),
            _buildValidationRow('hello', 'hasLength(min:3, max:10)',
                'hello'.hasLength(min: 3, max: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '字符串脱敏',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildResultRow(
                '13812345678', 'maskPhone', '13812345678'.maskPhone()),
            _buildResultRow('320123199001011234', 'maskIdCard',
                '320123199001011234'.maskIdCard()),
            _buildResultRow('6222021234567890', 'maskBankCard',
                '6222021234567890'.maskBankCard()),
            _buildResultRow('test@example.com', 'maskEmail',
                'test@example.com'.maskEmail()),
            _buildResultRow('张三', 'maskName', '张三'.maskName()),
            _buildResultRow(
                '京A12345', 'maskPlateNumber', '京A12345'.maskPlateNumber()),
            _buildResultRow('北京市朝阳区xxx街道xxx号', 'maskAddress',
                '北京市朝阳区xxx街道xxx号'.maskAddress()),
            _buildResultRow('1234567890', 'maskCustom',
                '1234567890'.maskCustom(keepStart: 2, keepEnd: 2)),
            _buildResultRow('1234567890', 'maskMiddle',
                '1234567890'.maskMiddle(keepStart: 2, keepEnd: 2)),
            _buildResultRow('1234567890', 'maskAll', '1234567890'.maskAll()),
          ],
        ),
      ),
    );
  }

  Widget _buildStringOperationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '字符串操作',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildResultRow('hello', 'skipFirstN(2)', 'hello'.skipFirstN(2)),
            _buildResultRow('hello', 'skipLastN(2)', 'hello'.skipLastN(2)),
            _buildResultRow('hello', 'skipFirst', 'hello'.skipFirst()),
            _buildResultRow('hello', 'skipLast', 'hello'.skipLast()),
            _buildResultRow('hello', 'skipWhile((c) => c == "h")',
                'hello'.skipWhile((c) => c == 'h')),
            _buildResultRow('hello', 'skipUntil((c) => c == "l")',
                'hello'.skipUntil((c) => c == 'l')),
            _buildResultRow('hello', 'filter((c) => c != "l")',
                'hello'.filter((c) => c != 'l')),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String input, String method, String output) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$input.$method',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '→ $output',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationRow(String input, String method, bool result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$input.$method',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Icon(
            result ? Icons.check_circle : Icons.cancel,
            color: result ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }
}
