import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/trainer_customers_provider.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerCustomersProvider>().loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerCustomersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: "Customers",
            actions: [
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.trainerCustomerAddEdit);
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: AppColors.primary,
                iconSize: 28,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: CustomTextField(
                    hintText: 'Search customers...',
                    prefixIcon: Icons.search_rounded,
                    hintColor: AppColors.textLight.withValues(alpha: 0.5),
                    onChanged: (value) {
                      context.read<TrainerCustomersProvider>().searchCustomers(
                        value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (provider.filteredCustomers.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No customers found.',
                  style: TextStyle(color: AppColors.textLight),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final customer = provider.filteredCustomers[index];

                  // Calculate age from date of birth
                  int age = 0;
                  try {
                    final dob = DateTime.parse(customer.dateofbirth);
                    final now = DateTime.now();
                    age = now.year - dob.year;
                    if (now.month < dob.month ||
                        (now.month == dob.month && now.day < dob.day)) {
                      age--;
                    }
                  } catch (e) {
                    age = 0;
                  }
                  String imageUrl =
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80';
                  if (customer.profilephoto != null &&
                      !customer.profilephoto!.contains('[object')) {
                    imageUrl = 'http://localhost:3000${customer.profilephoto}';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomerCard(
                      id: customer.id,
                      name: customer.fullname,
                      age: age,
                      gender: customer.gender,
                      weight: '${customer.weight} kg',
                      goal: customer.fitnessgoal,
                      membershipStatus: customer.status,
                      imageUrl: imageUrl,
                    ),
                  );
                }, childCount: provider.filteredCustomers.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String weight;
  final String goal;
  final String membershipStatus;
  final String imageUrl;

  const CustomerCard({
    super.key,
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.goal,
    required this.membershipStatus,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = membershipStatus.toLowerCase() == 'active';

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.trainerCustomerDetails, extra: id);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.background,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.lightGreenBg
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              membershipStatus.toUpperCase(),
                              style: TextStyle(
                                color: isActive
                                    ? AppColors.lightGreen
                                    : AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$age yrs • $gender • $weight',
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.flag_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            goal,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
