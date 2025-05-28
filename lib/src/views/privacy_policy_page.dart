import 'package:flutter/material.dart';
import 'package:property_manage/src/localization/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('privacyPolicy'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'We know how important personal information is to you and thank you for the trust you place in us. Through this policy, we will explain to you the purpose, method, and scope of the collection, storage, sharing, protection, and use of your personal information, information security protection measures, as well as the methods we provide you with to access, update, delete, and other control of your personal information, and explain your rights, which are as follows:\n\n'
                '1. In order to help you understand the types and purposes of information that we need to collect when you use our services, we will explain to you one by one based on the specific services.\n\n'
                '2. In order to provide services to you, we will collect your information in accordance with the principles of legality, legitimacy, necessity, and good faith.\n\n'
                '3. If it is necessary to share your information to a third party in order to provide you with services, we will assess the legality, legitimacy, and necessity of the information collected by the third party. We will require third parties to take measures to strictly protect your information and comply with relevant laws, regulations, and regulatory requirements. In addition, we will obtain your consent or confirm that you have authorized your consent in the form of confirmation agreement, copy confirmation in specific scenarios, pop-up prompts, etc., in accordance with the requirements of laws and regulations and national standards.\n\n'
                '4. If we need to obtain your information from a third party in order to provide services to you, we will ask the third party to explain the source of the information and obtain your authorization to guarantee the legality of the information provided. If the processing of personal information required for our business exceeds the scope of your authorization or involves the provision of your personal information to a third party, we will obtain your express consent.\n\n'
                '5. You can access and manage your information, privacy management functions, log out of your account, or make complaints through the means described in this policy. When you agree to our registration agreement and service agreement, or when you visit or download our platform, or when you actually use any of our products or services through our own customer service channels, existing or future software developed by third-party partners, please confirm that you have read and understood the terms of this policy by clicking "confirm", "agree" (specific to the name displayed on the page) or otherwise sign this policy, you agree that we will process your personal information in accordance with this policy. We strive to use plain, concise, and concise text, and the terms and personal sensitive information in this policy have been specially marked in bold for your attention. If you do not agree with or understand part or all of this policy, please stop using our products or services immediately. You may contact and consult us on matters related to this policy through our contact information. This policy is based on applicable laws and regulations as of the effective date, with reference to industry best practices and international standards. If the content of this policy is otherwise stipulated by national laws and regulations, the laws and regulations shall prevail. When you agree to this policy, the other provisions and agreements shall prevail. This policy does not apply to services, please ensure that you are 18 years of age or older before using the related products and/or services. If you have not reached the age above, we will inform you in a timely manner when there is any significant change in the scope, purpose, and manner of collection and processing of your personal information, and we will obtain your consent again.\n\n'
                'We will use the collected information for other purposes. We will use the flower in a reasonable way (such as app-to-window, etc.) to inform you and before the use of your consent again.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
