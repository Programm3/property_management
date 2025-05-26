import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/services/api_service.dart';
import 'package:property_manage/src/widgets/contact_option_widget.dart';
import 'package:property_manage/src/widgets/tag_widget_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  const DetailsPage({super.key, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _property;
  int _currentImageIndex = 0;
  late PageController _mainPageController;

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);

      return '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year}';
    } catch (e) {
      return 'Invalid';
    }
  }

  @override
  void initState() {
    super.initState();
    _mainPageController = PageController(initialPage: 0);
    _fetchPropertyDetails();
  }

  @override
  void dispose() {
    _mainPageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPropertyDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.get('posts/${widget.id}');

      if (mounted) {
        setState(() {
          _property = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An error occurred: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    final Map<String, String> titleName = {
      'zh': 'title_chinese',
      'en': 'title',
      'th': 'title_thailand',
      'lrr': 'title_myanmar',
    };

    final currentLanguageCode = languageProvider.currentLocale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffdcf5ea),
        elevation: 0,
        title: Text(
          _property != null &&
                  _property![titleName[currentLanguageCode]] != null
              ? utf8.decode(
                _property![titleName[currentLanguageCode]].runes.toList(),
              )
              : 'Property Details',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffddfcdb), Color(0xffffffff)],
                    stops: [0.24, 1.0],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('contactUs'),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PingFangSC-Medium',
                          ),
                        ),
                        Image.asset(
                          'assets/images/contact_img.png',
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Contact Options
                    ContactOption(
                      icon: 'assets/images/line_img.png',
                      title: 'Line ID',
                      subtitle: '12331698642',
                      onTap: () {
                        final lineUserId = '12331698642';
                        final lineUrl = 'https://line.me/ti/p/~$lineUserId';
                        launchUrl(
                          Uri.parse(lineUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ContactOption(
                      icon: 'assets/images/whatapp_img.png',
                      title: 'WHATS APP',
                      subtitle: '12331698642',
                      onTap: () {
                        final phoneNumber = '12331698642';
                        final whatsappUrl = 'https://wa.me/$phoneNumber';
                        launchUrl(
                          Uri.parse(whatsappUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ContactOption(
                      icon: 'assets/images/wechat_img.png',
                      title: 'WECHAT',
                      subtitle: '12331698642',
                    ),
                    const SizedBox(height: 16),
                    ContactOption(
                      icon: 'assets/images/telegram_img.png',
                      title: 'TELEGRAM',
                      subtitle: '12331698642',
                      onTap: () async {
                        final contact = '12331698642';
                        final telegramAppUrl = 'tg://resolve?phone=$contact';
                        final telegramWebUrl = 'https://t.me/+$contact';

                        if (await canLaunchUrl(Uri.parse(telegramAppUrl))) {
                          launchUrl(
                            Uri.parse(telegramAppUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(
                            Uri.parse(telegramWebUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF26CB93), // TODO: color wrong 60c696
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(
          AppLocalizations.of(context).translate('contactUs'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_property == null) {
      return const Center(child: Text('No property details available.'));
    }

    final languageProvider = Provider.of<LanguageProvider>(context);

    final Map<String, String> titleName = {
      'zh': 'title_chinese',
      'en': 'title',
      'th': 'title_thailand',
      'lrr': 'title_myanmar',
    };

    final Map<String, String> contentName = {
      'zh': 'content_chinese',
      'en': 'content',
      'th': 'content_thailand',
      'lrr': 'content_myanmar',
    };

    final Map<String, String> nameValue = {
      'zh': 'name_chinese',
      'en': 'name',
      'th': 'name_thailand',
      'lrr': 'name_myanmar',
    };

    final Map<String, String> colorText = {
      'zh': 'name_chinese',
      'en': 'name',
      'th': 'name_thailand',
      'lrr': 'name_myanmar',
    };

    final currentLanguageCode = languageProvider.currentLocale.languageCode;
    // print(_property!['property_type_detail']?[nameValue[currentLanguageCode]]);

    final images = _property!['images'] as List<dynamic>? ?? [];
    final title = utf8.decode(
      _property![titleName[currentLanguageCode]].runes.toList(),
    );
    final dynamic rawPrice = _property!['total'];
    final double numericPrice =
        (rawPrice is String)
            ? double.tryParse(rawPrice) ?? 0.0
            : (rawPrice is num ? rawPrice.toDouble() : 0.0);

    final String price = NumberFormat.currency(
      symbol: '฿',
      decimalDigits: 0,
    ).format(numericPrice);
    final content = utf8.decode(
      _property![contentName[currentLanguageCode]].runes.toList(),
    );
    final propertyArea = _property!['rai'] ?? 'Unknown Rai';
    final province = utf8.decode(
      _property!['province_detail']?[nameValue[currentLanguageCode]].runes
              .toList() ??
          'Unknown Province'.runes.toList(),
    );
    final landColor = utf8.decode(
      _property!['landcolor_detail']?[colorText[currentLanguageCode]].runes
              .toList() ??
          'Unknown Color'.runes.toList(),
    );
    final propertyType = utf8.decode(
      _property!['property_type_detail']?[nameValue[currentLanguageCode]].runes
          .toList(),
    );

    final rentType = utf8.decode(
      _property!['rent_type_detail']?[nameValue[currentLanguageCode]].runes
          .toList(),
    );

    final location = _property!['location'] ?? 'No location available';
    final createdAt =
        _property!['created_at'] != null
            ? _formatDate(_property!['created_at'])
            : '-';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 212,
              width: double.infinity,
              child:
                  images.isNotEmpty
                      ? PageView.builder(
                        controller: _mainPageController,
                        itemCount: images.length,
                        onPageChanged: (newIndex) {
                          setState(() {
                            _currentImageIndex = newIndex;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  int currentDialogImageIndex = index;
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    child: StatefulBuilder(
                                      builder: (
                                        BuildContext dialogContext,
                                        StateSetter setDialogState,
                                      ) {
                                        return Stack(
                                          children: [
                                            PageView.builder(
                                              itemCount: images.length,
                                              controller: PageController(
                                                initialPage: index,
                                              ),
                                              onPageChanged: (newIndex) {
                                                setDialogState(() {
                                                  currentDialogImageIndex =
                                                      newIndex;
                                                });
                                                setState(() {
                                                  _currentImageIndex = newIndex;
                                                });

                                                _mainPageController.jumpToPage(
                                                  newIndex,
                                                );
                                              },
                                              itemBuilder: (
                                                context,
                                                pageIndex,
                                              ) {
                                                return InteractiveViewer(
                                                  minScale: 0.5,
                                                  maxScale: 3.0,
                                                  child: Container(
                                                    color: Colors.black,
                                                    child: Center(
                                                      child: Image.network(
                                                        images[pageIndex]['image'],
                                                        width: double.infinity,
                                                        fit: BoxFit.contain,
                                                        errorBuilder:
                                                            (
                                                              ctx,
                                                              error,
                                                              _,
                                                            ) => Container(
                                                              color:
                                                                  Colors.black,
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  size: 100,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            // Close button
                                            Positioned(
                                              top: 20,
                                              right: 20,
                                              child: GestureDetector(
                                                onTap:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Positioned(
                                              bottom: 20,
                                              right: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  '${currentDialogImageIndex + 1}/${images.length}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              images[index]['image'],
                              width: double.infinity,
                              height: 212,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (ctx, error, _) => Container(
                                    height: 212,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          );
                        },
                      )
                      : Container(
                        width: double.infinity,
                        height: 212,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
            ),

            // Image counter
            Positioned(
              bottom: 30,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xaa000000),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  images.isNotEmpty
                      ? '${_currentImageIndex + 1}/${images.length}'
                      : '0/0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),

        Transform.translate(
          offset: const Offset(0, -25),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffe85c48),
                      ),
                    ),
                    Text(
                      createdAt,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 11),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TagWidget(
                            label:
                                propertyArea +
                                AppLocalizations.of(
                                  context,
                                ).translate('areaUnit'),
                            imagePath: 'assets/images/property_img.png',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TagWidget(
                            label: landColor.toUpperCase(),
                            imagePath: 'assets/images/theme_img.png',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TagWidget(
                            label: propertyType,
                            imagePath: 'assets/images/education_img.png',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TagWidget(
                            label: rentType,
                            imagePath: 'assets/images/sell_img.png',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TagWidget(
                            label: province,
                            imagePath: 'assets/images/place_img.png',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // final encodedLocation = Uri.encodeComponent(
                              //   location,
                              // );
                              // final googleMapsUrl =
                              //     'https://maps.google.com/?q=$encodedLocation';
                              String mapUrl = location;

                              // if (Platform.isIOS) {
                              //   mapUrl =
                              //       'comgooglemaps://?q=${Uri.encodeComponent(location)}';
                              // }
                              final Uri uri = Uri.parse(mapUrl);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                final fallbackUrl =
                                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}';
                                final fallbackUri = Uri.parse(fallbackUrl);

                                if (await canLaunchUrl(fallbackUri)) {
                                  await launchUrl(
                                    fallbackUri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('couldNotOpenMap'),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: TagWidget(
                              label: AppLocalizations.of(
                                context,
                              ).translate('googleMap'),
                              imagePath: 'assets/images/google_map_img.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).translate('detailedIntro'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                if (content.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xfff5f5f5), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),

                        // const SizedBox(height: 10),
                        // Container(
                        //   width: double.infinity,
                        //   height: 212,
                        //   color: Colors.grey[300],
                        //   child: const Icon(
                        //     Icons.broken_image,
                        //     size: 60,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
