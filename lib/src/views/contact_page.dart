import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/widgets/message_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final companyName = dotenv.env['COMPANY_NAME'] ?? "[CO Name]";
    // final companyAddress = dotenv.env['COMPANY_ADDRESS'] ?? "[CO Address]";
    final companyEmail = dotenv.env['COMPANY_EMAIL'] ?? "[CO Email]";

    final currentLanguageCode = languageProvider.currentLocale.languageCode;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: GestureDetector(
      //     onTap: () => FocusScope.of(context).unfocus(),
      //     child: Text(
      //       AppLocalizations.of(context).translate('contactUs'),
      //       style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 18,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/contact_bg.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('companyEmail'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          companyEmail,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text:
                              companyName +
                              AppLocalizations.of(
                                context,
                              ).translate('contactOne') +
                              ('\n\n'),
                        ),
                        if (currentLanguageCode == 'en')
                          TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                ).translate('contactTwo') +
                                ('\n\n'),
                          ),
                        if (currentLanguageCode != 'en')
                          TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                ).translate('ourExpertise') +
                                ('\n\n'),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        TextSpan(
                          text:
                              "• ${AppLocalizations.of(context).translate('contactTitle1')}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(
                                context,
                              ).translate('contactValue1') +
                              ('\n\n'),
                        ),
                        TextSpan(
                          text:
                              "• ${AppLocalizations.of(context).translate('contactTitle2')}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(
                                context,
                              ).translate('contactValue2') +
                              ('\n\n'),
                        ),
                        if (currentLanguageCode == 'en')
                          TextSpan(
                            text:
                                "• ${AppLocalizations.of(context).translate('contactTitle3')}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        if (currentLanguageCode == 'en')
                          TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                ).translate('contactValue3') +
                                ('\n\n'),
                          ),
                        if (currentLanguageCode != 'en')
                          TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                ).translate('ourCommitment') +
                                ('\n\n'),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        TextSpan(
                          text:
                              AppLocalizations.of(
                                context,
                              ).translate('contactLast') +
                              ('\n\n'),
                        ),
                        if (currentLanguageCode != 'en')
                          TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                ).translate('contactLast2') +
                                ('\n\n'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (kIsWeb)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Our App',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Google Play Store Button
                              GestureDetector(
                                onTap: () async {
                                  // final playStoreUrl = '';
                                  // if (await canLaunchUrl(
                                  //   Uri.parse(playStoreUrl),
                                  // )) {
                                  //   await launchUrl(
                                  //     Uri.parse(playStoreUrl),
                                  //     mode: LaunchMode.externalApplication,
                                  //   );
                                  // } else {
                                  //   if (!context.mounted) return;
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text(
                                  //         AppLocalizations.of(
                                  //           context,
                                  //         ).translate('errorOpeningLink'),
                                  //       ),
                                  //       backgroundColor: Colors.red,
                                  //     ),
                                  //   );
                                  // }
                                },
                                child: Image.asset(
                                  'assets/images/img_google_play.png',
                                  height: 40,
                                ),
                              ),

                              const SizedBox(width: 16),
                              // Apple App Store Button
                              GestureDetector(
                                onTap: () async {
                                  final appStoreUrl =
                                      'https://apps.apple.com/us/app/nca-property/id6746011092';
                                  if (await canLaunchUrl(
                                    Uri.parse(appStoreUrl),
                                  )) {
                                    await launchUrl(
                                      Uri.parse(appStoreUrl),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('errorOpeningLink'),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Image.asset(
                                  'assets/images/img_appstore.png',
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  // Download Image button
                  Text(
                    AppLocalizations.of(context).translate('contactUs'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContactInfoRow(
                    img: 'assets/images/line_img.png',
                    label: AppLocalizations.of(context).translate('line'),
                    value:
                        dotenv.env['LINE_ID'] ??
                        'https://line.me/ti/p/12331698642',
                    onTap: () async {
                      // final lineUserId = '12331698642';
                      final lineUrl =
                          dotenv.env['LINE_ID'] ??
                          'https://line.me/ti/p/12331698642';

                      if (await canLaunchUrl(Uri.parse(lineUrl))) {
                        await launchUrl(
                          Uri.parse(lineUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        Clipboard.setData(ClipboardData(text: lineUrl));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('copyClipboard'),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF26CB93),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                  ),

                  ContactInfoRow(
                    img: 'assets/images/wechat_img.png',
                    label: AppLocalizations.of(context).translate('wechat'),
                    value: dotenv.env['WECHAT_ID'] ?? '12331',
                    onTap: () async {
                      final wechatId = dotenv.env['WECHAT_ID'] ?? '12331';
                      final wechatUrlAndroid = 'weixin://dl/chat?';
                      final wechatUrlIOS = 'wechat://';
                      final wechatUrl =
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? wechatUrlIOS
                              : wechatUrlAndroid;

                      try {
                        bool launched = false;
                        if (await canLaunchUrl(Uri.parse(wechatUrl))) {
                          await launchUrl(
                            Uri.parse(wechatUrl),
                            mode: LaunchMode.externalApplication,
                          );
                          launched = true;
                        }
                        await Clipboard.setData(ClipboardData(text: wechatId));

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    launched
                                        ? AppLocalizations.of(
                                          context,
                                        ).translate('pleaseSearchInWeChat')
                                        : AppLocalizations.of(
                                          context,
                                        ).translate('copyClipboard'),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF26CB93),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      } catch (e) {
                        print('WeChat launch error: $e');

                        if (!context.mounted) return;
                        await Clipboard.setData(ClipboardData(text: wechatId));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('copyClipboard'),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF26CB93),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const MessageFormWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final String img;
  final String label;
  final String value;
  final Function()? onTap;

  const ContactInfoRow({
    super.key,
    required this.img,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Image.asset(img, width: 16, height: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap:
                  onTap ??
                  () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('copyClipboard'),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF26CB93),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
