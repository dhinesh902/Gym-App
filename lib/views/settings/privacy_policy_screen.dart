import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Privacy Policy"),
      body: const ElegantGradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.screenPadding),
          child: Text(
            'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information...',
          ),
        ),
      ),
    );
  }
}
