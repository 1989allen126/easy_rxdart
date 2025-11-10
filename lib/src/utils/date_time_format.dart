import 'package:intl/intl.dart';

/// 日期时间快速格式工具类
///
/// 提供常用的日期时间格式常量和快速格式化方法
class DateTimeFormat {
  // 日期格式
  /// 标准日期格式：yyyy-MM-dd
  static const String dateStandard = 'yyyy-MM-dd';

  /// 短日期格式：yy-MM-dd
  static const String dateShort = 'yy-MM-dd';

  /// 美式日期格式：MM/dd/yyyy
  static const String dateUS = 'MM/dd/yyyy';

  /// 欧式日期格式：dd/MM/yyyy
  static const String dateEU = 'dd/MM/yyyy';

  /// 中文日期格式：yyyy年MM月dd日
  static const String dateCN = 'yyyy年MM月dd日';

  /// 日期格式（无分隔符）：yyyyMMdd
  static const String dateCompact = 'yyyyMMdd';

  // 时间格式
  /// 标准时间格式：HH:mm:ss
  static const String timeStandard = 'HH:mm:ss';

  /// 短时间格式：HH:mm
  static const String timeShort = 'HH:mm';

  /// 12小时制时间格式：hh:mm:ss a
  static const String time12Hour = 'hh:mm:ss a';

  /// 12小时制短时间格式：hh:mm a
  static const String time12HourShort = 'hh:mm a';

  /// 时间格式（无分隔符）：HHmmss
  static const String timeCompact = 'HHmmss';

  // 日期时间格式
  /// 标准日期时间格式：yyyy-MM-dd HH:mm:ss
  static const String dateTimeStandard = 'yyyy-MM-dd HH:mm:ss';

  /// 短日期时间格式：yyyy-MM-dd HH:mm
  static const String dateTimeShort = 'yyyy-MM-dd HH:mm';

  /// ISO 8601 格式：yyyy-MM-ddTHH:mm:ss
  static const String dateTimeISO = 'yyyy-MM-ddTHH:mm:ss';

  /// ISO 8601 格式（带时区）：yyyy-MM-ddTHH:mm:ssZ
  static const String dateTimeISOWithTimezone = 'yyyy-MM-ddTHH:mm:ssZ';

  /// 美式日期时间格式：MM/dd/yyyy HH:mm:ss
  static const String dateTimeUS = 'MM/dd/yyyy HH:mm:ss';

  /// 欧式日期时间格式：dd/MM/yyyy HH:mm:ss
  static const String dateTimeEU = 'dd/MM/yyyy HH:mm:ss';

  /// 中文日期时间格式：yyyy年MM月dd日 HH:mm:ss
  static const String dateTimeCN = 'yyyy年MM月dd日 HH:mm:ss';

  /// 日期时间格式（无分隔符）：yyyyMMddHHmmss
  static const String dateTimeCompact = 'yyyyMMddHHmmss';

  // 周格式
  /// 周格式：EEEE（星期一、Tuesday等）
  static const String weekFull = 'EEEE';

  /// 短周格式：EEE（周一、Mon等）
  static const String weekShort = 'EEE';

  // 月份格式
  /// 月份格式：MMMM（一月、January等）
  static const String monthFull = 'MMMM';

  /// 短月份格式：MMM（1月、Jan等）
  static const String monthShort = 'MMM';

