import 'package:flutter_test/flutter_test.dart';
import 'package:futurae_flutter_plugin/futurae_flutter_plugin.dart';
import 'package:futurae_flutter_plugin/src/models/futurae_account.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFuturaeFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements FuturaeFlutterPluginPlatform {
  @override
  Future<bool> sdkIsLaunched() => Future.value(true);

  @override
  Future<FuturaeSdkState> getSdkState() {
    throw UnimplementedError();
  }

  @override
  Future<void> launch({
    required String sdkId,
    required String sdkKey,
    required String baseUrl,
    required FuturaeLockConfiguration lockConfiguration,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> enroll({required String qrCode}) {
    throw UnimplementedError();
  }

  @override
  Future<List<FuturaeUnlockMethodType>> getActiveUnlockMethods() {
    throw UnimplementedError();
  }

  @override
  Future<void> unlock({required FuturaeUnlockMethodType unlockMethodType}) {
    throw UnimplementedError();
  }

  @override
  Future<void> registerPushToken({required String pushToken}) {
    throw UnimplementedError();
  }

  @override
  Stream<Map> onApproveAuthentication() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleNotification({required Map<String, dynamic> payload}) {
    throw UnimplementedError();
  }

  @override
  Future<void> handleScannedQrCode({required String qrCode}) {
    throw UnimplementedError();
  }

  @override
  Future<void> approveAuthWithUserId(
      {required Map<String, dynamic> authenticationInfo}) {
    throw UnimplementedError();
  }

  @override
  Future<void> rejectAuthWithUserId(
      {required Map<String, dynamic> authenticationInfo}) {
    throw UnimplementedError();
  }

  @override
  Future<List<FuturaeAccount>> getAccounts() {
    throw UnimplementedError();
  }

  @override
  Future<List<FuturaeAccount>> getAccountsStatus(
      {required List<FuturaeAccount> accounts}) {
    throw UnimplementedError();
  }
}

void main() {
  final FuturaeFlutterPluginPlatform initialPlatform =
      FuturaeFlutterPluginPlatform.instance;

  test('$MethodChannelFuturaeFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFuturaeFlutterPlugin>());
  });
}
