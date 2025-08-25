import '../utils/logger.dart';

/// Weather data model following SRP (Single Responsibility Principle)
/// Only responsible for weather data representation
/// 
/// This model represents current weather conditions for a specific location.
/// It includes essential weather metrics, location information, and provides
/// formatted string representations for UI display.
/// 
/// ## Usage
/// 
/// ```dart
/// // Create from API response
/// final weather = WeatherData.fromJson(apiResponse);
/// 
/// // Access formatted values for UI
/// Text(weather.temperatureString); // "22°"
/// Text(weather.capitalizedDescription); // "Partly Cloudy"
/// 
/// // Access raw values for calculations
/// double temp = weather.temperature; // 22.0
/// ```
/// 
/// ## Properties
/// 
/// ### Core Weather Data
/// - [temperature]: Current temperature in Celsius
/// - [feelsLike]: Perceived temperature in Celsius
/// - [humidity]: Relative humidity percentage (0-100)
/// - [windSpeed]: Wind speed in meters per second
/// - [pressure]: Atmospheric pressure in hectopascals (hPa)
/// - [visibility]: Visibility distance in meters
/// 
/// ### Weather Description
/// - [description]: Human-readable weather description
/// - [iconCode]: OpenWeatherMap icon code for weather visualization
/// 
/// ### Location Information
/// - [cityName]: Name of the city/location
/// - [country]: ISO country code
/// - [latitude]: Geographic latitude (optional)
/// - [longitude]: Geographic longitude (optional)
/// 
/// ### Environmental Data
/// - [uvIndex]: UV radiation index (0-11+ scale)
/// - [airQuality]: Air quality index (1-5 scale, 1=good, 5=poor)
class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final String cityName;
  final String country;
  final int pressure;
  final int visibility;
  final int uvIndex;
  final int airQuality;
  final double? latitude;
  final double? longitude;
  final DateTime? sunrise;
  final DateTime? sunset;

  /// Creates a new WeatherData instance
  /// 
  /// All weather parameters are required except [latitude], [longitude], [sunrise], and [sunset]
  /// which are optional for cases where precise coordinates or timing are not available.
  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.cityName,
    required this.country,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.airQuality,
    this.latitude,
    this.longitude,
    this.sunrise,
    this.sunset,
  });

  /// Creates a WeatherData instance from OpenWeatherMap API JSON response
  /// 
  /// Expects a valid OpenWeatherMap current weather JSON structure.
  /// Falls back to default values for optional fields like visibility.
  /// 
  /// Note: UV index and air quality currently use mock data as they
  /// require separate API calls from OpenWeatherMap.
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // API 응답에서 sunrise/sunset 데이터 확인을 위한 로그
    final sunriseTimestamp = json['sys']['sunrise'];
    final sunsetTimestamp = json['sys']['sunset'];
    
    final sunrise = sunriseTimestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000)
        : null;
    final sunset = sunsetTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000)
        : null;
    
    Logger.api('Raw timestamps: sunrise=$sunriseTimestamp, sunset=$sunsetTimestamp');
    if (sunrise != null && sunset != null) {
      Logger.api('Parsed times: sunrise=${sunrise.toLocal()}, sunset=${sunset.toLocal()}');
      Logger.api('UTC times: sunrise=$sunrise, sunset=$sunset');
    } else {
      Logger.warning('Missing sunrise/sunset data in API response');
    }
    
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      cityName: json['name'],
      country: json['sys']['country'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'] ?? 10000, // Default 10km if not provided
      uvIndex: 5, // TODO: Implement separate UV index API call
      airQuality: 2, // TODO: Implement separate air quality API call
      latitude: json['coord']['lat']?.toDouble(),
      longitude: json['coord']['lon']?.toDouble(),
      sunrise: sunrise,
      sunset: sunset,
    );
  }

  // MARK: - Formatted String Getters
  
  /// Temperature formatted with degree symbol (e.g., "22°")
  String get temperatureString => '${temperature.round()}°';
  
  /// Feels-like temperature formatted with degree symbol (e.g., "24°")
  String get feelsLikeString => '${feelsLike.round()}°';
  
  /// Wind speed formatted with unit (e.g., "3.2 m/s")
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} m/s';
  
  /// Humidity formatted with percentage (e.g., "65%")
  String get humidityString => '$humidity%';
  
  /// Atmospheric pressure formatted with unit (e.g., "1013 hPa")
  String get pressureString => '$pressure hPa';
  
  /// Visibility formatted in kilometers (e.g., "10.0 km")
  String get visibilityString => '${(visibility / 1000).toStringAsFixed(1)} km';
  
  /// UV index as string (e.g., "5")
  String get uvIndexString => uvIndex.toString();
  
  /// Air quality index as string (e.g., "2")
  String get airQualityString => airQuality.toString();
  
  // MARK: - Separated Number and Unit Getters
  // For UI flexibility when styling numbers and units differently
  
  /// Wind speed number only (e.g., "3.2")
  String get windSpeedNumber => windSpeed.toStringAsFixed(1);
  
  /// Wind speed unit only (e.g., "m/s")
  String get windSpeedUnit => 'm/s';
  
  /// Humidity number only (e.g., "65")
  String get humidityNumber => humidity.toString();
  
  /// Humidity unit only (e.g., "%")
  String get humidityUnit => '%';
  
  /// Pressure number only (e.g., "1013")
  String get pressureNumber => pressure.toString();
  
  /// Pressure unit only (e.g., "hPa")
  String get pressureUnit => 'hPa';
  
  /// Visibility number only (e.g., "10.0")
  String get visibilityNumber => (visibility / 1000).toStringAsFixed(1);
  
  /// Visibility unit only (e.g., "km")
  String get visibilityUnit => 'km';
  
  /// Weather description with proper capitalization (e.g., "Partly Cloudy")
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}