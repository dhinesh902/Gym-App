import 'package:flutter/material.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TrainerScheduleProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();
  
  List<WorkoutAssignmentModel> _assignments = [];
  List<WorkoutAssignmentModel> get assignments => _assignments;
  
  PaginationModel? _pagination;
  PaginationModel? get pagination => _pagination;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;
  
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  
  Future<void> fetchInitialData() async {
    _isLoading = true;
    _assignments.clear();
    _pagination = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final trainerId = prefs.getInt('userId') ?? 0;
      final monthString = DateFormat('yyyy-MM').format(_selectedDate);
      
      final response = await _trainerService.getTrainerAssignments(
        trainerId,
        page: 1,
        limit: 30,
        month: monthString,
      );
      
      _assignments = response.data;
      _pagination = response.pagination;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchNextPage() async {
    if (_isFetchingMore || _pagination == null || !_pagination!.hasNextPage) return;
    
    _isFetchingMore = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final trainerId = prefs.getInt('userId') ?? 0;
      final monthString = DateFormat('yyyy-MM').format(_selectedDate);
      
      final response = await _trainerService.getTrainerAssignments(
        trainerId,
        page: _pagination!.currentPage + 1,
        limit: 30,
        month: monthString,
      );
      
      _assignments.addAll(response.data);
      _pagination = response.pagination;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
  
  void changeMonth(int monthsToAdd) {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + monthsToAdd, 1);
    fetchInitialData();
  }

  Future<bool> deleteAssignment(int assignmentId) async {
    try {
      await _trainerService.deleteTrainerAssignment(assignmentId);
      _assignments.removeWhere((a) => a.id == assignmentId);
      notifyListeners();
      return true;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      return false;
    }
  }

  Future<bool> editAssignment(int assignmentId, String newDate, String? newNotes) async {
    try {
      await _trainerService.editTrainerAssignment(assignmentId, scheduledDate: newDate, notes: newNotes);
      
      final index = _assignments.indexWhere((a) => a.id == assignmentId);
      if (index != -1) {
        final old = _assignments[index];
        _assignments[index] = WorkoutAssignmentModel(
          id: old.id,
          memberId: old.memberId,
          trainerId: old.trainerId,
          workoutId: old.workoutId,
          scheduledDate: newDate,
          status: old.status,
          createdAt: old.createdAt,
          updatedAt: old.updatedAt,
          notes: newNotes,
          member: old.member,
          workout: old.workout,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      return false;
    }
  }
}
