import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/views/auth/splash_screen.dart';
import 'package:gym/views/auth/auth_selection_screen.dart';
import 'package:gym/views/auth/login_screen.dart';
import 'package:gym/views/auth/register_screen.dart';
import 'package:gym/views/auth/onboarding_screen.dart';
import 'package:gym/views/user/diet/diet_screen.dart';
import 'package:gym/views/user/home/home_screen.dart';
import 'package:gym/views/user/main/main_screen.dart';
import 'package:gym/views/user/payments/payments_screen.dart';
import 'package:gym/views/user/profile/edit_profile_screen.dart';
import 'package:gym/views/user/profile/profile_screen.dart';
import 'package:gym/views/user/progress/progress_screen.dart';
import 'package:gym/views/user/workout/workout_screen.dart';
import 'package:gym/views/user/workout/workout_details_screen.dart';
import 'package:gym/views/attendance/attendance_screen.dart';
import 'package:gym/views/membership/membership_screen.dart';
import 'package:gym/views/notifications/notifications_screen.dart';
import 'package:gym/views/settings/shop_screen.dart';
import 'package:gym/views/settings/about_gym_screen.dart';
import 'package:gym/views/settings/contact_us_screen.dart';
import 'package:gym/views/settings/policy_screen.dart';
import 'package:gym/utils/constants/policies.dart';
import 'package:gym/views/trainer/main/trainer_main_screen.dart';
import 'package:gym/views/trainer/profile/trainer_edit_profile_screen.dart';
import 'package:gym/views/trainer/profile/trainer_change_password_screen.dart';
import 'package:gym/views/trainer/profile/trainer_profile_screen.dart';
import 'package:gym/views/trainer/customers/customer_details_screen.dart';
import 'package:gym/views/trainer/diet/diet_management_screen.dart';
import 'package:gym/views/trainer/diet/add_food_screen.dart';
import 'package:gym/views/trainer/diet/assign_diet_screen.dart';
import 'package:gym/views/trainer/workouts/workouts_screen.dart';
import 'package:gym/views/trainer/workouts/assign_workout_screen.dart';
import 'package:gym/providers/assign_workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:gym/views/trainer/workouts/workout_add_edit_screen.dart';
import 'package:gym/views/trainer/customers/customer_add_edit_screen.dart';
import 'package:gym/models/workout_model.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorWorkoutKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWorkout');
final GlobalKey<NavigatorState> _shellNavigatorDietKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellDiet');
final GlobalKey<NavigatorState> _shellNavigatorAttendanceKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAttendance');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.authSelection,
      builder: (context, state) => const AuthSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerHome,
      builder: (context, state) => const TrainerMainScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerEditProfile,
      builder: (context, state) => TrainerEditProfileScreen(
        trainer: state.extra as TrainerDetailModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.trainerChangePassword,
      builder: (context, state) => const TrainerChangePasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerCustomerDetails,
      builder: (context, state) => CustomerDetailsScreen(
        customerId: state.extra as int,
      ),
    ),
    GoRoute(
      path: AppRoutes.trainerDiet,
      builder: (context, state) => const DietManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerAddFood,
      builder: (context, state) => const AddFoodScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerAssignDiet,
      builder: (context, state) => const AssignDietScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerWorkouts,
      builder: (context, state) => const WorkoutsScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerAssignWorkout,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => AssignWorkoutProvider(),
        child: const AssignWorkoutScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.trainerWorkoutAddEdit,
      builder: (context, state) => WorkoutAddEditScreen(
        workout: state.extra as WorkoutModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.trainerCustomerAddEdit,
      builder: (context, state) => CustomerAddEditScreen(
        customer: state.extra as MemberDetailModel?,
      ),
    ),

    // Shell Route for Bottom Navigation Bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorWorkoutKey,
          routes: [
            GoRoute(
              path: AppRoutes.workout,
              builder: (context, state) => const WorkoutScreen(),
            ),
            GoRoute(
              path: AppRoutes.workoutDetails,
              builder: (context, state) => const WorkoutDetailsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDietKey,
          routes: [
            GoRoute(
              path: AppRoutes.diet,
              builder: (context, state) => const DietScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAttendanceKey,
          routes: [
            GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Other routes
    GoRoute(
      path: AppRoutes.membership,
      builder: (context, state) => const MembershipScreen(),
    ),
    GoRoute(
      path: AppRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.progress,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => EditProfileScreen(
        member: state.extra as MemberDetailModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.shop,
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: AppRoutes.aboutGym,
      builder: (context, state) => const AboutGymScreen(),
    ),
    GoRoute(
      path: AppRoutes.contactUs,
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => const PolicyScreen(
        title: 'Privacy Policy',
        content: GymPolicies.privacyPolicy,
      ),
    ),
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) => const PolicyScreen(
        title: 'Terms & Conditions',
        content: GymPolicies.termsAndConditions,
      ),
    ),
    GoRoute(
      path: AppRoutes.disclaimer,
      builder: (context, state) => const PolicyScreen(
        title: 'Disclaimer',
        content: GymPolicies.disclaimer,
      ),
    ),
    GoRoute(
      path: AppRoutes.cancellationRefund,
      builder: (context, state) => const PolicyScreen(
        title: 'Cancellation & Refund',
        content: GymPolicies.cancellationAndRefundPolicy,
      ),
    ),
    GoRoute(
      path: AppRoutes.trainerPolicy,
      builder: (context, state) => const PolicyScreen(
        title: 'Trainer Policy',
        content: GymPolicies.trainerPolicy,
      ),
    ),
  ],
);
