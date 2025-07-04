package com.nca.bkk

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nca.bkk/ad_id"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAdvertisingId" -> {
                    GlobalScope.launch(Dispatchers.IO) {
                        try {
                            val adInfo = AdvertisingIdClient.getAdvertisingIdInfo(context)
                            val adId = adInfo.id ?: ""
                            GlobalScope.launch(Dispatchers.Main) {
                                result.success(adId)
                            }
                        } catch (e: Exception) {
                            GlobalScope.launch(Dispatchers.Main) {
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }
                }
                "isLimitAdTrackingEnabled" -> {
                    GlobalScope.launch(Dispatchers.IO) {
                        try {
                            val adInfo = AdvertisingIdClient.getAdvertisingIdInfo(context)
                            val isLimitAdTrackingEnabled = adInfo.isLimitAdTrackingEnabled
                            GlobalScope.launch(Dispatchers.Main) {
                                result.success(isLimitAdTrackingEnabled)
                            }
                        } catch (e: Exception) {
                            GlobalScope.launch(Dispatchers.Main) {
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}