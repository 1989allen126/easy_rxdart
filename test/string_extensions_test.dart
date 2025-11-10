import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions 命名规则转换测试', () {
    group('toCamelCase - 下划线转小驼峰', () {
      test('基本转换', () {
        expect('user_name'.toCamelCase, 'userName');
        expect('user_name_test'.toCamelCase, 'userNameTest');
      });

      test('单个单词', () {
        expect('user'.toCamelCase, 'user');
        expect('User'.toCamelCase, 'user');
      });

      test('多个下划线', () {
        expect('user_name_test_case'.toCamelCase, 'userNameTestCase');
      });

      test('空字符串', () {
        expect(''.toCamelCase, '');
      });

      test('只有下划线', () {
        expect('___'.toCamelCase, '___');
      });

      test('下划线开头', () {
        expect('_user_name'.toCamelCase, 'userName');
      });

      test('下划线结尾', () {
        expect('user_name_'.toCamelCase, 'userName');
      });

      test('混合大小写', () {
        expect('USER_NAME'.toCamelCase, 'userName');
        expect('User_Name'.toCamelCase, 'userName');
      });
    });

    group('toPascalCase - 下划线转大驼峰', () {
      test('基本转换', () {
        expect('user_name'.toPascalCase, 'UserName');
        expect('user_name_test'.toPascalCase, 'UserNameTest');
      });

      test('单个单词', () {
        expect('user'.toPascalCase, 'User');
        expect('User'.toPascalCase, 'User');
      });

      test('多个下划线', () {
        expect('user_name_test_case'.toPascalCase, 'UserNameTestCase');
      });

      test('空字符串', () {
        expect(''.toPascalCase, '');
      });

      test('下划线开头', () {
        expect('_user_name'.toPascalCase, 'UserName');
      });

      test('下划线结尾', () {
        expect('user_name_'.toPascalCase, 'UserName');
      });

      test('混合大小写', () {
        expect('USER_NAME'.toPascalCase, 'UserName');
        expect('User_Name'.toPascalCase, 'UserName');
      });
    });

    group('toSnakeCase - 驼峰转下划线', () {
      test('基本转换 - camelCase', () {
        expect('userName'.toSnakeCase, 'user_name');
        expect('userNameTest'.toSnakeCase, 'user_name_test');
      });

      test('基本转换 - PascalCase', () {
        expect('UserName'.toSnakeCase, 'user_name');
        expect('UserNameTest'.toSnakeCase, 'user_name_test');
      });

      test('单个单词', () {
        expect('user'.toSnakeCase, 'user');
        expect('User'.toSnakeCase, 'user');
      });

      test('连续大写字母', () {
        expect('XMLParser'.toSnakeCase, 'x_m_l_parser');
        expect('HTTPServer'.toSnakeCase, 'h_t_t_p_server');
      });

      test('空字符串', () {
        expect(''.toSnakeCase, '');
      });

      test('数字', () {
        expect('userName123'.toSnakeCase, 'user_name123');
        expect('User123Name'.toSnakeCase, 'user123_name');
      });

      test('混合大小写', () {
        expect('userNameTestCase'.toSnakeCase, 'user_name_test_case');
        expect('UserNameTestCase'.toSnakeCase, 'user_name_test_case');
      });
    });

    group('capitalize - 首字母大写', () {
      test('基本转换', () {
        expect('hello'.capitalize, 'Hello');
        expect('world'.capitalize, 'World');
      });

      test('已是大写', () {
        expect('Hello'.capitalize, 'Hello');
        expect('HELLO'.capitalize, 'Hello');
      });

      test('空字符串', () {
        expect(''.capitalize, '');
      });

      test('单个字符', () {
        expect('h'.capitalize, 'H');
        expect('H'.capitalize, 'H');
      });

      test('数字开头', () {
        expect('123hello'.capitalize, '123hello');
      });
    });

    group('capitalizeWords - 每个单词首字母大写', () {
      test('基本转换', () {
        expect('hello world'.capitalizeWords, 'Hello World');
        expect('hello world test'.capitalizeWords, 'Hello World Test');
      });

      test('单个单词', () {
        expect('hello'.capitalizeWords, 'Hello');
      });

      test('空字符串', () {
        expect(''.capitalizeWords, '');
      });

      test('多个空格', () {
        expect('hello  world'.capitalizeWords, 'Hello  World');
      });
    });

    group('综合测试 - 命名规则转换链', () {
      test('snake_case -> camelCase -> snake_case', () {
        final original = 'user_name_test';
        final camelCase = original.toCamelCase;
        final backToSnake = camelCase.toSnakeCase;
        expect(backToSnake, 'user_name_test');
      });

      test('snake_case -> PascalCase -> snake_case', () {
        final original = 'user_name_test';
        final pascalCase = original.toPascalCase;
        final backToSnake = pascalCase.toSnakeCase;
        expect(backToSnake, 'user_name_test');
      });

      test('camelCase -> snake_case -> camelCase', () {
        final original = 'userNameTest';
        final snakeCase = original.toSnakeCase;
        final backToCamel = snakeCase.toCamelCase;
        expect(backToCamel, 'userNameTest');
      });
    });
  });
}

