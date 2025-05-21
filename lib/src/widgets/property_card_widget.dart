import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:provider/provider.dart';

class PropertyCard extends StatelessWidget {
  final dynamic property;
  final VoidCallback onTap;

  const PropertyCard({super.key, required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> contentText = {
      'zh': 'content_chinese',
      'en': 'content',
      'th': 'content_thailand',
      'lrr': 'content_myanmar',
    };

    final Map<String, String> titleText = {
      'zh': 'title_chinese',
      'en': 'title',
      'th': 'title_thailand',
      'lrr': 'title_myanmar',
    };

    final Map<String, String> colorText = {
      'zh': 'name_chinese',
      'en': 'name',
      'th': 'name_thailand',
      'lrr': 'name_myanmar',
    };

    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguageCode = languageProvider.currentLocale.languageCode;
    final String title = utf8.decode(
      property[titleText[currentLanguageCode]].runes.toList(),
    );
    final double price = double.tryParse('${property['total']}') ?? 0;
    final String formattedPrice = NumberFormat.currency(
      symbol: '฿',
      decimalDigits: 0,
    ).format(price);

    final String size =
        "${property['rai']}${AppLocalizations.of(context).translate('areaUnit')}";
    final String color = utf8.decode(
      property['landcolor_detail']?[colorText[currentLanguageCode]].runes
              .toList() ??
          'Unknown Color'.runes.toList(),
    );
    final List<dynamic> images = property['images'] ?? [];
    final String? imageUrl = images.isNotEmpty ? images[0]['image'] : null;

    final DateTime createdDate =
        DateTime.tryParse(property['created_at'] ?? '') ?? DateTime.now();
    final String formattedDate = DateFormat('dd/MM/yyyy').format(createdDate);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    imageUrl != null
                        ? Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (ctx, error, _) => Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'NO PICTURES',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),

            // Property details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 40,
                    runSpacing: 8,
                    children: [
                      buildTag(
                        size,
                        imagePath: 'assets/images/property_img.png',
                      ),
                      buildTag(color, imagePath: 'assets/images/theme_img.png'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (property[contentText[currentLanguageCode]].runes
                      .toList()
                      .isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4FCF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        utf8.decode(
                          property[contentText[currentLanguageCode]].runes
                              .toList(),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffe85c48),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(String label, {String? imagePath}) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (imagePath != null) Image.asset(imagePath, width: 25, height: 25),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff000000),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
