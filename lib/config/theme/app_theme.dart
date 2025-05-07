import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF6F61EF);
const Color secondaryColor = Color(0xFF39D2C0);
const Color tertiaryColor = Color(0xFFEE8B60);
const Color errorColor = Color(0xFFFF5963);
const Color lightSurface = Color(0xFFF1F4F8);
const Color darkSurface = Color(0xFF15161E);
const Color onDark = Color(0xFFE5E7EB);
const Color onLight = Color(0xFF15161E);

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    surface: lightSurface,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: onLight,
    onTertiary: onLight,
    onSurface: onLight,
    onError: Colors.white,
    outline: const Color(0xFFB0BEC5),
  ),
  textTheme: GoogleFonts.interTextTheme().apply(
    bodyColor: onLight,
    displayColor: onLight,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    surface: darkSurface,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: onDark,
    onTertiary: onDark,
    onSurface: onDark,
    onError: Colors.white,
    outline: const Color(0xFF37474F),
  ),
  textTheme: GoogleFonts.interTextTheme().apply(
    bodyColor: onDark,
    displayColor: onDark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
);
