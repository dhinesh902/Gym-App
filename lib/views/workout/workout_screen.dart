import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/views/widgets/actionbar.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CustomSliverAppBar(title: 'Today\'s Workout'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161622),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -40,
                          top: -30,
                          child: Icon(
                            Icons.fitness_center_rounded,
                            size: 160,
                            color: Colors.white.withValues(alpha: 0.03),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'TODAY\'S FOCUS',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Chest & Triceps',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Build upper body strength with this intensive push-focused routine.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                const Expanded(
                                  child: _WorkoutStat(
                                    icon: Icons.repeat_rounded,
                                    value: '6',
                                    label: 'Exercises',
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                const Expanded(
                                  child: _WorkoutStat(
                                    icon: Icons.timer_outlined,
                                    value: '45m',
                                    label: 'Duration',
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                const Expanded(
                                  child: _WorkoutStat(
                                    icon: Icons.local_fire_department_rounded,
                                    value: '350',
                                    label: 'Calories',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ExerciseCard(
                    title: 'Bench Press',
                    subtitle: '4 Sets • 10 Reps',
                    imageUrl:
                        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500&q=80',
                    completed: true,
                  ),
                  const ExerciseCard(
                    title: 'Incline Dumbbell Press',
                    subtitle: '3 Sets • 12 Reps',
                    imageUrl:
                        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=500&q=80',
                    completed: false,
                  ),
                  const ExerciseCard(
                    title: 'Tricep Pushdown',
                    subtitle: '4 Sets • 15 Reps',
                    imageUrl:
                        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&q=80',
                    completed: false,
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

class _WorkoutStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WorkoutStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool completed;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.workoutDetails);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.border.withValues(alpha: 0.3),
                  child: const Icon(Icons.image, color: AppColors.textLight),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: completed
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed
                      ? Colors.transparent
                      : AppColors.border.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                completed ? Icons.check_rounded : Icons.play_arrow_rounded,
                color: completed ? AppColors.accent : AppColors.textLight,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
