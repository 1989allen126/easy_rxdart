/// 国际化文本提供者接口
///
/// 用于提供国际化翻译文本，不依赖特定的国际化库
///
/// 使用示例：
///
/// 1. 使用默认提供者（内置英文和中文）：
/// ```dart
/// // 使用默认提供者
/// I18nDateTimeUtils.formatRelative(DateTime.now());
/// ```
///
/// 2. 使用自定义提供者（easy_localization）：
/// ```dart
/// import 'package:easy_localization/easy_localization.dart';
///
/// class EasyLocalizationProvider implements I18nTextProvider {
///   @override
///   String translate(String key, {Map<String, String>? namedArgs}) {
///     if (namedArgs != null) {
///       return key.tr(namedArgs: namedArgs);
///     } else {
///       return key.tr();
///     }
///   }
/// }
///
/// // 设置提供者
/// I18nDateTimeUtils.setTextProvider(EasyLocalizationProvider());
/// ```
///
/// 3. 使用自定义提供者（其他国际化库）：
/// ```dart
/// class MyCustomProvider implements I18nTextProvider {
///   @override
///   String translate(String key, {Map<String, String>? namedArgs}) {
///     // 使用你的国际化库
///     return myI18nLibrary.translate(key, namedArgs);
///   }
/// }
///
/// I18nDateTimeUtils.setTextProvider(MyCustomProvider());
/// ```
///
/// 4. 使用 buildWith 方法临时设置提供者：
/// ```dart
/// final result = I18nDateTimeUtils.buildWith(
///   MyCustomProvider(),
///   () => I18nDateTimeUtils.formatRelative(dateTime),
/// );
/// ```
abstract class I18nTextProvider {
  /// 获取翻译文本
  ///
  /// [key] 翻译键
  /// [namedArgs] 命名参数（可选）
  /// 返回翻译后的文本
  String translate(String key, {Map<String, String>? namedArgs});
}

/// 默认国际化文本提供者（简单实现）
///
/// 如果未设置自定义提供者，将使用此默认实现
class DefaultI18nTextProvider implements I18nTextProvider {
  final Map<String, Map<String, String>> _translations;

  /// 构造函数
  ///
  /// [translations] 翻译映射，格式为 {locale: {key: value}}
  DefaultI18nTextProvider({
    Map<String, Map<String, String>>? translations,
    String locale = 'en',
  }) : _translations = translations ?? _defaultTranslations {
    _currentLocale = locale;
  }

  String _currentLocale = 'en';

  /// 设置当前语言环境
  void setLocale(String locale) {
    _currentLocale = locale;
  }

  @override
  String translate(String key, {Map<String, String>? namedArgs,}) {
    final localeTranslations =
        _translations[_currentLocale] ?? _translations['en'] ?? {};
    String text = localeTranslations[key] ?? key;

    // 替换命名参数
    if (namedArgs != null) {
      namedArgs.forEach((name, value) {
        text = text.replaceAll('{$name}', value);
      });
    }

    return text;
  }

  static final Map<String, Map<String, String>> _defaultTranslations = {
    'en': {
      'just_now': 'just now',
      'minutes_ago': '{count} minutes ago',
      'hours_ago': '{count} hours ago',
      'days_ago': '{count} days ago',
      'weeks_ago': '{count} weeks ago',
      'months_ago': '{count} months ago',
      'years_ago': '{count} years ago',
      'in_seconds': 'in {count} seconds',
      'in_minutes': 'in {count} minutes',
      'in_hours': 'in {count} hours',
      'in_days': 'in {count} days',
      'in_weeks': 'in {count} weeks',
      'in_months': 'in {count} months',
      'in_years': 'in {count} years',
    },
    'zh': {
      'just_now': '刚刚',
      'minutes_ago': '{count}分钟前',
      'hours_ago': '{count}小时前',
      'days_ago': '{count}天前',
      'weeks_ago': '{count}周前',
      'months_ago': '{count}个月前',
      'years_ago': '{count}年前',
      'in_seconds': '{count}秒后',
      'in_minutes': '{count}分钟后',
      'in_hours': '{count}小时后',
      'in_days': '{count}天后',
      'in_weeks': '{count}周后',
      'in_months': '{count}个月后',
      'in_years': '{count}年后',
    },
  };
}
