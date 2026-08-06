import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Notifications"),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          const SectionHeader(title: 'Today'),
          NotificationCard(
            title: 'Workout Reminder!',
            description: 'Don\'t forget your chest day session scheduled at 5:00 PM.',
            timestamp: '2 hours ago',
            icon: Icons.fitness_center_rounded,
            iconColor: AppColors.lightBlue,
            iconBgColor: AppColors.lightBlueBg,
            isUnread: true,
          ),
          NotificationCard(
            title: 'Membership Expiring Soon',
            description: 'Your Pro Membership will expire in 3 days. Renew now to keep access to all features.',
            timestamp: '5 hours ago',
            icon: Icons.warning_rounded,
            iconColor: Colors.redAccent,
            iconBgColor: Colors.redAccent.withValues(alpha: 0.1),
            isUnread: true,
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Yesterday'),
          NotificationCard(
            title: 'Great Job!',
            description: 'You burned 500 calories in your last cardio session. Keep it up!',
            timestamp: '1 day ago',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.lightGreen,
            iconBgColor: AppColors.lightGreenBg,
          ),
          NotificationCard(
            title: 'Payment Successful',
            description: 'Your payment of \$49.99 for the monthly plan was successful.',
            timestamp: '1 day ago',
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primary.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Earlier'),
          NotificationCard(
            title: 'New Class Added',
            description: 'A new Yoga class has been added on weekends. Tap to check the schedule.',
            timestamp: '3 days ago',
            icon: Icons.event_available_rounded,
            iconColor: AppColors.accent,
            iconBgColor: AppColors.accent.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isUnread;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
    this.icon = Icons.notifications_active_rounded,
    this.iconColor = AppColors.primary,
    this.iconBgColor = const Color(0xFFFEE2E2),
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnread ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.3),
          width: isUnread ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isUnread 
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.w900 : FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnread ? AppColors.primary : AppColors.textLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary.withValues(alpha: 0.7),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
