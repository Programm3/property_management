import 'package:flutter/material.dart';
import 'package:property_manage/src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

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
