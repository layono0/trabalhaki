import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFF393BE7);
  static const Color primaryLight = Color(0xFF5B5DED);
  static const Color primaryDark = Color(0xFF2628C5);
  static const Color secondary = Color(0xFF86E5A1);
  static const Color secondaryLight = Color(0xFFA8ECBB);
  static const Color secondaryDark = Color(0xFF5DCB7D);
  static const Color accent = Color(0xFF280F9F);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Swipe colors
  static const Color swipeRight = Color(0xFF22C55E);
  static const Color swipeLeft = Color(0xFFEF4444);
  static const Color swipeMaybe = Color(0xFFF59E0B);

  // Background / Surface
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF3F4F6);
  static const Color surfaceDark = Color(0xFF0F0A2E);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders / Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  static const LinearGradient matchGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF280F9F), Color(0xFF393BE7), Color(0xFF5B8EF0)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F0A2E), Color(0xFF1A0F5E), Color(0xFF280F9F)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0F172A)],
  );

  // Auth background blob colors
  static const Color blobBlue = Color(0xFF393BE7);
  static const Color blobPurple = Color(0xFF280F9F);
  static const Color blobGreen = Color(0xFF86E5A1);
}
