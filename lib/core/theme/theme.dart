import 'package:flutter/material.dart';

final ThemeData fleetDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0f172a), 
  primaryColor: const Color(0xFF2563eb), 
  hintColor: const Color(0xFF38bdf8), 

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1e293b), 
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: Color(0xFFcbd5e1)), 
    bodyLarge: TextStyle(color: Color(0xFFe2e8f0)), 
    bodyMedium: TextStyle(color: Color(0xFF94a3b8)), 
  ),

  cardColor: Colors.white.withOpacity(0.05), 
  canvasColor: const Color(0xFF1e293b), 
  dialogBackgroundColor: Colors.white.withOpacity(0.05), 

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2563eb), 
      foregroundColor: Colors.white,
      elevation: 6,
      shadowColor: const Color(0xFF3b82f6).withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF60a5fa), 
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFF334155)), 
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    hintStyle: const TextStyle(color: Color(0xFF94a3b8)), 
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2563eb)), 
    ),
  ),

  colorScheme: const ColorScheme.dark().copyWith(
    primary: Color(0xFF2563eb),   
    secondary: Color(0xFF0ea5e9), 
    error: Color(0xFFef4444),     
    background: Color(0xFF0f172a),
    surface: Color(0xFF1e293b),   
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFFcbd5e1), 
    onError: Colors.white,
  ),
);
