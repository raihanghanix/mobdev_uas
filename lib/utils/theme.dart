import 'package:flutter/material.dart';
import '../utils/custom_theme.dart';

ThemeData applyTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: bgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      shadowColor: textLight,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: primaryColor,
      labelColor: primaryColor,
      overlayColor: MaterialStatePropertyAll(secondaryColor),
    ),
    useMaterial3: true,
  );
}
