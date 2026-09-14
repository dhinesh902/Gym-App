import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Color hintColor;

  const CustomDropdown({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: hintColor,
      ),
      isDense: true,
      isExpanded: true,
      dropdownColor: AppColors.surface,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: hintColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: hintColor,
        ),

        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: AppColors.primary,
        )
            : null,

        filled: true,

        fillColor: AppColors.border.withValues(
          alpha: 0.3,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.inputRadius,
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.inputRadius,
          ),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.inputRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.inputRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.inputRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),

      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: item.child,
            ),
          );
        }).toList();
      },
    );
  }
}