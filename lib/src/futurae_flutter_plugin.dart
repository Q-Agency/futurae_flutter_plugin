import 'package:futurae_flutter_plugin/futurae_flutter_plugin.dart';
import 'package:futurae_flutter_plugin/src/models/futurae_account.dart';

class FuturaeFlutterPlugin {
  Future<bool> sdkIsLaunched() {
    return FuturaeFlutterPluginPlatform.instance.sdkIsLaunched();
  }

  Future<void> launch({
    required String sdkId,
    required String sdkKey,
    required String baseUrl,
    required FuturaeLockConfiguration lockConfiguration,
  }) =>
      FuturaeFlutterPluginPlatform.instance.launch(
        sdkId: sdkId,
        sdkKey: sdkKey,
        baseUrl: baseUrl,
        lockConfiguration: lockConfiguration,
      );

  Future<FuturaeSdkState> getSdkState() =>
      FuturaeFlutterPluginPlatform.instance.getSdkState();

  Future<List<FuturaeUnlockMethodType>> getActiveUnlockMethods() =>
      FuturaeFlutterPluginPlatform.instance.getActiveUnlockMethods();

  Future<void> unlock({required FuturaeUnlockMethodType unlockMethodType}) =>
      FuturaeFlutterPluginPlatform.instance
          .unlock(unlockMethodType: unlockMethodType);

  Future<void> enroll({required String qrCode}) =>
      FuturaeFlutterPluginPlatform.instance.enroll(qrCode: qrCode);

  Future<void> registerPushToken({required String pushToken}) =>
      FuturaeFlutterPluginPlatform.instance
          .registerPushToken(pushToken: pushToken);

  Future<void> handleNotification({required Map<String, dynamic> payload}) =>
      FuturaeFlutterPluginPlatform.instance
          .handleNotification(payload: payload);

  Stream<Map<dynamic, dynamic>> onApproveAuthentication() =>
      FuturaeFlutterPluginPlatform.instance.onApproveAuthentication();

  Future<void> handleScannedQrCode({required String qrCode}) =>
      FuturaeFlutterPluginPlatform.instance.handleScannedQrCode(qrCode: qrCode);

  Future<void> approveAuthWithUserId(
          {required Map<String, dynamic> authenticationInfo}) =>
      FuturaeFlutterPluginPlatform.instance
          .approveAuthWithUserId(authenticationInfo: authenticationInfo);

  Future<void> rejectAuthWithUserId(
          {required Map<String, dynamic> authenticationInfo}) =>
      FuturaeFlutterPluginPlatform.instance
          .rejectAuthWithUserId(authenticationInfo: authenticationInfo);

  Future<List<FuturaeAccount>> getAccounts() =>
      FuturaeFlutterPluginPlatform.instance.getAccounts();

  Future<List<FuturaeAccount>> getAccountsStatus(
          {required List<FuturaeAccount> accounts}) =>
      FuturaeFlutterPluginPlatform.instance
          .getAccountsStatus(accounts: accounts);
}
