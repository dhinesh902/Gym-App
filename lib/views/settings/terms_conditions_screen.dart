import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.screenPadding),
        child: Text('By using the Gym Pro app, you agree to comply with and be bound by the following terms and conditions of use...'),
      ),
    );
  }
}
