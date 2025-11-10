import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 字符串脱敏工具类示例页面
class StringMaskUtilsExamplePage extends StatelessWidget {
  const StringMaskUtilsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字符串脱敏工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 手机号脱敏'),
          _buildPhoneMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 身份证号脱敏'),
          _buildIdCardMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 银行卡号脱敏'),
          _buildBankCardMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. 邮箱脱敏'),
          _buildEmailMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 姓名脱敏'),
          _buildNameMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. 车牌号脱敏'),
          _buildPlateNumberMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('7. 地址脱敏'),
          _buildAddressMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('8. 自定义脱敏'),
          _buildCustomMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('9. 中间部分脱敏'),
          _buildMiddleMaskExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('10. 全部脱敏'),
          _buildAllMaskExample(),
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

  Widget _buildPhoneMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '13812345678', StringMaskUtils.maskPhone('13812345678')),
            _buildResultRow(
                '13812345678 (keepStart:2, keepEnd:2)',
                StringMaskUtils.maskPhone('13812345678',
                    keepStart: 2, keepEnd: 2)),
            _buildResultRow('13812345678 (maskChar:X)',
                StringMaskUtils.maskPhone('13812345678', maskChar: 'X')),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('320123199001011234',
                StringMaskUtils.maskIdCard('320123199001011234')),
            _buildResultRow('320123900101123',
                StringMaskUtils.maskIdCard('320123900101123')),
            _buildResultRow(
                '320123199001011234 (keepStart:3, keepEnd:3)',
                StringMaskUtils.maskIdCard('320123199001011234',
                    keepStart: 3, keepEnd: 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCardMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('6222021234567890',
                StringMaskUtils.maskBankCard('6222021234567890')),
            _buildResultRow('6222021234567890123',
                StringMaskUtils.maskBankCard('6222021234567890123')),
            _buildResultRow(
                '6222021234567890 (keepStart:2, keepEnd:2)',
                StringMaskUtils.maskBankCard('6222021234567890',
                    keepStart: 2, keepEnd: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('test@example.com',
                StringMaskUtils.maskEmail('test@example.com')),
            _buildResultRow('abc123@example.com',
                StringMaskUtils.maskEmail('abc123@example.com')),
            _buildResultRow('test@example.com (keepStart:1)',
                StringMaskUtils.maskEmail('test@example.com', keepStart: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildNameMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('张三', StringMaskUtils.maskName('张三')),
            _buildResultRow('李四', StringMaskUtils.maskName('李四')),
            _buildResultRow('欧阳修', StringMaskUtils.maskName('欧阳修')),
            _buildResultRow(
                '欧阳修 (keepEnd:1)', StringMaskUtils.maskName('欧阳修', keepEnd: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateNumberMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '京A12345', StringMaskUtils.maskPlateNumber('京A12345')),
            _buildResultRow(
                '粤B12345', StringMaskUtils.maskPlateNumber('粤B12345')),
            _buildResultRow(
                '沪C123456', StringMaskUtils.maskPlateNumber('沪C123456')),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('北京市朝阳区xxx街道xxx号',
                StringMaskUtils.maskAddress('北京市朝阳区xxx街道xxx号')),
            _buildResultRow(
                '北京市朝阳区xxx街道xxx号 (keepStart:2, keepEnd:2)',
                StringMaskUtils.maskAddress('北京市朝阳区xxx街道xxx号',
                    keepStart: 2, keepEnd: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '1234567890 (keepStart:2, keepEnd:2)',
                StringMaskUtils.maskCustom('1234567890',
                    keepStart: 2, keepEnd: 2)),
            _buildResultRow(
                '1234567890 (keepStart:3, keepEnd:3)',
                StringMaskUtils.maskCustom('1234567890',
                    keepStart: 3, keepEnd: 3)),
            _buildResultRow(
                '1234567890 (maskChar:X)',
                StringMaskUtils.maskCustom('1234567890',
                    keepStart: 2, keepEnd: 2, maskChar: 'X')),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '1234567890 (maskLength:4)',
                StringMaskUtils.maskMiddle('1234567890',
                    keepStart: 2, keepEnd: 2, maskLength: 4)),
            _buildResultRow(
                '1234567890 (auto maskLength)',
                StringMaskUtils.maskMiddle('1234567890',
                    keepStart: 2, keepEnd: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildAllMaskExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '1234567890', StringMaskUtils.maskAll('1234567890')),
            _buildResultRow(
                '1234567890 (keepStart:2, keepEnd:2)',
                StringMaskUtils.maskAll('1234567890',
                    keepStart: 2, keepEnd: 2)),
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
