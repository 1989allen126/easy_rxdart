import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 字符串格式化工具类示例页面
class StringFormatterUtilsExamplePage extends StatelessWidget {
  const StringFormatterUtilsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字符串格式化工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 手机号格式化'),
          _buildPhoneFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 身份证号格式化'),
          _buildIdCardFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 银行卡号格式化'),
          _buildBankCardFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. 金额格式化'),
          _buildAmountFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 文件大小格式化'),
          _buildFileSizeFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. 数字格式化（千分位）'),
          _buildNumberFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('7. 百分比格式化'),
          _buildPercentFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('8. 日期时间格式化'),
          _buildDateTimeFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('9. 字符串截断'),
          _buildTruncateExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('10. 首字母大写'),
          _buildCapitalizeExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('11. 移除空白字符'),
          _buildRemoveWhitespaceExample(),
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

  Widget _buildPhoneFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '13812345678', StringFormatterUtils.formatPhone('13812345678')),
            _buildResultRow(
                '15912345678', StringFormatterUtils.formatPhone('15912345678')),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('320123199001011234',
                StringFormatterUtils.formatIdCard('320123199001011234')),
            _buildResultRow('320123900101123',
                StringFormatterUtils.formatIdCard('320123900101123')),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCardFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('6222021234567890',
                StringFormatterUtils.formatBankCard('6222021234567890')),
            _buildResultRow('6222021234567890123',
                StringFormatterUtils.formatBankCard('6222021234567890123')),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '1234567.89', StringFormatterUtils.formatAmount(1234567.89)),
            _buildResultRow('1234.5',
                StringFormatterUtils.formatAmount(1234.5, decimals: 1)),
            _buildResultRow(
                '999999.99', StringFormatterUtils.formatAmount(999999.99)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSizeFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('1024', StringFormatterUtils.formatFileSize(1024)),
            _buildResultRow(
                '1048576', StringFormatterUtils.formatFileSize(1048576)),
            _buildResultRow(
                '1073741824', StringFormatterUtils.formatFileSize(1073741824)),
            _buildResultRow('1099511627776',
                StringFormatterUtils.formatFileSize(1099511627776)),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '1234567', StringFormatterUtils.formatNumber(1234567)),
            _buildResultRow(
                '1234567890', StringFormatterUtils.formatNumber(1234567890)),
            _buildResultRow('999', StringFormatterUtils.formatNumber(999)),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentFormatExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '0.1234', StringFormatterUtils.formatPercent(0.1234)),
            _buildResultRow(
                '0.5', StringFormatterUtils.formatPercent(0.5, decimals: 1)),
            _buildResultRow('1.0', StringFormatterUtils.formatPercent(1.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeFormatExample() {
    final now = DateTime.now();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                'yyyy-MM-dd',
                StringFormatterUtils.formatDateTime(
                    now.toString(), 'yyyy-MM-dd')),
            _buildResultRow(
                'yyyy-MM-dd HH:mm:ss',
                StringFormatterUtils.formatDateTime(
                    now.toString(), 'yyyy-MM-dd HH:mm:ss')),
            _buildResultRow(
                'MM/dd/yyyy',
                StringFormatterUtils.formatDateTime(
                    now.toString(), 'MM/dd/yyyy')),
          ],
        ),
      ),
    );
  }

  Widget _buildTruncateExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '这是一个很长的字符串', StringFormatterUtils.truncate('这是一个很长的字符串', 10)),
            _buildResultRow(
                'Hello World',
                StringFormatterUtils.truncate('Hello World', 5,
                    ellipsis: '...')),
          ],
        ),
      ),
    );
  }

  Widget _buildCapitalizeExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('hello', StringFormatterUtils.capitalize('hello')),
            _buildResultRow('hello world',
                StringFormatterUtils.capitalizeWords('hello world')),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveWhitespaceExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('hello world',
                StringFormatterUtils.removeWhitespace('hello world')),
            _buildResultRow('  hello  world  ',
                StringFormatterUtils.removeWhitespace('  hello  world  ')),
            _buildResultRow('hello\nworld',
                StringFormatterUtils.removeWhitespace('hello\nworld')),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String input, String output) {
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
                  '输入: $input',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '输出: $output',
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
}
