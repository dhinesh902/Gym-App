import 'package:flutter/material.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/providers/assign_workout_provider.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_date_picker.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AssignWorkoutScreen extends StatefulWidget {
  const AssignWorkoutScreen({super.key});

  @override
  State<AssignWorkoutScreen> createState() => _AssignWorkoutScreenState();
}

class _AssignWorkoutScreenState extends State<AssignWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  TextEditingController? _internalMemberController;
  TextEditingController? _internalWorkoutController;

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showCustomDatePicker(
      context,
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _assignWorkouts() async {
    if (!_formKey.currentState!.validate()) return;
    
    final provider = context.read<AssignWorkoutProvider>();
    final success = await provider.submitAssignment(
      scheduledDate: _dateController.text,
      notes: _notesController.text,
    );

    if (success && mounted) {
      context.pop();
    }
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 24),
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
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssignWorkoutProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Assign Workout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ElegantGradientBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 120, bottom: 40, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionCard(
                  title: 'Select Member',
                  icon: Icons.person_search_rounded,
                  children: [
                    Autocomplete<MemberSearchModel>(
                      displayStringForOption: (option) => option.fullname,
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        return await provider.searchMembers(textEditingValue.text);
                      },
                      onSelected: (MemberSearchModel selection) {
                        provider.setMember(selection);
                        Future.microtask(() {
                          _internalMemberController?.clear();
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        _internalMemberController = textEditingController;
                        return CustomTextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          labelText: 'Search Member',
                          hintText: 'Type name to search...',
                          prefixIcon: Icons.search_rounded,
                          suffixIcon: provider.isSearchingMember
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : null,
                          validator: (v) => provider.selectedMember == null ? 'Please select a member' : null,
                        );
                      },
                    ),
                    if (provider.selectedMember != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_rounded, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  provider.selectedMember!.fullname,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                              onPressed: () {
                                provider.setMember(null);
                              },
                            )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
                _buildSectionCard(
                  title: 'Select Workouts',
                  icon: Icons.fitness_center_rounded,
                  children: [
                    Autocomplete<WorkoutSearchModel>(
                      displayStringForOption: (option) => option.title,
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        return await provider.searchWorkouts(textEditingValue.text);
                      },
                      onSelected: (WorkoutSearchModel selection) {
                        provider.addWorkout(selection);
                        Future.microtask(() {
                          _internalWorkoutController?.clear();
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        _internalWorkoutController = textEditingController;
                        return CustomTextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          labelText: 'Search Workout',
                          hintText: 'Type workout title...',
                          prefixIcon: Icons.search_rounded,
                          suffixIcon: provider.isSearchingWorkout
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : null,
                          validator: (v) => provider.selectedWorkouts.isEmpty ? 'Please select at least 1 workout' : null,
                        );
                      },
                    ),
                    if (provider.selectedWorkouts.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.selectedWorkouts.map((workout) {
                          return Chip(
                            label: Text(workout.title),
                            deleteIcon: const Icon(Icons.cancel_rounded, size: 18),
                            onDeleted: () {
                              provider.removeWorkout(workout);
                            },
                            backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                            side: BorderSide(color: AppColors.secondary.withValues(alpha: 0.3)),
                          );
                        }).toList(),
                      ),
                    ]
                  ],
                ),
                _buildSectionCard(
                  title: 'Assignment Details',
                  icon: Icons.calendar_month_rounded,
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _dateController,
                          labelText: 'Scheduled Date',
                          hintText: 'Select Date',
                          prefixIcon: Icons.event_available_outlined,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _notesController,
                      labelText: 'Notes (Optional)',
                      hintText: 'Any special instructions...',
                      prefixIcon: Icons.note_alt_outlined,
                      maxLines: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                provider.isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          onPressed: _assignWorkouts,
                          child: const Text(
                            'Assign Workouts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
