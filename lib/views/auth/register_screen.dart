import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_dropdown.dart';
import 'package:gym/views/widgets/custom_date_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/controller/auth/auth_bloc.dart';
import 'package:gym/controller/auth/auth_event.dart';
import 'package:gym/controller/auth/auth_state.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/register_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Hero Image Header
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to start your fitness journey',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Light Theme TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textLight,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'Athlete'),
                  Tab(text: 'Trainer'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Forms
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [
                  RegisterFormWidget(isTrainer: false),
                  RegisterFormWidget(isTrainer: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted the form into its own independent widget
class RegisterFormWidget extends StatefulWidget {
  final bool isTrainer;

  const RegisterFormWidget({super.key, required this.isTrainer});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Athlete specific
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _fitnessgoalController = TextEditingController();
  final TextEditingController _assignedtrainerController =
      TextEditingController();
  final TextEditingController _membershipplanidController =
      TextEditingController();
  final TextEditingController _joiningdateController = TextEditingController();

  // Trainer specific
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _shiftTimingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isTrainer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RegisterProvider>().loadFormData();
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _emergencyController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodgroupController.dispose();
    _fitnessgoalController.dispose();
    _assignedtrainerController.dispose();
    _membershipplanidController.dispose();
    _joiningdateController.dispose();
    _specialityController.dispose();
    _experienceController.dispose();
    _shiftTimingController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isTrainer) {
        final request = TrainerRegisterRequest(
          fullname: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          dateofbirth: _dobController.text.trim(),
          speciality: _specialityController.text.trim(),
          experience: _experienceController.text.trim(),
          shifttiming: _shiftTimingController.text.trim(),
        );
        context.read<AuthBloc>().add(AuthRegisterTrainerRequested(request));
      } else {
        final request = MemberRegisterRequest(
          fullname: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          dateofbirth: _dobController.text.trim(),
          gender: _genderController.text.trim(),
          emergency: _emergencyController.text.trim(),
          address: _addressController.text.trim(),
          height: _heightController.text.trim(),
          weight: _weightController.text.trim(),
          bloodgroup: _bloodgroupController.text.trim(),
          fitnessgoal: _fitnessgoalController.text.trim(),
          assignedtrainer: _assignedtrainerController.text.trim(),
          membershipplanid: _membershipplanidController.text.trim(),
          joiningdate: _joiningdateController.text.trim(),
          status: 'active',
        );
        context.read<AuthBloc>().add(AuthRegisterMemberRequested(request));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.watch<RegisterProvider>();
    final _isLoadingData = registerProvider.isLoadingData;
    final _trainers = registerProvider.trainers;
    final _plans = registerProvider.plans;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              SnackBarUtils.showSuccess(state.response.message ?? 'Registration successful');
              context.go(AppRoutes.login);
            } else if (state is AuthFailure) {
              SnackBarUtils.showError(state.error);
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'This field is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _dobController,
                      labelText: 'Date of Birth (YYYY-MM-DD)',
                      hintText: 'Select your DOB',
                      prefixIcon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showCustomDatePicker(
                          context,
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 365 * 18),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _dobController.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'This field is required'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    if (!widget.isTrainer) ...[
                      CustomDropdown<String>(
                        labelText: 'Gender',
                        hintText: 'Select Gender',
                        prefixIcon: Icons.transgender_outlined,
                        value: _genderController.text.isNotEmpty
                            ? _genderController.text
                            : null,
                        items: ['Male', 'Female', 'Other']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _genderController.text = val;
                            });
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emergencyController,
                        labelText: 'Emergency Contact',
                        hintText: 'Name & Phone',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.health_and_safety_outlined,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        prefixIcon: Icons.home_outlined,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _heightController,
                              labelText: 'Height (cm)',
                              hintText: 'e.g. 180',
                              prefixIcon: Icons.height_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _weightController,
                              labelText: 'Weight (kg)',
                              hintText: 'e.g. 75',
                              prefixIcon: Icons.monitor_weight_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        labelText: 'Blood Group',
                        hintText: 'Select Blood Group',
                        prefixIcon: Icons.bloodtype_outlined,
                        value: _bloodgroupController.text.isNotEmpty ? _bloodgroupController.text : null,
                        items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _bloodgroupController.text = val);
                        },
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        labelText: 'Fitness Goal',
                        hintText: 'Select Fitness Goal',
                        prefixIcon: Icons.flag_outlined,
                        value: _fitnessgoalController.text.isNotEmpty ? _fitnessgoalController.text : null,
                        items: ['Muscle Gain', 'Weight Loss', 'Endurance', 'Flexibility', 'General Fitness']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _fitnessgoalController.text = val);
                        },
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        labelText: 'Assigned Trainer',
                        hintText: _isLoadingData
                            ? 'Loading trainers...'
                            : 'Select Trainer',
                        prefixIcon: Icons.sports,
                        value: _assignedtrainerController.text.isNotEmpty
                            ? _assignedtrainerController.text
                            : null,
                        items: _trainers
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text('${e.fullname} (${e.id})'),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(
                              () => _assignedtrainerController.text = val,
                            );
                        },
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        labelText: 'Membership Plan',
                        hintText: _isLoadingData
                            ? 'Loading plans...'
                            : 'Select Plan',
                        prefixIcon: Icons.card_membership_outlined,
                        value: _membershipplanidController.text.isNotEmpty
                            ? _membershipplanidController.text
                            : null,
                        items: _plans
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text('${e.name} (${e.price ?? 0})'),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(
                              () => _membershipplanidController.text = val,
                            );
                          }
                        },
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _joiningdateController,
                        labelText: 'Joining Date',
                        hintText: 'Select Date',
                        prefixIcon: Icons.event_available_outlined,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showCustomDatePicker(
                            context,
                            initialDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _joiningdateController.text =
                                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'This field is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'This field is required'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    if (widget.isTrainer) ...[
                      CustomDropdown<String>(
                        labelText: 'Speciality',
                        hintText: 'Select Speciality',
                        prefixIcon: Icons.fitness_center_outlined,
                        value: _specialityController.text.isNotEmpty
                            ? _specialityController.text
                            : null,
                        items:
                            [
                                  "General Fitness",
                                  "Strength & Conditioning",
                                  "Weight Loss & Fat Loss",
                                  "Muscle Building",
                                  "Functional Training",
                                  "Sports Performance",
                                  "Corrective Exercise",
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _specialityController.text = val;
                            });
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _experienceController,
                        labelText: 'Experience (Years)',
                        hintText: 'Enter your experience',
                        prefixIcon: Icons.star_border_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        labelText: 'Shift Timing',
                        hintText: 'Select Shift Timing',
                        prefixIcon: Icons.access_time_outlined,
                        value: _shiftTimingController.text.isNotEmpty
                            ? _shiftTimingController.text
                            : null,
                        items:
                            [
                                  'Morning (6 AM - 2 PM)',
                                  'Evening (2 PM - 10 PM)',
                                  'Full Day',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _shiftTimingController.text = val;
                            });
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Create a password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'This field is required'
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.textLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: Icons.lock_reset_rounded,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.textLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Premium Gradient Button
                    CustomElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : _onRegisterPressed,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Create an Account",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
