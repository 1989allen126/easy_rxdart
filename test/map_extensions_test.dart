import 'package:easy_rxdart/easy_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapExtensions 命名规则转换测试', () {
    group('一级转换 - toCamelCaseKeys', () {
      test('基本转换', () {
        final map = {'user_name': 'test', 'user_age': 25};
        final result = map.toCamelCaseKeys;
        expect(result, {'userName': 'test', 'userAge': 25});
      });

      test('不递归处理嵌套Map', () {
        final map = {
          'user_name': 'test',
          'nested_map': {'inner_key': 'value'}
        };
        final result = map.toCamelCaseKeys;
        expect(result['userName'], 'test');
        expect(result['nestedMap'], {'inner_key': 'value'});
      });

      test('空Map', () {
        final map = <String, dynamic>{};
        final result = map.toCamelCaseKeys;
        expect(result, isEmpty);
      });

      test('单个key', () {
        final map = {'test_key': 'value'};
        final result = map.toCamelCaseKeys;
        expect(result, {'testKey': 'value'});
      });
    });

    group('一级转换 - toPascalCaseKeys', () {
      test('基本转换', () {
        final map = {'user_name': 'test', 'user_age': 25};
        final result = map.toPascalCaseKeys;
        expect(result, {'UserName': 'test', 'UserAge': 25});
      });

      test('不递归处理嵌套Map', () {
        final map = {
          'user_name': 'test',
          'nested_map': {'inner_key': 'value'}
        };
        final result = map.toPascalCaseKeys;
        expect(result['UserName'], 'test');
        expect(result['NestedMap'], {'inner_key': 'value'});
      });
    });

    group('一级转换 - toSnakeCaseKeys', () {
      test('基本转换 - camelCase', () {
        final map = {'userName': 'test', 'userAge': 25};
        final result = map.toSnakeCaseKeys;
        expect(result, {'user_name': 'test', 'user_age': 25});
      });

      test('基本转换 - PascalCase', () {
        final map = {'UserName': 'test', 'UserAge': 25};
        final result = map.toSnakeCaseKeys;
        expect(result, {'user_name': 'test', 'user_age': 25});
      });

      test('不递归处理嵌套Map', () {
        final map = {
          'userName': 'test',
          'nestedMap': {'innerKey': 'value'}
        };
        final result = map.toSnakeCaseKeys;
        expect(result['user_name'], 'test');
        expect(result['nested_map'], {'innerKey': 'value'});
      });
    });

    group('一级转换 - capitalizeKeys', () {
      test('基本转换', () {
        final map = {'hello': 'test', 'world': 'value'};
        final result = map.capitalizeKeys;
        expect(result, {'Hello': 'test', 'World': 'value'});
      });

      test('不递归处理嵌套Map', () {
        final map = {
          'hello': 'test',
          'nested': {'inner': 'value'}
        };
        final result = map.capitalizeKeys;
        expect(result['Hello'], 'test');
        expect(result['Nested'], {'inner': 'value'});
      });
    });

    group('深度转换 - toDeepCamelCaseKeys', () {
      test('基本转换', () {
        final map = {'user_name': 'test', 'user_age': 25};
        final result = map.toDeepCamelCaseKeys;
        expect(result, {'userName': 'test', 'userAge': 25});
      });

      test('递归处理嵌套Map', () {
        final map = {
          'user_name': 'test',
          'nested_map': {'inner_key': 'value', 'another_key': 123}
        };
        final result = map.toDeepCamelCaseKeys;
        expect(result['userName'], 'test');
        expect(result['nestedMap'], {'innerKey': 'value', 'anotherKey': 123});
      });

      test('递归处理多层嵌套Map', () {
        final map = {
          'level_one': {
            'level_two': {
              'level_three_key': 'value'
            }
          }
        };
        final result = map.toDeepCamelCaseKeys;
        expect(result['levelOne']['levelTwo']['levelThreeKey'], 'value');
      });

      test('递归处理List中的Map', () {
        final map = {
          'items': [
            {'item_name': 'test1', 'item_id': 1},
            {'item_name': 'test2', 'item_id': 2}
          ]
        };
        final result = map.toDeepCamelCaseKeys;
        expect(result['items'], isA<List>());
        expect(result['items'][0], {'itemName': 'test1', 'itemId': 1});
        expect(result['items'][1], {'itemName': 'test2', 'itemId': 2});
      });

      test('混合嵌套结构', () {
        final map = {
          'user_name': 'test',
          'user_info': {
            'first_name': 'John',
            'last_name': 'Doe',
            'addresses': [
              {'street_name': 'Main St', 'city_name': 'NYC'}
            ]
          }
        };
        final result = map.toDeepCamelCaseKeys;
        expect(result['userName'], 'test');
        expect(result['userInfo']['firstName'], 'John');
        expect(result['userInfo']['lastName'], 'Doe');
        expect(result['userInfo']['addresses'][0]['streetName'], 'Main St');
        expect(result['userInfo']['addresses'][0]['cityName'], 'NYC');
      });

      test('空Map', () {
        final map = <String, dynamic>{};
        final result = map.toDeepCamelCaseKeys;
        expect(result, isEmpty);
      });

      test('空List', () {
        final map = {'items': <Map<String, dynamic>>[]};
        final result = map.toDeepCamelCaseKeys;
        expect(result['items'], isEmpty);
      });
    });

    group('深度转换 - toDeepPascalCaseKeys', () {
      test('基本转换', () {
        final map = {'user_name': 'test', 'user_age': 25};
        final result = map.toDeepPascalCaseKeys;
        expect(result, {'UserName': 'test', 'UserAge': 25});
      });

      test('递归处理嵌套Map', () {
        final map = {
          'user_name': 'test',
          'nested_map': {'inner_key': 'value'}
        };
        final result = map.toDeepPascalCaseKeys;
        expect(result['UserName'], 'test');
        expect(result['NestedMap'], {'InnerKey': 'value'});
      });

      test('递归处理List中的Map', () {
        final map = {
          'items': [
            {'item_name': 'test1'},
            {'item_name': 'test2'}
          ]
        };
        final result = map.toDeepPascalCaseKeys;
        expect(result['Items'][0], {'ItemName': 'test1'});
        expect(result['Items'][1], {'ItemName': 'test2'});
      });
    });

    group('深度转换 - toDeepSnakeCaseKeys', () {
      test('基本转换 - camelCase', () {
        final map = {'userName': 'test', 'userAge': 25};
        final result = map.toDeepSnakeCaseKeys;
        expect(result, {'user_name': 'test', 'user_age': 25});
      });

      test('基本转换 - PascalCase', () {
        final map = {'UserName': 'test', 'UserAge': 25};
        final result = map.toDeepSnakeCaseKeys;
        expect(result, {'user_name': 'test', 'user_age': 25});
      });

      test('递归处理嵌套Map', () {
        final map = {
          'userName': 'test',
          'nestedMap': {'innerKey': 'value', 'anotherKey': 123}
        };
        final result = map.toDeepSnakeCaseKeys;
        expect(result['user_name'], 'test');
        expect(result['nested_map'], {'inner_key': 'value', 'another_key': 123});
      });

      test('递归处理List中的Map', () {
        final map = {
          'items': [
            {'itemName': 'test1', 'itemId': 1},
            {'itemName': 'test2', 'itemId': 2}
          ]
        };
        final result = map.toDeepSnakeCaseKeys;
        expect(result['items'][0], {'item_name': 'test1', 'item_id': 1});
        expect(result['items'][1], {'item_name': 'test2', 'item_id': 2});
      });
    });

    group('深度转换 - toDeepCapitalizeKeys', () {
      test('基本转换', () {
        final map = {'hello': 'test', 'world': 'value'};
        final result = map.toDeepCapitalizeKeys;
        expect(result, {'Hello': 'test', 'World': 'value'});
      });

      test('递归处理嵌套Map', () {
        final map = {
          'hello': 'test',
          'nested': {'inner': 'value', 'another': 123}
        };
        final result = map.toDeepCapitalizeKeys;
        expect(result['Hello'], 'test');
        expect(result['Nested'], {'Inner': 'value', 'Another': 123});
      });

      test('递归处理List中的Map', () {
        final map = {
          'items': [
            {'name': 'test1'},
            {'name': 'test2'}
          ]
        };
        final result = map.toDeepCapitalizeKeys;
        expect(result['Items'][0], {'Name': 'test1'});
        expect(result['Items'][1], {'Name': 'test2'});
      });
    });
  });
}

