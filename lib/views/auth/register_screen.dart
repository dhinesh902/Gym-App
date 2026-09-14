import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

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
        body: Stack(
          children: [
            // High-quality background image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),

            // Deep Premium Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withValues(alpha: 0.1),
                      AppColors.black.withValues(alpha: 0.85),
                      AppColors.black.withValues(alpha: 1.0),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),

            // Main content
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    // Premium Pill-shaped TabBar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white.withValues(
                          alpha: 0.5,
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.5,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Floating 3D-like Icon with Pulse Glow
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, AppColors.primary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 32),

              // Typography with modern scaling
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),

              LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            hintColor: Colors.white70,
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
                            hintColor: Colors.white70,
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
                            hintColor: Colors.white70,
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
                            hintColor: Colors.white70,
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
                            hintColor: Colors.white70,
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
                              hintColor: Colors.white70,
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
                              hintColor: Colors.white70,
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
                              hintColor: Colors.white70,
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
                              hintColor: Colors.white70,
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
                            hintColor: Colors.white70,
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
                                color: Colors.white54,
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
                            hintColor: Colors.white70,
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
                                color: Colors.white54,
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
                          CustomElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Registration Logic
                              }
                            },
                            child: Text(
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
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
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
                                    fontWeight: FontWeight.w800,
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
