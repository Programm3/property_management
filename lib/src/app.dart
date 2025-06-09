import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_manage/src/providers/connectivity_provider.dart';
import 'package:property_manage/src/providers/message_provider.dart';
import 'package:property_manage/src/providers/property_provider.dart';
import 'package:property_manage/src/providers/rental_types_provider.dart';
import 'package:property_manage/src/routes.dart';
import 'package:property_manage/src/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/providers/province_provider.dart';
import 'package:property_manage/src/localization/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLogin();
    });
  }

  Future<void> _checkAndLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.ensureInitialized();

    setState(() {
      _isInitializing = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<AuthProvider, ApiService>(
          update: (_, authProvider, __) => ApiService(authProvider),
        ),
        ChangeNotifierProxyProvider<ApiService, ProvinceProvider>(
          create: (context) => ProvinceProvider(context.read<ApiService>()),
          update:
              (context, apiService, previous) =>
                  previous ?? ProvinceProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, PropertyProvider>(
          create: (context) => PropertyProvider(context.read<ApiService>()),
          update:
              (context, apiService, previous) =>
                  previous ?? PropertyProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, RentalTypesProvider>(
          create: (context) => RentalTypesProvider(context.read<ApiService>()),
          update:
              (context, apiService, previous) =>
                  previous ?? RentalTypesProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, MessageProvider>(
          create: (context) => MessageProvider(context.read<ApiService>()),
          update:
              (context, apiService, previous) =>
                  previous ?? MessageProvider(apiService),
        ),
      ],
      child: Consumer3<LanguageProvider, AuthProvider, ConnectivityProvider>(
        builder: (
          context,
          languageProvider,
          authProvider,
          connectivityProvider,
          child,
        ) {
          if (_isInitializing) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }
          return MaterialApp.router(
            routerConfig: router,
            title: 'NCA Property',
            locale: languageProvider.currentLocale,
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
              Locale('th', 'TH'),
              Locale('my', 'MM'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  if (!connectivityProvider.isConnected)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.only(top: 60, bottom: 20),
                        width: double.infinity,
                        child: const Text(
                          'No Internet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
