import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Gym Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Gradient Overlay for professional look and readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textPrimary,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      tabs: const [
                        Tab(text: 'User Sign Up'),
                        Tab(text: 'Trainer Sign Up'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

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
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    final title = widget.isTrainer ? 'Join as Trainer' : 'Create Account';
    final subtitle = widget.isTrainer
        ? 'Register to build your fitness business'
        : 'Sign up to start your fitness journey';
    final icon = widget.isTrainer
        ? Icons.sports
        : Icons.person_add_alt_1_rounded;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Icon(icon, size: 52, color: AppColors.surface),
              ),
              const SizedBox(height: 32),

              // Typography with modern scaling
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.surface,
                  // changed to surface since bg is dark
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70, // adjusted for dark bg
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Glassmorphic Form Container
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
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
                            labelText: 'Date of Birth / Age',
                            hintText: 'Enter your DOB or age',
                            prefixIcon: Icons.calendar_today_outlined,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'This field is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            labelText: 'Gender',
                            hintText: 'Enter your gender',
                            prefixIcon: Icons.transgender_outlined,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'This field is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
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
                            CustomTextField(
                              labelText: 'Height',
                              hintText: 'Enter your height',
                              prefixIcon: Icons.height_outlined,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'Weight',
                              hintText: 'Enter your weight',
                              prefixIcon: Icons.monitor_weight_outlined,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'Fitness Goal',
                              hintText: 'Enter your fitness goal',
                              prefixIcon: Icons.flag_outlined,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'Address',
                              hintText: 'Enter your address',
                              prefixIcon: Icons.location_on_outlined,
                              maxLines: 2,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          CustomTextField(
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
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            prefixIcon: Icons.lock_reset_rounded,
                            obscureText: _obscureConfirmPassword,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'This field is required'
                                : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: AppColors.textLight,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Premium Gradient Button
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.buttonRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.primary,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: CustomElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // Registration Logic
                                }
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  context.pop();
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
