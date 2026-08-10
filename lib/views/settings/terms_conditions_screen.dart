import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Terms & Conditions"),
      body: const ElegantGradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.screenPadding),
          child: Text(
            'By using the Gym Pro app, you agree to comply with and be bound by the following terms and conditions of use...',
          ),
        ),
      ),
    );
  }
}
