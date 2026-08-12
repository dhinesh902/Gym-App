import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';

class TrainerNotificationSettingsScreen extends StatefulWidget {
  const TrainerNotificationSettingsScreen({super.key});

  @override
  State<TrainerNotificationSettingsScreen> createState() => _TrainerNotificationSettingsScreenState();
}

class _TrainerNotificationSettingsScreenState extends State<TrainerNotificationSettingsScreen> {
  bool _sessionReminders = true;
  bool _newClientAlerts = true;
  bool _messages = true;
  bool _marketing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Notification Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Alerts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose what notifications you want to receive to stay on top of your training schedule.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Session Reminders',
                    subtitle: 'Get reminded 30 minutes before a session',
                    icon: Icons.timer_outlined,
                    value: _sessionReminders,
                    onChanged: (val) => setState(() => _sessionReminders = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'New Client Alerts',
                    subtitle: 'When a new client books or assigns you',
                    icon: Icons.person_add_outlined,
                    value: _newClientAlerts,
                    onChanged: (val) => setState(() => _newClientAlerts = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Direct Messages',
                    subtitle: 'When clients send you a message',
                    icon: Icons.message_outlined,
                    value: _messages,
                    onChanged: (val) => setState(() => _messages = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Marketing & Promos',
                    subtitle: 'Gym updates and promotional offers',
                    icon: Icons.campaign_outlined,
                    value: _marketing,
                    onChanged: (val) => setState(() => _marketing = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.2),
            inactiveThumbColor: AppColors.textLight.withValues(alpha: 0.6),
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border.withValues(alpha: 0.4),
      indent: 20,
      endIndent: 20,
    );
  }
}
