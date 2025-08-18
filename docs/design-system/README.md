# SkyMesh Design System

## Overview

The SkyMesh design system is a comprehensive visual language inspired by the geometric, faceted aesthetic of low poly art. It provides consistent design patterns across the weather application with atmospheric color palettes and angular layouts.

## Design Principles

1. **Geometric Harmony**: Clean, angular shapes that reflect the low poly aesthetic
2. **Atmospheric Colors**: Color palettes inspired by different weather conditions
3. **Faceted Shadows**: Multi-directional shadows that create depth and dimension
4. **Typography Clarity**: Clean, readable fonts that complement the geometric design
5. **Consistent Spacing**: Mathematical spacing system based on 8px grid

## Core Components

### Colors (`lib/design_system/colors.dart`)

#### Primary Colors - Sky & Atmospheric Elements
- `primaryBlue` (0xFF4A90E2) - Sky blue
- `primaryTeal` (0xFF2DD4BF) - Ocean teal
- `primaryIndigo` (0xFF6366F1) - Deep sky

#### Secondary Colors - Geometric Accents
- `accentOrange` (0xFFFF6B35) - Sunset orange
- `accentPurple` (0xFF9333EA) - Twilight purple
- `accentPink` (0xFFEC4899) - Dawn pink

#### Surface Colors - Low Poly Terrain Inspired
- `surfaceLight` (0xFFF8FAFC) - Snow/ice
- `surfaceMedium` (0xFFE2E8F0) - Mountain mist
- `surfaceDark` (0xFF334155) - Shadow faces
- `surfaceDeep` (0xFF1E293B) - Deep valleys

#### Atmospheric Colors - Weather Conditions
- `sunnyYellow` (0xFFFBBF24) - Bright sun
- `cloudyGray` (0xFF9CA3AF) - Overcast
- `rainyBlue` (0xFF3B82F6) - Rain blue
- `foggyWhite` (0xFFE5E7EB) - Misty white
- `snowyWhite` (0xFFF3F4F6) - Pure snow
- `sunsetOrange` (0xFFF97316) - Golden hour

#### Semantic Colors
- `successGreen` (0xFF10B981) - Growth/positive
- `warningAmber` (0xFFF59E0B) - Caution
- `errorRed` (0xFFEF4444) - Error/danger
- `infoBlue` (0xFF3B82F6) - Information

#### Gradients - Low Poly Lighting Effects
- `skyGradient` - Blue to teal vertical gradient
- `sunsetGradient` - Orange to pink diagonal gradient
- `atmosphericGradient` - Indigo to dark vertical gradient

#### Color Schemes
- `sunnyScheme` - Light scheme for sunny weather
- `cloudyScheme` - Light scheme for cloudy weather
- `nightScheme` - Dark scheme for night conditions

### Typography (`lib/design_system/typography.dart`)

#### Font Families
- **Primary Font**: Inter - Main UI text
- **Display Font**: Poppins - Headlines and hero content
- **Monospace Font**: Roboto Mono - Time displays and data

#### Font Weights
- Light (300), Regular (400), Medium (500)
- Semi Bold (600), Bold (700), Extra Bold (800)

#### Text Styles

##### Display Text (Hero Content)
- `displayLarge` - 57px, Extra Bold, Poppins
- `displayMedium` - 45px, Bold, Poppins
- `displaySmall` - 36px, Bold, Poppins

##### Headlines
- `headlineLarge` - 32px, Semi Bold, Inter
- `headlineMedium` - 28px, Semi Bold, Inter
- `headlineSmall` - 24px, Medium, Inter

##### Titles
- `titleLarge` - 22px, Medium, Inter
- `titleMedium` - 20px, Medium, Inter
- `titleSmall` - 18px, Medium, Inter

##### Labels (Buttons, Tabs)
- `labelLarge` - 16px, Medium, Inter
- `labelMedium` - 14px, Medium, Inter
- `labelSmall` - 12px, Medium, Inter

##### Body Text
- `bodyLarge` - 18px, Regular, Inter
- `bodyMedium` - 16px, Regular, Inter
- `bodySmall` - 14px, Regular, Inter

##### Special Styles
- `locationName` - 24px, Semi Bold, Poppins
- `timeDisplay` - 32px, Bold, Roboto Mono
- `weatherLabel` - 12px, Medium, Inter (uppercase)
- `monospace` - 14px, Regular, Roboto Mono

### Spacing (`lib/design_system/spacing.dart`)

#### Primary Spacing Scale (8px Grid)
- `xs` - 4px (0.5 × base)
- `sm` - 8px (1 × base)
- `md` - 16px (2 × base)
- `lg` - 24px (3 × base)
- `xl` - 32px (4 × base)
- `xxl` - 48px (6 × base)
- `xxxl` - 64px (8 × base)

#### Secondary Spacing Scale (Fine-tuning)
- `xs2` - 6px (0.75 × base)
- `sm2` - 12px (1.5 × base)
- `md2` - 20px (2.5 × base)
- `lg2` - 28px (3.5 × base)
- `xl2` - 40px (5 × base)
- `xxl2` - 56px (7 × base)

