import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/services/weather_condition_rule_engine.dart';
import 'package:sky_mesh/core/models/weather_data.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';

void main() {
  group('WeatherConditionRuleEngine Tests', () {
    late WeatherConditionRuleEngine ruleEngine;

    setUp(() {
      ruleEngine = WeatherConditionRuleEngine();
    });

    group('Temperature Conditions', () {
      test('generates heat wave danger alert for temperature >= 35°C', () {
        final weatherData = WeatherData(
          temperature: 36.0,
          feelsLike: 38.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Seoul',
          country: 'KR',
          pressure: 1013,
          visibility: 10000,
          pm25: 25.0,
          pm10: 35.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final heatWaveCards = cards.where((card) => card.type == WeatherCardType.heatWave).toList();

        expect(heatWaveCards.length, 1);
        expect(heatWaveCards.first.severity, WeatherCardSeverity.danger);
      });

      test('generates heat wave warning alert for temperature >= 33°C', () {
        final weatherData = WeatherData(
          temperature: 34.0,
          feelsLike: 36.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Seoul',
          country: 'KR',
          pressure: 1013,
          visibility: 10000,
          pm25: 25.0,
          pm10: 35.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final heatWaveCards = cards.where((card) => card.type == WeatherCardType.heatWave).toList();

        expect(heatWaveCards.length, 1);
        expect(heatWaveCards.first.severity, WeatherCardSeverity.warning);
      });

      test('generates cold wave danger alert for temperature <= -15°C', () {
        final weatherData = WeatherData(
          temperature: -16.0,
          feelsLike: -20.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Snow',
          iconCode: '13d',
          cityName: 'Moscow',
          country: 'RU',
          pressure: 1013,
          visibility: 10000,
          pm25: 15.0,
          pm10: 25.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final coldWaveCards = cards.where((card) => card.type == WeatherCardType.coldWave).toList();

        expect(coldWaveCards.length, 1);
        expect(coldWaveCards.first.severity, WeatherCardSeverity.danger);
      });

      test('generates cold wave warning alert for temperature <= -12°C', () {
        final weatherData = WeatherData(
          temperature: -13.0,
          feelsLike: -16.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Snow',
          iconCode: '13d',
          cityName: 'Moscow',
          country: 'RU',
          pressure: 1013,
          visibility: 10000,
          pm25: 15.0,
          pm10: 25.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final coldWaveCards = cards.where((card) => card.type == WeatherCardType.coldWave).toList();

        expect(coldWaveCards.length, 1);
        expect(coldWaveCards.first.severity, WeatherCardSeverity.warning);
      });

      test('does not generate temperature alerts for normal temperatures', () {
        final weatherData = WeatherData(
          temperature: 22.0,
          feelsLike: 24.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Seoul',
          country: 'KR',
          pressure: 1013,
          visibility: 10000,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final temperatureCards = cards.where((card) => 
          card.type == WeatherCardType.heatWave || card.type == WeatherCardType.coldWave
        ).toList();

        expect(temperatureCards.length, 0);
      });
    });

    group('UV Index Conditions', () {
      test('generates UV danger alert for UV index >= 11', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Sydney',
          country: 'AU',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 12.0,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex).toList();

        expect(uvCards.length, 1);
        expect(uvCards.first.severity, WeatherCardSeverity.danger);
      });

      test('generates UV warning alert for UV index >= 8', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Sydney',
          country: 'AU',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 9.0,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex).toList();

        expect(uvCards.length, 1);
        expect(uvCards.first.severity, WeatherCardSeverity.warning);
      });

      test('generates UV info alert for UV index >= 6', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Sydney',
          country: 'AU',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 7.0,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex).toList();

        expect(uvCards.length, 1);
        expect(uvCards.first.severity, WeatherCardSeverity.info);
      });

      test('skips UV evaluation when UV index is null', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Sydney',
          country: 'AU',
          pressure: 1013,
          visibility: 10000,
          uvIndex: null,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex).toList();

        expect(uvCards.length, 0);
      });
    });

    group('Air Quality Conditions', () {
      test('generates air quality danger alert for very poor air', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Haze',
          iconCode: '50d',
          cityName: 'Beijing',
          country: 'CN',
          pressure: 1013,
          visibility: 5000,
          airQuality: 5,
          pm25: 80.0,
          pm10: 160.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final airQualityCards = cards.where((card) => card.type == WeatherCardType.airQuality).toList();

        expect(airQualityCards.length, 1);
        expect(airQualityCards.first.severity, WeatherCardSeverity.danger);
      });

      test('generates air quality warning alert for poor air', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Haze',
          iconCode: '50d',
          cityName: 'Beijing',
          country: 'CN',
          pressure: 1013,
          visibility: 8000,
          airQuality: 4,
          pm25: 50.0,
          pm10: 90.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final airQualityCards = cards.where((card) => card.type == WeatherCardType.airQuality).toList();

        expect(airQualityCards.length, 1);
        expect(airQualityCards.first.severity, WeatherCardSeverity.warning);
      });

      test('skips air quality evaluation when air quality is null', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 2.5,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Seoul',
          country: 'KR',
          pressure: 1013,
          visibility: 10000,
          airQuality: null,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final airQualityCards = cards.where((card) => card.type == WeatherCardType.airQuality).toList();

        expect(airQualityCards.length, 0);
      });
    });

    group('Wind Conditions', () {
      test('generates strong wind danger alert for wind >= 14 m/s', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 15.0,
          description: 'Windy',
          iconCode: '03d',
          cityName: 'Chicago',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final windCards = cards.where((card) => card.type == WeatherCardType.strongWind).toList();

        expect(windCards.length, 1);
        expect(windCards.first.severity, WeatherCardSeverity.danger);
      });

      test('generates strong wind warning alert for wind >= 9 m/s', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 65,
          windSpeed: 10.0,
          description: 'Windy',
          iconCode: '03d',
          cityName: 'Chicago',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final windCards = cards.where((card) => card.type == WeatherCardType.strongWind).toList();

        expect(windCards.length, 1);
        expect(windCards.first.severity, WeatherCardSeverity.warning);
      });
    });

    group('Activity Indices', () {
      test('generates car wash index for good conditions', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 50,
          windSpeed: 5.0,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Los Angeles',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          airQuality: 2,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final carWashCards = cards.where((card) => card.type == WeatherCardType.carWashIndex).toList();

        expect(carWashCards.length, 1);
        expect(carWashCards.first.severity, WeatherCardSeverity.info);
      });

      test('generates laundry index for good conditions', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 55,
          windSpeed: 4.0,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Phoenix',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final laundryCards = cards.where((card) => card.type == WeatherCardType.laundryIndex).toList();

        expect(laundryCards.length, 1);
        expect(laundryCards.first.severity, WeatherCardSeverity.info);
      });

      test('does not generate car wash index for poor air quality', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 50,
          windSpeed: 5.0,
          description: 'Haze',
          iconCode: '50d',
          cityName: 'Beijing',
          country: 'CN',
          pressure: 1013,
          visibility: 8000,
          airQuality: 4,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final carWashCards = cards.where((card) => card.type == WeatherCardType.carWashIndex).toList();

        expect(carWashCards.length, 0);
      });

      test('does not generate laundry index for high humidity', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 80,
          windSpeed: 4.0,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Miami',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final laundryCards = cards.where((card) => card.type == WeatherCardType.laundryIndex).toList();

        expect(laundryCards.length, 0);
      });
    });

    group('Card Sorting', () {
      test('sorts cards by severity priority (danger > warning > info)', () {
        final weatherData = WeatherData(
          temperature: 36.0, // Heat wave danger
          feelsLike: 40.0,
          humidity: 50,
          windSpeed: 3.0,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Phoenix',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 8.0, // UV warning
          airQuality: 2,
          pm25: 20.0,
          pm10: 30.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        
        // Should have heat wave (danger), UV (warning), car wash & laundry (info)
        expect(cards.length, greaterThanOrEqualTo(3));
        
        // First card should be danger severity
        expect(cards.first.severity, WeatherCardSeverity.danger);
        
        // Check that danger cards come before warning cards
        final dangerIndex = cards.indexWhere((card) => card.severity == WeatherCardSeverity.danger);
        final warningIndex = cards.indexWhere((card) => card.severity == WeatherCardSeverity.warning);
        
        if (dangerIndex >= 0 && warningIndex >= 0) {
          expect(dangerIndex, lessThan(warningIndex));
        }
      });
    });
  });

  group('WeatherConditionPreferences Tests', () {
    test('getDefaultPreferences returns all cards enabled', () {
      final preferences = WeatherConditionPreferences.getDefaultPreferences();
      
      expect(preferences['heat_cold_alerts'], true);
      expect(preferences['uv_alerts'], true);
      expect(preferences['air_quality_alerts'], true);
      expect(preferences['wind_alerts'], true);
      expect(preferences['activity_indices'], true);
    });
  });
}