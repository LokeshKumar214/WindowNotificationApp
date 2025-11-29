import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // Background colors
  static const Color backgroundColor = Color(0xFFD7DADF);
  static const Color notificationBarColor = Color(0xFF5A6671);
  static const Color middleSectionBackground = Color(0xFFEEEFF0);
  static const Color redBannerBackground = Color(0xFFD16565);
  static const Color borderRedBanner = Color(0xFFD16565);

  // Button colors
  static const Color grey_1 = Color(0xFFFCFCFD);
  static const Color buttonBorder = Color(0xFFD9D9E0); // FIXED
  static const Color buttonBorderRight = Colors.deepPurple;

  // Text colors
  static const Color buttonTextColor = Color(0xFF6B6E78);
  static const Color grey_9 = Color(0xFF898E96);
  static const Color whiteText = Colors.white;
  static const Color whiteTextF = Color(0xFFFFFFFF);

  // Border colors
  static const Color grey_6 = Color(0xFFD7DADF);
  static const Color grey_4 = Color(0xFFE8E8EC);
  static const Color grey_11 = Color(0xFF60646B);
  static const Color primaryA13 = Color(0x15006EFF); // ARGB FIXED
  static const Color primary9 = Color(0xFF80B5FF);
  static const Color primary_3 = Color(0x15006EFF);

  static const Color white12 = Color(0x1FFFFFFFFEC); // FIXED
  static const Color grey7 = Color(0xFFCDCED6);
  static const Color grey12 = Color(0xFF5A6671);
  static const Color grey_5 = Color(0xFFE0E1E6);
  static const Color grey_10 = Color(0xFF80838D);
  static const Color primary_11 = Color(0xFF3C6EB3);
  static const Color primaryA_9 = Color(0x7F006BFF);
  static const Color blackA_6 = Color(0x1D000000);

  // Top notification bar colors
  static const Color topBarBackground = Colors.black;
  static const Color shadowLight = Colors.black12;
  static const Color alertBubbleBackground = Colors.red;
  static const Color alertItemSelected = Colors.blue;
  static const Color alertItemUnselected = Color(
    0xFF424242,
  ); // Colors.grey[800]

  // Alias for backward compatibility
  static const Color labelTextColor = grey_9;
  static const Color fieldBorderColor = grey_6;
  // Shadow colors
  static const Color whiteShadow = Colors.white70;

  // Placeholder colors
  static const Color imagePlaceholder = Colors.amber;
}
