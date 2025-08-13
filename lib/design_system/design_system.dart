/// Low Poly Design System for SkyMesh
/// 
/// A comprehensive design system inspired by the geometric, faceted aesthetic
/// of low poly art. This system provides consistent visual language across
/// the entire application with atmospheric color palettes and angular layouts.
/// 
/// ## Design Principles
/// 
/// 1. **Geometric Harmony**: Clean, angular shapes that reflect the low poly aesthetic
/// 2. **Atmospheric Colors**: Color palettes inspired by different weather conditions
/// 3. **Faceted Shadows**: Multi-directional shadows that create depth and dimension
/// 4. **Typography Clarity**: Clean, readable fonts that complement the geometric design
/// 5. **Consistent Spacing**: Mathematical spacing system based on 8px grid
/// 
/// ## Usage
/// 
/// ```dart
/// import 'package:sky_mesh/design_system/design_system.dart';
/// 
/// // Use in MaterialApp
/// MaterialApp(
///   theme: LowPolyTheme.lightTheme,
///   darkTheme: LowPolyTheme.darkTheme,
///   // ...
/// )
/// 
/// // Use colors
/// Container(
///   color: LowPolyColors.primaryBlue,
///   // ...
/// )
/// 
/// // Use typography
/// Text(
///   'Hello World',
///   style: LowPolyTypography.headlineLarge,
/// )
/// 
/// // Use spacing
/// Padding(
///   padding: EdgeInsets.all(LowPolySpacing.md),
///   // ...
/// )
/// 
/// // Use components
/// Container(
///   decoration: LowPolyComponents.primaryCard,
///   // ...
/// )
/// ```

library design_system;

// Core design tokens
export 'colors.dart';
export 'typography.dart';
export 'spacing.dart';
export 'shadows.dart';

// Component styles and themes
export 'components.dart';
export 'theme.dart';