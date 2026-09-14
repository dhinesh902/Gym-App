import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/controller/auth/auth_bloc.dart';
import 'package:gym/controller/auth/auth_event.dart';
import 'package:gym/providers/trainer_profile_provider.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class TrainerProfileScreen extends StatefulWidget {
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainerProfileProvider = context.watch<TrainerProfileProvider>();
    final _isLoading = trainerProfileProvider.isLoading;
    final trainer = trainerProfileProvider.trainerDetail;
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (trainer == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: Text("Failed to load profile")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.secondary,
                                    AppColors.primary,
                                  ],
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: (trainer.profilephoto != null && !trainer.profilephoto!.contains('[object'))
                                      ? NetworkImage('http://localhost:3000${trainer.profilephoto}')
                                      : const NetworkImage('https://images.unsplash.com/photo-1594381898411-846e7d193883?q=80&w=100&auto=format&fit=crop'),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          trainer.fullname,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Senior Fitness Trainer',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${trainer.email}\n${trainer.phone}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Professional Info',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        _ProfileDetailTile(
                          icon: Icons.star_rounded,
                          title: 'Specialization',
                          subtitle: trainer.speciality,
                        ),
                        const CustomDivider(),
                        _ProfileDetailTile(
                          icon: Icons.timeline_rounded,
                          title: 'Experience',
                          subtitle: '${trainer.experience} Years',
                        ),
                        const CustomDivider(),
                        _ProfileDetailTile(
                          icon: Icons.schedule_rounded,
                          title: 'Shift Timing',
                          subtitle: trainer.shifttiming,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _buildMenuSection(context, [
                      TrainerProfileMenuItem(
                        title: 'Edit Profile',
                        icon: Icons.person_outline_rounded,
                        route: AppRoutes.trainerEditProfile,
                        extra: trainer,
                        color: AppColors.lightBlue,
                        bgColor: AppColors.lightBlueBg,
                      ),
                      TrainerProfileMenuItem(
                        title: 'Change Password',
                        icon: Icons.lock_outline_rounded,
                        route: AppRoutes.trainerChangePassword,
                        color: AppColors.primary,
                        bgColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'General',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _buildMenuSection(context, [
                      TrainerProfileMenuItem(
                        title: 'Disclaimer',
                        icon: Icons.gavel_outlined,
                        route: AppRoutes.disclaimer,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      TrainerProfileMenuItem(
                        title: 'Cancellation & Refund',
                        icon: Icons.receipt_long_outlined,
                        route: AppRoutes.cancellationRefund,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      TrainerProfileMenuItem(
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        route: AppRoutes.privacyPolicy,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      TrainerProfileMenuItem(
                        title: 'Terms & Conditions',
                        icon: Icons.description_outlined,
                        route: AppRoutes.terms,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      TrainerProfileMenuItem(
                        title: 'Trainer Policy',
                        icon: Icons.assignment_ind_outlined,
                        route: AppRoutes.trainerPolicy,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 32),
                  // Logout Button
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.error.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        context.go(AppRoutes.login);
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                        size: 22,
                      ),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
}

class _ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileDetailTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.4,
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

Widget _buildMenuSection(
  BuildContext context,
  List<TrainerProfileMenuItem> items,
) {
  return Column(
    children: items.map((item) {
      final isLast = items.last == item;
      return Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textLight.withValues(alpha: 0.5),
            ),
            onTap: () {
              if (item.extra != null) {
                context.push(item.route, extra: item.extra);
              } else {
                context.push(item.route);
              }
            },
          ),
          if (!isLast)
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border.withValues(alpha: 0.3),
              indent: 72,
              endIndent: 24,
            ),
        ],
      );
    }).toList(),
  );
}

class TrainerProfileMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final dynamic extra;
  final Color color;
  final Color bgColor;

  TrainerProfileMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.extra,
    required this.color,
    required this.bgColor,
  });
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border.withValues(alpha: 0.3),
      indent: 72,
      endIndent: 24,
    );
  }
}
