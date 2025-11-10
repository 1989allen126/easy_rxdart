import 'package:intl/intl.dart';

/// 日期时间工具类
class DateTimeUtils {
  /// 格式化日期时间
  ///
  /// [dateTime] 日期时间
  /// [pattern] 格式模式
  /// 返回格式化后的字符串
  static String format(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// 解析日期时间
  ///
  /// [dateString] 日期字符串
  /// [pattern] 格式模式
  /// 返回解析后的DateTime
  static DateTime? parse(String dateString, String pattern) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 获取当前日期时间
  ///
  /// 返回当前DateTime
  static DateTime now() {
    return DateTime.now();
  }

  /// 获取今天开始时间
  ///
  /// 返回今天的00:00:00
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 获取今天结束时间
  ///
  /// 返回今天的23:59:59
  static DateTime todayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 获取昨天开始时间
  ///
  /// 返回昨天的00:00:00
  static DateTime yesterday() {
    final today = DateTimeUtils.today();
    return today.subtract(const Duration(days: 1));
  }

  /// 获取明天开始时间
  ///
  /// 返回明天的00:00:00
  static DateTime tomorrow() {
    final today = DateTimeUtils.today();
    return today.add(const Duration(days: 1));
  }

  /// 获取本周开始时间
  ///
  /// 返回本周一的00:00:00
  static DateTime thisWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final daysFromMonday = weekday - 1;
    return DateTime(now.year, now.month, now.day - daysFromMonday);
  }

  /// 获取本月开始时间
  ///
  /// 返回本月1号的00:00:00
  static DateTime thisMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// 获取本年开始时间
  ///
  /// 返回今年1月1日的00:00:00
  static DateTime thisYear() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  /// 添加天数
  ///
  /// [dateTime] 日期时间
  /// [days] 天数
  /// 返回添加后的DateTime
  static DateTime addDays(DateTime dateTime, int days) {
    return dateTime.add(Duration(days: days));
  }

  /// 添加小时
  ///
  /// [dateTime] 日期时间
  /// [hours] 小时数
  /// 返回添加后的DateTime
  static DateTime addHours(DateTime dateTime, int hours) {
    return dateTime.add(Duration(hours: hours));
  }

  /// 添加分钟
  ///
  /// [dateTime] 日期时间
  /// [minutes] 分钟数
  /// 返回添加后的DateTime
  static DateTime addMinutes(DateTime dateTime, int minutes) {
    return dateTime.add(Duration(minutes: minutes));
  }

  /// 添加秒数
  ///
  /// [dateTime] 日期时间
  /// [seconds] 秒数
  /// 返回添加后的DateTime
  static DateTime addSeconds(DateTime dateTime, int seconds) {
    return dateTime.add(Duration(seconds: seconds));
  }

  /// 计算两个日期之间的天数差
  ///
  /// [start] 开始日期
  /// [end] 结束日期
  /// 返回天数差
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// 计算两个日期之间的小时差
  ///
  /// [start] 开始日期
  /// [end] 结束日期
  /// 返回小时差
  static int hoursBetween(DateTime start, DateTime end) {
    return end.difference(start).inHours;
  }

  /// 计算两个日期之间的分钟差
  ///
  /// [start] 开始日期
  /// [end] 结束日期
  /// 返回分钟差
  static int minutesBetween(DateTime start, DateTime end) {
    return end.difference(start).inMinutes;
  }

  /// 计算两个日期之间的秒数差
  ///
  /// [start] 开始日期
  /// [end] 结束日期
  /// 返回秒数差
  static int secondsBetween(DateTime start, DateTime end) {
    return end.difference(start).inSeconds;
  }

  /// 判断是否为今天
  ///
  /// [dateTime] 日期时间
  /// 返回是否为今天
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// 判断是否为昨天
  ///
  /// [dateTime] 日期时间
  /// 返回是否为昨天
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTimeUtils.yesterday();
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// 判断是否为明天
  ///
  /// [dateTime] 日期时间
  /// 返回是否为明天
  static bool isTomorrow(DateTime dateTime) {
    final tomorrow = DateTimeUtils.tomorrow();
    return dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day;
  }

  /// 判断是否为本周
  ///
  /// [dateTime] 日期时间
  /// 返回是否为本周
  static bool isThisWeek(DateTime dateTime) {
    final thisWeek = DateTimeUtils.thisWeek();
    final nextWeek = thisWeek.add(const Duration(days: 7));
    return dateTime.isAfter(thisWeek) && dateTime.isBefore(nextWeek);
  }

