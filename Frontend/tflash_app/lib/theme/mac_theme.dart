import 'package:flutter/material.dart';

class MacTheme {
  // System colors
  static const systemGray = Color(0xFF8E8E93);
  static const systemGray2 = Color(0xFFAEAEB2);
  static const systemGray3 = Color(0xFFC7C7CC);
  static const systemGray4 = Color(0xFFD1D1D6);
  static const systemGray5 = Color(0xFFE5E5EA);
  static const systemGray6 = Color(0xFFF2F2F7);
  
  static const label = Color(0xFF000000);
  static const secondaryLabel = Color(0x99000000); // 60% opacity
  static const tertiaryLabel = Color(0x4D000000); // 30% opacity
  
  static const backgroundColor = Color(0xFFFFFFFF);
  static const secondaryBackgroundColor = Color(0xFFF2F2F7);
  
  // Blur effect background
  static const blurBackground = Color(0xFFFBFBFB);
  
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: label,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: '.AppleSystemUIFont',
      
      appBarTheme: AppBarTheme(
        backgroundColor: blurBackground.withOpacity(0.8),
        elevation: 0,
        foregroundColor: label,
        titleTextStyle: TextStyle(
          color: label,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: '.AppleSystemUIFont',
        ),
      ),
      
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200]!, width: 0.5),
      ),
    ),

      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: label,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: '.AppleSystemUIFont',
          ),
        ),
      ),
    );
  }
}
