import '../models/weather_data.dart';
import '../models/weather_condition_card.dart';
import '../utils/logger.dart';

/// Weather condition rule engine that evaluates weather data against
/// predefined conditions to generate appropriate weather condition cards
/// 
/// This service implements business logic for determining when to show
/// specific weather alerts and information cards to users based on current
/// weather conditions and forecast data.
/// 
/// ## Features
/// - Heat/Cold wave detection
/// - UV index alerts
/// - Air quality warnings
/// - Strong wind alerts
/// - Activity indices (car wash, laundry)
/// - User preference integration
/// - Priority-based card ordering
/// 
/// ## Usage
/// 
/// ```dart
/// final ruleEngine = WeatherConditionRuleEngine();
/// final cards = ruleEngine.evaluateConditions(weatherData, preferences);
/// 
/// // Display cards in UI
/// for (final card in cards) {
///   showWeatherCard(card);
/// }
/// ```
class WeatherConditionRuleEngine {
  
  /// Evaluates weather conditions and returns list of applicable condition cards
  /// 
  /// Cards are returned in priority order (most important first)
  /// All card types are enabled by default
  List<WeatherConditionCard> evaluateConditions(
    WeatherData weather,
  ) {
    final cards = <WeatherConditionCard>[];
    
    Logger.debug('🧠 Evaluating weather conditions for ${weather.cityName}');
    Logger.debug('Temperature: ${weather.temperature}°C, UV: ${weather.uvIndex}, AQI: ${weather.airQuality}');
    
    // Evaluate each condition type
    _evaluateTemperatureConditions(weather, cards);
    _evaluateUVConditions(weather, cards);
    _evaluateAirQualityConditions(weather, cards);
    _evaluateWindConditions(weather, cards);
    _evaluateActivityIndices(weather, cards);
    
    // Sort by priority (danger > warning > info)
    cards.sort((a, b) {
      final aPriority = _getSeverityPriority(a.severity);
      final bPriority = _getSeverityPriority(b.severity);
      return bPriority.compareTo(aPriority);
    });
    
    Logger.debug('📊 Generated ${cards.length} condition cards');
    return cards;
  }
  
  /// Evaluates temperature-based conditions (heat wave, cold wave)
  void _evaluateTemperatureConditions(
    WeatherData weather,
    List<WeatherConditionCard> cards,
  ) {
    
    // Heat wave conditions
    if (weather.temperature >= 35) {
      cards.add(WeatherConditionCard.heatWave(
        temperature: weather.temperature,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.danger, // 폭염경보
      ));
      Logger.debug('🌡️ Heat wave alert (danger): ${weather.temperature}°C');
    } else if (weather.temperature >= 33) {
      cards.add(WeatherConditionCard.heatWave(
        temperature: weather.temperature,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.warning, // 폭염주의보
      ));
      Logger.debug('🌡️ Heat wave alert (warning): ${weather.temperature}°C');
    }
    
    // Cold wave conditions  
    if (weather.temperature <= -15) {
      cards.add(WeatherConditionCard.coldWave(
        temperature: weather.temperature,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.danger, // 한파경보
      ));
      Logger.debug('❄️ Cold wave alert (danger): ${weather.temperature}°C');
    } else if (weather.temperature <= -12) {
      cards.add(WeatherConditionCard.coldWave(
        temperature: weather.temperature,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.warning, // 한파주의보
      ));
      Logger.debug('❄️ Cold wave alert (warning): ${weather.temperature}°C');
    }
  }
  
  /// Evaluates UV index conditions
  void _evaluateUVConditions(
    WeatherData weather,
    List<WeatherConditionCard> cards,
  ) {
    // Skip UV evaluation if data is not available
    if (weather.uvIndex == null) {
      Logger.debug('☀️ UV data not available, skipping UV condition evaluation');
      return;
    }
    
    final uvIndex = weather.uvIndex!;
    if (uvIndex >= 11) {
      cards.add(WeatherConditionCard.uvAlert(
        uvIndex: uvIndex,
        severity: WeatherCardSeverity.danger, // 위험
      ));
      Logger.debug('☀️ UV alert (danger): $uvIndex');
    } else if (uvIndex >= 8) {
      cards.add(WeatherConditionCard.uvAlert(
        uvIndex: uvIndex,
        severity: WeatherCardSeverity.warning, // 매우 높음
      ));
      Logger.debug('☀️ UV alert (warning): $uvIndex');
    } else if (uvIndex >= 6) {
      cards.add(WeatherConditionCard.uvAlert(
        uvIndex: uvIndex,
        severity: WeatherCardSeverity.info, // 높음
      ));
      Logger.debug('☀️ UV alert (info): $uvIndex');
    }
  }
  