#### Special Low Poly Ratios
- `facet1` - 11.3px (√2 ratio)
- `facet2` - 13.9px (√3 ratio)
- `facet3` - 17.9px (Golden ratio φ)

#### Component-Specific Spacing
- **Card Padding**: 16px (md)
- **List Item Padding**: 16px (md)
- **Button Padding**: 12px (sm2)
- **Icon Padding**: 8px (sm)
- **Section Spacing**: 32px (xl)
- **Page Margin**: 16px (md)

#### Weather-Specific Spacing
- **Weather Card Padding**: 24px (lg)
- **Weather Card Spacing**: 16px (md)
- **Weather Icon Size**: 32px (xl)
- **Location Card Padding**: 24px (lg)
- **Timezone Spacing**: 48px (xxl)
- **City Image Height**: 192px (xxxl × 3)

#### Border Radius (Angular/Faceted Design)
- `radiusNone` - 0px
- `radiusXs` - 2px
- `radiusSm` - 4px
- `radiusMd` - 8px
- `radiusLg` - 12px
- `radiusXl` - 16px
- `radiusXxl` - 24px

## Usage Examples

### Basic Implementation

```dart
import 'package:sky_mesh/design_system/design_system.dart';

// Apply theme to MaterialApp
MaterialApp(
  theme: LowPolyTheme.lightTheme,
  darkTheme: LowPolyTheme.darkTheme,
  // ...
)

// Use colors
Container(
  color: LowPolyColors.primaryBlue,
  child: Text(
    'Weather Information',
    style: LowPolyTypography.headlineLarge,
  ),
)

// Use spacing
Padding(
  padding: EdgeInsets.all(LowPolySpacing.md),
  child: Column(
    children: [
      // Weather card with proper spacing
      Container(
        padding: EdgeInsets.all(LowPolySpacing.weatherCardPadding),
        margin: EdgeInsets.symmetric(vertical: LowPolySpacing.weatherCardSpacing),
        decoration: BoxDecoration(
          gradient: LowPolyColors.skyGradient,
          borderRadius: BorderRadius.circular(LowPolySpacing.radiusLg),
        ),
        child: Text(
          'Current Weather',
          style: LowPolyTypography.titleLarge,
        ),
      ),
    ],
  ),
)
```

### Weather-Adaptive Styling

```dart
// Get colors based on weather condition
List<Color> weatherColors = LowPolyColors.getWeatherColors('sunny');

// Apply weather-specific color scheme
Theme(
  data: Theme.of(context).copyWith(
    colorScheme: LowPolyColors.sunnyScheme,
  ),
  child: WeatherWidget(),
)
```

### Typography Hierarchy

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Location name
    Text(
      'San Francisco',
      style: LowPolyTypography.locationName,
    ),
    SizedBox(height: LowPolySpacing.sm),
    
    // Current temperature
    Text(
      '72°F',
      style: LowPolyTypography.displayLarge.copyWith(
        color: LowPolyColors.primaryBlue,
      ),
    ),
    SizedBox(height: LowPolySpacing.xs),
    
    // Weather description
    Text(
      'PARTLY CLOUDY',
      style: LowPolyTypography.weatherLabel,
    ),
    SizedBox(height: LowPolySpacing.lg),
    
    // Additional details
    Text(
      'Feels like 75°F',
      style: LowPolyTypography.bodyMedium,
    ),
  ],
)
```

### Custom Styling

```dart
// Customize existing styles
TextStyle customWeatherStyle = LowPolyTypography.withColor(
  LowPolyTypography.headlineLarge,
  LowPolyColors.sunnyYellow,
);

// Create weather-specific card decoration
BoxDecoration weatherCardDecoration = BoxDecoration(
  gradient: LowPolyColors.sunsetGradient,
  borderRadius: BorderRadius.circular(LowPolySpacing.radiusLg),
  boxShadow: [
    BoxShadow(
      color: LowPolyColors.withOpacity(LowPolyColors.surfaceDark, 0.2),
      blurRadius: LowPolySpacing.sm,
      offset: Offset(0, LowPolySpacing.xs),
    ),
  ],
);
```

## Design System Structure

```
lib/design_system/
├── design_system.dart          # Main export file with documentation
├── colors.dart                 # Color palette and schemes
├── typography.dart             # Text styles and font definitions
├── spacing.dart                # Spacing scale and component spacing
├── shadows.dart                # Shadow definitions for depth
├── components.dart             # Component-specific styling
└── theme.dart                  # Complete Material theme configuration
```

## Best Practices

1. **Consistent Usage**: Always use design tokens instead of hardcoded values
2. **Weather Adaptation**: Leverage weather-specific color schemes for dynamic theming
3. **Accessibility**: Ensure sufficient color contrast and readable font sizes
4. **Spacing Harmony**: Use the 8px grid system for consistent layouts
5. **Typography Hierarchy**: Follow the established text style hierarchy
6. **Angular Aesthetics**: Use border radius sparingly to maintain low poly feel

## Integration with Flutter Material Design

The design system is fully compatible with Flutter's Material Design 3, extending it with custom tokens while maintaining accessibility and platform conventions.