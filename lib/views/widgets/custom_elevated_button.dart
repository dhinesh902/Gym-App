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
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.surface,
    elevation: 0,
    minimumSize: Size(double.maxFinite, 55),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle,
        child: child!,
      ),
    );
  }
}
