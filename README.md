# 🌤️ SkyMesh - Intelligent Location-Based Weather App

**Real-time weather information from anywhere in the world with beautiful low-poly backgrounds**

SkyMesh is a Flutter-based weather application that provides detailed weather information with customized background images tailored to your location and weather conditions.

## 📱 Key Features

### 🎯 Core Features
- **Real-time Location-Based Weather**: Automatic GPS location detection and weather information
- **Global Random City Explorer**: Explore weather from 68 major cities worldwide
- **Intelligent Background Images**: Automatic background image matching based on location and weather conditions
- **30-Minute Auto Refresh**: Automatic weather updates for selected regions

### 📊 Detailed Weather Information
- **Current Weather**: Temperature, feels-like temperature, humidity, wind speed, pressure, visibility
- **Hourly Forecast**: Detailed 24-hour forecast information
- **7-Day Weather Forecast**: Weekly weather trends and high/low temperatures
- **Air Quality Index**: Real-time air quality information (AQI)
- **UV Index**: UV levels and exposure risk assessment
- **Weather Condition Cards**: Smart contextual alerts for extreme weather, air quality, and daily life recommendations
- **Enhanced City Coverage**: Now supporting 78+ cities worldwide with expanded regional coverage

## 🖼️ App Screenshots

<div align="center">
  <img src="sample_images/Screenshot_1755228803.png" width="45%" alt="Main Screen"/>
  <img src="sample_images/Screenshot_1755228814.png" width="45%" alt="Hourly Forecast"/>
</div>

<div align="center">
  <img src="sample_images/Screenshot_1755228818.png" width="45%" alt="7-Day Forecast"/>
  <img src="sample_images/Screenshot_1755228822.png" width="45%" alt="Detailed Weather Information"/>
</div>

## ✨ Special Features

### 🌍 Smart Location Recognition
- **Automatic Location Detection**: Accurate current location tracking via GPS
- **Expanded Global Coverage**: Support for 78+ major cities across all continents
- **Random City Explorer**: Discover weather in cities worldwide with timezone-aware displays
- **Offline Resilience**: Stable service with mock data during network errors
- **Enhanced Regional Fallback**: Comprehensive regional image mapping system

### 🎨 Beautiful UI/UX
- **Low-Poly Design**: Modern and minimalist low-poly art style with geometric aesthetics
- **Context-Based Backgrounds**: Backgrounds reflecting location landmarks and weather conditions
- **Smooth Animations**: Enhanced fade effects and smooth image transitions during screen updates
- **Intuitive Interface**: User-friendly information layout with improved visual elements
- **Comprehensive Design System**: Consistent visual language with atmospheric color palettes
- **Weather Condition Tags**: Visual tags for easy weather condition identification

### ⚡ Performance Optimization
- **Efficient Memory Management**: Advanced image caching and proper resource disposal
- **Fast Response Times**: Optimized communication with OpenWeatherMap API
- **Battery Efficiency**: Intelligent background update management with 30-minute intervals
- **Enhanced Image Loading**: WebP format support for faster loading and smaller file sizes
- **Comprehensive Test Coverage**: 95%+ test coverage across data services layer

### 🏗️ Clean Architecture
- **SOLID Principles**: Complete adherence to all five SOLID principles with extensive documentation
- **Dependency Injection**: Advanced modular dependency management with service locator pattern
- **Interface Segregation**: Small, focused interfaces for better maintainability and testing
- **Strategy Pattern**: Extensible weather data sources without code modification
- **Weather Condition Rule Engine**: Smart rule-based system for contextual weather alerts
- **Comprehensive Testing**: Unit tests, integration tests, and contract tests ensuring reliability

## 🛠️ Tech Stack

### Framework & Language
- **Flutter 3.35.1**: Cross-platform mobile development framework
- **Dart 3.9.0**: High-performance asynchronous programming language

### Key Libraries
- **geolocator ^10.1.1**: GPS location services and coordinate management
- **http ^1.5.0**: REST API communication with OpenWeatherMap
- **permission_handler ^11.4.0**: System permission management for location access
- **cupertino_icons ^1.0.8**: iOS-style icons for cross-platform consistency

### Architecture Patterns
- **Repository Pattern**: Clean data access abstraction with interface-based design
- **Strategy Pattern**: Pluggable weather data sources for extensibility
- **Dependency Injection**: Loose coupling and enhanced testability
- **Facade Pattern**: Simplified API for complex subsystems
- **Rule Engine Pattern**: Smart contextual weather condition analysis
- **Observer Pattern**: Reactive UI updates and state management

### External APIs
- **OpenWeatherMap API**: Real-time weather data and forecast information
- **Custom Image Mapping System**: Location-specific background images

