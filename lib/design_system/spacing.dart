/// Low Poly Spacing System
/// Geometric spacing system based on 8px grid
/// with additional faceted ratios for angular layouts
class LowPolySpacing {
  // Base unit (8px) - follows Material Design guidelines
  static const double base = 8.0;
  
  // Primary spacing scale (8px increments)
  static const double xs = base * 0.5;    // 4px
  static const double sm = base * 1;      // 8px
  static const double md = base * 2;      // 16px
  static const double lg = base * 3;      // 24px
  static const double xl = base * 4;      // 32px
  static const double xxl = base * 6;     // 48px
  static const double xxxl = base * 8;    // 64px
  
  // Secondary spacing scale (for fine-tuning)
  static const double xs2 = base * 0.75;  // 6px
  static const double sm2 = base * 1.5;   // 12px
  static const double md2 = base * 2.5;   // 20px
  static const double lg2 = base * 3.5;   // 28px
  static const double xl2 = base * 5;     // 40px
  static const double xxl2 = base * 7;    // 56px
  
  // Special low poly ratios (for angular layouts)
  static const double facet1 = base * 1.414;  // √2 ratio ≈ 11.3px
  static const double facet2 = base * 1.732;  // √3 ratio ≈ 13.9px
  static const double facet3 = base * 2.236;  // Golden ratio φ ≈ 17.9px
  
  // Component-specific spacing
  static const double cardPadding = md;        // 16px
  static const double listItemPadding = md;    // 16px
  static const double buttonPadding = sm2;     // 12px
  static const double iconPadding = sm;        // 8px
  static const double sectionSpacing = xl;     // 32px
  static const double pageMargin = md;         // 16px
  
  // Weather card specific
  static const double weatherCardPadding = lg;     // 24px
  static const double weatherCardSpacing = md;     // 16px
  static const double weatherIconSize = xl;        // 32px
  
  // Location/timezone specific
  static const double locationCardPadding = lg;    // 24px
  static const double timezoneSpacing = xxl;       // 48px
  static const double cityImageHeight = xxxl * 3;  // 192px
  
  // Border radius (angular/faceted design)
  static const double radiusNone = 0.0;
  static const double radiusXs = xs / 2;      // 2px
  static const double radiusSm = xs;          // 4px
  static const double radiusMd = sm;          // 8px
  static const double radiusLg = sm2;         // 12px
  static const double radiusXl = md;          // 16px
  static const double radiusXxl = lg;         // 24px
  
  // Angular cuts (for low poly effect)
  static const double cutSmall = sm;          // 8px
  static const double cutMedium = md;         // 16px
  static const double cutLarge = lg;          // 24px
}