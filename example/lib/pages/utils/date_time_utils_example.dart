import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter/material.dart';

/// 日期时间工具类示例页面
class DateTimeUtilsExamplePage extends StatelessWidget {
  const DateTimeUtilsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日期时间工具类示例'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. 日期时间格式化'),
          _buildFormatExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('2. 日期时间解析'),
          _buildParseExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('3. 获取时间点'),
          _buildTimePointExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('4. 日期计算'),
          _buildDateCalculationExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('5. 日期比较'),
          _buildDateComparisonExample(),
          const SizedBox(height: 24),
          _buildSectionTitle('6. 日期格式化'),
          _buildDateFormatExample(),
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

  Widget _buildFormatExample() {
    final now = DateTime.now();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                'yyyy-MM-dd', DateTimeUtils.format(now, 'yyyy-MM-dd')),
            _buildResultRow('yyyy-MM-dd HH:mm:ss',
                DateTimeUtils.format(now, 'yyyy-MM-dd HH:mm:ss')),
            _buildResultRow(
                'MM/dd/yyyy', DateTimeUtils.format(now, 'MM/dd/yyyy')),
            _buildResultRow(
                'yyyy年MM月dd日', DateTimeUtils.format(now, 'yyyy年MM月dd日')),
            _buildResultRow('HH:mm:ss', DateTimeUtils.format(now, 'HH:mm:ss')),
          ],
        ),
      ),
    );
  }

  Widget _buildParseExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                '2024-01-01',
                DateTimeUtils.parse('2024-01-01', 'yyyy-MM-dd')?.toString() ??
                    '解析失败'),
            _buildResultRow(
                '2024-01-01 12:30:45',
                DateTimeUtils.parse(
                            '2024-01-01 12:30:45', 'yyyy-MM-dd HH:mm:ss')
                        ?.toString() ??
                    '解析失败'),
            _buildResultRow(
                'invalid',
                DateTimeUtils.parse('invalid', 'yyyy-MM-dd')?.toString() ??
                    '解析失败'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePointExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('now()', DateTimeUtils.now().toString()),
            _buildResultRow('today()', DateTimeUtils.today().toString()),
            _buildResultRow('todayEnd()', DateTimeUtils.todayEnd().toString()),
            _buildResultRow(
                'yesterday()', DateTimeUtils.yesterday().toString()),
            _buildResultRow('tomorrow()', DateTimeUtils.tomorrow().toString()),
            _buildResultRow('thisWeek()', DateTimeUtils.thisWeek().toString()),
            _buildResultRow(
                'thisMonth()', DateTimeUtils.thisMonth().toString()),
            _buildResultRow('thisYear()', DateTimeUtils.thisYear().toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCalculationExample() {
    final now = DateTime.now();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                'addDays(now, 7)', DateTimeUtils.addDays(now, 7).toString()),
            _buildResultRow(
                'addDays(now, -7)', DateTimeUtils.addDays(now, -7).toString()),
            _buildResultRow(
                'addHours(now, 1)', DateTimeUtils.addHours(now, 1).toString()),
            _buildResultRow('addMinutes(now, 30)',
                DateTimeUtils.addMinutes(now, 30).toString()),
            _buildResultRow('addSeconds(now, 60)',
                DateTimeUtils.addSeconds(now, 60).toString()),
            _buildResultRow(
                'daysBetween(now, tomorrow)',
                DateTimeUtils.daysBetween(now, DateTimeUtils.tomorrow())
                    .toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateComparisonExample() {
    final now = DateTime.now();
    final tomorrow = DateTimeUtils.tomorrow();
    final yesterday = DateTimeUtils.yesterday();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow(
                'isToday(now)', DateTimeUtils.isToday(now).toString()),
            _buildResultRow('isToday(tomorrow)',
                DateTimeUtils.isToday(tomorrow).toString()),
            _buildResultRow('isYesterday(yesterday)',
                DateTimeUtils.isYesterday(yesterday).toString()),
            _buildResultRow('isTomorrow(tomorrow)',
                DateTimeUtils.isTomorrow(tomorrow).toString()),
            _buildResultRow(
                'isThisWeek(now)', DateTimeUtils.isThisWeek(now).toString()),
            _buildResultRow(
                'isThisMonth(now)', DateTimeUtils.isThisMonth(now).toString()),
            _buildResultRow(
                'isThisYear(now)', DateTimeUtils.isThisYear(now).toString()),
            _buildResultRow('daysBetween(now, tomorrow)',
                DateTimeUtils.daysBetween(now, tomorrow).toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFormatExample() {
    final now = DateTime.now();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('formatDate(now)', DateTimeUtils.formatDate(now)),
            _buildResultRow('formatTime(now)', DateTimeUtils.formatTime(now)),
            _buildResultRow(
                'formatDateTime(now)', DateTimeUtils.formatDateTime(now)),
            _buildResultRow(
                'formatRelative(now)', DateTimeUtils.formatRelative(now)),
            _buildResultRow('formatRelative(yesterday)',
                DateTimeUtils.formatRelative(DateTimeUtils.yesterday())),
            _buildResultRow('formatRelative(tomorrow)',
                DateTimeUtils.formatRelative(DateTimeUtils.tomorrow())),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
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
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
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
