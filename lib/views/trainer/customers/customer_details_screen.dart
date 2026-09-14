import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/trainer_customers_provider.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final int customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerCustomersProvider>().loadCustomerDetail(
        widget.customerId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerCustomersProvider>();
    final customer = provider.currentCustomer;

    if (provider.isLoadingDetail || customer == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    String imageUrl =
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80';
    if (customer.profilephoto != null &&
        !customer.profilephoto!.contains('[object')) {
      imageUrl = 'http://localhost:3000${customer.profilephoto}';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
            onPressed: () {
              context.push(AppRoutes.trainerCustomerAddEdit, extra: customer);
            },
          ),
        ],
      ),
      body: ElegantGradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.background,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      customer.fullname,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: customer.status.toLowerCase() == 'active'
                            ? AppColors.lightGreenBg
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${customer.status.toUpperCase()} MEMBER',
                        style: TextStyle(
                          color: customer.status.toLowerCase() == 'active'
                              ? AppColors.lightGreen
                              : AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // Quick Metrics Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Height',
                            customer.height.toString(),
                            'cm',
                            Icons.height_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            'Weight',
                            customer.weight.toString(),
                            'kg',
                            Icons.monitor_weight_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            'Blood',
                            customer.bloodgroup,
                            '',
                            Icons.water_drop_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Personal Information Section
                    _buildSectionContainer(
                      title: 'Personal Information',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _buildInfoTile(
                          Icons.email_outlined,
                          'Email Address',
                          customer.email,
                        ),
                        _buildInfoTile(
                          Icons.phone_outlined,
                          'Phone Number',
                          customer.phone,
                        ),
                        _buildInfoTile(
                          Icons.cake_outlined,
                          'Date of Birth',
                          customer.dateofbirth,
                        ),
                        _buildInfoTile(
                          Icons.wc_outlined,
                          'Gender',
                          customer.gender,
                        ),
                        _buildInfoTile(
                          Icons.medical_services_outlined,
                          'Emergency Contact',
                          customer.emergency,
                        ),
                        _buildInfoTile(
                          Icons.location_on_outlined,
                          'Address',
                          customer.address,
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Health & Fitness Section
                    _buildSectionContainer(
                      title: 'Health & Fitness',
                      icon: Icons.favorite_outline_rounded,
                      children: [
                        _buildInfoTile(
                          Icons.flag_outlined,
                          'Fitness Goal',
                          customer.fitnessgoal,
                        ),
                        _buildInfoTile(
                          Icons.health_and_safety_outlined,
                          'Medical History / Injuries',
                          'None',
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Membership Details Section
                    _buildSectionContainer(
                      title: 'Membership Details',
                      icon: Icons.card_membership_rounded,
                      children: [
                        _buildInfoTile(
                          Icons.star_outline_rounded,
                          'Membership Plan',
                          customer.membershipPlan?.name ?? 'Unknown',
                        ),
                        _buildInfoTile(
                          Icons.sports_rounded,
                          'Assign Trainer',
                          customer.trainer?.fullname ?? 'Unknown',
                        ),
                        _buildInfoTile(
                          Icons.calendar_month_outlined,
                          'Joining Date',
                          customer.joiningdate,
                        ),
                        _buildInfoTile(
                          Icons.payment_rounded,
                          'Payment Status',
                          customer.status,
                          isLast: true,
                        ),
                      ],
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

  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textLight.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
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
