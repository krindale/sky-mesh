/// Weather data model following SRP (Single Responsibility Principle)
/// Only responsible for weather data representation
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
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
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
      visibility: json['visibility'] ?? 10000,
      uvIndex: 5, // UV index requires separate API call
      airQuality: 2, // Air quality - mock data (1-5 scale)
      latitude: json['coord']['lat']?.toDouble(),
      longitude: json['coord']['lon']?.toDouble(),
    );
  }

  // Getters for formatted strings - following SRP
  String get temperatureString => '${temperature.round()}°';
  String get feelsLikeString => '${feelsLike.round()}°';
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} m/s';
  String get humidityString => '$humidity%';
  String get pressureString => '${pressure} hPa';
  String get visibilityString => '${(visibility / 1000).toStringAsFixed(1)} km';
  String get uvIndexString => uvIndex.toString();
  String get airQualityString => airQuality.toString();
  
  // Separated number and unit for UI flexibility
  String get windSpeedNumber => windSpeed.toStringAsFixed(1);
  String get windSpeedUnit => 'm/s';
  String get humidityNumber => humidity.toString();
  String get humidityUnit => '%';
  String get pressureNumber => pressure.toString();
  String get pressureUnit => 'hPa';
  String get visibilityNumber => (visibility / 1000).toStringAsFixed(1);
  String get visibilityUnit => 'km';
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}