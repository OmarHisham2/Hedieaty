// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_PRIMARY_LIGHT = Color(0xffdad8d4);
const COLOR_ACCENT_LIGHT = Color(0xff151515);
const COLOR_ACCENT_DARK = Color.fromARGB(255, 163, 58, 58);
const COLOR_BUTTONS_LIGHT = Color(0xffe63c3a);
const COLOR_BUTTONS_DARK = Color.fromARGB(255, 67, 66, 66);
const COLOR_INPUT_OUTLINE_LIGHT = Color(0xff535151);
const COLOR_INPUT_TEXT_LIGHT = Color(0xff5a5a58);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: COLOR_PRIMARY_LIGHT,
  primaryColor: COLOR_PRIMARY_LIGHT,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: const CircleBorder(),
    backgroundColor: COLOR_BUTTONS_LIGHT,
    splashColor: Colors.white.withOpacity(0.25),
    iconSize: 15,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: COLOR_BUTTONS_LIGHT),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: COLOR_INPUT_OUTLINE_LIGHT),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 55, 50, 50),
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelStyle:
          GoogleFonts.poppins(color: COLOR_INPUT_TEXT_LIGHT, fontSize: 15.0),
      filled: true,
      fillColor: Colors.transparent),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 60.0),
    titleMedium: GoogleFonts.poppins(
        color: const Color.fromRGBO(0, 0, 0, 0.50), fontSize: 20.0),
    labelLarge: GoogleFonts.poppins(
      fontSize: 25.0,
      color: const Color.fromARGB(255, 53, 52, 50),
    ),
    labelMedium: GoogleFonts.poppins(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 25.0),
    labelSmall: GoogleFonts.poppins(
        color: const Color.fromARGB(149, 0, 0, 0),
        fontWeight: FontWeight.w500,
        fontSize: 15.0),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      iconColor: COLOR_ACCENT_LIGHT,
      foregroundColor: COLOR_ACCENT_LIGHT,
      textStyle:
          GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: COLOR_BUTTONS_LIGHT,
      
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: const CircleBorder(),
    backgroundColor: COLOR_ACCENT_DARK,
    splashColor: Colors.white.withOpacity(0.25),
    iconSize: 15,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: COLOR_ACCENT_DARK),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: COLOR_INPUT_OUTLINE_LIGHT),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 55, 50, 50),
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 15.0),
      filled: true,
      fillColor: Colors.transparent),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.w500,
        fontSize: 60.0),
    titleMedium: GoogleFonts.poppins(
        color: const Color.fromARGB(61, 255, 255, 255), fontSize: 20.0),
    labelLarge: GoogleFonts.poppins(
      fontSize: 25.0,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    labelMedium: GoogleFonts.poppins(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.w500,
        fontSize: 25.0),
    labelSmall: GoogleFonts.poppins(
        color: const Color.fromARGB(150, 255, 255, 255),
        fontWeight: FontWeight.w500,
        fontSize: 15.0),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.all<Color>(COLOR_ACCENT_DARK),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      iconColor: Colors.white,
      foregroundColor: Colors.white,
      textStyle:
          GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: COLOR_ACCENT_DARK,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
    ),
  ),
);
