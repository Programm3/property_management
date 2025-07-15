import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/widgets/message_form_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CooperationPage extends StatelessWidget {
  const CooperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/cooperation_bg.png',
                fit: BoxFit.fill,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('factoryDormitory'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('cooperationObjective'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('cooperationObjectiveValue'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('cooperationDetails'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. ${AppLocalizations.of(context).translate('cooperationDetailsValueOne')}\n\n 2. ${AppLocalizations.of(context).translate('cooperationDetailsValueTwo')}\n\n 3. ${AppLocalizations.of(context).translate('cooperationDetailsValueThree')}',

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).translate('contactUs') +
                        ('\n'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('contactUsValue') +
                        ('\n'),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  ContactInfoRow(
                    img: 'assets/images/line_img.png',
                    label: AppLocalizations.of(context).translate('line'),
                    value:
                        dotenv.env['LINE_ID'] ??
                        'https://line.me/ti/p/12331698642',
                    onTap: () async {
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
                  const SizedBox(height: 16),
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
