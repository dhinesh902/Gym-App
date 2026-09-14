import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:gym/providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() => _userId = userId);
      if (mounted) {
        context.read<AttendanceProvider>().loadAttendanceData(userId);
      }
    }
  }

  String _formatTimeDisplay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "--:--";
    try {
      final parts = timeStr.split(':');
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return timeStr;
    }
  }

  String _calculateDuration(String? startStr, String? endStr) {
    if (startStr == null || endStr == null || startStr.isEmpty || endStr.isEmpty) return "--:--";
    try {
      final p1 = startStr.split(':');
      final p2 = endStr.split(':');
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, int.parse(p1[0]), int.parse(p1[1]), int.parse(p1.length > 2 ? p1[2] : '0'));
      final end = DateTime(now.year, now.month, now.day, int.parse(p2[0]), int.parse(p2[1]), int.parse(p2.length > 2 ? p2[2] : '0'));
      final diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${minutes}m';
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final data = provider.attendanceData;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String todayStatus = "Absent";
    Color statusColor = AppColors.textLight;
    String checkInTimeDisplay = "--:--";
    String checkOutTimeDisplay = "--:--";
    String workoutDuration = "--:--";

    if (provider.isCheckedIn) {
      todayStatus = "Checked In";
      statusColor = AppColors.primary;
      checkInTimeDisplay = _formatTimeDisplay(provider.checkInTime);
    }

    if (data != null && data.records.isNotEmpty) {
      final idx = data.records.indexWhere((r) => r.date.startsWith(today));
      if (idx != -1) {
        final todayRecord = data.records[idx];
        todayStatus = "Present";
        statusColor = AppColors.lightGreen;
        checkInTimeDisplay = _formatTimeDisplay(todayRecord.checkInTime);
        checkOutTimeDisplay = _formatTimeDisplay(todayRecord.checkOutTime);
        workoutDuration = _calculateDuration(todayRecord.checkInTime, todayRecord.checkOutTime);
      }
    }

    // Override values if currently checked in but record exists
    if (provider.isCheckedIn) {
      checkInTimeDisplay = _formatTimeDisplay(provider.checkInTime);
      checkOutTimeDisplay = "--:--";
      workoutDuration = "--:--";
      todayStatus = "In Progress";
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(title: "Attendance"),
          SliverToBoxAdapter(
            child: provider.isLoading && data == null
                ? const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Information',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.5),
                            ),
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              InfoRow(
                                title: "Today's Status",
                                value: todayStatus,
                                valueColor: statusColor,
                              ),
                              const Divider(height: 32, thickness: 1, color: AppColors.background),
                              InfoRow(title: "Check-In Time", value: checkInTimeDisplay),
                              const Divider(height: 32, thickness: 1, color: AppColors.background),
                              InfoRow(title: "Check-Out Time", value: checkOutTimeDisplay),
                              const Divider(height: 32, thickness: 1, color: AppColors.background),
                              InfoRow(title: "Workout Duration", value: workoutDuration),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Summary stats
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard('Total Days Present', '${data?.presentdays ?? 0} Days', Icons.check_circle_rounded, AppColors.lightGreen),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard('Monthly Attendance', '${data?.percentage ?? 0}%', Icons.percent_rounded, AppColors.lightBlue),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: CustomElevatedButton(
                            onPressed: () {
                              if (_userId != null && !provider.isActionLoading) {
                                provider.toggleCheckInOut(_userId!);
                              }
                            },
                            child: provider.isActionLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: AppColors.surface, strokeWidth: 3),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        provider.isCheckedIn ? Icons.logout_rounded : Icons.login_rounded,
                                        color: AppColors.surface,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        provider.isCheckedIn ? 'Check Out' : 'Check In',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Attendance History',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (data != null && data.records.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.records.length,
                            itemBuilder: (context, index) {
                              final record = data.records.reversed.toList()[index];
                              
                              // Parse date string for friendly display
                              String displayDate = record.date;
                              try {
                                final dt = DateTime.parse(record.date);
                                displayDate = DateFormat('MMM d, yyyy').format(dt);
                              } catch (e) {}

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(alpha: 0.03),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: AppColors.border.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayDate,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                size: 14,
                                                color: AppColors.textLight,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatTimeDisplay(record.checkInTime),
                                                style: const TextStyle(
                                                  color: AppColors.textLight,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Icon(
                                                Icons.timer_outlined,
                                                size: 14,
                                                color: AppColors.textLight,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _calculateDuration(record.checkInTime, record.checkOutTime),
                                                style: const TextStyle(
                                                  color: AppColors.textLight,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'No attendance records yet',
                                style: TextStyle(color: AppColors.textLight),
                              ),
                            ),
                          ),
                          
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
