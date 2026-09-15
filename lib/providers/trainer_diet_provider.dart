import 'package:flutter/material.dart';
import 'package:gym/models/diet_model.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

class TrainerDietProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DietLibraryModel> _diets = [];
  List<DietLibraryModel> get diets => _diets;
  
  Map<String, int> _counts = {};
  Map<String, int> get counts => _counts;

  String _currentSession = 'breakfast';
  String get currentSession => _currentSession;

  Future<void> fetchDiets(String session) async {
    // Standardize session to API expected format (lowercase, no spaces)
    String apiSession = session.toLowerCase().replaceAll(' ', '');
    _currentSession = session;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _trainerService.getDietsBySession(apiSession);
      _diets = response.records;
      
      _counts = response.counts.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      _diets = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addDiet(Map<String, dynamic> data) async {
    try {
      await _trainerService.addDiet(data);
      SnackBarUtils.showSuccess('Diet added successfully');
      await fetchDiets(_currentSession);
      return true;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      return false;
    }
  }

  Future<bool> editDiet(int id, Map<String, dynamic> data) async {
    try {
      await _trainerService.editDiet(id, data);
      SnackBarUtils.showSuccess('Diet updated successfully');
      await fetchDiets(_currentSession);
      return true;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      return false;
    }
  }

  Future<bool> deleteDiet(int id) async {
    try {
      await _trainerService.deleteDiet(id);
      SnackBarUtils.showSuccess('Diet deleted successfully');
      _diets.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      SnackBarUtils.showError(e.toString());
      return false;
    }
  }
}
