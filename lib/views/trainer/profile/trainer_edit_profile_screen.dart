import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'dart:ui';
import 'package:gym/views/widgets/custom_elevated_button.dart';

class TrainerEditProfileScreen extends StatelessWidget {
  const TrainerEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1594381898411-846e7d193883?q=80&w=100&auto=format&fit=crop',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: 'Full Name',
                    initialValue: 'Coach Mike',
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Email Address',
                    initialValue: 'mike.trainer@gym.com',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Phone Number',
                    initialValue: '+1 234 567 8900',
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Specialization',
                    initialValue: 'Strength & Conditioning, HIIT',
                    prefixIcon: Icons.star_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Experience (Years)',
                    initialValue: '8',
                    prefixIcon: Icons.timeline_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomElevatedButton(
              onPressed: () {},

              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