  /// Evaluates air quality conditions
  void _evaluateAirQualityConditions(
    WeatherData weather,
    List<WeatherConditionCard> cards,
  ) {
    // Skip air quality evaluation if data is not available
    if (weather.airQuality == null) {
      Logger.debug('💨 Air quality data not available, skipping air quality condition evaluation');
      return;
    }
    
    // PM2.5 기준: 나쁨 76+, 매우나쁨 151+
    // PM10 기준: 나쁨 81+, 매우나쁨 151+
    // AQI 기준: 나쁨 4+, 매우나쁨 5
    
    final airQuality = weather.airQuality!;
    bool isVeryBad = weather.pm25 >= 76 || weather.pm10 >= 151 || airQuality >= 5;
    bool isBad = weather.pm25 >= 36 || weather.pm10 >= 81 || airQuality >= 4;
    
    if (isVeryBad) {
      cards.add(WeatherConditionCard.airQualityAlert(
        pm25: weather.pm25,
        pm10: weather.pm10,
        aqi: airQuality,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.danger, // 매우 나쁨
      ));
      Logger.debug('💨 Air quality alert (danger): PM2.5=${weather.pm25}, PM10=${weather.pm10}');
    } else if (isBad) {
      cards.add(WeatherConditionCard.airQualityAlert(
        pm25: weather.pm25,
        pm10: weather.pm10,
        aqi: airQuality,
        cityName: weather.cityName,
        severity: WeatherCardSeverity.warning, // 나쁨
      ));
      Logger.debug('💨 Air quality alert (warning): PM2.5=${weather.pm25}, PM10=${weather.pm10}');
    }
  }
  
  /// Evaluates wind conditions
  void _evaluateWindConditions(
    WeatherData weather,
    List<WeatherConditionCard> cards,
  ) {
    
    // Strong wind: >= 9 m/s (나뭇가지가 흔들리는 정도)
    if (weather.windSpeed >= 9.0) {
      cards.add(WeatherConditionCard.strongWind(
        windSpeed: weather.windSpeed,
        cityName: weather.cityName,
        severity: weather.windSpeed >= 14.0 
            ? WeatherCardSeverity.danger 
            : WeatherCardSeverity.warning,
      ));
      Logger.debug('💨 Strong wind alert: ${weather.windSpeed} m/s');
    }
  }
  
  /// Evaluates activity indices (car wash, laundry)
  void _evaluateActivityIndices(
    WeatherData weather,
    List<WeatherConditionCard> cards,
  ) {
    
    // Car wash index: good when precipitation <= 20% AND air quality < 4 (나쁨)
    // If air quality data is not available, only check precipitation
    bool carWashGood = weather.precipitationProbability <= 0.2 && 
        (weather.airQuality == null || weather.airQuality! < 4);
    
    if (carWashGood) {
      cards.add(WeatherConditionCard.carWashIndex(
        precipitationProbability: weather.precipitationProbability,
        airQuality: weather.airQuality ?? 1, // Default to good air quality if not available
      ));
      Logger.debug('🚗 Car wash index: good conditions');
    }
    
    // Laundry index: good when precipitation <= 20% AND humidity <= 60% AND wind >= 2 m/s
    bool laundryGood = weather.precipitationProbability <= 0.2 && 
                      weather.humidity <= 60 && 
                      weather.windSpeed >= 2.0;
    
    if (laundryGood) {
      cards.add(WeatherConditionCard.laundryIndex(
        precipitationProbability: weather.precipitationProbability,
        humidity: weather.humidity,
        windSpeed: weather.windSpeed,
      ));
      Logger.debug('👔 Laundry index: good conditions');
    }
  }
  
  /// Gets priority value for severity (higher value = higher priority)
  int _getSeverityPriority(WeatherCardSeverity severity) {
    switch (severity) {
      case WeatherCardSeverity.danger:
        return 3;
      case WeatherCardSeverity.warning:
        return 2;
      case WeatherCardSeverity.info:
        return 1;
    }
  }
}

/// Weather condition preferences - all enabled by default
class WeatherConditionPreferences {
  /// Gets default preferences with all cards enabled
  static Map<String, bool> getDefaultPreferences() {
    return {
      'heat_cold_alerts': true,    // 폭염/한파
      'uv_alerts': true,           // 자외선
      'air_quality_alerts': true,  // 미세먼지
      'wind_alerts': true,         // 강풍/태풍
      'activity_indices': true,    // 세차/빨래 지수
    };
  }
}