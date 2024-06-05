import 'package:flutter/material.dart';

class AppThemes {
  AppThemes()
      : lightTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF0F1828),
          hintColor: const Color(0xFF2E8DFF),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Color(0xFF0F1828)),
            titleTextStyle: TextStyle(color: Color(0xFF0F1828), fontSize: 20),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF333333)),
            bodyMedium: TextStyle(color: Color(0xFF0F1828)),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF002DE3),
            textTheme: ButtonTextTheme.primary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        darkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          hintColor: const Color(0xFF2E8DFF),
          scaffoldBackgroundColor: const Color(0xFF131F2C),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF131F2C),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFA5A5A5)),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF2E8DFF),
            textTheme: ButtonTextTheme.primary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1C2A38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        );
  final ThemeData lightTheme;
  final ThemeData darkTheme;
}
