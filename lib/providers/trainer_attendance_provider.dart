import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym/models/attendance_model.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

class TrainerAttendanceProvider with ChangeNotifier {
  final TrainerService _trainerService = TrainerService();

  AttendanceDataModel? _attendanceData;
  AttendanceDataModel? get attendanceData => _attendanceData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  bool _isCheckedIn = false;
  bool get isCheckedIn => _isCheckedIn;

  String? _checkInTime;
  String? get checkInTime => _checkInTime;

  TrainerAttendanceProvider() {
    _loadLocalState();
  }

  Future<void> _loadLocalState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('trainer_attendance_date');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (savedDate == today) {
      _isCheckedIn = prefs.getBool('trainer_is_checked_in') ?? false;
      _checkInTime = prefs.getString('trainer_check_in_time');
    } else {
      await prefs.remove('trainer_attendance_date');
      await prefs.remove('trainer_is_checked_in');
      await prefs.remove('trainer_check_in_time');
    }
    notifyListeners();
  }

  Future<void> loadAttendanceData(int trainerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceData = await _trainerService.getTrainerAttendance(trainerId);
      
      // Sync local state with server data
      if (_attendanceData != null && _attendanceData!.records.isNotEmpty) {
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final idx = _attendanceData!.records.indexWhere((r) => r.date.startsWith(today));
        
        final prefs = await SharedPreferences.getInstance();
        if (idx != -1) {
          final todayRecord = _attendanceData!.records[idx];
          if (todayRecord.checkOutTime == null || todayRecord.checkOutTime!.isEmpty) {
            // User is currently checked in on the server
            _isCheckedIn = true;
            _checkInTime = todayRecord.checkInTime;
            
            await prefs.setString('trainer_attendance_date', today);
            await prefs.setBool('trainer_is_checked_in', true);
            await prefs.setString('trainer_check_in_time', _checkInTime!);
          } else {
            // User is checked out for today
            _isCheckedIn = false;
            _checkInTime = null;
            await prefs.remove('trainer_attendance_date');
            await prefs.remove('trainer_is_checked_in');
            await prefs.remove('trainer_check_in_time');
          }
        }
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to load attendance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCheckInOut(int trainerId) async {
    if (_isActionLoading) return;

    _isActionLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);
      final timeStr = DateFormat('HH:mm:ss').format(now);
      final prefs = await SharedPreferences.getInstance();

      if (!_isCheckedIn) {
        // Send check-in to server
        await _trainerService.checkInTrainer(trainerId, date, timeStr);
        
        _checkInTime = timeStr;
        _isCheckedIn = true;
        
        await prefs.setString('trainer_attendance_date', date);
        await prefs.setBool('trainer_is_checked_in', true);
        await prefs.setString('trainer_check_in_time', _checkInTime!);

        SnackBarUtils.showSuccess('Checked in successfully at ${DateFormat('hh:mm a').format(now)}');
        
        // Refresh data
        await loadAttendanceData(trainerId);
      } else {
        // Send check-out to server
        await _trainerService.checkOutTrainer(trainerId, date, _checkInTime!, timeStr);

        _isCheckedIn = false;
        _checkInTime = null;
        await prefs.remove('trainer_attendance_date');
        await prefs.remove('trainer_is_checked_in');
        await prefs.remove('trainer_check_in_time');

        SnackBarUtils.showSuccess('Checked out successfully at ${DateFormat('hh:mm a').format(now)}');
        
        await loadAttendanceData(trainerId);
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to mark attendance: $e');
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
