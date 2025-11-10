import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 字符串验证工具类示例页面
class StringValidatorUtilsExamplePage extends StatefulWidget {
  const StringValidatorUtilsExamplePage({super.key});

  @override
  State<StringValidatorUtilsExamplePage> createState() =>
      _StringValidatorUtilsExamplePageState();
}

class _StringValidatorUtilsExamplePageState
    extends State<StringValidatorUtilsExamplePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _bankCardController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    _idCardController.dispose();
    _bankCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字符串验证工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 基础验证'),
          _buildBasicValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 邮箱验证'),
          _buildEmailValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 手机号验证'),
          _buildPhoneValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. URL验证'),
          _buildUrlValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 数字验证'),
          _buildNumericValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. 身份证号验证'),
          _buildIdCardValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('7. 银行卡号验证'),
          _buildBankCardValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('8. IP地址验证'),
          _buildIpAddressValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('9. 中文验证'),
          _buildChineseValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('10. 长度验证'),
          _buildLengthValidationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('11. 正则表达式验证'),
          _buildRegexValidationExample(),
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

  Widget _buildBasicValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildValidationRow(
                'isEmpty', '', StringValidatorUtils.isEmpty('')),
            _buildValidationRow('isNotEmpty', 'hello',
                StringValidatorUtils.isNotEmpty('hello')),
            _buildValidationRow(
                'isBlank', '   ', StringValidatorUtils.isBlank('   ')),
            _buildValidationRow('isNotBlank', 'hello',
                StringValidatorUtils.isNotBlank('hello')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '邮箱地址',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final isValid =
                        StringValidatorUtils.isEmail(_emailController.text);
                    _showValidationResult('邮箱', _emailController.text, isValid);
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            _buildValidationResult('邮箱', _emailController.text,
                StringValidatorUtils.isEmail(_emailController.text)),
            const SizedBox(height: 8),
            _buildExampleRow('test@example.com',
                StringValidatorUtils.isEmail('test@example.com')),
            _buildExampleRow(
                'invalid-email', StringValidatorUtils.isEmail('invalid-email')),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '手机号',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final isValid =
                        StringValidatorUtils.isPhone(_phoneController.text);
                    _showValidationResult(
                        '手机号', _phoneController.text, isValid);
                  },
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            _buildValidationResult('手机号', _phoneController.text,
                StringValidatorUtils.isPhone(_phoneController.text)),
            const SizedBox(height: 8),
            _buildExampleRow(
                '13812345678', StringValidatorUtils.isPhone('13812345678')),
            _buildExampleRow(
                '12345678901', StringValidatorUtils.isPhone('12345678901')),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL地址',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final isValid =
                        StringValidatorUtils.isUrl(_urlController.text);
                    _showValidationResult('URL', _urlController.text, isValid);
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            _buildValidationResult('URL', _urlController.text,
                StringValidatorUtils.isUrl(_urlController.text)),
            const SizedBox(height: 8),
            _buildExampleRow('https://www.example.com',
                StringValidatorUtils.isUrl('https://www.example.com')),
            _buildExampleRow(
                'invalid-url', StringValidatorUtils.isUrl('invalid-url')),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExampleRow('123', StringValidatorUtils.isNumeric('123')),
            _buildExampleRow(
                '123.45', StringValidatorUtils.isNumeric('123.45')),
            _buildExampleRow('abc', StringValidatorUtils.isNumeric('abc')),
            _buildExampleRow('123', StringValidatorUtils.isInteger('123')),
            _buildExampleRow(
                '123.45', StringValidatorUtils.isInteger('123.45')),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idCardController,
              decoration: InputDecoration(
                labelText: '身份证号',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final isValid =
                        StringValidatorUtils.isIdCard(_idCardController.text);
                    _showValidationResult(
                        '身份证号', _idCardController.text, isValid);
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            _buildValidationResult('身份证号', _idCardController.text,
                StringValidatorUtils.isIdCard(_idCardController.text)),
            const SizedBox(height: 8),
            _buildExampleRow('320123199001011234',
                StringValidatorUtils.isIdCard('320123199001011234')),
            _buildExampleRow('320123900101123',
                StringValidatorUtils.isIdCard('320123900101123')),
            _buildExampleRow(
                '123456789', StringValidatorUtils.isIdCard('123456789')),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCardValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _bankCardController,
              decoration: InputDecoration(
                labelText: '银行卡号',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final isValid = StringValidatorUtils.isBankCard(
                        _bankCardController.text);
                    _showValidationResult(
                        '银行卡号', _bankCardController.text, isValid);
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            _buildValidationResult('银行卡号', _bankCardController.text,
                StringValidatorUtils.isBankCard(_bankCardController.text)),
            const SizedBox(height: 8),
            _buildExampleRow('6222021234567890',
                StringValidatorUtils.isBankCard('6222021234567890')),
            _buildExampleRow(
                '123456789', StringValidatorUtils.isBankCard('123456789')),
          ],
        ),
      ),
    );
  }

  Widget _buildIpAddressValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExampleRow(
                '192.168.1.1', StringValidatorUtils.isIpAddress('192.168.1.1')),
            _buildExampleRow(
                '256.1.1.1', StringValidatorUtils.isIpAddress('256.1.1.1')),
            _buildExampleRow(
                'invalid-ip', StringValidatorUtils.isIpAddress('invalid-ip')),
          ],
        ),
      ),
    );
  }

  Widget _buildChineseValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExampleRow('中文', StringValidatorUtils.isChinese('中文')),
            _buildExampleRow('hello', StringValidatorUtils.isChinese('hello')),
            _buildExampleRow(
                'hello中文', StringValidatorUtils.containsChinese('hello中文')),
            _buildExampleRow(
                'hello', StringValidatorUtils.containsChinese('hello')),
          ],
        ),
      ),
    );
  }

  Widget _buildLengthValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExampleRow('hello (min:3, max:10)',
                StringValidatorUtils.hasLength('hello', min: 3, max: 10)),
            _buildExampleRow('hi (min:3, max:10)',
                StringValidatorUtils.hasLength('hi', min: 3, max: 10)),
            _buildExampleRow('hello world (min:3, max:10)',
                StringValidatorUtils.hasLength('hello world', min: 3, max: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildRegexValidationExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExampleRow(
                '123 (\\d+)', StringValidatorUtils.matches('123', r'\d+')),
            _buildExampleRow(
                'abc (\\d+)', StringValidatorUtils.matches('abc', r'\d+')),
            _buildExampleRow('hello ([a-z]+)',
                StringValidatorUtils.matches('hello', r'[a-z]+')),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationRow(String label, String value, bool result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text('$label("$value"):'),
            flex: 2,
          ),
          Expanded(
            child: Text(
              result.toString(),
              style: TextStyle(
                color: result ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildExampleRow(String input, bool result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              input,
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

  Widget _buildValidationResult(String label, String value, bool result) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: result ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: result ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            result ? Icons.check_circle : Icons.cancel,
            color: result ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: ${result ? "有效" : "无效"}',
              style: TextStyle(
                color: result ? Colors.green[900] : Colors.red[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationResult(String label, String value, bool result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label: ${result ? "有效" : "无效"}'),
        backgroundColor: result ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
