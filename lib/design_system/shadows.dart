import 'package:flutter/material.dart';

/// Low Poly Shadow System
/// Geometric shadows that enhance the faceted design
/// with angular light sources and dramatic depth
class LowPolyShadows {
  
  // Elevation-based shadows (Material Design inspired)
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> elevation5 = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];
  
  // Angular shadows (for low poly geometric effect)
  static const List<BoxShadow> angularTopLeft = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(-2, -2),
    ),
  ];
  
  static const List<BoxShadow> angularTopRight = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(2, -2),
    ),
  ];
  
  static const List<BoxShadow> angularBottomLeft = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(-2, 2),
    ),
  ];
  
  static const List<BoxShadow> angularBottomRight = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(2, 2),
    ),
  ];
  
  // Atmospheric shadows (weather-based)
  static const List<BoxShadow> sunnyShadow = [
    BoxShadow(
      color: Color(0x26F59E0B), // Warm yellow shadow
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> cloudyShadow = [
    BoxShadow(
      color: Color(0x336B7280), // Cool gray shadow
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
  
  static const List<BoxShadow> rainyShadow = [
    BoxShadow(
      color: Color(0x333B82F6), // Blue rain shadow
      blurRadius: 10,
      offset: Offset(0, 5),
      spreadRadius: -2,
    ),
  ];
  
  static const List<BoxShadow> snowyShadow = [
    BoxShadow(
      color: Color(0x1AE5E7EB), // Soft white shadow
      blurRadius: 16,
      offset: Offset(0, 8),
      spreadRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> sunsetShadow = [
    BoxShadow(
      color: Color(0x26F97316), // Orange sunset shadow
      blurRadius: 14,
      offset: Offset(-3, 6),
    ),
    BoxShadow(
      color: Color(0x1AEC4899), // Pink sunset shadow
      blurRadius: 8,
      offset: Offset(3, 3),
    ),
  ];
  
  // Faceted shadows (multiple directional shadows for geometry)
  static const List<BoxShadow> facetedLight = [
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 3,
      offset: Offset(-1, -1),
    ),
    BoxShadow(
      color: Color(0x0D1E293B),
      blurRadius: 3,
      offset: Offset(1, -1),
    ),
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> facetedMedium = [
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(-2, -2),
    ),
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 6,
      offset: Offset(2, -2),
    ),
    BoxShadow(
      color: Color(0x261E293B),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> facetedHeavy = [
    BoxShadow(
      color: Color(0x261E293B),
      blurRadius: 8,
      offset: Offset(-3, -3),
    ),
    BoxShadow(
      color: Color(0x261E293B),
      blurRadius: 8,
      offset: Offset(3, -3),
    ),
    BoxShadow(
      color: Color(0x331E293B),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x1A1E293B),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  // Text shadows
  static const Shadow textShadowLight = Shadow(
    color: Color(0x1A1E293B),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const Shadow textShadowMedium = Shadow(
    color: Color(0x261E293B),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const Shadow textShadowHeavy = Shadow(
    color: Color(0x331E293B),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  // Glow effects (for atmospheric lighting)
  static const List<BoxShadow> innerGlow = [
    BoxShadow(
      color: Color(0x0DFFFFFF),
      blurRadius: 8,
      offset: Offset(0, 0),
      spreadRadius: -4,
    ),
  ];
  
  static const List<BoxShadow> outerGlow = [
    BoxShadow(
      color: Color(0x1A4A90E2), // Blue glow
      blurRadius: 16,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];
  
  // Utility methods
  static List<BoxShadow> withOpacity(List<BoxShadow> shadows, double opacity) {
    return shadows.map((shadow) => shadow.copyWith(
      color: shadow.color.withValues(alpha: shadow.color.a * opacity),
    )).toList();
  }
  
  static List<BoxShadow> getWeatherShadow(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return sunnyShadow;
      case 'cloudy':
        return cloudyShadow;
      case 'rainy':
        return rainyShadow;
      case 'snowy':
        return snowyShadow;
      case 'sunset':
        return sunsetShadow;
      default:
        return elevation2;
    }
  }
}