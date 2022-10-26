package q.agency.futurae_flutter_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.futurae.sdk.FuturaeSDK
import com.futurae.sdk.LockConfigurationType
import com.futurae.sdk.SDKConfiguration
import com.futurae.sdk.exception.FTException

/** FuturaeFlutterPlugin */
class FuturaeFlutterPlugin: FlutterPlugin, MethodCallHandler {
  private companion object {
    const val CHANNEL_NAME = "futurae_flutter_plugin"
    const val GENERAL_ERROR_CODE = "futurae_flutter_plugin_general_error"
    const val MISSING_ARGUMENTS_ERROR_CODE = "futurae_flutter_plugin_missing_arguments_error"
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "sdkIsLaunched" -> sdkIsLaunched(result)
      "launch" -> launch(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun sdkIsLaunched(result: Result) {
    result.success(mapOf("isLaunched" to true));
  }

  private fun launch(call: MethodCall, result: Result) {
    try {
      val sdkId = call.argument<String>("sdkId")
      val sdkKey = call.argument<String>("sdkKey")
      val baseUrl = call.argument<String>("baseUrl")
      val lockConfigurationJson =
        call.argument<HashMap<String, Any>>("lockConfiguration");
      val lockConfigurationType = lockConfigurationJson?.get("type") as? Int;
      if (sdkId == null || sdkKey == null || baseUrl == null || lockConfigurationType == null) {
        result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
        return;
      }
      val unlockDuration = lockConfigurationJson["unlockDuration"] as? Int ?: 60
      val invalidatedByBiometricsChange =
        lockConfigurationJson["invalidatedByBiometricsChange"] as? Boolean
          ?: false
//      FuturaeSDK.INSTANCE.launch(this, SDKConfiguration.Builder()
//          .setLockConfigurationType(LockConfigurationType.values()[lockConfigurationType])
//          .setUnlockDuration(unlockDuration)
//          .setInvalidatedByBiometricChange(invalidatedByBiometricsChange)
//          .build()
//      )
      result.success(null)
    } catch (fte: FTException) {
      println(fte.stackTraceToString());
      result.error("FuturaeSDKError", fte.message, null)
    } catch (e: Exception) {
      println(e.stackTraceToString());
      result.error(GENERAL_ERROR_CODE, e.message, null)
    }
  }
}
