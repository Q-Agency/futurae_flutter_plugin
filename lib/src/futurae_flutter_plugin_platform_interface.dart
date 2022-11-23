import 'package:futurae_flutter_plugin/futurae_flutter_plugin.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FuturaeFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a FuturaeFlutterPluginPlatform.
  FuturaeFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FuturaeFlutterPluginPlatform _instance =
      MethodChannelFuturaeFlutterPlugin();

  /// The default instance of [FuturaeFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFuturaeFlutterPlugin].
  static FuturaeFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FuturaeFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(FuturaeFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> sdkIsLaunched() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> launch({
    required String sdkId,
    required String sdkKey,
    required String baseUrl,
    required FuturaeLockConfiguration lockConfiguration,
  }) {
    throw UnimplementedError('launch() has not been implemented.');
  }

  Future<FuturaeSdkState> getSdkState() {
    throw UnimplementedError('getSdkState() has not been implemented.');
  }

  Future<List<FuturaeUnlockMethodType>> getActiveUnlockMethods() {
    throw UnimplementedError(
        'getActiveUnlockMethods() has not been implemented.');
  }

  Future<void> unlock({required FuturaeUnlockMethodType unlockMethodType}) {
    throw UnimplementedError('unlock() has not been implemented.');
  }

  Future<void> enroll({required String qrCode}) {
    throw UnimplementedError('enroll() has not been implemented');
  }

  Future<void> registerPushToken({required String pushToken}) {
    throw UnimplementedError('registerPushToken() has not been implemented');
  }

  Future<void> handleNotification({required Map<String, dynamic> payload}) {
    throw UnimplementedError('handleNotification() has not been implemented');
  }

  Stream<Map<dynamic, dynamic>> onApproveAuthentication() {
    throw UnimplementedError(
        'onApproveAuthentication() has not been implemented');
  }

  Future<void> handleScannedQrCode({required String qrCode}) {
    throw UnimplementedError('handleScannedQrCode() has not been implemented');
  }

  Future<void> approveAuthWithUserId(
      {required Map<String, dynamic> authenticationInfo}) {
    throw UnimplementedError(
        'approveAuthWithUserId() has not been implemented');
  }

  Future<void> rejectAuthWithUserId(
      {required Map<String, dynamic> authenticationInfo}) {
    throw UnimplementedError('rejectAuthWithUserId() has not been implemented');
  }

  Future<List<FuturaeAccount>> getAccounts() {
    throw UnimplementedError('getAccounts() has not been implemented');
  }

  Future<List<FuturaeAccount>> getAccountsStatus(
      {required List<FuturaeAccount> accounts}) {
    throw UnimplementedError('getAccountsStatus() has not been implemented');
  }
}
