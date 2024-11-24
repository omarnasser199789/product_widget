import 'package:example/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = Color.fromRGBO(255, 84, 191, 0.8);//Color.fromRGBO(46, 18, 112, 1);
///Light
Color scaffoldBackgroundColorForLightTheme = Color.fromRGBO(28, 24, 84, 1);
Color cardColorForLightTheme = const Color.fromRGBO(255, 255, 255, 0.15);
///Dark
Color scaffoldBackgroundColorForDarkTheme = const Color.fromRGBO(28, 24, 84, 1);
Color cardColorForDarkMode = const Color.fromRGBO(255, 255, 255, 0.15);

/// ----  lightTheme  ----
final ThemeData appTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  secondaryHeaderColor:  Color.fromRGBO(255, 84, 191, 0.8),
  scaffoldBackgroundColor: scaffoldBackgroundColorForLightTheme,
  cardColor: cardColorForLightTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromRGBO(46, 18, 112, 0.7),
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.cairo(fontSize: 57).copyWith(color: Colors.black),
    displayMedium: GoogleFonts.cairo(fontSize: 30).copyWith(color: Colors.black),
    displaySmall: GoogleFonts.cairo(fontSize: 36).copyWith(color: Colors.black),
    headlineLarge: GoogleFonts.cairo(fontSize: 32).copyWith(color: Colors.black),
    headlineMedium: GoogleFonts.cairo(fontSize: 28).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    headlineSmall: GoogleFonts.cairo(fontSize: 24).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleLarge: GoogleFonts.cairo(fontSize: 20).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleMedium: GoogleFonts.cairo(fontSize: 17).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleSmall: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight:FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    labelLarge: GoogleFonts.cairo(fontSize: 15).copyWith(fontWeight: FontWeight.w600,color: Color.fromRGBO(255, 255, 255, 1)),
    labelMedium: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    labelSmall: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight: FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 0.6)),
    bodyLarge: GoogleFonts.cairo(fontSize: 15).copyWith(fontWeight: FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    bodyMedium: GoogleFonts.cairo(fontSize: 14).copyWith(fontWeight:FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    bodySmall: GoogleFonts.cairo(fontSize: 13).copyWith(fontWeight:FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
  ),
  disabledColor: const Color.fromRGBO(18, 18, 18, 1),
  canvasColor: const Color.fromRGBO(18, 18, 18, 1),

  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
  ),
  snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
          color: Color.fromRGBO(18, 18, 18, 1), fontFamily: "taleeq-bold")),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius,
    ),
    color: const Color.fromRGBO(255, 255, 255, 0.9),
  ),
);

/// ----  DarkTheme  ----
final ThemeData darkTheme = ThemeData(
  primaryColor: primaryColor,
  secondaryHeaderColor:  Color.fromRGBO(255, 84, 191, 0.8),
  scaffoldBackgroundColor: scaffoldBackgroundColorForLightTheme,
  cardColor: cardColorForLightTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromRGBO(46, 18, 112, 0.7),
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.cairo(fontSize: 57).copyWith(color: Colors.black),
    displayMedium: GoogleFonts.cairo(fontSize: 30).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    displaySmall: GoogleFonts.cairo(fontSize: 36).copyWith(color: Colors.black),
    headlineLarge: GoogleFonts.cairo(fontSize: 32).copyWith(color: Colors.black),
    headlineMedium: GoogleFonts.cairo(fontSize: 28).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    headlineSmall: GoogleFonts.cairo(fontSize: 24).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleLarge: GoogleFonts.cairo(fontSize: 20).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleMedium: GoogleFonts.cairo(fontSize: 17).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    titleSmall: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight:FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    labelLarge: GoogleFonts.cairo(fontSize: 15).copyWith(fontWeight: FontWeight.w600,color: Color.fromRGBO(255, 255, 255, 1)),
    labelMedium: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
    labelSmall: GoogleFonts.cairo(fontSize: 12).copyWith(fontWeight: FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 0.6)),
    bodyLarge: GoogleFonts.cairo(fontSize: 15).copyWith(fontWeight: FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    bodyMedium: GoogleFonts.cairo(fontSize: 14).copyWith(fontWeight:FontWeight.w400,color: Color.fromRGBO(255, 255, 255, 1)),
    bodySmall: GoogleFonts.cairo(fontSize: 13).copyWith(fontWeight:FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1)),
  ),
  disabledColor: const Color.fromRGBO(18, 18, 18, 1),
  canvasColor: const Color.fromRGBO(18, 18, 18, 1),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
  ),
  snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
          color: Color.fromRGBO(18, 18, 18, 1), fontFamily: "taleeq-bold")),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius,
    ),
    color: const Color.fromRGBO(255, 255, 255, 0.9),
  ),
);
