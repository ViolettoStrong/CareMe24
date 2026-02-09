import 'package:careme24/theme/app_colors.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: ColorConstant.bluegradient,
    scaffoldBackgroundColor: const Color.fromRGBO(244, 245, 247, 1),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstant.bluegradient,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    /*textTheme: TextTheme(
        bodySmall: Theme.of(context)
            .textTheme
            .bodySmall!
            .apply(color: AppColors.subtitleColor)), */
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.enabledBorderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.focusedBorderColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: AppColors.errorBorderColor,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        elevation: 0,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}
