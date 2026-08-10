import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(title: "Today\'s Diet"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MacroSummary(),
                  const SizedBox(height: 32),
                  const Text(
                    'Meals',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const MealCard(
                    mealTime: 'Breakfast',
                    mealName: 'Oats & Eggs',
                    macros: '450 kcal • 30g Protein',
                    icon: Icons.breakfast_dining_rounded,
                    color: AppColors.lightBlue,
                    bgColor: AppColors.lightBlueBg,
                  ),
                  const MealCard(
                    mealTime: 'Lunch',
                    mealName: 'Chicken & Rice',
                    macros: '650 kcal • 50g Protein',
                    icon: Icons.lunch_dining_rounded,
                    color: AppColors.lightGreen,
                    bgColor: AppColors.lightGreenBg,
                  ),
                  MealCard(
                    mealTime: 'Snack',
                    mealName: 'Protein Shake',
                    macros: '200 kcal • 25g Protein',
                    icon: Icons.local_cafe_rounded,
                    color: AppColors.accent,
                    bgColor: AppColors.accent.withValues(alpha: 0.15),
                  ),
                  MealCard(
                    mealTime: 'Dinner',
                    mealName: 'Salmon & Veggies',
                    macros: '550 kcal • 40g Protein',
                    icon: Icons.dinner_dining_rounded,
                    color: AppColors.primary,
                    bgColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MacroSummary extends StatelessWidget {
  const MacroSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
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
          const Text(
            'Daily Macros',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              MacroItem(label: 'Calories', current: '1850', total: '2500', color: AppColors.primary),
              MacroItem(label: 'Protein', current: '145g', total: '180g', color: AppColors.accent),
              MacroItem(label: 'Carbs', current: '120g', total: '200g', color: AppColors.lightBlue),
            ],
          ),
        ],
      ),
    );
  }
}

class MacroItem extends StatelessWidget {
  final String label;
  final String current;
  final String total;
  final Color color;

  const MacroItem({
    super.key,
    required this.label,
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: 0.7,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 8,
              ),
            ),
            Icon(Icons.restaurant_menu_rounded, color: color, size: 28),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current / $total',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealTime;
  final String mealName;
  final String macros;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const MealCard({
    super.key,
    required this.mealTime,
    required this.mealName,
    required this.macros,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealTime,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  mealName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  macros,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.accent,
            size: 24,
          ),
        ],
      ),
    );
  }
}
