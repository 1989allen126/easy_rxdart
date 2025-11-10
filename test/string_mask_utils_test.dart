import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringMaskUtils 单元测试', () {
    group('手机号脱敏', () {
      test('正常手机号脱敏', () {
        expect(StringMaskUtils.maskPhone('13812345678'), '138****5678');
        expect(StringMaskUtils.maskPhone('15912345678'), '159****5678');
        expect(StringMaskUtils.maskPhone('18812345678'), '188****5678');
      });

      test('手机号脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskPhone('13812345678', keepStart: 2, keepEnd: 2),
          '13*******78', // 11-2-2=7个*
        );
        expect(
          StringMaskUtils.maskPhone('13812345678', maskChar: 'X'),
          '138XXXX5678',
        );
        expect(
          StringMaskUtils.maskPhone('13812345678', maskChar: '●'),
          '138●●●●5678',
        );
      });

      test('手机号脱敏 - 扩展方法', () {
        expect('13812345678'.maskPhone(), '138****5678');
        expect('13812345678'.maskPhone(maskChar: 'X'), '138XXXX5678');
        expect('13812345678'.maskPhone(keepStart: 2, keepEnd: 2), '13*******78'); // 11-2-2=7个*
      });

      test('手机号脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskPhone(null), '');
        expect(StringMaskUtils.maskPhone(''), '');
      });

      test('手机号脱敏 - 临界值：长度不足', () {
        expect(StringMaskUtils.maskPhone('1381234567'), '1381234567'); // 10位
        expect(StringMaskUtils.maskPhone('138123456789'), '138123456789'); // 12位
        expect(StringMaskUtils.maskPhone('123'), '123'); // 太短
      });

      test('手机号脱敏 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskPhone('13812345678', keepStart: 7, keepEnd: 4),
          '13812345678', // 7+4=11，等于总长度，返回原值
        );
      });

      test('手机号脱敏 - 临界值：保留位数超过总长度', () {
        expect(
          StringMaskUtils.maskPhone('13812345678', keepStart: 8, keepEnd: 4),
          '13812345678', // 8+4=12，超过总长度，返回原值
        );
      });

      test('手机号脱敏 - 异常：包含非数字字符', () {
        expect(StringMaskUtils.maskPhone('1381234567a'), '1381234567a'); // 包含字母
        expect(StringMaskUtils.maskPhone('138-1234-5678'), '138****5678'); // 包含连字符，会被清理
        expect(StringMaskUtils.maskPhone('138 1234 5678'), '138****5678'); // 包含空格，会被清理
      });

      test('手机号脱敏 - 边界：保留前0位', () {
        expect(
          StringMaskUtils.maskPhone('13812345678', keepStart: 0, keepEnd: 4),
          '*******5678',
        );
      });

      test('手机号脱敏 - 边界：保留后0位', () {
        expect(
          StringMaskUtils.maskPhone('13812345678', keepStart: 3, keepEnd: 0),
          '138********',
        );
      });
    });

    group('身份证号脱敏', () {
      test('正常身份证号脱敏 - 18位', () {
        expect(
          StringMaskUtils.maskIdCard('320123199001011234'),
          '320123********1234',
        );
      });

      test('正常身份证号脱敏 - 15位', () {
        expect(
          StringMaskUtils.maskIdCard('320123900101123'),
          '320123*****1123', // 15-6-4=5个*
        );
      });

      test('身份证号脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskIdCard('320123199001011234', keepStart: 3, keepEnd: 3),
          '320************234', // 18-3-3=12个*
        );
        expect(
          StringMaskUtils.maskIdCard('320123199001011234', maskChar: 'X'),
          '320123XXXXXXXX1234',
        );
      });

      test('身份证号脱敏 - 扩展方法', () {
        expect('320123199001011234'.maskIdCard(), '320123********1234');
        expect('320123900101123'.maskIdCard(), '320123*****1123'); // 15-6-4=5个*
      });

      test('身份证号脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskIdCard(null), '');
        expect(StringMaskUtils.maskIdCard(''), '');
      });

      test('身份证号脱敏 - 临界值：长度不符合', () {
        expect(StringMaskUtils.maskIdCard('32012319900101123'), '32012319900101123'); // 17位
        expect(StringMaskUtils.maskIdCard('3201231990010112345'), '3201231990010112345'); // 19位
        expect(StringMaskUtils.maskIdCard('123'), '123'); // 太短
      });

      test('身份证号脱敏 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskIdCard('320123199001011234', keepStart: 10, keepEnd: 8),
          '320123199001011234', // 10+8=18，等于总长度，返回原值
        );
      });

      test('身份证号脱敏 - 异常：包含非数字字符（除X外）', () {
        expect(StringMaskUtils.maskIdCard('32012319900101123a'), '32012319900101123a'); // 包含字母a
        expect(StringMaskUtils.maskIdCard('32012319900101123X'), '320123********123X'); // 最后一位是X，正常
        expect(StringMaskUtils.maskIdCard('32012319900101123x'), '320123********123x'); // 最后一位是x，正常
      });

      test('身份证号脱敏 - 边界：保留前0位', () {
        expect(
          StringMaskUtils.maskIdCard('320123199001011234', keepStart: 0, keepEnd: 4),
          '**************1234',
        );
      });

      test('身份证号脱敏 - 边界：保留后0位', () {
        expect(
          StringMaskUtils.maskIdCard('320123199001011234', keepStart: 6, keepEnd: 0),
          '320123************',
        );
      });
    });

    group('银行卡号脱敏', () {
      test('正常银行卡号脱敏', () {
        expect(
          StringMaskUtils.maskBankCard('6222021234567890'),
          '6222********7890', // 16-4-4=8个*
        );
        expect(
          StringMaskUtils.maskBankCard('6222021234567890123'),
          '6222***********0123', // 19-4-4=11个*
        );
      });

      test('银行卡号脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskBankCard('6222021234567890', keepStart: 2, keepEnd: 2),
          '62************90', // 16-2-2=12个*
        );
        expect(
          StringMaskUtils.maskBankCard('6222021234567890', maskChar: 'X'),
          '6222XXXXXXXX7890',
        );
      });

      test('银行卡号脱敏 - 扩展方法', () {
        expect('6222021234567890'.maskBankCard(), '6222********7890'); // 16-4-4=8个*
        expect('6222021234567890123'.maskBankCard(), '6222***********0123'); // 19-4-4=11个*
      });

      test('银行卡号脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskBankCard(null), '');
        expect(StringMaskUtils.maskBankCard(''), '');
      });

      test('银行卡号脱敏 - 临界值：长度不足8位', () {
        expect(StringMaskUtils.maskBankCard('1234567'), '1234567'); // 7位
        expect(StringMaskUtils.maskBankCard('123456'), '123456'); // 6位
        expect(StringMaskUtils.maskBankCard('12345'), '12345'); // 5位
      });

      test('银行卡号脱敏 - 临界值：正好8位', () {
        expect(StringMaskUtils.maskBankCard('12345678'), '12345678'); // 8位，4+4=8等于总长度，返回原值
      });

      test('银行卡号脱敏 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskBankCard('12345678', keepStart: 4, keepEnd: 4),
          '12345678', // 4+4=8，等于总长度，返回原值
        );
      });

      test('银行卡号脱敏 - 异常：包含非数字字符', () {
        expect(StringMaskUtils.maskBankCard('622202123456789a'), '622202123456789a'); // 包含字母
        expect(StringMaskUtils.maskBankCard('6222-0212-3456-7890'), '6222********7890'); // 包含连字符，会被清理
      });

      test('银行卡号脱敏 - 边界：保留前0位', () {
        expect(
          StringMaskUtils.maskBankCard('6222021234567890', keepStart: 0, keepEnd: 4),
          '************7890',
        );
      });

      test('银行卡号脱敏 - 边界：保留后0位', () {
        expect(
          StringMaskUtils.maskBankCard('6222021234567890', keepStart: 4, keepEnd: 0),
          '6222************',
        );
      });
    });

    group('邮箱脱敏', () {
      test('正常邮箱脱敏', () {
        expect(
          StringMaskUtils.maskEmail('test@example.com'),
          'te**@example.com',
        );
        expect(
          StringMaskUtils.maskEmail('abc123@example.com'),
          'ab****@example.com',
        );
        expect(
          StringMaskUtils.maskEmail('user.name@example.com'),
          'us*******@example.com',
        );
      });

      test('邮箱脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskEmail('test@example.com', keepStart: 1),
          't***@example.com',
        );
        expect(
          StringMaskUtils.maskEmail('test@example.com', keepStart: 3),
          'tes*@example.com',
        );
        expect(
          StringMaskUtils.maskEmail('test@example.com', maskChar: 'X'),
          'teXX@example.com',
        );
      });

      test('邮箱脱敏 - 扩展方法', () {
        expect('test@example.com'.maskEmail(), 'te**@example.com');
        expect('abc123@example.com'.maskEmail(), 'ab****@example.com');
      });

      test('邮箱脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskEmail(null), '');
        expect(StringMaskUtils.maskEmail(''), '');
      });

      test('邮箱脱敏 - 临界值：本地部分太短', () {
        expect(StringMaskUtils.maskEmail('a@example.com'), 'a@example.com'); // 1位，keepStart=2但只有1位，返回原值
        expect(StringMaskUtils.maskEmail('ab@example.com'), 'a*@example.com'); // 2位，keepStart=2，返回"a*"
      });

      test('邮箱脱敏 - 临界值：本地部分只有1位', () {
        expect(StringMaskUtils.maskEmail('a@example.com'), 'a@example.com'); // 1位，keepStart=2但只有1位，返回原值
      });

      test('邮箱脱敏 - 异常：格式不正确', () {
        expect(StringMaskUtils.maskEmail('invalid-email'), 'invalid-email'); // 没有@
        expect(StringMaskUtils.maskEmail('test@'), 'test@'); // 没有域名
        expect(StringMaskUtils.maskEmail('@example.com'), '@example.com'); // 没有本地部分
        expect(StringMaskUtils.maskEmail('test@example'), 'test@example'); // 没有顶级域名
      });

      test('邮箱脱敏 - 异常：多个@符号', () {
        expect(StringMaskUtils.maskEmail('test@@example.com'), 'test@@example.com'); // 多个@
      });

      test('邮箱脱敏 - 边界：长邮箱', () {
        expect(
          StringMaskUtils.maskEmail('verylongemailaddress@example.com'),
          've******************@example.com', // 本地部分22位，keepStart=2，脱敏20位
        );
      });
    });

    group('姓名脱敏', () {
      test('正常姓名脱敏', () {
        expect(StringMaskUtils.maskName('张三'), '张*');
        expect(StringMaskUtils.maskName('李四'), '李*');
        expect(StringMaskUtils.maskName('王五'), '王*');
      });

      test('姓名脱敏 - 多字姓名', () {
        expect(StringMaskUtils.maskName('欧阳修'), '欧**'); // keepStart=1, keepEnd=0，3-1=2个*
        expect(StringMaskUtils.maskName('欧阳修', keepEnd: 1), '欧*修'); // keepStart=1, keepEnd=1，3-1-1=1个*
        expect(StringMaskUtils.maskName('司马相如'), '司***'); // keepStart=1, keepEnd=0，4-1=3个*
      });

      test('姓名脱敏 - 自定义参数', () {
        expect(StringMaskUtils.maskName('张三', keepStart: 0, keepEnd: 1), '*三'); // keepStart=0, keepEnd=1，2-0-1=1个*
        expect(StringMaskUtils.maskName('张三', maskChar: 'X'), '张X'); // keepStart=1, keepEnd=0，2-1=1个X
        expect(StringMaskUtils.maskName('欧阳修', keepStart: 2, keepEnd: 1), '欧阳*'); // keepStart=2, keepEnd=1，3-2-1=0个*，但3<=2+1，所以返回"欧阳"+"*"
      });

      test('姓名脱敏 - 扩展方法', () {
        expect('张三'.maskName(), '张*'); // keepStart=1, keepEnd=0，2-1=1个*
        expect('欧阳修'.maskName(), '欧**'); // keepStart=1, keepEnd=0，3-1=2个*
      });

      test('姓名脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskName(null), '');
        expect(StringMaskUtils.maskName(''), '');
      });

      test('姓名脱敏 - 临界值：单字姓名', () {
        expect(StringMaskUtils.maskName('张'), '张'); // 1位，keepStart=1, keepEnd=0，1<=1+0，返回"张"+""
      });

      test('姓名脱敏 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskName('张三', keepStart: 1, keepEnd: 1),
          '张*', // 1+1=2，等于总长度，但2<=1+1，所以返回"张"+"*"
        );
      });

      test('姓名脱敏 - 临界值：保留位数超过总长度', () {
        expect(
          StringMaskUtils.maskName('张三', keepStart: 2, keepEnd: 1),
          '张三', // 2+1=3，超过总长度，返回原值
        );
      });

      test('姓名脱敏 - 边界：保留前0位', () {
        expect(
          StringMaskUtils.maskName('张三', keepStart: 0, keepEnd: 1),
          '*三',
        );
      });

      test('姓名脱敏 - 边界：保留后0位', () {
        expect(
          StringMaskUtils.maskName('张三', keepStart: 1, keepEnd: 0),
          '张*',
        );
      });
    });

    group('车牌号脱敏', () {
      test('正常车牌号脱敏', () {
        expect(StringMaskUtils.maskPlateNumber('京A12345'), '京A***45');
        expect(StringMaskUtils.maskPlateNumber('粤B12345'), '粤B***45');
        expect(StringMaskUtils.maskPlateNumber('沪C123456'), '沪C****56');
      });

      test('车牌号脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskPlateNumber('京A12345', maskChar: 'X'),
          '京AXXX45',
        );
      });

      test('车牌号脱敏 - 扩展方法', () {
        expect('京A12345'.maskPlateNumber(), '京A***45');
        expect('粤B12345'.maskPlateNumber(), '粤B***45');
      });

      test('车牌号脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskPlateNumber(null), '');
        expect(StringMaskUtils.maskPlateNumber(''), '');
      });

      test('车牌号脱敏 - 临界值：长度不符合', () {
        expect(StringMaskUtils.maskPlateNumber('京A123'), '京A123'); // 5位，太短
        expect(StringMaskUtils.maskPlateNumber('京A1234'), '京A**34'); // 6位
        expect(StringMaskUtils.maskPlateNumber('京A1234567'), '京A1234567'); // 9位，太长
      });

      test('车牌号脱敏 - 临界值：正好4位', () {
        expect(StringMaskUtils.maskPlateNumber('京A12'), '京A12'); // 4位，太短
      });

      test('车牌号脱敏 - 边界：最短有效长度', () {
        expect(StringMaskUtils.maskPlateNumber('京A1234'), '京A**34'); // 6位
      });
    });

    group('地址脱敏', () {
      test('正常地址脱敏', () {
        expect(
          StringMaskUtils.maskAddress('北京市朝阳区xxx街道xxx号'),
          '北京市*********xx号', // keepStart=3, keepEnd=3，总长度15，15-3-3=9个*
        );
      });

      test('地址脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskAddress('北京市朝阳区xxx街道xxx号', keepStart: 2, keepEnd: 2),
          '北京***********x号', // keepStart=2, keepEnd=2，总长度15，15-2-2=11个*
        );
        expect(
          StringMaskUtils.maskAddress('北京市朝阳区xxx街道xxx号', maskChar: 'X'),
          '北京市XXXXXXXXXxx号', // keepStart=3, keepEnd=3，总长度15，15-3-3=9个X
        );
      });

      test('地址脱敏 - 扩展方法', () {
        expect('北京市朝阳区xxx街道xxx号'.maskAddress(), '北京市*********xx号'); // keepStart=3, keepEnd=3，总长度15，15-3-3=9个*
      });

      test('地址脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskAddress(null), '');
        expect(StringMaskUtils.maskAddress(''), '');
      });

      test('地址脱敏 - 临界值：长度不足', () {
        expect(StringMaskUtils.maskAddress('北京'), '北京'); // 2位，小于keepStart+keepEnd
        expect(StringMaskUtils.maskAddress('北京市'), '北京市'); // 3位，等于keepStart+keepEnd
      });
    });

    group('自定义脱敏', () {
      test('正常自定义脱敏', () {
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 2, keepEnd: 2),
          '12******90', // 10-2-2=6个*
        );
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 3, keepEnd: 3),
          '123****890', // 10-3-3=4个*
        );
      });

      test('自定义脱敏 - 自定义参数', () {
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 2, keepEnd: 2, maskChar: 'X'),
          '12XXXXXX90',
        );
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 2, keepEnd: 2, minLength: 5),
          '12******90',
        );
      });

      test('自定义脱敏 - 扩展方法', () {
        expect('1234567890'.maskCustom(keepStart: 2, keepEnd: 2), '12******90');
      });

      test('自定义脱敏 - 临界值：空值', () {
        expect(StringMaskUtils.maskCustom(null, keepStart: 2, keepEnd: 2), '');
        expect(StringMaskUtils.maskCustom('', keepStart: 2, keepEnd: 2), '');
      });

      test('自定义脱敏 - 临界值：长度小于最小长度', () {
        expect(
          StringMaskUtils.maskCustom('123', keepStart: 1, keepEnd: 1, minLength: 4),
          '123', // 长度3小于minLength 4，返回原值
        );
      });

      test('自定义脱敏 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskCustom('1234', keepStart: 2, keepEnd: 2),
          '1234', // 2+2=4，等于总长度，返回原值
        );
      });

      test('自定义脱敏 - 临界值：保留位数超过总长度', () {
        expect(
          StringMaskUtils.maskCustom('1234', keepStart: 3, keepEnd: 2),
          '1234', // 3+2=5，超过总长度，返回原值
        );
      });

      test('自定义脱敏 - 边界：保留前0位', () {
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 0, keepEnd: 2),
          '********90',
        );
      });

      test('自定义脱敏 - 边界：保留后0位', () {
        expect(
          StringMaskUtils.maskCustom('1234567890', keepStart: 2, keepEnd: 0),
          '12********',
        );
      });
    });

    group('脱敏中间部分', () {
      test('正常脱敏中间部分', () {
        expect(
          StringMaskUtils.maskMiddle('1234567890', keepStart: 2, keepEnd: 2, maskLength: 4),
          '12****90', // 指定maskLength=4
        );
        expect(
          StringMaskUtils.maskMiddle('1234567890', keepStart: 2, keepEnd: 2),
          '12******90', // 自动计算maskLength=10-2-2=6
        );
      });

      test('脱敏中间部分 - 自定义参数', () {
        expect(
          StringMaskUtils.maskMiddle('1234567890', keepStart: 2, keepEnd: 2, maskLength: 6, maskChar: 'X'),
          '12XXXXXX90',
        );
      });

      test('脱敏中间部分 - 扩展方法', () {
        expect('1234567890'.maskMiddle(keepStart: 2, keepEnd: 2), '12******90'); // 自动计算maskLength=6
        expect('1234567890'.maskMiddle(keepStart: 2, keepEnd: 2, maskLength: 4), '12****90'); // 指定maskLength=4
      });

      test('脱敏中间部分 - 临界值：空值', () {
        expect(StringMaskUtils.maskMiddle(null, keepStart: 2, keepEnd: 2), '');
        expect(StringMaskUtils.maskMiddle('', keepStart: 2, keepEnd: 2), '');
      });

      test('脱敏中间部分 - 临界值：保留位数等于总长度', () {
        expect(
          StringMaskUtils.maskMiddle('1234', keepStart: 2, keepEnd: 2),
          '1234', // 2+2=4，等于总长度，返回原值
        );
      });

      test('脱敏中间部分 - 临界值：保留位数超过总长度', () {
        expect(
          StringMaskUtils.maskMiddle('1234', keepStart: 3, keepEnd: 2),
          '1234', // 3+2=5，超过总长度，返回原值
        );
      });
    });

    group('脱敏全部', () {
      test('正常脱敏全部', () {
        expect(StringMaskUtils.maskAll('1234567890'), '1********0');
        expect(StringMaskUtils.maskAll('1234567890', keepStart: 2, keepEnd: 2), '12******90');
      });

      test('脱敏全部 - 自定义参数', () {
        expect(StringMaskUtils.maskAll('1234567890', maskChar: 'X'), '1XXXXXXXX0');
        expect(StringMaskUtils.maskAll('1234567890', keepStart: 0, keepEnd: 1), '*********0');
      });

      test('脱敏全部 - 扩展方法', () {
        expect('1234567890'.maskAll(), '1********0');
        expect('1234567890'.maskAll(keepStart: 2, keepEnd: 2), '12******90');
      });

      test('脱敏全部 - 临界值：空值', () {
        expect(StringMaskUtils.maskAll(null), '');
        expect(StringMaskUtils.maskAll(''), '');
      });

      test('脱敏全部 - 临界值：单字符', () {
        expect(StringMaskUtils.maskAll('1'), '1'); // 1位，保留1+1=2，超过总长度，返回原值
      });

      test('脱敏全部 - 临界值：双字符', () {
        expect(StringMaskUtils.maskAll('12'), '12'); // 2位，保留1+1=2，等于总长度，返回原值
      });
    });

    group('综合测试', () {
      test('多种脱敏方法组合', () {
        final phone = '13812345678';
        final idCard = '320123199001011234';
        final bankCard = '6222021234567890';
        final email = 'test@example.com';
        final name = '张三';

        expect(phone.maskPhone(), '138****5678');
        expect(idCard.maskIdCard(), '320123********1234');
        expect(bankCard.maskBankCard(), '6222********7890');
        expect(email.maskEmail(), 'te**@example.com');
        expect(name.maskName(), '张*');
      });

      test('特殊字符处理', () {
        // 手机号包含空格和连字符
        expect(StringMaskUtils.maskPhone('138-1234-5678'), '138****5678');
        expect(StringMaskUtils.maskPhone('138 1234 5678'), '138****5678');

        // 银行卡号包含空格和连字符
        expect(StringMaskUtils.maskBankCard('6222-0212-3456-7890'), '6222********7890');
        expect(StringMaskUtils.maskBankCard('6222 0212 3456 7890'), '6222********7890');
      });

      test('边界值组合测试', () {
        // 最小长度
        expect(StringMaskUtils.maskPhone('13812345678'), '138****5678'); // 11位
        expect(StringMaskUtils.maskIdCard('320123900101123'), '320123*****1123'); // 15位，15-6-4=5个*
        expect(StringMaskUtils.maskBankCard('12345678'), '12345678'); // 8位，4+4=8等于总长度，返回原值

        // 最大长度
        expect(StringMaskUtils.maskIdCard('320123199001011234'), '320123********1234'); // 18位
        expect(StringMaskUtils.maskIdCard('320123900101123'), '320123*****1123'); // 15位，15-6-4=5个*
        expect(StringMaskUtils.maskBankCard('6222021234567890123456'), '6222**************3456'); // 22位，22-4-4=14个*
      });
    });
  });
}

