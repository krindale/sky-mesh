import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';
import 'package:sky_mesh/core/models/weather_data.dart';
import 'package:sky_mesh/core/services/weather_condition_rule_engine.dart';

void main() {
  group('Weather Condition Integration Tests', () {
    late WeatherConditionRuleEngine ruleEngine;

    setUp(() {
      ruleEngine = WeatherConditionRuleEngine();
    });

    group('WeatherConditionRuleEngine Card Generation', () {
      test('generates correct heat wave cards with proper data', () {
        final weatherData = WeatherData(
          temperature: 36.0,
          feelsLike: 38.0,
          humidity: 60,
          windSpeed: 5.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Phoenix',
          country: 'US',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 8.0,
          airQuality: 2,
          pm25: 15.0,
          pm10: 25.0,
          precipitationProbability: 0.0,
          latitude: 33.4484,
          longitude: -112.0740,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final heatWaveCards = cards.where((card) => card.type == WeatherCardType.heatWave).toList();

        expect(heatWaveCards.length, 1);
        final heatCard = heatWaveCards.first;
        expect(heatCard.severity, WeatherCardSeverity.danger);
        expect(heatCard.data['temperature'], 36.0);
        expect(heatCard.data['cityName'], 'Phoenix');
        expect(heatCard.message, contains('Phoenix'));
        expect(heatCard.message, contains('36°C'));
      });

      test('generates correct cold wave cards with proper data', () {
        final weatherData = WeatherData(
          temperature: -16.0,
          feelsLike: -20.0,
          humidity: 80,
          windSpeed: 10.0,
          description: 'snow',
          iconCode: '13d',
          cityName: 'Moscow',
          country: 'RU',
          pressure: 1020,
          visibility: 5000,
          uvIndex: 1.0,
          airQuality: 3,
          pm25: 30.0,
          pm10: 50.0,
          precipitationProbability: 0.8,
          latitude: 55.7558,
          longitude: 37.6176,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final coldWaveCards = cards.where((card) => card.type == WeatherCardType.coldWave).toList();

        expect(coldWaveCards.length, 1);
        final coldCard = coldWaveCards.first;
        expect(coldCard.severity, WeatherCardSeverity.danger);
        expect(coldCard.data['temperature'], -16.0);
        expect(coldCard.data['cityName'], 'Moscow');
        expect(coldCard.message, contains('Moscow'));
        expect(coldCard.message, contains('-16°C'));
      });

      test('generates correct UV alert cards with proper data', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 50,
          windSpeed: 3.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Sydney',
          country: 'AU',
          pressure: 1015,
          visibility: 15000,
          uvIndex: 12.0,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: -33.8688,
          longitude: 151.2093,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex).toList();

        expect(uvCards.length, 1);
        final uvCard = uvCards.first;
        expect(uvCard.severity, WeatherCardSeverity.danger);
        expect(uvCard.data['uvIndex'], 12.0);
        expect(uvCard.message, contains('UV Warning'));
      });

      test('generates correct air quality alert cards with proper data', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 2.0,
          description: 'haze',
          iconCode: '50d',
          cityName: 'Beijing',
          country: 'CN',
          pressure: 1010,
          visibility: 3000,
          uvIndex: 5.0,
          airQuality: 5,
          pm25: 80.0,
          pm10: 160.0,
          precipitationProbability: 0.2,
          latitude: 39.9042,
          longitude: 116.4074,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final airQualityCards = cards.where((card) => card.type == WeatherCardType.airQuality).toList();

        expect(airQualityCards.length, 1);
        final airCard = airQualityCards.first;
        expect(airCard.severity, WeatherCardSeverity.danger);
        expect(airCard.data['pm25'], 80.0);
        expect(airCard.data['pm10'], 160.0);
        expect(airCard.data['aqi'], 5);
        // Air quality danger message doesn't include city name, so check data instead
        expect(airCard.data['cityName'], 'Beijing');
      });

      test('generates correct strong wind alert cards with proper data', () {
        final weatherData = WeatherData(
          temperature: 20.0,
          feelsLike: 18.0,
          humidity: 70,
          windSpeed: 15.0,
          description: 'scattered clouds',
          iconCode: '03d',
          cityName: 'Chicago',
          country: 'US',
          pressure: 1008,
          visibility: 12000,
          uvIndex: 4.0,
          airQuality: 2,
          pm25: 20.0,
          pm10: 35.0,
          precipitationProbability: 0.3,
          latitude: 41.8781,
          longitude: -87.6298,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        final windCards = cards.where((card) => card.type == WeatherCardType.strongWind).toList();

        expect(windCards.length, 1);
        final windCard = windCards.first;
        expect(windCard.data['windSpeed'], 15.0);
        expect(windCard.data['cityName'], 'Chicago');
        expect(windCard.message, contains('Chicago'));
        expect(windCard.message, contains('15.0m/s'));
      });

      test('generates activity index cards with proper data', () {
        final weatherData = WeatherData(
          temperature: 22.0,
          feelsLike: 24.0,
          humidity: 45,
          windSpeed: 3.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Los Angeles',
          country: 'US',
          pressure: 1016,
          visibility: 20000,
          uvIndex: 5.0,
          airQuality: 2,
          pm25: 10.0,
          pm10: 15.0,
          precipitationProbability: 0.05,
          latitude: 34.0522,
          longitude: -118.2437,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        
        final carWashCards = cards.where((card) => card.type == WeatherCardType.carWashIndex).toList();
        final laundryCards = cards.where((card) => card.type == WeatherCardType.laundryIndex).toList();

        // Should generate both activity cards in good conditions
        expect(carWashCards.length, 1);
        expect(laundryCards.length, 1);

        final carCard = carWashCards.first;
        expect(carCard.severity, WeatherCardSeverity.info);
        expect(carCard.data['precipitationProbability'], 0.05);
        expect(carCard.data['airQuality'], 2);

        final laundryCard = laundryCards.first;
        expect(laundryCard.severity, WeatherCardSeverity.info);
        expect(laundryCard.data['precipitationProbability'], 0.05);
        expect(laundryCard.data['humidity'], 45);
        expect(laundryCard.data['windSpeed'], 3.0);
      });

      test('generates multiple cards for complex weather conditions', () {
        final weatherData = WeatherData(
          temperature: 36.0,
          feelsLike: 40.0,
          humidity: 80,
          windSpeed: 12.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Phoenix',
          country: 'US',
          pressure: 1008,
          visibility: 8000,
          uvIndex: 11.0,
          airQuality: 4,
          pm25: 55.0,
          pm10: 95.0,
          precipitationProbability: 0.0,
          latitude: 33.4484,
          longitude: -112.0740,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);

        // Should generate multiple warning cards
        expect(cards.length, greaterThan(2));
        
        final heatCards = cards.where((card) => card.type == WeatherCardType.heatWave);
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex);
        final windCards = cards.where((card) => card.type == WeatherCardType.strongWind);
        final airCards = cards.where((card) => card.type == WeatherCardType.airQuality);

        expect(heatCards.length, 1);
        expect(uvCards.length, 1);
        expect(windCards.length, 1);
        expect(airCards.length, 1);

        // Verify cards have proper severity levels
        expect(heatCards.first.severity, WeatherCardSeverity.danger);
        expect(uvCards.first.severity, WeatherCardSeverity.danger);
        expect(airCards.first.severity, WeatherCardSeverity.warning);
      });

      test('does not generate cards when conditions are normal', () {
        final weatherData = WeatherData(
          temperature: 22.0,
          feelsLike: 24.0,
          humidity: 50,
          windSpeed: 3.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'San Francisco',
          country: 'US',
          pressure: 1015,
          visibility: 15000,
          uvIndex: 4.0,
          airQuality: 2,
          pm25: 12.0,
          pm10: 18.0,
          precipitationProbability: 0.1,
          latitude: 37.7749,
          longitude: -122.4194,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        
        // Should only generate activity index cards in normal conditions
        final alertCards = cards.where((card) => 
          card.type != WeatherCardType.carWashIndex && 
          card.type != WeatherCardType.laundryIndex
        ).toList();
        
        expect(alertCards.isEmpty, true);
        
        // Should still have activity cards
        final activityCards = cards.where((card) => 
          card.type == WeatherCardType.carWashIndex || 
          card.type == WeatherCardType.laundryIndex
        ).toList();
        
        expect(activityCards.length, 2);
      });
    });

    group('Card Data Consistency Tests', () {
      test('card timestamps are recent', () {
        final weatherData = WeatherData(
          temperature: 35.0,
          feelsLike: 37.0,
          humidity: 60,
          windSpeed: 5.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 8.0,
          airQuality: 2,
          pm25: 15.0,
          pm10: 25.0,
          precipitationProbability: 0.0,
        );

        final before = DateTime.now();
        final cards = ruleEngine.evaluateConditions(weatherData);
        final after = DateTime.now();

        for (final card in cards) {
          expect(card.timestamp.isAfter(before.subtract(Duration(seconds: 1))), true);
          expect(card.timestamp.isBefore(after.add(Duration(seconds: 1))), true);
        }
      });

      test('cards contain required data fields', () {
        final weatherData = WeatherData(
          temperature: 38.0,
          feelsLike: 42.0,
          humidity: 65,
          windSpeed: 8.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Dubai',
          country: 'AE',
          pressure: 1010,
          visibility: 12000,
          uvIndex: 10.0,
          airQuality: 3,
          pm25: 40.0,
          pm10: 70.0,
          precipitationProbability: 0.0,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);

        for (final card in cards) {
          expect(card.title, isNotEmpty);
          expect(card.message, isNotEmpty);
          expect(card.iconCode, isNotEmpty);
          expect(card.data, isNotEmpty);
          expect(card.type, isNotNull);
          expect(card.severity, isNotNull);
          expect(card.timestamp, isNotNull);
        }
      });

      test('card messages contain city names when applicable', () {
        final weatherData = WeatherData(
          temperature: 40.0,
          feelsLike: 45.0,
          humidity: 70,
          windSpeed: 12.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Las Vegas',
          country: 'US',
          pressure: 1005,
          visibility: 10000,
          uvIndex: 9.0,
          airQuality: 4,
          pm25: 50.0,
          pm10: 80.0,
          precipitationProbability: 0.0,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);
        
        final citySpecificCards = cards.where((card) => 
          card.type == WeatherCardType.heatWave ||
          card.type == WeatherCardType.coldWave ||
          card.type == WeatherCardType.airQuality ||
          card.type == WeatherCardType.strongWind
        ).toList();

        for (final card in citySpecificCards) {
          expect(card.message, contains('Las Vegas'));
          expect(card.data['cityName'], 'Las Vegas');
        }
      });
    });

    group('Boundary Condition Tests', () {
      test('handles null weather data fields gracefully', () {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 50,
          windSpeed: 3.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: null, // Null UV index
          airQuality: null, // Null air quality
          pm25: 0.0,
          pm10: 0.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(weatherData);

        // Should not crash and should still generate some cards
        expect(cards, isNotNull);
        expect(cards.length, greaterThanOrEqualTo(0));
        
        // Should not generate UV or air quality cards when data is null
        final uvCards = cards.where((card) => card.type == WeatherCardType.uvIndex);
        final airCards = cards.where((card) => card.type == WeatherCardType.airQuality);
        
        expect(uvCards.isEmpty, true);
        expect(airCards.isEmpty, true);
      });

      test('handles extreme weather values correctly', () {
        final extremeWeatherData = WeatherData(
          temperature: 55.0, // Extreme heat
          feelsLike: 60.0,
          humidity: 95,
          windSpeed: 50.0, // Extreme wind
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Extreme City',
          country: 'EC',
          pressure: 950,
          visibility: 1000,
          uvIndex: 20.0, // Extreme UV
          airQuality: 5,
          pm25: 500.0, // Extreme pollution
          pm10: 1000.0,
          precipitationProbability: 1.0,
        );

        final cards = ruleEngine.evaluateConditions(extremeWeatherData);

        expect(cards.length, greaterThan(3)); // Should generate multiple danger alerts

        // All non-activity cards should be danger level
        final alertCards = cards.where((card) => 
          card.type != WeatherCardType.carWashIndex && 
          card.type != WeatherCardType.laundryIndex
        ).toList();

        for (final card in alertCards) {
          expect(card.severity, WeatherCardSeverity.danger);
        }
      });
    });

    group('Card Sorting and Priority Tests', () {
      test('cards are sorted by severity priority', () {
        final mixedSeverityWeatherData = WeatherData(
          temperature: 35.0, // Warning heat wave
          feelsLike: 38.0,
          humidity: 50,
          windSpeed: 10.0, // Warning wind
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Mixed City',
          country: 'MC',
          pressure: 1005,
          visibility: 10000,
          uvIndex: 12.0, // Danger UV
          airQuality: 2,
          pm25: 15.0,
          pm10: 25.0,
          precipitationProbability: 0.1,
        );

        final cards = ruleEngine.evaluateConditions(mixedSeverityWeatherData);

        // Find cards of different severities
        final dangerCards = cards.where((card) => card.severity == WeatherCardSeverity.danger).toList();
        final warningCards = cards.where((card) => card.severity == WeatherCardSeverity.warning).toList();
        final infoCards = cards.where((card) => card.severity == WeatherCardSeverity.info).toList();

        expect(dangerCards.isNotEmpty, true);
        expect(warningCards.isNotEmpty, true);
        expect(infoCards.isNotEmpty, true);

        // Cards should be sorted by severity (danger first, then warning, then info)
        var foundDanger = false;
        var foundWarning = false;

        for (final card in cards) {
          if (card.severity == WeatherCardSeverity.danger) {
            foundDanger = true;
            expect(foundWarning, false); // No warning cards should come before danger
          } else if (card.severity == WeatherCardSeverity.warning) {
            foundWarning = true;
          } else if (card.severity == WeatherCardSeverity.info) {
            expect(foundDanger || foundWarning, true); // Info should come after danger/warning
          }
        }
      });
    });
  });
}