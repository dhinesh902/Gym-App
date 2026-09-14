import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

Future<DateTime?> showCustomDatePicker(
  BuildContext context, {
  required DateTime initialDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
          useMaterial3: false,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primary,
            headerForegroundColor: Colors.white,
            backgroundColor: Colors.white,
            weekdayStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            dayStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
