import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/views/auth/splash_screen.dart';
import 'package:gym/views/auth/login_screen.dart';
import 'package:gym/views/auth/onboarding_screen.dart';
import 'package:gym/views/home/home_screen.dart';
import 'package:gym/views/workout/workout_screen.dart';
import 'package:gym/views/workout/workout_details_screen.dart';
import 'package:gym/views/diet/diet_screen.dart';
import 'package:gym/views/attendance/attendance_screen.dart';
import 'package:gym/views/membership/membership_screen.dart';
import 'package:gym/views/payments/payments_screen.dart';
import 'package:gym/views/progress/progress_screen.dart';
import 'package:gym/views/notifications/notifications_screen.dart';
import 'package:gym/views/profile/profile_screen.dart';
import 'package:gym/views/profile/edit_profile_screen.dart';
import 'package:gym/views/settings/shop_screen.dart';
import 'package:gym/views/settings/about_gym_screen.dart';
import 'package:gym/views/settings/contact_us_screen.dart';
import 'package:gym/views/settings/privacy_policy_screen.dart';
import 'package:gym/views/settings/terms_conditions_screen.dart';
import 'package:gym/views/main/main_screen.dart';

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
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
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
      builder: (context, state) => const EditProfileScreen(),
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
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) => const TermsConditionsScreen(),
    ),
  ],
);