## 📁 Project Structure

### Clean Architecture with SOLID Principles

```
lib/
├── main.dart                              # App entry point with DI initialization
├── core/                                  # Core business logic (Clean Architecture)
│   ├── interfaces/                        # Abstract interfaces (DIP)
│   │   ├── weather_repository.dart        # Weather data abstraction
│   │   ├── location_service.dart          # Location service interface
│   │   ├── image_service.dart             # Image service interface
│   │   └── weather_interfaces.dart        # ISP-compliant interfaces
│   ├── models/                            # Domain models (SRP)
│   │   ├── weather_data.dart              # Core weather data model
│   │   ├── hourly_weather_data.dart       # Hourly forecast model
│   │   ├── weekly_weather_data.dart       # Weekly forecast model
│   │   └── weather_condition_card.dart    # Weather condition alert model
│   ├── services/                          # Core business services
│   │   └── weather_condition_rule_engine.dart # Smart rule-based alert system
│   ├── strategies/                        # Strategy pattern (OCP)
│   │   └── weather_strategy.dart          # Pluggable weather strategies
│   ├── dependency_injection/              # DI container (DIP)
│   │   ├── service_locator.dart           # Service locator pattern
│   │   └── weather_module.dart            # Module configuration
│   ├── utils/                             # Core utilities
│   │   └── logger.dart                    # Application logging
│   └── tests/                             # Contract tests (LSP)
│       └── weather_repository_test.dart   # Repository contract tests
├── data/                                  # Data layer implementations
│   └── services/                          # Concrete service implementations
│       ├── openweather_api_service.dart   # OpenWeatherMap API client
│       ├── geolocator_service.dart        # GPS location service
│       └── location_image_service_impl.dart # Location-image mapping impl
├── services/                              # Facade layer (backward compatibility)
│   ├── weather_service.dart              # Simplified weather facade
│   └── location_image_service.dart        # Location-image mapping facade
├── widgets/                               # Presentation layer components
│   ├── weather_display_widget.dart        # Main weather UI components
│   ├── background_image_widget.dart       # Dynamic background management
│   ├── weather_condition_card_widget.dart # Weather alert cards
│   ├── weather_condition_tags_widget.dart # Weather condition tags
│   └── weather_condition_settings_widget.dart # User preference settings
├── design_system/                         # Comprehensive UI design system
│   ├── design_system.dart                # Main export and documentation
│   ├── colors.dart                       # Color palette and schemes
│   ├── typography.dart                   # Text styles and fonts
│   ├── spacing.dart                      # Spacing scale and layout
│   ├── shadows.dart                      # Shadow definitions
│   ├── components.dart                   # Component-specific styles
│   └── theme.dart                        # Complete Material theme
└── utils/                                 # Utility functions and helpers
    └── image_assets.dart                  # Asset management and mapping
```

## 🚀 Installation and Setup

### Prerequisites
- Flutter SDK 3.35.1 or higher
- Dart SDK 3.9.0 or higher
- Android Studio or VS Code with Flutter extensions
- Android/iOS development environment setup

