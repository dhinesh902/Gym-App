import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.screenPadding),
        child: Text('Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information...'),
      ),
    );
  }
}
