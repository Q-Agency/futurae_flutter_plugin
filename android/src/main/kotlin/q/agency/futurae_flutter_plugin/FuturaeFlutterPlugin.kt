package q.agency.futurae_flutter_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FuturaeFlutterPlugin */
class FuturaeFlutterPlugin: FlutterPlugin, MethodCallHandler {
  private companion object {
    const val CHANNEL_NAME = "futurae_flutter_plugin"
    const val GENERAL_ERROR_CODE = "futurae_flutter_plugin_general_error"
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "futurae_flutter_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "sdkIsLaunched") {
      sdkIsLaunched(call, result);
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun sdkIsLaunched(call: MethodCall, result: Result) {
    result.success(mapOf("isLaunched" to true));
  }
}
