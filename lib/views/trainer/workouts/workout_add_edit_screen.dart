import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/providers/trainer_workouts_provider.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_dropdown.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';

class WorkoutAddEditScreen extends StatefulWidget {
  final WorkoutModel? workout;

  const WorkoutAddEditScreen({super.key, this.workout});

  @override
  State<WorkoutAddEditScreen> createState() => _WorkoutAddEditScreenState();
}

class _WorkoutAddEditScreenState extends State<WorkoutAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _targetMuscleController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;
  String _difficultLevel = 'Beginner';

  final List<String> _difficultyLevels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    final w = widget.workout;
    _titleController = TextEditingController(text: w?.title ?? '');
    _targetMuscleController = TextEditingController(text: w?.targetmuscle ?? '');
    _durationController = TextEditingController(text: w?.duration ?? '');
    _descriptionController = TextEditingController(text: w?.description ?? '');
    if (w != null && _difficultyLevels.contains(w.difficultlevel)) {
      _difficultLevel = w.difficultlevel;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetMuscleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    final request = WorkoutRequestModel(
      title: _titleController.text,
      targetmuscle: _targetMuscleController.text,
      difficultlevel: _difficultLevel,
      duration: _durationController.text,
      description: _descriptionController.text,
    );

    final provider = context.read<TrainerWorkoutsProvider>();
    bool success;

    if (widget.workout == null) {
      success = await provider.addWorkout(request);
    } else {
      success = await provider.editWorkout(widget.workout!.id, request);
    }

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workout != null;
    final isActionLoading = context.watch<TrainerWorkoutsProvider>().isActionLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Workout' : 'Add Workout',
          style: const TextStyle(
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
      body: ElegantGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(28),
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
                        const Text(
                          'Workout Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          hintText: 'Workout Title',
                          prefixIcon: Icons.title_rounded,
                          controller: _titleController,
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Target Muscle',
                          prefixIcon: Icons.accessibility_new_rounded,
                          controller: _targetMuscleController,
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          hintText: 'Difficulty Level',
                          prefixIcon: Icons.bar_chart_rounded,
                          value: _difficultLevel,
                          items: _difficultyLevels.map((String level) {
                            return DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _difficultLevel = val);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Duration (e.g. 60 mins)',
                          prefixIcon: Icons.timer_outlined,
                          controller: _durationController,
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Description',
                          prefixIcon: Icons.description_outlined,
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    onPressed: isActionLoading ? () {} : _saveWorkout,
                    child: isActionLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.surface,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Create Workout',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
