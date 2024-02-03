import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_22_copy/theme/custom_colors.dart';

class DefaultTheme {
  static const primary = Color(0xFF2F2CE6);
  static const onPrimary = Colors.white;
  static const secondary = Color(0xFFFB6B4FF);
  static const onSecondary = Colors.white;
  static const error = Colors.red;
  static const onError = Colors.white;
  static const background = Color(0xFFEBEBFF);
  static const onBackground = Color(0xFF0A0A0A);
  static const surface = Colors.white;
  static const onSurface = Colors.black;

  static final get = ThemeData(
    scaffoldBackgroundColor: background,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalBackgroundColor: Colors.transparent,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: GoogleFonts.arimo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackground,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.arimo(
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      displayMedium: GoogleFonts.arimo(
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
      ),
      displaySmall: GoogleFonts.arimo(
        fontWeight: FontWeight.w700,
        fontSize: 16.0,
      ),
      headlineMedium: GoogleFonts.arimo(
        fontWeight: FontWeight.w700,
        fontSize: 14.0,
      ),
      headlineSmall: GoogleFonts.arimo(
        fontWeight: FontWeight.w400,
        fontSize: 13.0,
      ),
    ).apply(
      bodyColor: onBackground,
      displayColor: onBackground,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
    ),
    extensions: [
      CustomColors.customColors,
    ],
  );
}