  // 快速格式化方法
  /// 格式化日期（yyyy-MM-dd）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String date(DateTime dateTime) {
    return DateFormat(dateStandard).format(dateTime);
  }

  /// 格式化时间（HH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String time(DateTime dateTime) {
    return DateFormat(timeStandard).format(dateTime);
  }

  /// 格式化日期时间（yyyy-MM-dd HH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateTime(DateTime dateTime) {
    return DateFormat(dateTimeStandard).format(dateTime);
  }

  /// 格式化短日期时间（yyyy-MM-dd HH:mm）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateTimeShortFormat(DateTime dateTime) {
    return DateFormat(dateTimeShort).format(dateTime);
  }

  /// 格式化ISO 8601格式（yyyy-MM-ddTHH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String iso(DateTime dateTime) {
    return DateFormat(dateTimeISO).format(dateTime);
  }

  /// 格式化美式日期（MM/dd/yyyy）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateUSFormat(DateTime dateTime) {
    return DateFormat(dateUS).format(dateTime);
  }

  /// 格式化欧式日期（dd/MM/yyyy）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateEUFormat(DateTime dateTime) {
    return DateFormat(dateEU).format(dateTime);
  }

  /// 格式化中文日期（yyyy年MM月dd日）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateCNFormat(DateTime dateTime) {
    return DateFormat(dateCN).format(dateTime);
  }

  /// 格式化中文日期时间（yyyy年MM月dd日 HH:mm:ss）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String dateTimeCNFormat(DateTime dateTime) {
    return DateFormat(dateTimeCN).format(dateTime);
  }

  /// 格式化短时间（HH:mm）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String timeShortFormat(DateTime dateTime) {
    return DateFormat(timeShort).format(dateTime);
  }

  /// 格式化12小时制时间（hh:mm:ss a）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String time12HourFormat(DateTime dateTime) {
    return DateFormat(time12Hour).format(dateTime);
  }

  /// 格式化12小时制短时间（hh:mm a）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String time12HourShortFormat(DateTime dateTime) {
    return DateFormat(time12HourShort).format(dateTime);
  }

  /// 格式化周（EEEE）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String weekFormat(DateTime dateTime) {
    return DateFormat(weekFull).format(dateTime);
  }

  /// 格式化短周（EEE）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String weekShortFormat(DateTime dateTime) {
    return DateFormat(weekShort).format(dateTime);
  }

  /// 格式化月份（MMMM）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String monthFormat(DateTime dateTime) {
    return DateFormat(monthFull).format(dateTime);
  }

  /// 格式化短月份（MMM）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String monthShortFormat(DateTime dateTime) {
    return DateFormat(monthShort).format(dateTime);
  }

  /// 使用自定义格式格式化日期时间
  ///
  /// [dateTime] 日期时间
  /// [pattern] 格式模式
  /// 返回格式化后的字符串
  static String custom(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// 解析日期时间字符串
  ///
  /// [dateString] 日期字符串
  /// [pattern] 格式模式
  /// 返回解析后的DateTime，如果解析失败则返回null
  static DateTime? parse(String dateString, String pattern) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 解析标准日期格式（yyyy-MM-dd）
  ///
  /// [dateString] 日期字符串
  /// 返回解析后的DateTime，如果解析失败则返回null
  static DateTime? parseDate(String dateString) {
    return parse(dateString, dateStandard);
  }

  /// 解析标准日期时间格式（yyyy-MM-dd HH:mm:ss）
  ///
  /// [dateString] 日期时间字符串
  /// 返回解析后的DateTime，如果解析失败则返回null
  static DateTime? parseDateTime(String dateString) {
    return parse(dateString, dateTimeStandard);
  }

  /// 解析ISO 8601格式（yyyy-MM-ddTHH:mm:ss）
  ///
  /// [dateString] 日期时间字符串
  /// 返回解析后的DateTime，如果解析失败则返回null
  static DateTime? parseISO(String dateString) {
    return parse(dateString, dateTimeISO);
  }
}

/// 日期时间快速格式扩展
extension DateTimeFormatExtensions on DateTime {
  /// 格式化日期（yyyy-MM-dd）
  String toDate() => DateTimeFormat.date(this);

  /// 格式化时间（HH:mm:ss）
  String toTime() => DateTimeFormat.time(this);

  /// 格式化日期时间（yyyy-MM-dd HH:mm:ss）
  String toDateTime() => DateTimeFormat.dateTime(this);

  /// 格式化短日期时间（yyyy-MM-dd HH:mm）
  String toDateTimeShort() => DateTimeFormat.dateTimeShortFormat(this);

  /// 格式化ISO 8601格式（yyyy-MM-ddTHH:mm:ss）
  String toISO() => DateTimeFormat.iso(this);

  /// 格式化美式日期（MM/dd/yyyy）
  String toDateUS() => DateTimeFormat.dateUSFormat(this);

  /// 格式化欧式日期（dd/MM/yyyy）
  String toDateEU() => DateTimeFormat.dateEUFormat(this);

  /// 格式化中文日期（yyyy年MM月dd日）
  String toDateCN() => DateTimeFormat.dateCNFormat(this);

  /// 格式化中文日期时间（yyyy年MM月dd日 HH:mm:ss）
  String toDateTimeCN() => DateTimeFormat.dateTimeCNFormat(this);

  /// 格式化短时间（HH:mm）
  String toTimeShort() => DateTimeFormat.timeShortFormat(this);

  /// 格式化12小时制时间（hh:mm:ss a）
  String toTime12Hour() => DateTimeFormat.time12HourFormat(this);

  /// 格式化12小时制短时间（hh:mm a）
  String toTime12HourShort() => DateTimeFormat.time12HourShortFormat(this);

  /// 格式化周（EEEE）
  String toWeek() => DateTimeFormat.weekFormat(this);

  /// 格式化短周（EEE）
  String toWeekShort() => DateTimeFormat.weekShortFormat(this);

  /// 格式化月份（MMMM）
  String toMonth() => DateTimeFormat.monthFormat(this);

  /// 格式化短月份（MMM）
  String toMonthShort() => DateTimeFormat.monthShortFormat(this);

  /// 使用自定义格式格式化日期时间
  ///
  /// [pattern] 格式模式
  String toCustom(String pattern) => DateTimeFormat.custom(this, pattern);
}

