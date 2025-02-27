import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFF0D0D1E);
  static const Color primaryColor = Color(0xFF27253C);
  static const Color purpleColor = Color(0xFFB11890);
  static const Color greenTextColor = Color(0xFF1AE03E);
  static const Color greenColor = Color(0xFF31B118);
  static const Color yellowColor = Color(0xFFB18818);
  static const Color blueColor = Color(0xFF185AB1);
  static const Color redColor = Color(0xFFB11D18);
  static const Color secondaryColor = Color(0xFF1B1A2E);
}

class AppFonts {
  static TextStyle appBarheading =
      TextStyle(fontFamily: 'Jersey', fontSize: 32, color: Colors.white);
  static TextStyle heading =
      TextStyle(fontFamily: 'Jersey', fontSize: 40, color: Colors.white);

  static TextStyle normalText =
      TextStyle(fontFamily: 'Jersey', fontSize: 24, color: Colors.white);
  static TextStyle smallText =
      TextStyle(fontFamily: 'Jersey', fontSize: 20, color: Colors.white);
}

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.backgroundColor,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.white,
    surface: AppColors.primaryColor,
    onSurface: Colors.white,
    error: AppColors.redColor,
    onError: Colors.white,
  ),
  primaryColor: AppColors.primaryColor,
  brightness: Brightness.dark,
  cardColor: AppColors.primaryColor,
  dividerColor: Colors.black12,
  textTheme: TextTheme(
    headlineMedium: AppFonts.appBarheading,
    headlineLarge: AppFonts.heading,
    bodyMedium: AppFonts.normalText,
    bodySmall: AppFonts.smallText,
  ),
);
