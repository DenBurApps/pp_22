import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_22/theme/custom_colors.dart';

class DefaultTheme {
  static const primary = Color(0xFF3451B2);
  static const onPrimary = Colors.white;
  static const secondary = Color(0xFFFB6B4FF);
  static const onSecondary = Colors.white;
  static const error = Colors.red;
  static const onError = Colors.white;
  static const background = Colors.white;
  static const onBackground = Color(0xFF101D46);
  static const surface = Colors.white;
  static const onSurface = Colors.black;

  static final get = ThemeData(
    scaffoldBackgroundColor: background,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalBackgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.arimo(
        fontWeight: FontWeight.w400,
        fontSize: 25,
      ),
      displayMedium: GoogleFonts.arimo(
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
      ),
      displaySmall: GoogleFonts.arimo(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
      ),
      headlineMedium: GoogleFonts.arimo(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
      headlineSmall: GoogleFonts.arimo(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
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
