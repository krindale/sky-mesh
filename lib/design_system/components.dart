import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';
import 'shadows.dart';

/// Low Poly Component Styles
/// Reusable component styles that embody the geometric aesthetic
class LowPolyComponents {
  
  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: LowPolyColors.primaryBlue,
    foregroundColor: LowPolyColors.textOnDark,
    elevation: 2,
    shadowColor: LowPolyColors.surfaceDeep,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: LowPolySpacing.lg,
      vertical: LowPolySpacing.buttonPadding,
    ),
    textStyle: LowPolyTypography.labelLarge,
  );
  
  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
    foregroundColor: LowPolyColors.primaryBlue,
    side: const BorderSide(color: LowPolyColors.primaryBlue, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: LowPolySpacing.lg,
      vertical: LowPolySpacing.buttonPadding,
    ),
    textStyle: LowPolyTypography.labelLarge,
  );
  
  static ButtonStyle get tertiaryButton => TextButton.styleFrom(
    foregroundColor: LowPolyColors.primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: LowPolySpacing.md,
      vertical: LowPolySpacing.buttonPadding,
    ),
    textStyle: LowPolyTypography.labelLarge,
  );
  
  // Card Styles
  static BoxDecoration get primaryCard => BoxDecoration(
    color: LowPolyColors.surfaceLight,
    borderRadius: BorderRadius.circular(LowPolySpacing.radiusLg),
    boxShadow: LowPolyShadows.elevation2,
    border: Border.all(
      color: LowPolyColors.surfaceMedium,
      width: 1,
    ),
  );
  
  static BoxDecoration get elevatedCard => BoxDecoration(
    color: LowPolyColors.surfaceLight,
    borderRadius: BorderRadius.circular(LowPolySpacing.radiusLg),
    boxShadow: LowPolyShadows.elevation4,
  );
  
  // Weather Card with angular cuts
  static BoxDecoration weatherCard(String weather) => BoxDecoration(
    color: LowPolyColors.surfaceLight,
    borderRadius: BorderRadius.circular(LowPolySpacing.radiusXl),
    boxShadow: LowPolyShadows.getWeatherShadow(weather),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        LowPolyColors.surfaceLight,
        LowPolyColors.surfaceLight.withOpacity(0.8),
      ],
    ),
  );
  
  // Faceted Card (angular design)
  static Widget facetedCard({
    required Widget child,
    Color? color,
    List<BoxShadow>? shadows,
  }) {
    return ClipPath(
      clipper: FacetedClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? LowPolyColors.surfaceLight,
          boxShadow: shadows ?? LowPolyShadows.facetedMedium,
        ),
        child: child,
      ),
    );
  }
  
  // Input Field Styles
  static InputDecorationTheme get primaryInputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: LowPolyColors.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
      borderSide: const BorderSide(color: LowPolyColors.surfaceMedium),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
      borderSide: const BorderSide(color: LowPolyColors.surfaceMedium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
      borderSide: const BorderSide(color: LowPolyColors.primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
      borderSide: const BorderSide(color: LowPolyColors.errorRed, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: LowPolySpacing.md,
      vertical: LowPolySpacing.sm2,
    ),
    hintStyle: LowPolyTypography.bodyMedium.copyWith(
      color: LowPolyColors.textTertiary,
    ),
  );
  
  // App Bar Styles
  static AppBarTheme get appBarTheme => const AppBarTheme(
    backgroundColor: LowPolyColors.surfaceLight,
    foregroundColor: LowPolyColors.textPrimary,
    elevation: 1,
    shadowColor: LowPolyColors.surfaceDeep,
    centerTitle: true,
    titleTextStyle: LowPolyTypography.titleLarge,
  );
  
  // Chip Styles
  static ChipThemeData get chipTheme => ChipThemeData(
    backgroundColor: LowPolyColors.surfaceMedium,
    selectedColor: LowPolyColors.primaryBlue,
    labelStyle: LowPolyTypography.labelMedium,
    padding: const EdgeInsets.symmetric(
      horizontal: LowPolySpacing.sm2,
      vertical: LowPolySpacing.xs,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusXl),
    ),
  );
  
  // List Tile Styles
  static ListTileThemeData get listTileTheme => const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: LowPolySpacing.listItemPadding,
      vertical: LowPolySpacing.xs,
    ),
    titleTextStyle: LowPolyTypography.titleMedium,
    subtitleTextStyle: LowPolyTypography.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(LowPolySpacing.radiusMd),
      ),
    ),
  );
  
  // Tab Bar Styles
  static TabBarThemeData get tabBarTheme => const TabBarThemeData(
    labelColor: LowPolyColors.primaryBlue,
    unselectedLabelColor: LowPolyColors.textSecondary,
    labelStyle: LowPolyTypography.labelLarge,
    unselectedLabelStyle: LowPolyTypography.labelMedium,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: LowPolyColors.primaryBlue,
        width: 3,
      ),
    ),
  );
  
  // Bottom Navigation Bar Styles
  static BottomNavigationBarThemeData get bottomNavTheme => 
    const BottomNavigationBarThemeData(
      backgroundColor: LowPolyColors.surfaceLight,
      selectedItemColor: LowPolyColors.primaryBlue,
      unselectedItemColor: LowPolyColors.textSecondary,
      selectedLabelStyle: LowPolyTypography.labelSmall,
      unselectedLabelStyle: LowPolyTypography.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  
  // Dialog Styles
  static DialogThemeData get dialogTheme => DialogThemeData(
    backgroundColor: LowPolyColors.surfaceLight,
    elevation: 8,
    shadowColor: LowPolyColors.surfaceDeep,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LowPolySpacing.radiusLg),
    ),
    titleTextStyle: LowPolyTypography.headlineSmall,
    contentTextStyle: LowPolyTypography.bodyMedium,
  );
  
  // Floating Action Button Styles
  static FloatingActionButtonThemeData get fabTheme => 
    const FloatingActionButtonThemeData(
      backgroundColor: LowPolyColors.primaryBlue,
      foregroundColor: LowPolyColors.textOnDark,
      elevation: 4,
      shape: CircleBorder(),
    );
}

