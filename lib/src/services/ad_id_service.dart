import 'package:flutter/services.dart';

class AdIdService {
  static const MethodChannel _channel = MethodChannel('com.nca.bkk/ad_id');
  static Future<String> getAdvertisingId() async {
    try {
      final String adId = await _channel.invokeMethod('getAdvertisingId');
      return adId;
    } on PlatformException catch (e) {
      print('Failed to get advertising ID: ${e.message}');
      return '';
    }
  }

  static Future<bool> isLimitAdTrackingEnabled() async {
    try {
      final bool isLimited = await _channel.invokeMethod(
        'isLimitAdTrackingEnabled',
      );
      return isLimited;
    } on PlatformException catch (e) {
      print('Failed to check limit ad tracking: ${e.message}');
      return true;
    }
  }
}
