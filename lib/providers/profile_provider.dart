import 'package:flutter/foundation.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/member_service.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/service/plan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  final MemberService _memberService = MemberService();
  final TrainerService _trainerService = TrainerService();
  final PlanService _planService = PlanService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDropdowns = false;
  bool get isLoadingDropdowns => _isLoadingDropdowns;

  MemberDetailModel? _memberDetail;
  MemberDetailModel? get memberDetail => _memberDetail;

  List<TrainerModel> _trainers = [];
  List<TrainerModel> get trainers => _trainers;

  List<MembershipPlanModel> _plans = [];
  List<MembershipPlanModel> get plans => _plans;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        _memberDetail = await _memberService.getMemberById(userId);
      }
    } catch (e) {
      _memberDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDropdowns() async {
    _isLoadingDropdowns = true;
    notifyListeners();

    try {
      _trainers = await _trainerService.getTrainers();
      _plans = await _planService.getPlans();
    } catch (e) {
      // handle error
    } finally {
      _isLoadingDropdowns = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(MemberUpdateRequest request) async {
    if (_memberDetail == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _memberService.updateMember(_memberDetail!.id, request);
      // Reload the profile to get updated info
      await loadProfile();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
