import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/widgets/message_form_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CooperationPage extends StatelessWidget {
  const CooperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('cooperation'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
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
                  AppLocalizations.of(context).translate('projectName'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).translate('factoryDormitory'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/cooperation_bg.png', // TODO: Replace image
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
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
                  AppLocalizations.of(context).translate('cooperationDetails'),
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
                  AppLocalizations.of(context).translate('contactUs') + ('\n'),
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
                  value: '12331698642',
                  onTap: () async {
                    final lineUserId = '12331698642';
                    final lineUrl = 'https://line.me/ti/p/~$lineUserId';

                    if (await canLaunchUrl(Uri.parse(lineUrl))) {
                      await launchUrl(
                        Uri.parse(lineUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      Clipboard.setData(ClipboardData(text: lineUserId));
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
                  img: 'assets/images/whatapp_img.png',
                  label: AppLocalizations.of(context).translate('whatsapp'),
                  value: '12331698642',
                  onTap: () async {
                    final phoneNumber = '12331698642';
                    final whatsappUrl = 'https://wa.me/$phoneNumber';
                    try {
                      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                        await launchUrl(
                          Uri.parse(whatsappUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        Clipboard.setData(ClipboardData(text: phoneNumber));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              ).translate('copyClipboard'),
                            ),
                            backgroundColor: const Color(0xFF26CB93),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                ContactInfoRow(
                  img: 'assets/images/wechat_img.png',
                  label: AppLocalizations.of(context).translate('wechat'),
                  value: '12331698642',
                  onTap: () async {
                    final wechatId = '12331698642';
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
                ContactInfoRow(
                  img: 'assets/images/telegram_img.png',
                  label: AppLocalizations.of(context).translate('telegram'),
                  value: '12331698642',
                  onTap: () async {
                    final phone = '12331698642';

                    final telegramAppUrl = 'tg://resolve?phone=$phone';
                    final telegramWebUrl = 'https://t.me/+$phone';

                    try {
                      if (await canLaunchUrl(Uri.parse(telegramAppUrl))) {
                        await launchUrl(
                          Uri.parse(telegramAppUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } else if (await canLaunchUrl(
                        Uri.parse(telegramWebUrl),
                      )) {
                        await launchUrl(
                          Uri.parse(telegramWebUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        await Clipboard.setData(ClipboardData(text: phone));
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
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).translate('leaveMessage'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
