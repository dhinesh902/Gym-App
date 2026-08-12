import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';

class TrainerPrivacySettingsScreen extends StatefulWidget {
  const TrainerPrivacySettingsScreen({super.key});

  @override
  State<TrainerPrivacySettingsScreen> createState() => _TrainerPrivacySettingsScreenState();
}

class _TrainerPrivacySettingsScreenState extends State<TrainerPrivacySettingsScreen> {
  bool _profileVisibility = true;
  bool _showContactInfo = false;
  bool _shareData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Privacy Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Data, Your Control',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Manage how your profile is displayed and how your data is shared with users and the platform.',
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
                    title: 'Public Profile',
                    subtitle: 'Allow users to search and view your profile',
                    icon: Icons.visibility_outlined,
                    value: _profileVisibility,
                    onChanged: (val) => setState(() => _profileVisibility = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Show Contact Info',
                    subtitle: 'Display your phone number and email',
                    icon: Icons.contact_mail_outlined,
                    value: _showContactInfo,
                    onChanged: (val) => setState(() => _showContactInfo = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Share Analytics Data',
                    subtitle: 'Help improve the app by sharing usage data',
                    icon: Icons.analytics_outlined,
                    value: _shareData,
                    onChanged: (val) => setState(() => _shareData = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
