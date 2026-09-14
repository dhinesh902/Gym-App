import 'package:flutter/foundation.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainerProfileProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TrainerDetailModel? _trainerDetail;
  TrainerDetailModel? get trainerDetail => _trainerDetail;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        _trainerDetail = await _trainerService.getTrainerById(userId);
      }
    } catch (e) {
      _trainerDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(TrainerUpdateRequest request) async {
    if (_trainerDetail == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _trainerService.updateTrainer(_trainerDetail!.id, request);
      await loadProfile();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
