import 'package:flutter/material.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

class TrainerWorkoutsProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();

  List<WorkoutModel> _workouts = [];
  List<WorkoutModel> get workouts => _workouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  Future<void> fetchWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await _trainerService.getWorkouts();
    } catch (e) {
      SnackBarUtils.showError('Failed to load workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addWorkout(WorkoutRequestModel request) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      await _trainerService.addWorkout(request);
      await fetchWorkouts();
      SnackBarUtils.showSuccess('Workout added successfully!');
      return true;
    } catch (e) {
      SnackBarUtils.showError('Failed to add workout: $e');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editWorkout(int id, WorkoutRequestModel request) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      await _trainerService.editWorkout(id, request);
      await fetchWorkouts();
      SnackBarUtils.showSuccess('Workout updated successfully!');
      return true;
    } catch (e) {
      SnackBarUtils.showError('Failed to update workout: $e');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteWorkout(int id) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      await _trainerService.deleteWorkout(id);
      await fetchWorkouts();
      SnackBarUtils.showSuccess('Workout deleted successfully!');
      return true;
    } catch (e) {
      SnackBarUtils.showError('Failed to delete workout: $e');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
