import 'package:flutter/material.dart';
import 'colors.dart';

/// Low Poly Typography System
/// Clean, geometric typography that complements the faceted aesthetic
/// while maintaining excellent readability across all sizes
class LowPolyTypography {
  // Font Families
  static const String primaryFont = 'Inter';
  static const String displayFont = 'Poppins';
  static const String monospaceFont = 'Roboto Mono';
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // Base font sizes
  static const double _baseSize = 16.0;
  static const double _scaleRatio = 1.2; // Minor Third scale
  
  // Display Text Styles - For headlines and hero content
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 57.0,
    fontWeight: extraBold,
    height: 1.1,
    letterSpacing: -0.5,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 45.0,
    fontWeight: bold,
    height: 1.15,
    letterSpacing: -0.25,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 36.0,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  // Headline Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28.0,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  // Title Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.15,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
    color: LowPolyColors.textPrimary,
  );
  
  // Label Text Styles - For buttons, tabs, etc.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
    color: LowPolyColors.textSecondary,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.25,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.4,
    color: LowPolyColors.textSecondary,
  );
  
  // Special Text Styles
  static const TextStyle monospace = TextStyle(
    fontFamily: monospaceFont,
    fontSize: 14.0,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  // Location/Time specific styles
  static const TextStyle locationName = TextStyle(
    fontFamily: displayFont,
    fontSize: 24.0,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle timeDisplay = TextStyle(
    fontFamily: monospaceFont,
    fontSize: 32.0,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.5,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle weatherLabel = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 1.0,
    color: LowPolyColors.textSecondary,
  );
  
  // Text Theme for Material Design
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
  
  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: displayFont,
      fontSize: 57.0,
      fontWeight: extraBold,
      height: 1.1,
      letterSpacing: -0.5,
      color: LowPolyColors.textOnDark,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFont,
      fontSize: 45.0,
      fontWeight: bold,
      height: 1.15,
      letterSpacing: -0.25,
      color: LowPolyColors.textOnDark,
    ),
    displaySmall: TextStyle(
      fontFamily: displayFont,
      fontSize: 36.0,
      fontWeight: bold,
      height: 1.2,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 32.0,
      fontWeight: semiBold,
      height: 1.25,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 28.0,
      fontWeight: semiBold,
      height: 1.3,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 24.0,
      fontWeight: medium,
      height: 1.3,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    titleLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 22.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 20.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.15,
      color: LowPolyColors.textOnDark,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 18.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.1,
      color: LowPolyColors.textOnDark,
    ),
    labelLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 16.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.1,
      color: LowPolyColors.textOnDark,
    ),
    labelMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 14.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.5,
      color: LowPolyColors.textOnDark,
    ),
    labelSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 12.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.5,
      color: LowPolyColors.textOnDark,
    ),
    bodyLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 18.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    bodyMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 16.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0.25,
      color: LowPolyColors.textOnDark,
    ),
    bodySmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 14.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0.4,
      color: LowPolyColors.textOnDark,
    ),
  );
  
  // Utility methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}