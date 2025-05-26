import 'package:flutter/material.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:property_manage/src/providers/message_provider.dart';

class MessageFormWidget extends StatefulWidget {
  final VoidCallback? onMessageSent;

  const MessageFormWidget({super.key, this.onMessageSent});

  @override
  State<MessageFormWidget> createState() => _MessageFormWidgetState();
}

class _MessageFormWidgetState extends State<MessageFormWidget> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('fillInAllField'),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 100),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final messageProvider = Provider.of<MessageProvider>(
        context,
        listen: false,
      );
      final success = await messageProvider.sendMessage(
        name: _nameController.text,
        contact: _contactController.text,
        content: _messageController.text,
      );

      if (success) {
        _nameController.clear();
        _contactController.clear();
        _messageController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('messageSentSuccess'),
              ),
              backgroundColor: Color(0xFF26CB93),
            ),
          );
        }

        if (widget.onMessageSent != null) {
          widget.onMessageSent!();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                messageProvider.error ??
                    AppLocalizations.of(context).translate('messageSentFail'),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 100),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 100),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('leaveMessage'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _nameController,
          label: AppLocalizations.of(context).translate('yourName'),
          hintText: AppLocalizations.of(context).translate('fillYourName'),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _contactController,
          label: AppLocalizations.of(context).translate('phoneOrEmail'),
          hintText: AppLocalizations.of(context).translate('fillPhoneOrEmail'),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _messageController,
          label: AppLocalizations.of(context).translate('yourRequirement'),
          hintText: AppLocalizations.of(context).translate('fillRequirements'),
          maxLines: 4,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 30),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 1,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        Center(
          child: SizedBox(
            width: 160,
            height: 40,
            child:
                _isSubmitting
                    ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF26CB93),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                    : ElevatedButton(
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26CB93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('send'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.maxLines = 1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (maxLines > 1) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
