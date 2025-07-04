import 'package:flutter/material.dart';
import 'package:property_manage/src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/connectivity_provider.dart';
import 'package:property_manage/src/services/ad_id_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeAdvertising();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initializeAdvertising() async {
  try {
    final bool isLimited = await AdIdService.isLimitAdTrackingEnabled();

    if (!isLimited) {
      final String adId = await AdIdService.getAdvertisingId();
      debugPrint('Advertising ID: $adId');
    } else {
      debugPrint('User has limited ad tracking');
    }
  } catch (e) {
    debugPrint('Error initializing advertising ID: $e');
  }
}
