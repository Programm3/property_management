import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/localization/app_localizations.dart';

class SwitchLanguagePage extends StatefulWidget {
  const SwitchLanguagePage({super.key});

  @override
  State<SwitchLanguagePage> createState() => _SwitchLanguagePageState();
}

class _SwitchLanguagePageState extends State<SwitchLanguagePage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languages = languageProvider.supportedLanguages.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('language'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final languageName = languages[index];
          final flag = 'assets/images/${_getFlagImage(languageName)}';
          final isSelected =
              languageProvider.getCurrentLanguageName() == languageName;

          return GestureDetector(
            onTap: () {
              languageProvider.changeLanguage(languageName);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(flag, width: 24, height: 24),
                  const SizedBox(width: 12),
                  Text(
                    languageName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color:
                        isSelected
                            ? const Color(0xFF26CB93)
                            : Color(0xff979797),
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFlagImage(String languageName) {
    switch (languageName) {
      case '中文':
        return 'china_flag.png';
      case 'English':
        return 'usa_flag.png';
      case 'ไทย':
        return 'thai_flag.png';
      case 'မြန်မာ':
        return 'burma_flag.png';
      default:
        return 'china_flag.png';
    }
  }
}