// Custom Clipper for Faceted Design
class FacetedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double cutSize = LowPolySpacing.cutMedium;
    
    // Start from top-left with cut
    path.moveTo(cutSize, 0);
    path.lineTo(size.width - cutSize, 0);
    path.lineTo(size.width, cutSize);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);
    path.lineTo(cutSize, size.height);
    path.lineTo(0, size.height - cutSize);
    path.lineTo(0, cutSize);
    path.close();
    
    return path;
  }
  
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Weather Icon Widget
class WeatherIcon extends StatelessWidget {
  final String weather;
  final double size;
  final Color? color;
  
  const WeatherIcon({
    super.key,
    required this.weather,
    this.size = LowPolySpacing.weatherIconSize,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = color ?? _getWeatherColor();
    
    switch (weather.toLowerCase()) {
      case 'sunny':
        iconData = Icons.wb_sunny;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        break;
      case 'rainy':
        iconData = Icons.umbrella;
        break;
      case 'snowy':
        iconData = Icons.ac_unit;
        break;
      case 'foggy':
        iconData = Icons.foggy;
        break;
      case 'sunset':
        iconData = Icons.wb_twilight;
        break;
      default:
        iconData = Icons.wb_sunny;
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(LowPolySpacing.radiusMd),
        boxShadow: LowPolyShadows.getWeatherShadow(weather),
      ),
      child: Icon(
        iconData,
        size: size * 0.6,
        color: iconColor,
      ),
    );
  }
  
  Color _getWeatherColor() {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return LowPolyColors.sunnyYellow;
      case 'cloudy':
        return LowPolyColors.cloudyGray;
      case 'rainy':
        return LowPolyColors.rainyBlue;
      case 'snowy':
        return LowPolyColors.snowyWhite;
      case 'foggy':
        return LowPolyColors.foggyWhite;
      case 'sunset':
        return LowPolyColors.sunsetOrange;
      default:
        return LowPolyColors.primaryBlue;
    }
  }
}