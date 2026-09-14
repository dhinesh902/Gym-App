import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gym/controller/auth/auth_bloc.dart';
import 'package:gym/controller/auth/auth_event.dart';
import 'package:gym/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final _isLoading = profileProvider.isLoading;
    final _memberDetail = profileProvider.memberDetail;
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final member = _memberDetail;
    if (member == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: Text("Failed to load profile")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ElegantGradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 260.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.background.withValues(alpha: 0.95),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Determine if we are nearly collapsed
                  bool isCollapsed =
                      constraints.biggest.height <=
                      kToolbarHeight + MediaQuery.of(context).padding.top + 20;

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: isCollapsed
                        ? Text(
                            member.fullname,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                          )
                        : null,
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundImage:
                                (member.profilephoto != null &&
                                    !member.profilephoto!.contains('[object'))
                                ? NetworkImage(
                                    'http://localhost:3000${member.profilephoto}',
                                  )
                                : const NetworkImage(
                                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&q=80',
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          member.fullname,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (member.membershipPlan?.name ?? 'MEMBER')
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
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
                        children: [
                          _buildInfoRow(
                            Icons.height,
                            'Height',
                            '${member.height} cm',
                          ),
                          CustomDivider(),
                          _buildInfoRow(
                            Icons.monitor_weight_outlined,
                            'Weight',
                            '${member.weight} kg',
                          ),
                          CustomDivider(),
                          _buildInfoRow(
                            Icons.bloodtype_outlined,
                            'Blood Group',
                            member.bloodgroup,
                          ),
                          CustomDivider(),
                          _buildInfoRow(
                            Icons.flag_outlined,
                            'Fitness Goal',
                            member.fitnessgoal,
                          ),
                          CustomDivider(),
                          _buildInfoRow(
                            Icons.calendar_month_outlined,
                            'Joining Date',
                            member.joiningdate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuSection(context, [
                      ProfileMenuItem(
                        title: 'Edit Profile',
                        icon: Icons.person_outline,
                        route: AppRoutes.editProfile,
                        extra: member,
                        color: AppColors.lightBlue,
                        bgColor: AppColors.lightBlueBg,
                      ),
                      ProfileMenuItem(
                        title: 'Shop',
                        icon: Icons.shopping_bag_outlined,
                        route: AppRoutes.shop,
                        color: AppColors.primary,
                        bgColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ]),
                    const SizedBox(height: 32),
                    const Text(
                      'General',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuSection(context, [
                      ProfileMenuItem(
                        title: 'About Gym',
                        icon: Icons.info_outline,
                        route: AppRoutes.aboutGym,
                        color: AppColors.accent,
                        bgColor: AppColors.accent.withValues(alpha: 0.1),
                      ),
                      ProfileMenuItem(
                        title: 'Contact Us',
                        icon: Icons.support_agent,
                        route: AppRoutes.contactUs,
                        color: AppColors.lightGreen,
                        bgColor: AppColors.lightGreenBg,
                      ),
                      ProfileMenuItem(
                        title: 'Disclaimer',
                        icon: Icons.gavel_outlined,
                        route: AppRoutes.disclaimer,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      ProfileMenuItem(
                        title: 'Cancellation & Refund',
                        icon: Icons.receipt_long_outlined,
                        route: AppRoutes.cancellationRefund,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      ProfileMenuItem(
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        route: AppRoutes.privacyPolicy,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                      ProfileMenuItem(
                        title: 'Terms & Conditions',
                        icon: Icons.description_outlined,
                        route: AppRoutes.terms,
                        color: AppColors.textLight,
                        bgColor: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ]),
                    const SizedBox(height: 40),
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
                            color: AppColors.accent,
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
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final dynamic extra;
  final Color color;
  final Color bgColor;

  ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.extra,
    required this.color,
    required this.bgColor,
  });
}

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.border.withValues(alpha: 0.3),
      ),
    );
  }
}
