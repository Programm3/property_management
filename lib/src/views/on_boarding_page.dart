import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/models/rent_type.dart';
// import 'package:property_manage/src/models/rent_type.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/rental_types_provider.dart';
// import 'package:property_manage/src/services/api_service.dart';
import 'package:property_manage/src/widgets/option_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:property_manage/src/services/privacy_policy_service.dart';
import 'package:property_manage/src/widgets/privacy_policy_dialog.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  String? selectedRentTypeId;
  bool _isLoggingIn = false;

  String getRentName(RentType rentType, String languageCode) {
    switch (languageCode) {
      case 'zh':
        return utf8.decode(rentType.nameChinese!.runes.toList());
      case 'th':
        return utf8.decode(rentType.nameThailand!.runes.toList());
      case 'my':
        return utf8.decode(rentType.nameMyanmar!.runes.toList());
      default:
        return rentType.name;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkPrivacyPolicy();
        _login();
        // context.read<RentalTypesProvider>().loadRentTypes();
      }
    });
  }

  Future<void> _checkPrivacyPolicy() async {
    final hasAccepted = await PrivacyPolicyService.hasAcceptedPrivacyPolicy();
    if (!hasAccepted && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PrivacyPolicyDialog(
            onAccept: () {
              PrivacyPolicyService.setPrivacyPolicyAccepted();
              Navigator.of(context).pop();
            },
            onDecline: () {
              Navigator.of(context).pop();
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          );
        },
      );
    }
  }

  Future<void> _login() async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isAuthenticated) {
        context.read<RentalTypesProvider>().loadRentTypes();

        if (!mounted) return;
        return;
      }

      final success = await authProvider.login('soegyi', 'ss123123');

      if (success) {
        if (!mounted) return;

        // _loadRentTypes();
        context.read<RentalTypesProvider>().loadRentTypes();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       AppLocalizations.of(context).translate('loginSuccess'),
        //     ),
        //   ),
        // );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.error.toString())));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error during login: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  void handlePropertyAction(String rentTypeId) {
    setState(() {
      selectedRentTypeId = rentTypeId;
    });
    context.push('/onboarding2?rent_type=$rentTypeId');
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguageCode = languageProvider.currentLocale.languageCode;
    return Consumer<RentalTypesProvider>(
      builder: (context, rentalTypesProvider, child) {
        if (rentalTypesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (rentalTypesProvider.error != null) {
          return Center(child: Text('Error: ${rentalTypesProvider.error}'));
        }
        final rentTypes = rentalTypesProvider.rentTypes.toList();
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffdcf5ea), Color(0xfff5f5f5)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    if (authProvider.isAuthenticated) {
                      context.push('/onboarding2');
                    } else {
                      _login().then((_) {
                        if (authProvider.isAuthenticated) {
                          if (!context.mounted) return;
                          context.push('/onboarding2');
                        }
                      });
                    }
                  },
                  child: Text(
                    AppLocalizations.of(
                      context,
                    ).translate('skip').toUpperCase(),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '" ',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26CB93),
                              ),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              ).translate('whatYouLookingFor'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '"',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26CB93),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  if (!Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).isAuthenticated)
                    Center(
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF26CB93),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('tryAgain'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: rentTypes.length,
                      itemBuilder: (context, index) {
                        final rentType = rentTypes[index];

                        String imagePath;

                        switch (rentType.name.toLowerCase()) {
                          case 'buy':
                            imagePath = 'assets/images/property_buy_img.png';
                            break;
                          case 'rent':
                            imagePath = 'assets/images/property_rent_img.png';
                            break;
                          case 'sell':
                            imagePath = 'assets/images/property_sell_img.png';
                            break;
                          case 'rent out':
                          case 'rent-out':
                            imagePath =
                                'assets/images/property_rent_out_img.png';
                            break;
                          default:
                            imagePath = 'assets/images/property_buy_img.png';
                        }

                        return OptionCard(
                          title: getRentName(rentType, currentLanguageCode),
                          imagePath: imagePath,
                          onTap:
                              () =>
                                  handlePropertyAction(rentType.id.toString()),
                        );
                      },
                    ),
                  ),

                  // OptionCard(
                  //   title: AppLocalizations.of(
                  //     context,
                  //   ).translate('propertyBuy'),
                  //   imagePath: 'assets/images/property_buy_img.png',
                  //   onTap: () => handlePropertyAction('buy'),
                  // ),
                  // OptionCard(
                  //   title: AppLocalizations.of(
                  //     context,
                  //   ).translate('propertyRent'),
                  //   imagePath: 'assets/images/property_rent_img.png',
                  //   onTap: () => handlePropertyAction('rent'),
                  // ),
                  // OptionCard(
                  //   title: AppLocalizations.of(
                  //     context,
                  //   ).translate('propertySell'),
                  //   imagePath: 'assets/images/property_sell_img.png',
                  //   onTap: () => handlePropertyAction('sell'),
                  // ),
                  // OptionCard(
                  //   title: AppLocalizations.of(
                  //     context,
                  //   ).translate('propertyRentOut'),
                  //   imagePath: 'assets/images/property_rent_out_img.png',
                  //   onTap: () => handlePropertyAction('rent-out'),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