### Installation Steps
1. **Clone Repository**
   ```bash
   git clone https://github.com/krindale/sky_mesh.git
   cd sky_mesh
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

### Development Environment
- **Android**: Android 5.0 (API 21) or higher
- **iOS**: iOS 12.0 or higher (future support planned)
- **Permissions**: Location services, Internet connectivity

## 🔧 API Configuration

1. **Get OpenWeatherMap API Key**
   - Sign up at [OpenWeatherMap](https://openweathermap.org/api)
   - Generate API key

2. **Environment Setup**
   - Replace API key in `lib/data/services/openweather_api_service.dart`
   - Or configure via `WeatherConfigurationService` in dependency injection
   - Development API key is included in this project

## 🏗️ Architecture Details

### SOLID Principles Implementation

#### 1. **Single Responsibility Principle (SRP)**
- Each class has one reason to change
- `WeatherRepository`: Only handles weather data operations
- `LocationService`: Only manages location functionality
- `ImageService`: Only handles image selection logic

#### 2. **Open/Closed Principle (OCP)**
- Open for extension, closed for modification
- Strategy pattern allows adding new weather data sources
- New location services can be added without changing existing code

#### 3. **Liskov Substitution Principle (LSP)**
- All implementations are substitutable for their interfaces
- Contract tests ensure behavioral compatibility
- Mock implementations maintain same contracts

#### 4. **Interface Segregation Principle (ISP)**
- Small, focused interfaces instead of large ones
- `CurrentWeatherService`, `WeatherForecastService`, `RandomWeatherService`
- Clients depend only on methods they actually use

#### 5. **Dependency Inversion Principle (DIP)**
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Dependency injection manages all dependencies

### Design Patterns Used

- **Repository Pattern**: Clean data access layer
- **Strategy Pattern**: Pluggable weather data sources  
- **Facade Pattern**: Simplified API for UI layer
- **Dependency Injection**: Inversion of control container
- **Factory Pattern**: Weather data object creation

## 🆕 Recent Updates & Features

### Version 1.0.0+1 - August 2025

#### 🔥 New Features
- **Weather Condition Cards**: Smart contextual alerts for extreme weather conditions, air quality warnings, and daily life recommendations
- **Enhanced City Coverage**: Expanded from 68 to 78+ cities worldwide with better regional representation
- **Weather Condition Tags**: Visual tags for easy weather condition identification with English localization
- **Improved Timezone Handling**: Fixed random city timezone display issues for accurate global weather information

#### 🏗️ Architecture Improvements
- **Weather Condition Rule Engine**: New rule-based system for intelligent weather alerts and recommendations
- **Comprehensive Design System**: Complete design system with atmospheric color palettes, typography hierarchy, and spacing guidelines
- **Enhanced Testing**: Achieved 95%+ test coverage across the data services layer with comprehensive unit and integration tests
- **Improved Image Management**: Enhanced location-image mapping system with regional fallback support

#### 🎨 UI/UX Enhancements
- **Smooth Image Transitions**: Enhanced fade effects and smooth transitions during weather data updates
- **Low-Poly Design Refinements**: Improved geometric aesthetics with consistent visual language
- **Better Image Loading**: WebP format support for faster loading and optimized file sizes
- **User Preference Settings**: New settings widget for customizing weather condition card preferences

#### 🔧 Performance & Quality
- **Advanced Memory Management**: Improved image caching and resource disposal
- **Enhanced Error Handling**: Better error recovery and offline resilience
- **Optimized API Communication**: Improved OpenWeatherMap API integration with better error handling
- **Automated Quality Gates**: Comprehensive testing and validation pipeline

#### 🌐 Global Coverage Expansion
Recent city additions include:
- **Europe**: Madrid (Spain), Milan (Italy)  
- **North America**: Montreal (Canada)
- **Asia**: Osaka (Japan), Delhi (India)
- **South America**: Bogotá (Colombia)
- **Africa**: Cape Town (South Africa)
- **Middle East**: Doha (Qatar)

## 📈 Development Roadmap

### Short-term Goals (1-2 months)
- **iOS Platform Support** expansion with platform-specific optimizations
- **Multi-language Support** (English, Korean, Chinese, Japanese)
- **Weather Notification Service** implementation
- **Widget Features** for home screen integration

### Medium-term Goals (3-6 months)
- **Enhanced Weather Condition Cards** with user customization
- **Personalized Weather Recommendations** based on user activity
- **Social Sharing** functionality with beautiful weather cards
- **Offline Mode** with cached weather data and images

### Long-term Goals (6+ months)
- **AI-based Weather Prediction** with machine learning models
- **Wearable Device Integration** (Apple Watch, Samsung Galaxy Watch)
- **Cloud Synchronization** services for user preferences
- **Advanced Analytics** dashboard for weather patterns
- **Community Features** for sharing weather experiences

## 🤝 Contributing

### How to Contribute
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Create Pull Request

### Development Guidelines
- **Code Style**: Follow Flutter/Dart official guidelines
- **SOLID Principles**: Maintain clean architecture principles
- **Testing**: Write unit tests and contract tests for new features
- **Documentation**: Update README and comments when code changes
- **Dependency Injection**: Use service locator for new dependencies

### Code Quality Standards
- **Architecture**: Follow Clean Architecture and SOLID principles with comprehensive documentation
- **Testing**: Minimum 95% code coverage with unit, integration, and contract tests
- **Code Review**: All changes must pass architectural review and automated quality gates
- **Performance**: Maintain sub-3-second load times and efficient memory usage
- **Documentation**: Maintain up-to-date documentation for all architectural decisions
- **Localization**: Support multiple languages with proper internationalization

## 📝 License

This project is distributed under the MIT License. See [LICENSE](LICENSE) file for details.

## 📞 Contact

**Developer**: krindale  
**Last Updated**: August 2025  
**Build Status**: ✅ All tests passing  
**Code Analysis**: 85 info/warning (no blocking errors)  
**Version**: 1.0.0+1 (Latest stable release)  
**GitHub**: [@krindale](https://github.com/krindale)

---

<div align="center">
  <h3>🌟 Explore weather around the world with SkyMesh! 🌟</h3>
  <p>A special journey combining real-time weather information with beautiful visual experiences</p>
</div>
