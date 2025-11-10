import 'package:intl/intl.dart';

import 'i18n_text_provider.dart';

/// 国际化日期时间工具类
class I18nDateTimeUtils {
  /// 翻译文本提供者
  static I18nTextProvider? _textProvider;

  /// 设置翻译文本提供者
  ///
  /// [provider] 翻译文本提供者
  static void setTextProvider(I18nTextProvider provider) {
    _textProvider = provider;
  }

  /// 获取翻译文本提供者
  ///
  /// 如果未设置，返回默认提供者
  static I18nTextProvider get _provider {
    return _textProvider ??= DefaultI18nTextProvider();
  }

  /// 使用自定义翻译文本提供者构建
  ///
  /// [provider] 翻译文本提供者
  /// [builder] 构建函数
  /// 返回构建结果
  static T buildWith<T>(I18nTextProvider provider, T Function() builder) {
    final oldProvider = _textProvider;
    _textProvider = provider;
    try {
      return builder();
    } finally {
      _textProvider = oldProvider;
    }
  }

  /// 格式化日期时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// [pattern] 格式模式
  /// 返回格式化后的字符串
  static String format(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// 格式化相对时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return _provider.translate('just_now');
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return _provider.translate(
        'minutes_ago',
        namedArgs: {'count': minutes.toString()},
      );
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return _provider.translate(
        'hours_ago',
        namedArgs: {'count': hours.toString()},
      );
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return _provider.translate(
        'days_ago',
        namedArgs: {'count': days.toString()},
      );
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return _provider.translate(
        'weeks_ago',
        namedArgs: {'count': weeks.toString()},
      );
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return _provider.translate(
        'months_ago',
        namedArgs: {'count': months.toString()},
      );
    } else {
      final years = (difference.inDays / 365).floor();
      return _provider.translate(
        'years_ago',
        namedArgs: {'count': years.toString()},
      );
    }
  }

  /// 格式化相对时间（afterAgo格式）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatAfterAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inSeconds > 0) {
      // 未来时间
      if (difference.inSeconds < 60) {
        return _provider.translate(
          'in_seconds',
          namedArgs: {'count': difference.inSeconds.toString()},
        );
      } else if (difference.inMinutes < 60) {
        return _provider.translate(
          'in_minutes',
          namedArgs: {'count': difference.inMinutes.toString()},
        );
      } else if (difference.inHours < 24) {
        return _provider.translate(
          'in_hours',
          namedArgs: {'count': difference.inHours.toString()},
        );
      } else if (difference.inDays < 7) {
        return _provider.translate(
          'in_days',
          namedArgs: {'count': difference.inDays.toString()},
        );
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return _provider.translate(
          'in_weeks',
          namedArgs: {'count': weeks.toString()},
        );
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return _provider.translate(
          'in_months',
          namedArgs: {'count': months.toString()},
        );
      } else {
        final years = (difference.inDays / 365).floor();
        return _provider.translate(
          'in_years',
          namedArgs: {'count': years.toString()},
        );
      }
    } else {
      // 过去时间
      return formatRelative(dateTime);
    }
  }

  /// 格式化日期（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMd().format(dateTime);
  }

  /// 格式化时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatTime(DateTime dateTime) {
    return DateFormat.Hms().format(dateTime);
  }

  /// 格式化日期时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMd().add_Hms().format(dateTime);
  }

  /// 格式化短日期时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDateTimeShort(DateTime dateTime) {
    return DateFormat.yMd().add_Hm().format(dateTime);
  }

  /// 格式化长日期时间（国际化）
  ///
  /// [dateTime] 日期时间
  /// 返回格式化后的字符串
  static String formatDateTimeLong(DateTime dateTime) {
    return DateFormat.yMMMMEEEEd().add_Hms().format(dateTime);
  }
}

/// 日期时间国际化扩展
extension DateTimeI18nExtensions on DateTime {
  /// 格式化相对时间（国际化）
  ///
  /// 返回格式化后的字符串
  String toRelativeI18n() {
    return I18nDateTimeUtils.formatRelative(this);
  }

  /// 格式化相对时间（afterAgo格式，国际化）
  ///
  /// 返回格式化后的字符串
  String toAfterAgoI18n() {
    return I18nDateTimeUtils.formatAfterAgo(this);
  }

  /// 格式化日期时间（国际化）
  ///
  /// [pattern] 格式模式
  /// 返回格式化后的字符串
  String formatI18n(String pattern) {
    return I18nDateTimeUtils.format(this, pattern);
  }

  /// 格式化日期（国际化）
  ///
  /// 返回格式化后的字符串
  String toDateI18n() {
    return I18nDateTimeUtils.formatDate(this);
  }

  /// 格式化时间（国际化）
  ///
  /// 返回格式化后的字符串
  String toTimeI18n() {
    return I18nDateTimeUtils.formatTime(this);
  }

  /// 格式化日期时间（国际化）
  ///
  /// 返回格式化后的字符串
  String toDateTimeI18n() {
    return I18nDateTimeUtils.formatDateTime(this);
  }

  /// 格式化短日期时间（国际化）
  ///
  /// 返回格式化后的字符串
  String toDateTimeShortI18n() {
    return I18nDateTimeUtils.formatDateTimeShort(this);
  }

  /// 格式化长日期时间（国际化）
  ///
  /// 返回格式化后的字符串
  String toDateTimeLongI18n() {
    return I18nDateTimeUtils.formatDateTimeLong(this);
  }
}
