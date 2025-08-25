import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';
import 'components.dart';

/// Low Poly Theme System
/// Complete theme implementation for the SkyMesh app
/// with geometric design principles and atmospheric aesthetics
class LowPolyTheme {
  
  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: LowPolyColors.primaryBlue,
      secondary: LowPolyColors.primaryTeal,
      tertiary: LowPolyColors.primaryIndigo,
      surface: LowPolyColors.surfaceLight,
      error: LowPolyColors.errorRed,
      onPrimary: LowPolyColors.textOnDark,
      onSecondary: LowPolyColors.textOnDark,
      onTertiary: LowPolyColors.textOnDark,
      onSurface: LowPolyColors.textPrimary,
      onError: LowPolyColors.textOnDark,
      outline: LowPolyColors.surfaceMedium,
      surfaceContainerHighest: LowPolyColors.surfaceMedium,
      onSurfaceVariant: LowPolyColors.textSecondary,
    ),
    
    // Typography
    textTheme: LowPolyTypography.lightTextTheme,
    
    // Component Themes
    appBarTheme: LowPolyComponents.appBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: LowPolyComponents.primaryButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: LowPolyComponents.secondaryButton,
    ),
    textButtonTheme: TextButtonThemeData(
      style: LowPolyComponents.tertiaryButton,
    ),
    inputDecorationTheme: LowPolyComponents.primaryInputDecoration,
    chipTheme: LowPolyComponents.chipTheme,
    listTileTheme: LowPolyComponents.listTileTheme,
    tabBarTheme: LowPolyComponents.tabBarTheme,
    bottomNavigationBarTheme: LowPolyComponents.bottomNavTheme,
    dialogTheme: LowPolyComponents.dialogTheme,
    floatingActionButtonTheme: LowPolyComponents.fabTheme,
    
    // Card Theme
    cardTheme: const CardThemeData(
      color: LowPolyColors.surfaceLight,
      shadowColor: LowPolyColors.surfaceDeep,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: LowPolyColors.surfaceMedium,
      thickness: 1,
      space: 1,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: LowPolyColors.textSecondary,
      size: 24,
    ),
    
    // Primary Icon Theme
    primaryIconTheme: const IconThemeData(
      color: LowPolyColors.textOnDark,
      size: 24,
    ),
    
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LowPolyColors.primaryBlue;
        }
        return LowPolyColors.surfaceMedium;
      }),
      checkColor: WidgetStateProperty.all(LowPolyColors.textOnDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    
    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LowPolyColors.primaryBlue;
        }
        return LowPolyColors.surfaceMedium;
      }),
    ),
    
    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LowPolyColors.primaryBlue;
        }
        return LowPolyColors.surfaceMedium;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LowPolyColors.primaryBlue.withValues(alpha: 0.5);
        }
        return LowPolyColors.surfaceMedium.withValues(alpha: 0.5);
      }),
    ),
    
    // Slider Theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: LowPolyColors.primaryBlue,
      inactiveTrackColor: LowPolyColors.surfaceMedium,
      thumbColor: LowPolyColors.primaryBlue,
      overlayColor: Color(0x1A4A90E2),
      valueIndicatorColor: LowPolyColors.primaryBlue,
      valueIndicatorTextStyle: LowPolyTypography.labelSmall,
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: LowPolyColors.primaryBlue,
      linearTrackColor: LowPolyColors.surfaceMedium,
      circularTrackColor: LowPolyColors.surfaceMedium,
    ),
    
    // Snackbar Theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: LowPolyColors.surfaceDeep,
      contentTextStyle: LowPolyTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
  
  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: LowPolyColors.nightScheme,
    
    // Typography
    textTheme: LowPolyTypography.darkTextTheme,
    
    // Component Themes (adapted for dark)
    appBarTheme: LowPolyComponents.appBarTheme.copyWith(
      backgroundColor: LowPolyColors.surfaceDeep,
      foregroundColor: LowPolyColors.textOnDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: LowPolyComponents.primaryButton.copyWith(
        backgroundColor: WidgetStateProperty.all(LowPolyColors.primaryIndigo),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: LowPolyComponents.secondaryButton.copyWith(
        foregroundColor: WidgetStateProperty.all(LowPolyColors.primaryTeal),
        side: WidgetStateProperty.all(
          const BorderSide(color: LowPolyColors.primaryTeal, width: 2),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: LowPolyComponents.tertiaryButton.copyWith(
        foregroundColor: WidgetStateProperty.all(LowPolyColors.primaryTeal),
      ),
    ),
    inputDecorationTheme: LowPolyComponents.primaryInputDecoration.copyWith(
      fillColor: LowPolyColors.surfaceDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: LowPolyColors.surfaceMedium),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: LowPolyColors.primaryTeal, width: 2),
      ),
    ),
    
    // Card Theme
    cardTheme: const CardThemeData(
      color: LowPolyColors.surfaceDark,
      shadowColor: Colors.black54,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
    ),
    
    // Bottom Navigation (adapted for dark)
    bottomNavigationBarTheme: LowPolyComponents.bottomNavTheme.copyWith(
      backgroundColor: LowPolyColors.surfaceDeep,
      selectedItemColor: LowPolyColors.primaryTeal,
    ),
    
    // Dialog Theme (adapted for dark)
    dialogTheme: LowPolyComponents.dialogTheme.copyWith(
      backgroundColor: LowPolyColors.surfaceDark,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: LowPolyColors.textOnDark,
      size: 24,
    ),
    
    // Snackbar Theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: LowPolyColors.surfaceMedium,
      contentTextStyle: LowPolyTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
  
  // Weather-specific themes
  static ThemeData getWeatherTheme(String weather) {
    final colors = LowPolyColors.getWeatherColors(weather);
    final baseTheme = lightTheme;
    
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: colors[0],
        secondary: colors[1],
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: colors[0].withValues(alpha: 0.1),
      ),
    );
  }
  
  // System UI Overlay Styles
  static const SystemUiOverlayStyle lightSystemUi = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: LowPolyColors.surfaceLight,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  
  static const SystemUiOverlayStyle darkSystemUi = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: LowPolyColors.surfaceDeep,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}

// Theme extensions for custom properties
extension LowPolyThemeExtension on ThemeData {
  // Weather-specific gradients
  LinearGradient get skyGradient => LowPolyColors.skyGradient;
  LinearGradient get sunsetGradient => LowPolyColors.sunsetGradient;
  LinearGradient get atmosphericGradient => LowPolyColors.atmosphericGradient;
  
  // Custom spacing
  double get baseSpacing => 8.0;
  double get cardPadding => 16.0;
  double get sectionSpacing => 32.0;
}