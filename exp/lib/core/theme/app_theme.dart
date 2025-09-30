// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryBlue = Color(0xFF1a237e);

  static ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    scaffoldBackgroundColor: _primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(_primaryBlue)),
    ),
  );

  static const Color cardBackground = Colors.white;
  static const Color legendBackground = Color(0xFFFAFAFA);
}
