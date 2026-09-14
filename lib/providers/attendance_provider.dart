import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym/models/attendance_model.dart';
import 'package:gym/service/member_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

class AttendanceProvider with ChangeNotifier {
  final MemberService _memberService = MemberService();

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

  AttendanceProvider() {
    _loadLocalState();
  }

  Future<void> _loadLocalState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('attendance_date');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Only restore check-in state if it's from today
    if (savedDate == today) {
      _isCheckedIn = prefs.getBool('is_checked_in') ?? false;
      _checkInTime = prefs.getString('check_in_time');
    } else {
      // Clear old state
      await prefs.remove('attendance_date');
      await prefs.remove('is_checked_in');
      await prefs.remove('check_in_time');
    }
    notifyListeners();
  }

  Future<void> loadAttendanceData(int memberId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceData = await _memberService.getMemberAttendance(memberId);
    } catch (e) {
      SnackBarUtils.showError('Failed to load attendance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCheckInOut(int memberId) async {
    if (_isActionLoading) return;

    _isActionLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);
      final timeStr = DateFormat('HH:mm:ss').format(now);
      final prefs = await SharedPreferences.getInstance();

      if (!_isCheckedIn) {
        // Checking in - save state locally
        _checkInTime = timeStr;
        _isCheckedIn = true;
        
        await prefs.setString('attendance_date', date);
        await prefs.setBool('is_checked_in', true);
        await prefs.setString('check_in_time', _checkInTime!);

        SnackBarUtils.showSuccess('Checked in successfully at ${DateFormat('hh:mm a').format(now)}');
      } else {
        // Checking out - send to server
        if (_checkInTime == null) {
          throw 'Missing check-in time';
        }

        await _memberService.markAttendance(
          memberId,
          date,
          _checkInTime!,
          timeStr, // checkout time
        );

        // Clear local state
        _isCheckedIn = false;
        _checkInTime = null;
        await prefs.remove('attendance_date');
        await prefs.remove('is_checked_in');
        await prefs.remove('check_in_time');

        SnackBarUtils.showSuccess('Checked out successfully at ${DateFormat('hh:mm a').format(now)}');
        
        // Refresh data
        await loadAttendanceData(memberId);
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to mark attendance: $e');
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
