package q.agency.futurae_flutter_plugin

import android.app.Activity
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import com.futurae.sdk.*
import com.futurae.sdk.exception.FTException
import com.futurae.sdk.model.AccountsStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat


/** FuturaeFlutterPlugin */
class FuturaeFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private companion object {
    const val CHANNEL_NAME = "futurae_flutter_plugin"
    const val GENERAL_ERROR_CODE = "futurae_flutter_plugin_general_error"
    const val MISSING_ARGUMENTS_ERROR_CODE = "futurae_flutter_plugin_missing_arguments_error"
    const val QR_CODE_INVALID_ERROR_CODE = "futurae_flutter_plugin_invalid_qr_code"
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity : Activity
  private var sdkIsLaunched = false
  private val isoFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'")

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "sdkIsLaunched" -> sdkIsLaunched(result)
      "launch" -> launch(call, result)
      "getSdkState" -> getSdkState(result)
      "getActiveUnlockMethods" -> getActiveUnlockMethods(result)
      "unlock" -> unlock(call, result)
      "enroll" -> enroll(call, result)
      "registerPushToken" -> registerPushToken(call, result)
      "handleScannedQrCode"-> handleScannedQrCode(call, result)
      "approveAuthWithUserId" -> approveAuthWithUserId(call, result)
      "rejectAuthWithUserId" -> rejectAuthWithUserId(call, result)
      "getAccounts" -> getAccounts(result)
      "getAccountsStatus" -> getAccountsStatus(call, result)
      "logoutWithUserId" -> logoutWithUserId(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun sdkIsLaunched(result: Result) {
    result.success(mapOf("isLaunched" to sdkIsLaunched));
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
      FuturaeSDK.INSTANCE.launch(activity.application, SDKConfiguration.Builder()
          .setLockConfigurationType(LockConfigurationType.values()[lockConfigurationType - 1])
          .setUnlockDuration(unlockDuration)
          .setInvalidatedByBiometricChange(invalidatedByBiometricsChange)
          .build()
      )
      sdkIsLaunched = true
      result.success(null)
    } catch (fte: FTException) {
      println(fte.stackTraceToString());
      result.error("FuturaeSDKError", fte.message, null)
    } catch (e: Exception) {
      println(e.stackTraceToString());
      if (e.message?.startsWith("SDK Already initialized") == true) {
        sdkIsLaunched = true
        result.success(null)
      } else {
        result.error(GENERAL_ERROR_CODE, e.message, null)
      }
    }
  }

  private fun getSdkState(result: Result) {
    result.success(mapOf("lockStatus" to if (FuturaeSDK.INSTANCE.client.isLocked) 0 else 1))
  }

  private fun getActiveUnlockMethods(result: MethodChannel.Result) {
    result.success(mapOf("unlockMethods" to FuturaeSDK.INSTANCE.client.activeUnlockMethods.map { unlockMethodType ->
      when(unlockMethodType) {
        UnlockMethodType.BIOMETRICS -> 1
        UnlockMethodType.BIOMETRICS_OR_DEVICE_CREDENTIALS -> 2
        UnlockMethodType.SDK_PIN -> 3
        else -> 4
      }
    }))
  }

