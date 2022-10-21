import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:futurae_flutter_plugin/futurae_flutter_plugin.dart';

/// An implementation of [FuturaeFlutterPluginPlatform] that uses method channels.
class MethodChannelFuturaeFlutterPlugin extends FuturaeFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('futurae_flutter_plugin');

  final StreamController<Map<dynamic, dynamic>>
      _approveAuthenticationStreamController =
      StreamController<Map<dynamic, dynamic>>();

  MethodChannelFuturaeFlutterPlugin() {
    methodChannel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'approveAuthenticationReceived':
            _approveAuthenticationStreamController
                .add(call.arguments as Map<dynamic, dynamic>);
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  Future<bool> sdkIsLaunched() async {
    final result = await methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('sdkIsLaunched');
    return result?['isLaunched'] ?? false;
  }

  @override
  Future<void> launch({
    required String sdkId,
    required String sdkKey,
    required String baseUrl,
    required FuturaeLockConfiguration lockConfiguration,
  }) {
    return methodChannel.invokeMethod<void>('launch', {
      'sdkId': sdkId,
      'sdkKey': sdkKey,
      'baseUrl': baseUrl,
      'lockConfiguration': lockConfiguration.toJson(),
    });
  }

  @override
  Future<FuturaeSdkState> getSdkState() async {
    final sdkState =
        await methodChannel.invokeMethod<Map<dynamic, dynamic>>('getSdkState');
    return FuturaeSdkState(
        lockStatus: FuturaeSdkLockStatus.values[sdkState?['lockStatus'] ?? 0],
        configStatus:
            FuturaeSdkLockConfigStatus.values[sdkState?['configStatus'] ?? 0],
        unlockedRemainingDuration: sdkState?['unlockedRemainingDuration']);
  }

  @override
  Future<List<FuturaeUnlockMethodType>> getActiveUnlockMethods() async {
    final result = await methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('getActiveUnlockMethods');
    final List<dynamic>? unlockMethodsList = result?['unlockMethods'];
    return unlockMethodsList
            ?.map((e) => FuturaeUnlockMethodType.getByNumber(e))
            .toList() ??
        [];
  }

  @override
  Future<void> unlock({required FuturaeUnlockMethodType unlockMethodType}) {
    return methodChannel.invokeMethod<void>(
        'unlock', {'unlockMethodType': unlockMethodType.number});
  }

  @override
  Future<void> enroll({required String qrCode}) {
    return methodChannel.invokeMethod<void>('enroll', {'qrCode': qrCode});
  }

  @override
  Future<void> registerPushToken({required String pushToken}) {
    return methodChannel
        .invokeMethod<void>('registerPushToken', {'pushToken': pushToken});
  }

  @override
  Future<void> handleNotification({required Map<String, dynamic> payload}) {
    return methodChannel
        .invokeMethod<void>('handleNotification', {'payload': payload});
  }

  @override
  Stream<Map<dynamic, dynamic>> onApproveAuthentication() =>
      _approveAuthenticationStreamController.stream;
}
