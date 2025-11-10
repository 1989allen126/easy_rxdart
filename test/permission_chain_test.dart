// 暂时注释，permission_handler_android 与 Android v1 embedding 不兼容
// import 'package:easy_rxdart/src/extensions/reactive/permission_chain_extensions.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:easy_rxdart/easy_rxdart.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   setUpAll(() {
//     TestWidgetsFlutterBinding.ensureInitialized();
//   });

//   group('PermissionChain', () {
//     test('chain应该创建PermissionChain实例', () {
//       final chain = Permission.camera.chain();
//       expect(chain, isA<PermissionChain>());
//       expect(chain.permission, Permission.camera);
//     });

//     // 注意：这些测试需要实际的权限插件实现，在单元测试环境中会失败
//     // 在实际设备或集成测试中可以运行
//     // test('checkStatus应该更新状态', () async {
//     //   final chain = await Permission.camera.chain().checkStatus();
//     //   expect(chain.status, isNotNull);
//     //   expect(chain.status, isA<PermissionStatus>());
//     // });

//     // test('request应该更新状态', () async {
//     //   final chain = await Permission.camera.chain().request();
//     //   expect(chain.status, isNotNull);
//     //   expect(chain.status, isA<PermissionStatus>());
//     // });

//     test('ifGranted应该在权限已授予时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.granted);
//       var executed = false;
//       chain.ifGranted(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('ifGranted应该在权限未授予时不执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.denied);
//       var executed = false;
//       chain.ifGranted(() {
//         executed = true;
//       });
//       expect(executed, false);
//     });

//     test('ifNotGranted应该在权限未授予时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.denied);
//       var executed = false;
//       chain.ifNotGranted(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('ifNotGranted应该在权限已授予时不执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.granted);
//       var executed = false;
//       chain.ifNotGranted(() {
//         executed = true;
//       });
//       expect(executed, false);
//     });

//     test('ifDenied应该在权限被拒绝时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.denied);
//       var executed = false;
//       chain.ifDenied(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('ifPermanentlyDenied应该在权限被永久拒绝时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.permanentlyDenied);
//       var executed = false;
//       chain.ifPermanentlyDenied(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('ifRestricted应该在权限受限时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.restricted);
//       var executed = false;
//       chain.ifRestricted(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('ifLimited应该在权限受限时执行回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.limited);
//       var executed = false;
//       chain.ifLimited(() {
//         executed = true;
//       });
//       expect(executed, true);
//     });

//     test('when应该在权限已授予时执行onGranted回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.granted);
//       var grantedExecuted = false;
//       var deniedExecuted = false;
//       chain.when(
//         onGranted: () {
//           grantedExecuted = true;
//         },
//         onDenied: () {
//           deniedExecuted = true;
//         },
//       );
//       expect(grantedExecuted, true);
//       expect(deniedExecuted, false);
//     });

//     test('when应该在权限被拒绝时执行onDenied回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.denied);
//       var grantedExecuted = false;
//       var deniedExecuted = false;
//       chain.when(
//         onGranted: () {
//           grantedExecuted = true;
//         },
//         onDenied: () {
//           deniedExecuted = true;
//         },
//       );
//       expect(grantedExecuted, false);
//       expect(deniedExecuted, true);
//     });

//     test('when应该在权限被永久拒绝时执行onPermanentlyDenied回调', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.permanentlyDenied);
//       var permanentlyDeniedExecuted = false;
//       chain.when(
//         onPermanentlyDenied: () {
//           permanentlyDeniedExecuted = true;
//         },
//       );
//       expect(permanentlyDeniedExecuted, true);
//     });

//     test('isGranted应该返回正确的值', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.granted);
//       expect(chain.isGranted, true);
//       chain.setStatus(PermissionStatus.denied);
//       expect(chain.isGranted, false);
//     });

//     test('isDenied应该返回正确的值', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.denied);
//       expect(chain.isDenied, true);
//       chain.setStatus(PermissionStatus.granted);
//       expect(chain.isDenied, false);
//     });

//     test('isPermanentlyDenied应该返回正确的值', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.permanentlyDenied);
//       expect(chain.isPermanentlyDenied, true);
//       chain.setStatus(PermissionStatus.denied);
//       expect(chain.isPermanentlyDenied, false);
//     });

//     test('isRestricted应该返回正确的值', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.restricted);
//       expect(chain.isRestricted, true);
//       chain.setStatus(PermissionStatus.granted);
//       expect(chain.isRestricted, false);
//     });

//     test('isLimited应该返回正确的值', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.limited);
//       expect(chain.isLimited, true);
//       chain.setStatus(PermissionStatus.granted);
//       expect(chain.isLimited, false);
//     });

//     // 注意：这个测试需要实际的权限插件实现，在单元测试环境中会失败
//     // 在实际设备或集成测试中可以运行
//     // test('链式调用应该可以连续调用多个方法', () async {
//     //   final chain = await Permission.camera.chain().checkStatus();
//     //   var grantedExecuted = false;
//     //   var deniedExecuted = false;
//     //   chain
//     //       .ifGranted(() {
//     //         grantedExecuted = true;
//     //       })
//     //       .ifDenied(() {
//     //         deniedExecuted = true;
//     //       });
//     //   // 至少有一个会被执行（取决于实际权限状态）
//     //   expect(grantedExecuted || deniedExecuted, true);
//     // });

//     test('链式调用应该可以连续调用多个方法（使用模拟状态）', () {
//       final chain = Permission.camera.chain();
//       chain.setStatus(PermissionStatus.granted);
//       var grantedExecuted = false;
//       var deniedExecuted = false;
//       chain
//           .ifGranted(() {
//             grantedExecuted = true;
//           })
//           .ifDenied(() {
//             deniedExecuted = true;
//           });
//       expect(grantedExecuted, true);
//       expect(deniedExecuted, false);
//     });
//   });
// }
