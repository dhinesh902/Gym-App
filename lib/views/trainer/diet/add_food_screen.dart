import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';

class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Add New Food'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionCard(
              title: 'Basic Details',
              icon: Icons.info_outline_rounded,
              children: [
                const CustomTextField(
                  hintText: 'Food Name',
                  prefixIcon: Icons.fastfood_rounded,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  hintText: 'Category (e.g., Protein, Carbs)',
                  prefixIcon: Icons.category_rounded,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  hintText: 'Serving Size (e.g., 100g, 1 cup)',
                  prefixIcon: Icons.scale_rounded,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SectionCard(
              title: 'Nutrition Facts (per serving)',
              icon: Icons.pie_chart_outline_rounded,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: CustomTextField(
                        hintText: 'Calories',
                        prefixIcon: Icons.local_fire_department_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Protein (g)',
                        prefixIcon: Icons.egg_alt_rounded,
                        keyboardType: TextInputType.number,
                        hintColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Carbs (g)',
                        prefixIcon: Icons.grass_rounded,
                        keyboardType: TextInputType.number,
                        hintColor: AppColors.lightBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: CustomTextField(
                        hintText: 'Fat (g)',
                        prefixIcon: Icons.opacity_rounded,
                        keyboardType: TextInputType.number,
                        hintColor: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            SectionCard(
              title: 'Extra Information',
              icon: Icons.description_outlined,
              children: [
                const CustomTextField(hintText: 'Description', maxLines: 3),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Health Benefits', maxLines: 3),
              ],
            ),
            const SizedBox(height: 48),
            CustomElevatedButton(
              onPressed: () {
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Add Food to Library',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
