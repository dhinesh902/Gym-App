import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_network_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Track Your Progress',
      'description':
      'Monitor your daily workouts, nutrition, and personal records easily with our intuitive dashboard.',
      'icon': 'fitness_center',
    },
    {
      'title': 'Expert Guidance',
      'description':
      'Access premium workout plans and connect with certified trainers to achieve your fitness goals faster.',
      'icon': 'trending_up',
    },
    {
      'title': 'Join the Community',
      'description':
      'Compete with friends, share your milestones, and stay motivated together on your fitness journey.',
      'icon': 'groups',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient effect
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image / Icon Container
                            Container(
                              height: 320,
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CustomNetworkImage(
                                  imageUrl: _getIconData(
                                    _onboardingData[index]['icon']!,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 56),
                            // Title
                            Text(
                              _onboardingData[index]['title']!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            // Description
                            Text(
                              _onboardingData[index]['description']!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: AppColors.textLight,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 40.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots Indicator
                      Row(
                        children: List.generate(
                          _onboardingData.length,
                              (index) =>
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 8),
                                height: 10,
                                width: _currentPage == index ? 32 : 10,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(
                                      alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                        ),
                      ),
                      // Next / Get Started Button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            context.go(AppRoutes.login);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 64,
                          width: _currentPage == _onboardingData.length - 1
                              ? 160
                              : 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _currentPage == _onboardingData.length - 1
                              ? const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIconData(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxEYo0LLR-zp7dcTqOLjWLzhG_oQpA5nwtjtrs-i-ESA&s=10";
      case 'trending_up':
        return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWIi6Op3-VjoML1sZBM2RV1MI1d1trJ_EyaaManmZUtg&s=10";
      case 'groups':
        return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7oh6Z4IfBTMYBpG_4YqplM39_kc51FaYkk08lOuoYg&s=10";
      default:
        return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxEYo0LLR-zp7dcTqOLjWLzhG_oQpA5nwtjtrs-i-ESA&s=10";
    }
  }
}
