import Flutter
import UIKit
import FuturaeKit

public class SwiftFuturaeFlutterPlugin: NSObject, FlutterPlugin {
    private struct Constants {
        static let ChannelName = "futurae_flutter_plugin"
        static let GeneralErrorCode = "futurae_flutter_plugin_general_error"
        static let MissingArgumentsError = "futurae_flutter_plugin_missing_arguments_error"
        
        static let SdkIsLaunched = "sdkIsLaunched"
        static let LaunchMethod = "launch"
        static let GetSdkStateMethod = "getSdkState"
        static let GetActiveUnlockMethods = "getActiveUnlockMethods"
        static let Unlock = "unlock"
        static let EnrollMethod = "enroll"
        static let RegisterPushToken = "registerPushToken"
        static let HandleNotification = "handleNotification"
        static let ApproveAuthenticationReceived = "approveAuthenticationReceived"
    }
    
    var _channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Constants.ChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFuturaeFlutterPlugin()
        instance._channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == Constants.SdkIsLaunched {
            sdkIsLaunched(result: result)
        } else if call.method == Constants.LaunchMethod {
            launch(callArguments: call.arguments as? [String: Any], result: result)
        } else if call.method == Constants.GetSdkStateMethod {
            getSdkState(result: result)
        } else if call.method == Constants.GetActiveUnlockMethods {
            getActiveUnlockMethods(result: result)
        } else if call.method == Constants.Unlock {
            unlock(callArguments: call.arguments as? [String: Any], result: result)
        } else if call.method == Constants.EnrollMethod {
            enroll(callArguments: call.arguments as? [String: Any], result: result)
        } else if call.method == Constants.RegisterPushToken {
            registerPushToken(callArguments: call.arguments as? [String: Any], result: result)
        } else if call.method == Constants.HandleNotification {
            handleNotification(callArguments: call.arguments as? [String: Any], result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func sdkIsLaunched(result: FlutterResult) {
        result(["isLaunched": FTRClient.sdkIsLaunched()])
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
//            self?._channel?.invokeMethod(Constants.ApproveAuthenticationReceived, arguments: ["abc": 123])
//        }
    }
    
    private func launch(callArguments: [String: Any]?, result: @escaping FlutterResult) {
        guard let sdkId = callArguments?["sdkId"] as? String, let sdkKey = callArguments?["sdkKey"] as? String, let baseUrl = callArguments?["baseUrl"] as? String, let lockConfigurationJson = callArguments?["lockConfiguration"] as? [String: Any], let lockConfigurationType = lockConfigurationJson["type"] as? Int else {
            result(FlutterError(code: Constants.MissingArgumentsError, message: nil, details: nil))
            return
        }
        let unlockDuration = (lockConfigurationJson["unlockDuration"] as? Double) ?? 60
        let invalidatedByBiometricsChange = (lockConfigurationJson["invalidatedByBiometricsChange"] as? Bool) ?? false
        let config = FTRConfig(sdkId: sdkId,
                               sdkKey: sdkKey,
                               baseUrl: baseUrl,
                               lockConfiguration: LockConfiguration(type: LockConfigurationType(rawValue: lockConfigurationType) ?? LockConfigurationType.none, unlockDuration: unlockDuration, invalidatedByBiometricsChange: invalidatedByBiometricsChange)
        )
        FTRClient.launch(with: config) {
            result(nil)
        } failure: { [weak self] error in
            result(FlutterError(code: self?.unwrapErrorCode(error: error) ?? Constants.GeneralErrorCode, message: self?.unwrapErrorMessage(error: error), details: nil))
        }
    }
    
    private func getSdkState(result: FlutterResult) {
        guard let sdkState = FTRClient.shared()?.getSdkState() else {
            result(FlutterError(code: Constants.GeneralErrorCode, message: nil, details: nil))
            return
        }
        if sdkState.error == nil {
            result(["lockStatus": sdkState.lockStatus.rawValue, "configStatus": sdkState.configStatus.rawValue, "unlockedRemainingDuration": Int(sdkState.unlockedRemainingDuration.rounded())])
        } else {
            result(FlutterError(code: unwrapErrorCode(error: sdkState.error) ?? Constants.GeneralErrorCode, message: unwrapErrorMessage(error: sdkState.error), details: nil))
        }
    }
    
    private func getActiveUnlockMethods(result: FlutterResult) {
        guard let unlockMethods = FTRClient.shared()?.getActiveUnlockMethods() else {
            result(FlutterError(code: Constants.GeneralErrorCode, message: nil, details: nil))
            return
        }
        result(["unlockMethods": unlockMethods])
    }
    
    private func unlock(callArguments: [String: Any]?, result: @escaping FlutterResult) {
        guard let unlockMethodTypeNumber = callArguments?["unlockMethodType"] as? Int, let unlockMethodType = UnlockMethodType(rawValue: unlockMethodTypeNumber) else {
            result(FlutterError(code: Constants.MissingArgumentsError, message: nil, details: nil))
            return
        }
        let callback = { [weak self] (error: Error?) in
            if error != nil {
                result(FlutterError(code: self?.unwrapErrorCode(error: error) ?? Constants.GeneralErrorCode, message: self?.unwrapErrorMessage(error: error), details: nil))
            } else {
                result(nil)
            }
        }
        switch unlockMethodType {
        case .biometric:
            FTRClient.shared()?.unlock(biometrics: callback, promptReason: "Unlock SDK")
        case .biometricsOrPasscode:
            FTRClient.shared()?.unlock(biometricsPasscode: callback, promptReason: "Unlock SDK")
        case .sdkPin:
            result(FlutterMethodNotImplemented)
        default:
            result(nil)
        }
    }
    
    private func enroll(callArguments: [String: Any]?, result: @escaping FlutterResult) {
        guard let qrCode = callArguments?["qrCode"] as? String else {
            result(FlutterError(code: Constants.MissingArgumentsError, message: nil, details: nil))
            return
        }
        FTRClient.shared()?.enroll(qrCode, callback: { [weak self] error in
            if error != nil {
                result(FlutterError(code: self?.unwrapErrorCode(error: error) ?? Constants.GeneralErrorCode, message: self?.unwrapErrorMessage(error: error), details: nil))
            } else {
                result(nil)
            }
        })
    }
    
    private func registerPushToken(callArguments: [String: Any]?, result: FlutterResult) {
        guard let pushToken = callArguments?["pushToken"] as? String else {
            result(FlutterError(code: Constants.MissingArgumentsError, message: nil, details: nil))
            return
        }
        FTRClient.shared()?.registerPushToken(Data(pushToken.utf8))
        result(nil)
    }
    
    private func handleNotification(callArguments: [String: Any]?, result: FlutterResult) {
        guard let payload = callArguments?["payload"] as? [String: Any] else {
            result(FlutterError(code: Constants.MissingArgumentsError, message: nil, details: nil))
            return
        }
        FTRClient.shared()?.handleNotification(payload, delegate: self)
        result(nil)
    }
    
    private func unwrapErrorMessage(error: Error?) -> String? {
        return (error as? NSError)?.userInfo["msg"] as? String
    }
    
    private func unwrapErrorCode(error: Error?) -> String? {
        if let code = (error as? NSError)?.code as? Int {
            return "\(code)"
        }
        return nil
    }
}

extension SwiftFuturaeFlutterPlugin: FTRNotificationDelegate {
    public func approveAuthenticationReceived(_ authenticationInfo: [AnyHashable : Any]) {
        _channel?.invokeMethod(Constants.ApproveAuthenticationReceived, arguments: authenticationInfo)
    }
    
    public func unenrollUserReceived(_ accountInfo: [AnyHashable : Any]) {
        
    }
    
    public func notificationError(_ error: Error) {
        
    }
}
