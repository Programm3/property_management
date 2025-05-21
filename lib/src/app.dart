import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

    // if (authProvider.isAuthenticated) {
    setState(() {
      _isInitializing = false;
    });
    return;
    // } else {
    //   await _loginUser();
    // }
  }

  // Future<void> _loginUser() async {
  //   try {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     final success = await authProvider.login('soegyi', 'ss123123');

  //     if (success) {
  //       print('Login successful');
  //     } else {
  //       print('Login failed: ${authProvider.error}');
  //     }
  //   } catch (e) {
  //     print('Error during login: $e');
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isInitializing = false;
  //       });
  //     }
  //   }
  // }

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
      child: Consumer2<LanguageProvider, AuthProvider>(
        builder: (context, languageProvider, authProvider, child) {
          if (_isInitializing) {
            return const Center(child: CircularProgressIndicator());
          }
          return MaterialApp.router(
            title: 'Property Management',
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
            routerConfig: router,
          );
        },
      ),
    );
  }
}
