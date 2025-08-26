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
/// - [pm25]: PM2.5 concentration (µg/m³)
/// - [pm10]: PM10 concentration (µg/m³)
/// - [precipitationProbability]: Precipitation probability (0.0-1.0)
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
  final double? uvIndex;
  final int? airQuality;
  final double pm25;
  final double pm10;
  final double precipitationProbability;
  final double? latitude;
  final double? longitude;
  final DateTime? sunrise;
  final DateTime? sunset;
  final int? timezone; // 시간대 오프셋 (초 단위)

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
    this.uvIndex,
    this.airQuality,
    required this.pm25,
    required this.pm10,
    required this.precipitationProbability,
    this.latitude,
    this.longitude,
    this.sunrise,
    this.sunset,
    this.timezone,
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
        ? DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000, isUtc: true)
        : null;
    final sunset = sunsetTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000, isUtc: true)
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
      uvIndex: null, // Will be updated by separate UV API call
      airQuality: null, // Will be updated by separate air quality API call
      pm25: 0.0, // Will be updated by air quality API call
      pm10: 0.0, // Will be updated by air quality API call
      precipitationProbability: 0.0, // Will be updated by forecast API call
      latitude: json['coord'] != null ? json['coord']['lat']?.toDouble() : null,
      longitude: json['coord'] != null ? json['coord']['lon']?.toDouble() : null,
      sunrise: sunrise,
      sunset: sunset,
      timezone: json['timezone'], // API에서 제공하는 시간대 오프셋 (초 단위)
    );
  }

  // MARK: - Formatted String Getters
  
  /// Temperature formatted with degree symbol (e.g., "22°")
  String get temperatureString => '${temperature.round()}°';
  
  /// 도시의 로컬 시간을 HH:mm 형식으로 반환
  String get cityLocalTime {
    if (timezone == null) {
      // 시간대 정보가 없으면 UTC 기준으로 표시
      final now = DateTime.now().toUtc();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
    
    // UTC 시간에 시간대 오프셋을 추가하여 도시의 로컬 시간 계산
    final utcNow = DateTime.now().toUtc();
    final cityTime = utcNow.add(Duration(seconds: timezone!));
    
    return '${cityTime.hour.toString().padLeft(2, '0')}:${cityTime.minute.toString().padLeft(2, '0')}';
  }
  
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
  
  /// UV index as string (e.g., "5" or "-" if not available)
  String get uvIndexString => uvIndex?.round().toString() ?? '-';
  
  /// Air quality index as string (e.g., "2" or "-" if not available)
  String get airQualityString => airQuality?.toString() ?? '-';
  
  /// PM2.5 concentration formatted with unit (e.g., "10.3 µg/m³")
  String get pm25String => '${pm25.toStringAsFixed(1)} µg/m³';
  
  /// PM10 concentration formatted with unit (e.g., "18.9 µg/m³")
  String get pm10String => '${pm10.toStringAsFixed(1)} µg/m³';
  
  /// Precipitation probability formatted as percentage (e.g., "80%")
  String get precipitationProbabilityString => '${(precipitationProbability * 100).round()}%';
  
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