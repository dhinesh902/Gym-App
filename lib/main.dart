import 'package:flutter/material.dart';
import 'package:gym/routes/router.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/utils/theme.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gym Management',
      theme: AppTheme.lightTheme(AppColors.primary),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