  private fun unlock(call: MethodCall, result: MethodChannel.Result) {
    val unlockMethodTypeNumber = call.argument<Int>("unlockMethodType")
    if (unlockMethodTypeNumber == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    val callback = object : Callback<Unit> {
      override fun onSuccess(p0: Unit?) {
        result.success(null)
      }

      override fun onError(throwable: Throwable) {
        result.error(GENERAL_ERROR_CODE, throwable.message, null)
      }
    }
    when (unlockMethodTypeNumber) {
      1 -> FuturaeSDK.INSTANCE.client.unlockWithBiometrics(
        activity as FragmentActivity,
        "Please unlock with biometrics",
        "",
        "",
        "Cancel",
        callback)
      2 -> FuturaeSDK.INSTANCE.client.unlockWithBiometricsDeviceCredentials(
        activity as FragmentActivity,
        "Please unlock with biometrics",
        "",
        "",
        callback)
      3 -> result.notImplemented()
      else -> result.success(null)
    }
  }

  private fun enroll(call: MethodCall, result: Result) {
    val qrCode = call.argument<String>("qrCode")
    if (qrCode == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    FuturaeSDK.INSTANCE.client.enroll(qrCode, object : FuturaeCallback {
      override fun success() {
        result.success(null)
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  private fun registerPushToken(call: MethodCall, result: Result) {
    val pushToken = call.argument<String>("pushToken")
    if (pushToken == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    FuturaeSDK.INSTANCE.client.registerPushToken(pushToken, object : FuturaeCallback {
      override fun success() {
        result.success(null)
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  private fun handleScannedQrCode(call: MethodCall, result: Result) {
    val qrCode = call.argument<String>("qrCode")
    if (qrCode == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    when (FuturaeClient.getQrcodeType(qrCode)) {
      "ftr_qrcode_enroll" -> enroll(call, result)
      "ftr_qrcode_online" -> approveAuthWithQrCode(call, result)
      "ftr_qrcode_offline" -> result.notImplemented()
      else -> result.error(QR_CODE_INVALID_ERROR_CODE, "QR Code is invalid", null)
    }
  }

  private fun approveAuthWithQrCode(call: MethodCall, result: Result) {
    val qrCode = call.argument<String>("qrCode")
    if (qrCode == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    FuturaeSDK.INSTANCE.client.approveAuth(qrCode, object : FuturaeCallback {
      override fun success() {
        result.success(null)
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  private fun approveAuthWithUserId(call: MethodCall, result: Result) {
    val authenticationInfo =
      call.argument<HashMap<String, Any>>("authenticationInfo");
    val userId = authenticationInfo?.get("user_id") as? String
    val sessionId = authenticationInfo?.get("session_id") as? String
    val extraInfo = authenticationInfo?.get("extra_info") as? Array<*>
    if (authenticationInfo == null || userId == null || sessionId == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return;
    }
    FuturaeSDK.INSTANCE.client.approveAuth(
      userId, sessionId,
      object : FuturaeCallback {
        override fun success() {
          result.success(null)
        }

        override fun failure(throwable: Throwable?) {
          result.error(GENERAL_ERROR_CODE, throwable?.message, null)
        }
      }, // TODO extraInfo
    )
  }

  private fun rejectAuthWithUserId(call: MethodCall, result: Result) {
    val authenticationInfo =
      call.argument<HashMap<String, Any>>("authenticationInfo");
    val userId = authenticationInfo?.get("user_id") as? String
    val sessionId = authenticationInfo?.get("session_id") as? String
    if (authenticationInfo == null || userId == null || sessionId == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return;
    }
    FuturaeSDK.INSTANCE.client.rejectAuth(userId, sessionId, false, object : FuturaeCallback {
      override fun success() {
        result.success(null)
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  private fun getAccounts(result: Result) {
    val accounts = FuturaeSDK.INSTANCE.client.accounts
    result.success(mapOf("accounts" to accounts.map {
        ftAccount -> mapOf(
      "user_id" to ftAccount.userId,
      "username" to ftAccount.username,
      "ft_api_server_base_url" to ftAccount.ftApiServerBaseUrl,
      "service_id" to ftAccount.serviceId,
      "device_id" to ftAccount.deviceId,
      "service_name" to ftAccount.serviceName,
      "enrolled_at" to isoFormat.format(ftAccount.enrolledAt),
      "updated_at" to isoFormat.format(ftAccount.updatedAt),
      "allowed_factors" to ftAccount.allowedFactors
    )
    }))
  }

  private fun getAccountsStatus(call: MethodCall, result: Result) {
    val accountsJson = call.argument<List<HashMap<String, Any>>>("accounts")
    if (accountsJson == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return;
    }
    if (accountsJson.isEmpty()) {
      result.success(mapOf("accounts" to null))
      return
    }
    val userIds = ArrayList<String>()
    accountsJson.forEach { accountJson ->
      userIds.add(accountJson["user_id"] as String)
    }
    FuturaeSDK.INSTANCE.client.getAccountsStatus(userIds, object : FuturaeResultCallback<AccountsStatus> {
      override fun success(accountsStatus: AccountsStatus?) {
        result.success(mapOf("accounts" to accountsStatus?.statuses?.map {
            accountStatus -> mapOf(
          "user_id" to accountStatus.userId,
          "username" to accountStatus.username,
          "ft_api_server_base_url" to "",
          "enrolled" to accountStatus.isEnrolled,
          "service_id" to "",
          "device_id" to "",
          "service_name" to "",
          "enrolled_at" to isoFormat.format(accountStatus.enrolledAt),
          "service_logo" to accountStatus.serviceLogo,
          "sessions" to accountStatus.sessionInfos.map { sessionInfo ->
            mapOf(
              "session_id" to sessionInfo.sessionId,
              "user_id" to sessionInfo.userId,
              "session_token" to sessionInfo.sessionToken,
              "type" to sessionInfo.type,
              "service_id" to sessionInfo.serviceId,
              "approve_combo" to sessionInfo.approveCombo,
              "approve_info" to sessionInfo.approveInfo.map {
                  approveInfo -> mapOf(
                "key" to approveInfo.key,
                "value" to approveInfo.value)
              },
              "factor" to sessionInfo.factor,
              "timeout" to sessionInfo.timeout
          ) })
        }))
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  private fun logoutWithUserId(call: MethodCall, result: Result) {
    val userId = call.argument<String>("userId")
    if (userId == null) {
      result.error(MISSING_ARGUMENTS_ERROR_CODE, null, null)
      return
    }
    FuturaeSDK.INSTANCE.client.logout(userId, object : FuturaeCallback {
      override fun success() {
        result.success(null)
      }

      override fun failure(throwable: Throwable?) {
        result.error(GENERAL_ERROR_CODE, throwable?.message, null)
      }
    })
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {

  }
}
