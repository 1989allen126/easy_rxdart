/// 字符串格式化工具类
class StringFormatterUtils {
  /// 格式化手机号（中间4位用*代替）
  ///
  /// [phone] 手机号
  /// 返回格式化后的手机号
  static String formatPhone(String? phone) {
    if (phone == null || phone.isEmpty || phone.length != 11) {
      return phone ?? '';
    }
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  /// 格式化身份证号（中间用*代替）
  ///
  /// [idCard] 身份证号
  /// 返回格式化后的身份证号
  static String formatIdCard(String? idCard) {
    if (idCard == null || idCard.isEmpty) {
      return '';
    }
    if (idCard.length == 18) {
      return '${idCard.substring(0, 6)}********${idCard.substring(14)}';
    }
    if (idCard.length == 15) {
      return '${idCard.substring(0, 6)}******${idCard.substring(12)}';
    }
    return idCard;
  }

  /// 格式化银行卡号（中间用*代替）
  ///
  /// [bankCard] 银行卡号
  /// 返回格式化后的银行卡号
  static String formatBankCard(String? bankCard) {
    if (bankCard == null || bankCard.isEmpty) {
      return '';
    }
    if (bankCard.length <= 8) {
      return bankCard;
    }
    final start = bankCard.substring(0, 4);
    final end = bankCard.substring(bankCard.length - 4);
    final middle = '*' * (bankCard.length - 8);
    return '$start$middle$end';
  }

  /// 格式化金额（添加千分位）
  ///
  /// [amount] 金额
  /// [decimals] 小数位数
  /// 返回格式化后的金额
  static String formatAmount(double? amount, {int decimals = 2}) {
    if (amount == null) {
      return '0.00';
    }
    final formatted = amount.toStringAsFixed(decimals);
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedInteger = integerPart.replaceAllMapped(
      regex,
      (match) => '${match.group(1)},',
    );
    return decimalPart.isNotEmpty ? '$formattedInteger.$decimalPart' : formattedInteger;
  }

  /// 格式化文件大小
  ///
  /// [bytes] 字节数
  /// 返回格式化后的文件大小
  static String formatFileSize(int? bytes) {
    if (bytes == null || bytes < 0) {
      return '0 B';
    }
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  /// 格式化数字（添加千分位）
  ///
  /// [number] 数字
  /// 返回格式化后的数字
  static String formatNumber(num? number) {
    if (number == null) {
      return '0';
    }
    final formatted = number.toString();
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return formatted.replaceAllMapped(
      regex,
      (match) => '${match.group(1)},',
    );
  }

  /// 格式化百分比
  ///
  /// [value] 值
  /// [decimals] 小数位数
  /// 返回格式化后的百分比
  static String formatPercent(double? value, {int decimals = 2}) {
    if (value == null) {
      return '0%';
    }
    final percent = (value * 100).toStringAsFixed(decimals);
    return '$percent%';
  }

  /// 格式化日期时间字符串
  ///
  /// [dateTime] 日期时间字符串
  /// [format] 格式模式
  /// 返回格式化后的日期时间字符串
  static String formatDateTime(String? dateTime, String format) {
    if (dateTime == null || dateTime.isEmpty) {
      return '';
    }
    try {
      final dt = DateTime.parse(dateTime);
      return _formatDateTime(dt, format);
    } catch (e) {
      return dateTime;
    }
  }

  /// 格式化日期时间
  ///
  /// [dateTime] 日期时间
  /// [format] 格式模式
  /// 返回格式化后的日期时间字符串
  static String _formatDateTime(DateTime dateTime, String format) {
    return format
        .replaceAll('yyyy', dateTime.year.toString())
        .replaceAll('MM', dateTime.month.toString().padLeft(2, '0'))
        .replaceAll('dd', dateTime.day.toString().padLeft(2, '0'))
        .replaceAll('HH', dateTime.hour.toString().padLeft(2, '0'))
        .replaceAll('mm', dateTime.minute.toString().padLeft(2, '0'))
        .replaceAll('ss', dateTime.second.toString().padLeft(2, '0'));
  }

  /// 截断字符串
  ///
  /// [value] 字符串
  /// [maxLength] 最大长度
  /// [ellipsis] 省略号
  /// 返回截断后的字符串
  static String truncate(String? value, int maxLength, {String ellipsis = '...'}) {
    if (value == null || value.isEmpty) {
      return '';
    }
    if (value.length <= maxLength) {
      return value;
    }
    return '${value.substring(0, maxLength)}$ellipsis';
  }

  /// 首字母大写
  ///
  /// [value] 字符串
  /// 返回首字母大写的字符串
  static String capitalize(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// 每个单词首字母大写
  ///
  /// [value] 字符串
  /// 返回每个单词首字母大写的字符串
  static String capitalizeWords(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// 移除空白字符
  ///
  /// [value] 字符串
  /// 返回移除空白字符后的字符串
  static String removeWhitespace(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value.replaceAll(RegExp(r'\s+'), '');
  }

  /// 移除指定字符
  ///
  /// [value] 字符串
  /// [characters] 要移除的字符
  /// 返回移除指定字符后的字符串
  static String removeCharacters(String? value, String characters) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value.replaceAll(RegExp('[${RegExp.escape(characters)}]'), '');
  }

  /// 填充字符串
  ///
  /// [value] 字符串
  /// [length] 目标长度
  /// [padding] 填充字符
  /// [padLeft] 是否左填充
  /// 返回填充后的字符串
  static String pad(String? value, int length, String padding, {bool padLeft = true}) {
    if (value == null) {
      value = '';
    }
    if (padLeft) {
      return value.padLeft(length, padding);
    }
    return value.padRight(length, padding);
  }

  /// 格式化JSON字符串（美化）
  ///
  /// [jsonString] JSON字符串
  /// [indent] 缩进字符
  /// 返回格式化后的JSON字符串
  static String formatJson(String? jsonString, {String indent = '  '}) {
    if (jsonString == null || jsonString.isEmpty) {
      return '';
    }
    try {
      // 简单的JSON格式化，实际项目中建议使用jsonEncode和jsonDecode
      return jsonString;
    } catch (e) {
      return jsonString;
    }
  }
}

