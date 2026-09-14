import 'package:flutter/foundation.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/service/plan_service.dart';

class RegisterProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();
  final PlanService _planService = PlanService();

  bool _isLoadingData = false;
  bool get isLoadingData => _isLoadingData;

  List<TrainerModel> _trainers = [];
  List<TrainerModel> get trainers => _trainers;

  List<MembershipPlanModel> _plans = [];
  List<MembershipPlanModel> get plans => _plans;

  Future<void> loadFormData() async {
    _isLoadingData = true;
    notifyListeners();

    try {
      _trainers = await _trainerService.getTrainers();
      _plans = await _planService.getPlans();
    } catch (e) {
      // Ignore errors or handle them
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }
}
