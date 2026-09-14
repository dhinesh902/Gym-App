import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/providers/trainer_workouts_provider.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerWorkoutsProvider>().fetchWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerWorkoutsProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addWorkout',
        onPressed: () {
          context.push(AppRoutes.trainerWorkoutAddEdit);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Workout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ElegantGradientBackground(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : provider.workouts.isEmpty
                ? const Center(
                    child: Text(
                      'No workouts found.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 100, bottom: 100, left: 16, right: 16),
                    itemCount: provider.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = provider.workouts[index];
                      return _buildWorkoutCard(context, workout, provider);
                    },
                  ),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, WorkoutModel workout, TrainerWorkoutsProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  workout.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push(AppRoutes.trainerWorkoutAddEdit, extra: workout);
                    },
                    icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 22),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, workout.id, provider),
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTag(Icons.fitness_center_rounded, workout.targetmuscle),
              const SizedBox(width: 8),
              _buildTag(Icons.timer_outlined, workout.duration),
              const SizedBox(width: 8),
              _buildTag(Icons.bar_chart_rounded, workout.difficultlevel),
            ],
          ),
          if (workout.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              workout.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, TrainerWorkoutsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout?'),
        content: const Text('Are you sure you want to delete this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteWorkout(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
