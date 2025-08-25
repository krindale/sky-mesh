/// Weather condition card model for displaying contextual weather alerts
/// 
/// This model represents various weather condition cards that provide
/// users with relevant information based on current weather conditions.
/// 
/// ## Card Types
/// - Heat/Cold warnings
/// - UV Index alerts
/// - Air quality alerts
/// - Wind/Typhoon warnings
/// - Activity indices (car wash/laundry)
class WeatherConditionCard {
  final WeatherCardType type;
  final WeatherCardSeverity severity;
  final String title;
  final String message;
  final String iconCode;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WeatherConditionCard({
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    required this.iconCode,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a heat wave warning card
  factory WeatherConditionCard.heatWave({
    required double temperature,
    required String cityName,
    required WeatherCardSeverity severity,
  }) {
    final severityText = severity == WeatherCardSeverity.warning ? 'Advisory' : 'Warning';
    return WeatherConditionCard(
      type: WeatherCardType.heatWave,
      severity: severity,
      title: 'Heat Wave $severityText',
      message: 'Heat wave $severityText! Today\'s high temperature in $cityName will reach ${temperature.round()}°C. Don\'t forget to stay hydrated.',
      iconCode: '🌡️',
      data: {'temperature': temperature, 'cityName': cityName},
    );
  }

  /// Creates a cold wave warning card
  factory WeatherConditionCard.coldWave({
    required double temperature,
    required String cityName,
    required WeatherCardSeverity severity,
  }) {
    final severityText = severity == WeatherCardSeverity.warning ? 'Advisory' : 'Warning';
    return WeatherConditionCard(
      type: WeatherCardType.coldWave,
      severity: severity,
      title: 'Cold Wave $severityText',
      message: 'Cold wave $severityText! Tomorrow morning temperature in $cityName will drop to ${temperature.round()}°C. Dress warmly when going outside.',
      iconCode: '❄️',
      data: {'temperature': temperature, 'cityName': cityName},
    );
  }

  /// Creates a UV index alert card
  factory WeatherConditionCard.uvAlert({
    required double uvIndex,
    required WeatherCardSeverity severity,
  }) {
    String title, message, icon;
    
    switch (severity) {
      case WeatherCardSeverity.info:
        title = 'UV Advisory';
        message = 'UV Advisory! Today\'s UV index is at \'High\' level. Use hat or sunglasses when going outside.';
        icon = '🕶️';
        break;
      case WeatherCardSeverity.warning:
      case WeatherCardSeverity.danger:
        title = 'UV Warning';
        message = 'UV Warning! UV index is very high. Avoid outdoor activities between 11 AM and 3 PM.';
        icon = '☀️';
        break;
    }

    return WeatherConditionCard(
      type: WeatherCardType.uvIndex,
      severity: severity,
      title: title,
      message: message,
      iconCode: icon,
      data: {'uvIndex': uvIndex},
    );
  }

  /// Creates an air quality alert card
  factory WeatherConditionCard.airQualityAlert({
    required double pm25,
    required double pm10,
    required int aqi,
    required String cityName,
    required WeatherCardSeverity severity,
  }) {
    String title, message, icon;
    
    switch (severity) {
      case WeatherCardSeverity.warning:
        title = 'Poor Air Quality';
        message = 'Poor air quality! Current fine dust concentration in $cityName is high. Make sure to wear a mask when going outside.';
        icon = '😷';
        break;
      case WeatherCardSeverity.danger:
        title = 'Very Poor Air Quality';
        message = 'Very poor air quality! Fine dust concentration is at dangerous levels. Keep windows closed and stay indoors as much as possible.';
        icon = '🚨';
        break;
      default:
        title = 'Air Quality Advisory';
        message = 'Check air quality levels.';
        icon = '💨';
    }

    return WeatherConditionCard(
      type: WeatherCardType.airQuality,
      severity: severity,
      title: title,
      message: message,
      iconCode: icon,
      data: {'pm25': pm25, 'pm10': pm10, 'aqi': aqi, 'cityName': cityName},
    );
  }

  /// Creates a strong wind alert card
  factory WeatherConditionCard.strongWind({
    required double windSpeed,
    required String cityName,
    required WeatherCardSeverity severity,
  }) {
    return WeatherConditionCard(
      type: WeatherCardType.strongWind,
      severity: severity,
      title: 'Strong Wind Advisory',
      message: 'Strong wind advisory! Strong winds of ${windSpeed.toStringAsFixed(1)}m/s are expected in $cityName from this afternoon. Be careful with facilities and outdoor objects.',
      iconCode: '💨',
      data: {'windSpeed': windSpeed, 'cityName': cityName},
    );
  }

  /// Creates a car wash index card
  factory WeatherConditionCard.carWashIndex({
    required double precipitationProbability,
    required int airQuality,
  }) {
    return WeatherConditionCard(
      type: WeatherCardType.carWashIndex,
      severity: WeatherCardSeverity.info,
      title: 'Perfect Car Wash Day',
      message: 'Perfect day for car washing! No rain expected until the weekend, so it will stay clean longer.',
      iconCode: '🚗',
      data: {'precipitationProbability': precipitationProbability, 'airQuality': airQuality},
    );
  }

  /// Creates a laundry index card
  factory WeatherConditionCard.laundryIndex({
    required double precipitationProbability,
    required int humidity,
    required double windSpeed,
  }) {
    return WeatherConditionCard(
      type: WeatherCardType.laundryIndex,
      severity: WeatherCardSeverity.info,
      title: 'Perfect Laundry Weather',
      message: 'Perfect laundry weather! Clear skies and moderate winds make it ideal for drying clothes.',
      iconCode: '👔',
      data: {
        'precipitationProbability': precipitationProbability,
        'humidity': humidity,
        'windSpeed': windSpeed,
      },
    );
  }
}

/// Types of weather condition cards
enum WeatherCardType {
  heatWave,      // Heat wave
  coldWave,      // Cold wave
  uvIndex,       // UV index
  airQuality,    // Air quality
  strongWind,    // Strong wind
  typhoon,       // Typhoon
  carWashIndex,  // Car wash index
  laundryIndex,  // Laundry index
}

/// Severity levels for weather condition cards
enum WeatherCardSeverity {
  info,     // Informational (blue)
  warning,  // Caution (orange)
  danger,   // Warning/danger (red)
}

/// Extension for getting display properties
extension WeatherCardTypeExtension on WeatherCardType {
  String get displayName {
    switch (this) {
      case WeatherCardType.heatWave:
        return 'Heat/Cold Wave';
      case WeatherCardType.coldWave:
        return 'Cold Wave';
      case WeatherCardType.uvIndex:
        return 'UV Index';
      case WeatherCardType.airQuality:
        return 'Air Quality';
      case WeatherCardType.strongWind:
        return 'Strong Wind/Typhoon';
      case WeatherCardType.typhoon:
        return 'Typhoon';
      case WeatherCardType.carWashIndex:
        return 'Car Wash Index';
      case WeatherCardType.laundryIndex:
        return 'Laundry Index';
    }
  }

  String get settingsKey {
    switch (this) {
      case WeatherCardType.heatWave:
        return 'heat_cold_alerts';
      case WeatherCardType.coldWave:
        return 'heat_cold_alerts';
      case WeatherCardType.uvIndex:
        return 'uv_alerts';
      case WeatherCardType.airQuality:
        return 'air_quality_alerts';
      case WeatherCardType.strongWind:
        return 'wind_alerts';
      case WeatherCardType.typhoon:
        return 'wind_alerts';
      case WeatherCardType.carWashIndex:
        return 'activity_indices';
      case WeatherCardType.laundryIndex:
        return 'activity_indices';
    }
  }
}

extension WeatherCardSeverityExtension on WeatherCardSeverity {
  String get colorHex {
    switch (this) {
      case WeatherCardSeverity.info:
        return '#2196F3'; // Blue
      case WeatherCardSeverity.warning:
        return '#FF9800'; // Orange
      case WeatherCardSeverity.danger:
        return '#F44336'; // Red
    }
  }
}