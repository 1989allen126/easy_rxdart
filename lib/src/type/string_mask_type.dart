enum StringMaskType {
  none(
    type: 0,
    mask: "",
    keepStart: 0,
    keepEnd: 0,
    desc: "不脱敏",
  ),
  phone(
    type: 1,
    mask: "*",
    keepStart: 3,
    keepEnd: 4,
    desc: "手机号",
  ),
  email(
    type: 2,
    mask: "*",
    keepStart: 2,
    keepEnd: 0,
    desc: "邮箱",
  ),
  name(
    type: 3,
    mask: "*",
    keepStart: 1,
    keepEnd: 0,
    desc: "姓名",
  ),
  idCard(
    type: 4,
    mask: "*",
    keepStart: 6,
    keepEnd: 4,
    desc: "身份证号",
  ),
  bankCard(
    type: 5,
    mask: "*",
    keepStart: 4,
    keepEnd: 4,
    desc: "银行卡号",
  );

  const StringMaskType({
    required this.type,
    required this.mask,
    required this.keepStart,
    required this.keepEnd,
    required this.desc,
  });
  
  /// 类型
  final int type;
  /// 脱敏字符
  final String mask;
  /// 保留前几位
  final int keepStart;
  /// 保留后几位
  final int keepEnd;
  /// 描述
  final String desc;

  /// 根据类型获取脱敏类型
  ///
  /// [type] 类型
  /// 返回脱敏类型
  static StringMaskType fromType(int type) {
    return StringMaskType.values.firstWhere(
      (element) => element.type == type,
      orElse: () => StringMaskType.none,
    );
  }
}
