import 'package:flutter/material.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/service/plan_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

class TrainerCustomersProvider extends ChangeNotifier {
  final TrainerService _trainerService = TrainerService();
  final PlanService _planService = PlanService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  bool _isLoadingDropdowns = false;
  bool get isLoadingDropdowns => _isLoadingDropdowns;

  List<TrainerModel> _trainers = [];
  List<TrainerModel> get trainers => _trainers;

  List<MembershipPlanModel> _plans = [];
  List<MembershipPlanModel> get plans => _plans;

  List<MemberDetailModel> _customers = [];
  List<MemberDetailModel> _filteredCustomers = [];
  List<MemberDetailModel> get filteredCustomers => _filteredCustomers;

  MemberDetailModel? _currentCustomer;
  MemberDetailModel? get currentCustomer => _currentCustomer;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _trainerService.getCustomers();
      _filterCustomers(_searchQuery);
    } catch (e) {
      SnackBarUtils.showError('Failed to load customers: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCustomers(String query) {
    _searchQuery = query;
    _filterCustomers(query);
    notifyListeners();
  }

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      _filteredCustomers = List.from(_customers);
    } else {
      _filteredCustomers = _customers.where((customer) {
        return customer.fullname.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> loadCustomerDetail(int id) async {
    _isLoadingDetail = true;
    _currentCustomer = null;
    notifyListeners();

    try {
      _currentCustomer = await _trainerService.getCustomerById(id);
    } catch (e) {
      SnackBarUtils.showError('Failed to load customer details: ${e.toString()}');
    } finally {
      _isLoadingDetail = false;
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
      SnackBarUtils.showError('Failed to load dropdowns: $e');
    } finally {
      _isLoadingDropdowns = false;
      notifyListeners();
    }
  }
}