  /// 判断是否为本月
  ///
  /// [dateTime] 日期时间
  /// 返回是否为本月
  static bool isThisMonth(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month;
  }

  /// 判断是否为本年
  ///
  /// [dateTime] 日期时间
  /// 返回是否为本年
  static bool isThisYear(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year;
  }

  /// 格式化日期（yyyy-MM-dd）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDate(DateTime dateTime) {
    return format(dateTime, 'yyyy-MM-dd');
  }

  /// 格式化时间（HH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatTime(DateTime dateTime) {
    return format(dateTime, 'HH:mm:ss');
  }

  /// 格式化日期时间（yyyy-MM-dd HH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDateTime(DateTime dateTime) {
    return format(dateTime, 'yyyy-MM-dd HH:mm:ss');
  }

  /// 格式化日期时间（yyyy-MM-dd HH:mm）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDateTimeShort(DateTime dateTime) {
    return format(dateTime, 'yyyy-MM-dd HH:mm');
  }

  /// 格式化相对时间（刚刚、几分钟前等）
  ///
  /// [dateTime] 日期时间
  /// [locale] 语言环境
  /// 返回格式化后的字符串
  static String formatRelative(DateTime dateTime, [String? locale]) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return locale == 'en' ? 'just now' : '刚刚';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return locale == 'en'
          ? '$minutes minutes ago'
          : '$minutes分钟前';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return locale == 'en' ? '$hours hours ago' : '$hours小时前';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return locale == 'en' ? '$days days ago' : '$days天前';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return locale == 'en' ? '$weeks weeks ago' : '$weeks周前';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return locale == 'en' ? '$months months ago' : '$months个月前';
    } else {
      final years = (difference.inDays / 365).floor();
      return locale == 'en' ? '$years years ago' : '$years年前';
    }
  }
}

/// 日期时间扩展
extension DateTimeExtensions on DateTime {
  /// 格式化日期时间
  ///
  /// [pattern] 格式模式
  /// 返回格式化后的字符串
  String format(String pattern) {
    return DateTimeUtils.format(this, pattern);
  }

  /// 格式化日期（yyyy-MM-dd）
  ///
  /// 返回格式化后的字符串
  String toDateString() {
    return DateTimeUtils.formatDate(this);
  }

  /// 格式化时间（HH:mm:ss）
  ///
  /// 返回格式化后的字符串
  String toTimeString() {
    return DateTimeUtils.formatTime(this);
  }

  /// 格式化日期时间（yyyy-MM-dd HH:mm:ss）
  ///
  /// 返回格式化后的字符串
  String toDateTimeString() {
    return DateTimeUtils.formatDateTime(this);
  }

  /// 格式化相对时间（刚刚、几分钟前等）
  ///
  /// [locale] 语言环境
  /// 返回格式化后的字符串
  String toRelativeString([String? locale]) {
    return DateTimeUtils.formatRelative(this, locale);
  }

  /// 添加天数
  ///
  /// [days] 天数
  /// 返回添加后的DateTime
  DateTime addDays(int days) {
    return DateTimeUtils.addDays(this, days);
  }

  /// 添加小时
  ///
  /// [hours] 小时数
  /// 返回添加后的DateTime
  DateTime addHours(int hours) {
    return DateTimeUtils.addHours(this, hours);
  }

  /// 添加分钟
  ///
  /// [minutes] 分钟数
  /// 返回添加后的DateTime
  DateTime addMinutes(int minutes) {
    return DateTimeUtils.addMinutes(this, minutes);
  }

  /// 添加秒数
  ///
  /// [seconds] 秒数
  /// 返回添加后的DateTime
  DateTime addSeconds(int seconds) {
    return DateTimeUtils.addSeconds(this, seconds);
  }

  /// 判断是否为今天
  ///
  /// 返回是否为今天
  bool get isToday => DateTimeUtils.isToday(this);

  /// 判断是否为昨天
  ///
  /// 返回是否为昨天
  bool get isYesterday => DateTimeUtils.isYesterday(this);

  /// 判断是否为明天
  ///
  /// 返回是否为明天
  bool get isTomorrow => DateTimeUtils.isTomorrow(this);

  /// 判断是否为本周
  ///
  /// 返回是否为本周
  bool get isThisWeek => DateTimeUtils.isThisWeek(this);

  /// 判断是否为本月
  ///
  /// 返回是否为本月
  bool get isThisMonth => DateTimeUtils.isThisMonth(this);

  /// 判断是否为本年
  ///
  /// 返回是否为本年
  bool get isThisYear => DateTimeUtils.isThisYear(this);
}
