import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class ElegantGradientBackground extends StatelessWidget {
  final Widget child;

  const ElegantGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base subtle background
        Container(color: AppColors.background),
        
        // Top right glowing orb
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
        ),
        
        // Bottom left glowing orb
        Positioned(
          bottom: -100,
          left: -150,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.15),
            ),
          ),
        ),
        
        // Middle right soft glowing orb
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.12),
            ),
          ),
        ),
        
        // Heavy blur layer to blend the orbs into a smooth mesh gradient
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        
        // The actual page content on top
        child,
      ],
    );
  }
}
