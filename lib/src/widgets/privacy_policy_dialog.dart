import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';

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
      child: SizedBox(
        // height: 189,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Text(
              AppLocalizations.of(context).translate('privacyPolicy'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                context.push('/privacy-policy');
              },
              child: Container(
                width: 170,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color.fromARGB(255, 179, 175, 175),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('clickToView'),
                    style: TextStyle(fontSize: 14, color: Color(0xFF10af79)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 23),
            Container(height: 0.5, color: Color.fromARGB(255, 179, 175, 175)),
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
                  Container(
                    width: 0.5,
                    height: 52,
                    color: Color.fromARGB(255, 179, 175, 175),
                  ),
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
      ),
    );
  }
}
