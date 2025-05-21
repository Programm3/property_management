import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        color: const Color(0xfff6f9fa),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'PingFangSC-Medium',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Image.asset(imagePath, width: 30, height: 30),
          onTap: onTap,
        ),
      ),
    );
  }
}
