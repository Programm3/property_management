import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/models/province.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/province_provider.dart';
import 'package:provider/provider.dart';

class OnBoarding2Page extends StatefulWidget {
  const OnBoarding2Page({super.key, this.rentTypeId});
  final String? rentTypeId;

  @override
  State<OnBoarding2Page> createState() => _OnBoarding2PageState();
}

class _OnBoarding2PageState extends State<OnBoarding2Page> {
  String? selectedProvinceId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProvinceProvider>().loadProvinces();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguageCode = languageProvider.currentLocale.languageCode;

    String getLocalizedProvinceName(Province province, String languageCode) {
      switch (languageCode) {
        case 'zh':
          return utf8.decode(province.nameChinese!.runes.toList());
        case 'th':
          return utf8.decode(province.nameThailand!.runes.toList());
        case 'my':
          return utf8.decode(province.nameMyanmar!.runes.toList());
        default:
          return province.name;
      }
    }

    return Consumer<ProvinceProvider>(
      builder: (context, provinceProvider, child) {
        if (provinceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provinceProvider.error != null) {
          return Center(child: Text('Error: ${provinceProvider.error}'));
        }

        final provinces =
            provinceProvider.provinces.where((p) => p.id != null).toList();
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
                  onPressed: () => context.push('/home'),
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
                              ).translate('specificProvince'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' "',
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: provinces.length,
                      itemBuilder: (context, index) {
                        final province = provinces[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            color: Color(0xFFF6F9FA),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              leading: Image.asset(
                                'assets/images/location_img.png',
                                width: 30,
                                height: 30,
                              ),
                              title: Text(
                                getLocalizedProvinceName(
                                  province,
                                  currentLanguageCode,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              trailing:
                                  selectedProvinceId == province.id.toString()
                                      ? Image.asset(
                                        'assets/images/check_mark.png',
                                        width: 24,
                                        height: 24,
                                      )
                                      : Image.asset(
                                        'assets/images/uncheck_green.png',
                                        width: 24,
                                        height: 24,
                                      ),
                              onTap: () {
                                setState(() {
                                  selectedProvinceId = province.id.toString();
                                  String navigationPath = '/home';
                                  if (selectedProvinceId != null) {
                                    navigationPath +=
                                        '?province=$selectedProvinceId';

                                    if (widget.rentTypeId != null) {
                                      navigationPath +=
                                          '&rent_type=${widget.rentTypeId}';
                                    }
                                  } else if (widget.rentTypeId != null) {
                                    navigationPath +=
                                        '?rent_type=${widget.rentTypeId}';
                                  }
                                  context.push(navigationPath);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
