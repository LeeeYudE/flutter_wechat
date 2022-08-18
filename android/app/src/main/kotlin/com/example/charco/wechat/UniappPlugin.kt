package com.example.charco.wechat

import android.content.Context
import android.os.Handler
import android.util.Log
import androidx.annotation.NonNull
import io.dcloud.feature.sdk.DCSDKInitConfig
import io.dcloud.feature.sdk.DCUniMPSDK
import io.dcloud.feature.unimp.config.IUniMPReleaseCallBack
import io.dcloud.feature.unimp.config.UniMPReleaseConfiguration
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** FlutterPlugin */
class UniappPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mContext: Context
  var uiHandler = Handler()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "uniapp_plugin")
    channel.setMethodCallHandler(this)
    Log.d("Charco","onAttachedToEngine")
    mContext = flutterPluginBinding.applicationContext
    _initUniapp(flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    Log.d("Charco","onMethodCall "+call.method)
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if(call.method == "releaseWgtToRunPath"){
      val argument = call.argument<Map<String,String>?>("argument")
      Log.d("Charco","releaseWgtToRunPath "+argument.toString())
      val appid = argument?.get("appid")
      val path = argument?.get("filePath")
      val password = argument?.get("password")
      if(appid != null && path != null){
        val uniMPReleaseConfiguration = UniMPReleaseConfiguration()
        uniMPReleaseConfiguration.wgtPath = path
        if(password != null){
          uniMPReleaseConfiguration.password = password
        }
        uiHandler.post {
          DCUniMPSDK.getInstance().releaseWgtToRunPath(
            appid,uniMPReleaseConfiguration, object : IUniMPReleaseCallBack{

              override fun onCallBack(code: Int, p1: Any?) {

                if (code == 1) {
                  //释放wgt完成
                  try {
                    DCUniMPSDK.getInstance().openUniMP(mContext, appid)
                  } catch (e: Exception) {
                    e.printStackTrace()
                  }
                } else {
                  //释放wgt失败
                }

              }

            }
          )
        }

      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun _initUniapp(context: Context){
    val config = DCSDKInitConfig.Builder().build()
    DCUniMPSDK.getInstance().initialize(context, config)
  }

}
