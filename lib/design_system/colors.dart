import 'package:flutter/material.dart';

/// Low Poly Design System Colors
/// Inspired by the faceted, geometric aesthetic of low poly art
/// with vibrant yet harmonious color palettes
class LowPolyColors {
  // Primary Colors - Inspired by sky and atmospheric elements
  static const Color primaryBlue = Color(0xFF4A90E2);      // Sky blue
  static const Color primaryTeal = Color(0xFF2DD4BF);      // Ocean teal
  static const Color primaryIndigo = Color(0xFF6366F1);    // Deep sky
  
  // Secondary Colors - Geometric accents
  static const Color accentOrange = Color(0xFFFF6B35);     // Sunset orange
  static const Color accentPurple = Color(0xFF9333EA);     // Twilight purple
  static const Color accentPink = Color(0xFFEC4899);       // Dawn pink
  
  // Surface Colors - Low poly terrain inspired
  static const Color surfaceLight = Color(0xFFF8FAFC);     // Snow/ice
  static const Color surfaceMedium = Color(0xFFE2E8F0);    // Mountain mist
  static const Color surfaceDark = Color(0xFF334155);      // Shadow faces
  static const Color surfaceDeep = Color(0xFF1E293B);      // Deep valleys
  
  // Atmospheric Colors - Weather conditions from assets
  static const Color sunnyYellow = Color(0xFFFBBF24);      // Bright sun
  static const Color cloudyGray = Color(0xFF9CA3AF);       // Overcast
  static const Color rainyBlue = Color(0xFF3B82F6);        // Rain blue
  static const Color foggyWhite = Color(0xFFE5E7EB);       // Misty white
  static const Color snowyWhite = Color(0xFFF3F4F6);       // Pure snow
  static const Color sunsetOrange = Color(0xFFF97316);     // Golden hour
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);     // Growth/positive
  static const Color warningAmber = Color(0xFFF59E0B);     // Caution
  static const Color errorRed = Color(0xFFEF4444);         // Error/danger
  static const Color infoBlue = Color(0xFF3B82F6);         // Information
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);      // Main text
  static const Color textSecondary = Color(0xFF6B7280);    // Secondary text
  static const Color textTertiary = Color(0xFF9CA3AF);     // Disabled text
  static const Color textOnDark = Color(0xFFF9FAFB);       // Text on dark
  
  // Gradient Sets - Mimicking low poly lighting
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryTeal],
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, accentPink],
  );
  
  static const LinearGradient atmosphericGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryIndigo, surfaceDark],
  );
  
  // Color Schemes for different weather states
  static const ColorScheme sunnyScheme = ColorScheme.light(
    primary: sunnyYellow,
    secondary: accentOrange,
    surface: surfaceLight,
    background: Color(0xFFFEFCE8),
    onPrimary: textPrimary,
    onSecondary: textOnDark,
    onSurface: textPrimary,
    onBackground: textPrimary,
  );
  
  static const ColorScheme cloudyScheme = ColorScheme.light(
    primary: cloudyGray,
    secondary: primaryBlue,
    surface: surfaceMedium,
    background: Color(0xFFF1F5F9),
    onPrimary: textOnDark,
    onSecondary: textOnDark,
    onSurface: textPrimary,
    onBackground: textPrimary,
  );
  
  static const ColorScheme nightScheme = ColorScheme.dark(
    primary: primaryIndigo,
    secondary: accentPurple,
    surface: surfaceDark,
    background: surfaceDeep,
    onPrimary: textOnDark,
    onSecondary: textOnDark,
    onSurface: textOnDark,
    onBackground: textOnDark,
  );
  
  // Utility methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  static List<Color> getWeatherColors(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return [sunnyYellow, accentOrange];
      case 'cloudy':
        return [cloudyGray, primaryBlue];
      case 'rainy':
        return [rainyBlue, primaryTeal];
      case 'foggy':
        return [foggyWhite, surfaceMedium];
      case 'snowy':
        return [snowyWhite, primaryBlue];
      case 'sunset':
        return [sunsetOrange, accentPink];
      default:
        return [primaryBlue, primaryTeal];
    }
  }
}