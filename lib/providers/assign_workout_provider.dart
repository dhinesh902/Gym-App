import 'package:flutter/material.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignWorkoutProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();

  MemberSearchModel? _selectedMember;
  MemberSearchModel? get selectedMember => _selectedMember;

  final List<WorkoutSearchModel> _selectedWorkouts = [];
  List<WorkoutSearchModel> get selectedWorkouts => _selectedWorkouts;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isSearchingMember = false;
  bool get isSearchingMember => _isSearchingMember;

  bool _isSearchingWorkout = false;
  bool get isSearchingWorkout => _isSearchingWorkout;

  Future<Iterable<MemberSearchModel>> searchMembers(String query) async {
    if (query.trim().isEmpty) {
      return const Iterable<MemberSearchModel>.empty();
    }
    
    _isSearchingMember = true;
    notifyListeners();
    
    try {
      return await _trainerService.searchCustomers(query.trim());
    } finally {
      _isSearchingMember = false;
      notifyListeners();
    }
  }

  void setMember(MemberSearchModel? member) {
    _selectedMember = member;
    notifyListeners();
  }

  Future<Iterable<WorkoutSearchModel>> searchWorkouts(String query) async {
    if (query.trim().isEmpty) {
      return const Iterable<WorkoutSearchModel>.empty();
    }

    _isSearchingWorkout = true;
    notifyListeners();
    
    try {
      return await _trainerService.searchWorkouts(query.trim());
    } finally {
      _isSearchingWorkout = false;
      notifyListeners();
    }
  }

  void addWorkout(WorkoutSearchModel workout) {
    if (!_selectedWorkouts.any((w) => w.id == workout.id)) {
      _selectedWorkouts.add(workout);
      notifyListeners();
    }
  }

  void removeWorkout(WorkoutSearchModel workout) {
    _selectedWorkouts.removeWhere((w) => w.id == workout.id);
    notifyListeners();
  }

  Future<bool> submitAssignment({
    required String scheduledDate,
    required String notes,
  }) async {
    if (_selectedMember == null) {
      SnackBarUtils.showError('Please select a member');
      return false;
    }
    if (_selectedWorkouts.isEmpty) {
      SnackBarUtils.showError('Please select at least one workout');
      return false;
    }
    if (scheduledDate.isEmpty) {
      SnackBarUtils.showError('Please select a scheduled date');
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final trainerId = prefs.getInt('userId') ?? 0;

      final List<WorkoutAssignmentItem> workoutItems = _selectedWorkouts
          .map(
            (w) => WorkoutAssignmentItem(
              workoutId: w.id,
              scheduledDate: scheduledDate,
              status: 'pending',
              notes: notes.isNotEmpty ? notes : null,
            ),
          )
          .toList();

      final request = AssignWorkoutRequestModel(
        memberId: _selectedMember!.id,
        trainerId: trainerId,
        workouts: workoutItems,
      );

      await _trainerService.assignWorkouts(request);
      SnackBarUtils.showSuccess('Workouts assigned successfully!');
      return true;
    } catch (e) {
      SnackBarUtils.showError('Failed to assign workouts: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
