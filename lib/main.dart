import 'package:flutter/material.dart';
import 'package:gym/routes/router.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/utils/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/profile_provider.dart';
import 'package:gym/providers/trainer_profile_provider.dart';
import 'package:gym/providers/trainer_customers_provider.dart';
import 'package:gym/providers/trainer_workouts_provider.dart';
import 'package:gym/providers/register_provider.dart';
import 'package:gym/providers/attendance_provider.dart';
import 'package:gym/providers/trainer_schedule_provider.dart';
import 'package:gym/providers/trainer_diet_provider.dart';
import 'package:gym/providers/trainer_assigned_diets_provider.dart';
import 'package:gym/controller/auth/auth_bloc.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/service/member_service.dart';
import 'package:gym/utils/snackbar_utils.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            trainerService: TrainerService(),
            memberService: MemberService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => TrainerProfileProvider()),
        ChangeNotifierProvider(create: (_) => TrainerCustomersProvider()),
        ChangeNotifierProvider(create: (_) => TrainerWorkoutsProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => TrainerScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TrainerDietProvider()),
        ChangeNotifierProvider(create: (_) => TrainerAssignedDietsProvider()),
      ],
      child: MaterialApp.router(
        title: 'Gym Management',
        theme: AppTheme.lightTheme(AppColors.primary),
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: appRouter,
      ),
    );
  }
}
