import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
// import 'package:property_manage/src/localization/app_localizations.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const PrivacyPolicyDialog({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Text(
            AppLocalizations.of(context).translate('privacyPolicy'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          InkWell(
            onTap: () {
              context.goNamed('privacyPolicy');
            },
            child: Container(
              width: 170,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF26CB93), width: 1),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('clickToView'),
                  style: TextStyle(fontSize: 14, color: Color(0xFF10af79)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(height: 1, color: Color(0xffe5e5e5)),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onDecline,
                    child: Container(
                      height: 56,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).translate('refuseAndClose'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff666666),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 52, color: Color(0xffe5e5e5)),
                Expanded(
                  child: InkWell(
                    onTap: onAccept,
                    child: Container(
                      height: 56,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).translate('agree'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF23b584),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
