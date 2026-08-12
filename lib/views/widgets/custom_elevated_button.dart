import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Widget? icon;
  final Widget? label;
  final bool isIcon;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  }) : isIcon = false,
       icon = null,
       label = null;

  const CustomElevatedButton.icon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : isIcon = true,
       child = null;

  ButtonStyle get _buttonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    elevation: 0,
    minimumSize: Size(double.maxFinite, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  @override
  Widget build(BuildContext context) {
    if (isIcon) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: _buttonStyle,
        icon: icon!,
        label: label!,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle,
      child: child!,
    );
  }
}
