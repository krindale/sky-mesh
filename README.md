# Sky Mesh
스타일리시 한 날씨 모바일 앱 (Stylish Weather Mobile App)

A Flutter application featuring global location backgrounds with low-poly design aesthetics.

## Features

- 🌍 **Global Location Backgrounds**: 300+ location images from timezones and regions worldwide
- 🎨 **Low Poly Design System**: Modern geometric design with cohesive color palette
- ✨ **Smooth Animations**: 300ms fade transitions between background images
- 🎯 **Interactive Experience**: Tap the shuffle button to explore random locations
- 📱 **Cross-Platform**: Runs on Android, iOS, Web, and Desktop

## Getting Started

### Prerequisites
- Flutter 3.8.1 or higher
- Dart SDK

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Add your location images to the `assets/location_images/` directory
4. Run `flutter run` to start the app

## Project Structure

```
lib/
├── design_system/     # Low poly design system components
├── utils/            # Image assets management
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

## Assets

Location images are organized by:
- **Timezones**: `assets/location_images/timezones/utc_*/`
- **Regional Fallbacks**: `assets/location_images/regional_fallback/*/`

Image naming convention: `{city/region}_{weather}.png`
