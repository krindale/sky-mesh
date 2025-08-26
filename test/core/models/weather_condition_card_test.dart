import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';

void main() {
  group('WeatherConditionCard Tests', () {
    group('Constructor Tests', () {
      test('creates a weather condition card with all required fields', () {
        final timestamp = DateTime(2024, 1, 15, 12, 0);
        final card = WeatherConditionCard(
          type: WeatherCardType.heatWave,
          severity: WeatherCardSeverity.warning,
          title: 'Test Title',
          message: 'Test Message',
          iconCode: '🌡️',
          data: {'temperature': 35.0},
          timestamp: timestamp,
        );

        expect(card.type, WeatherCardType.heatWave);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'Test Title');
        expect(card.message, 'Test Message');
        expect(card.iconCode, '🌡️');
        expect(card.data['temperature'], 35.0);
        expect(card.timestamp, timestamp);
      });

      test('uses current time as default timestamp when not provided', () {
        final before = DateTime.now();
        final card = WeatherConditionCard(
          type: WeatherCardType.uvIndex,
          severity: WeatherCardSeverity.info,
          title: 'Test',
          message: 'Test',
          iconCode: '☀️',
          data: {},
        );
        final after = DateTime.now();

        expect(card.timestamp.isAfter(before.subtract(Duration(seconds: 1))), true);
        expect(card.timestamp.isBefore(after.add(Duration(seconds: 1))), true);
      });
    });

    group('Heat Wave Factory Tests', () {
      test('creates warning heat wave card correctly', () {
        final card = WeatherConditionCard.heatWave(
          temperature: 34.0,
          cityName: 'Seoul',
          severity: WeatherCardSeverity.warning,
        );

        expect(card.type, WeatherCardType.heatWave);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'Heat Wave Advisory');
        expect(card.message, contains('Heat wave Advisory!'));
        expect(card.message, contains('Seoul'));
        expect(card.message, contains('34°C'));
        expect(card.iconCode, '🌡️');
        expect(card.data['temperature'], 34.0);
        expect(card.data['cityName'], 'Seoul');
      });

      test('creates danger heat wave card correctly', () {
        final card = WeatherConditionCard.heatWave(
          temperature: 36.0,
          cityName: 'Tokyo',
          severity: WeatherCardSeverity.danger,
        );

        expect(card.type, WeatherCardType.heatWave);
        expect(card.severity, WeatherCardSeverity.danger);
        expect(card.title, 'Heat Wave Warning');
        expect(card.message, contains('Heat wave Warning!'));
        expect(card.message, contains('Tokyo'));
        expect(card.message, contains('36°C'));
        expect(card.iconCode, '🌡️');
        expect(card.data['temperature'], 36.0);
        expect(card.data['cityName'], 'Tokyo');
      });

      test('rounds temperature values correctly', () {
        final card = WeatherConditionCard.heatWave(
          temperature: 35.7,
          cityName: 'Paris',
          severity: WeatherCardSeverity.warning,
        );

        expect(card.message, contains('36°C')); // Should round 35.7 to 36
      });
    });

    group('Cold Wave Factory Tests', () {
      test('creates warning cold wave card correctly', () {
        final card = WeatherConditionCard.coldWave(
          temperature: -10.0,
          cityName: 'Moscow',
          severity: WeatherCardSeverity.warning,
        );

        expect(card.type, WeatherCardType.coldWave);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'Cold Wave Advisory');
        expect(card.message, contains('Cold wave Advisory!'));
        expect(card.message, contains('Moscow'));
        expect(card.message, contains('-10°C'));
        expect(card.iconCode, '❄️');
        expect(card.data['temperature'], -10.0);
        expect(card.data['cityName'], 'Moscow');
      });

      test('creates danger cold wave card correctly', () {
        final card = WeatherConditionCard.coldWave(
          temperature: -20.0,
          cityName: 'Siberia',
          severity: WeatherCardSeverity.danger,
        );

        expect(card.type, WeatherCardType.coldWave);
        expect(card.severity, WeatherCardSeverity.danger);
        expect(card.title, 'Cold Wave Warning');
        expect(card.message, contains('Cold wave Warning!'));
        expect(card.message, contains('Siberia'));
        expect(card.message, contains('-20°C'));
        expect(card.iconCode, '❄️');
      });

      test('handles negative temperature rounding correctly', () {
        final card = WeatherConditionCard.coldWave(
          temperature: -15.6,
          cityName: 'Iceland',
          severity: WeatherCardSeverity.danger,
        );

        expect(card.message, contains('-16°C')); // Should round -15.6 to -16
      });
    });

    group('UV Alert Factory Tests', () {
      test('creates info UV alert card correctly', () {
        final card = WeatherConditionCard.uvAlert(
          uvIndex: 6.0,
          severity: WeatherCardSeverity.info,
        );

        expect(card.type, WeatherCardType.uvIndex);
        expect(card.severity, WeatherCardSeverity.info);
        expect(card.title, 'UV Advisory');
        expect(card.message, contains('UV Advisory!'));
        expect(card.message, contains('High'));
        expect(card.iconCode, '🕶️');
        expect(card.data['uvIndex'], 6.0);
      });

      test('creates warning UV alert card correctly', () {
        final card = WeatherConditionCard.uvAlert(
          uvIndex: 9.0,
          severity: WeatherCardSeverity.warning,
        );

        expect(card.type, WeatherCardType.uvIndex);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'UV Warning');
        expect(card.message, contains('UV Warning!'));
        expect(card.message, contains('very high'));
        expect(card.iconCode, '☀️');
        expect(card.data['uvIndex'], 9.0);
      });

      test('creates danger UV alert card correctly', () {
        final card = WeatherConditionCard.uvAlert(
          uvIndex: 12.0,
          severity: WeatherCardSeverity.danger,
        );

        expect(card.type, WeatherCardType.uvIndex);
        expect(card.severity, WeatherCardSeverity.danger);
        expect(card.title, 'UV Warning');
        expect(card.message, contains('UV Warning!'));
        expect(card.message, contains('very high'));
        expect(card.iconCode, '☀️');
        expect(card.data['uvIndex'], 12.0);
      });
    });

    group('Air Quality Alert Factory Tests', () {
      test('creates warning air quality alert card correctly', () {
        final card = WeatherConditionCard.airQualityAlert(
          pm25: 50.0,
          pm10: 90.0,
          aqi: 4,
          cityName: 'Beijing',
          severity: WeatherCardSeverity.warning,
        );

        expect(card.type, WeatherCardType.airQuality);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'Poor Air Quality');
        expect(card.message, contains('Poor air quality!'));
        expect(card.message, contains('Beijing'));
        expect(card.iconCode, '😷');
        expect(card.data['pm25'], 50.0);
        expect(card.data['pm10'], 90.0);
        expect(card.data['aqi'], 4);
        expect(card.data['cityName'], 'Beijing');
      });

      test('creates danger air quality alert card correctly', () {
        final card = WeatherConditionCard.airQualityAlert(
          pm25: 80.0,
          pm10: 160.0,
          aqi: 5,
          cityName: 'Delhi',
          severity: WeatherCardSeverity.danger,
        );

        expect(card.type, WeatherCardType.airQuality);
        expect(card.severity, WeatherCardSeverity.danger);
        expect(card.title, 'Very Poor Air Quality');
        expect(card.message, contains('Very poor air quality!'));
        expect(card.message, contains('dangerous levels'));
        expect(card.iconCode, '🚨');
        expect(card.data['pm25'], 80.0);
        expect(card.data['pm10'], 160.0);
        expect(card.data['aqi'], 5);
        expect(card.data['cityName'], 'Delhi');
      });

      test('creates info air quality alert card correctly', () {
        final card = WeatherConditionCard.airQualityAlert(
          pm25: 20.0,
          pm10: 40.0,
          aqi: 2,
          cityName: 'Singapore',
          severity: WeatherCardSeverity.info,
        );

        expect(card.type, WeatherCardType.airQuality);
        expect(card.severity, WeatherCardSeverity.info);
        expect(card.title, 'Air Quality Advisory');
        expect(card.message, contains('Check air quality levels'));
        expect(card.iconCode, '💨');
        expect(card.data['pm25'], 20.0);
        expect(card.data['pm10'], 40.0);
        expect(card.data['aqi'], 2);
        expect(card.data['cityName'], 'Singapore');
      });
    });

    group('Strong Wind Factory Tests', () {
      test('creates strong wind card correctly', () {
        final card = WeatherConditionCard.strongWind(
          windSpeed: 15.5,
          cityName: 'Chicago',
          severity: WeatherCardSeverity.warning,
        );

        expect(card.type, WeatherCardType.strongWind);
        expect(card.severity, WeatherCardSeverity.warning);
        expect(card.title, 'Strong Wind Advisory');
        expect(card.message, contains('Strong wind advisory!'));
        expect(card.message, contains('15.5m/s'));
        expect(card.message, contains('Chicago'));
        expect(card.iconCode, '💨');
        expect(card.data['windSpeed'], 15.5);
        expect(card.data['cityName'], 'Chicago');
      });

      test('handles various wind speeds correctly', () {
        final card1 = WeatherConditionCard.strongWind(
          windSpeed: 9.0,
          cityName: 'Miami',
          severity: WeatherCardSeverity.warning,
        );

        final card2 = WeatherConditionCard.strongWind(
          windSpeed: 25.7,
          cityName: 'Houston',
          severity: WeatherCardSeverity.danger,
        );

        expect(card1.message, contains('9.0m/s'));
        expect(card2.message, contains('25.7m/s'));
      });
    });

    group('Car Wash Index Factory Tests', () {
      test('creates car wash index card correctly', () {
        final card = WeatherConditionCard.carWashIndex(
          precipitationProbability: 0.1,
          airQuality: 2,
        );

        expect(card.type, WeatherCardType.carWashIndex);
        expect(card.severity, WeatherCardSeverity.info);
        expect(card.title, 'Perfect Car Wash Day');
        expect(card.message, contains('Perfect day for car washing!'));
        expect(card.message, contains('No rain expected'));
        expect(card.iconCode, '🚗');
        expect(card.data['precipitationProbability'], 0.1);
        expect(card.data['airQuality'], 2);
      });

      test('handles different precipitation probabilities', () {
        final card1 = WeatherConditionCard.carWashIndex(
          precipitationProbability: 0.0,
          airQuality: 1,
        );

        final card2 = WeatherConditionCard.carWashIndex(
          precipitationProbability: 0.3,
          airQuality: 3,
        );

        expect(card1.data['precipitationProbability'], 0.0);
        expect(card2.data['precipitationProbability'], 0.3);
      });
    });

    group('Laundry Index Factory Tests', () {
      test('creates laundry index card correctly', () {
        final card = WeatherConditionCard.laundryIndex(
          precipitationProbability: 0.05,
          humidity: 45,
          windSpeed: 3.5,
        );

        expect(card.type, WeatherCardType.laundryIndex);
        expect(card.severity, WeatherCardSeverity.info);
        expect(card.title, 'Perfect Laundry Weather');
        expect(card.message, contains('Perfect laundry weather!'));
        expect(card.message, contains('Clear skies'));
        expect(card.iconCode, '👔');
        expect(card.data['precipitationProbability'], 0.05);
        expect(card.data['humidity'], 45);
        expect(card.data['windSpeed'], 3.5);
      });

      test('handles various weather conditions for laundry', () {
        final card1 = WeatherConditionCard.laundryIndex(
          precipitationProbability: 0.0,
          humidity: 30,
          windSpeed: 5.0,
        );

        final card2 = WeatherConditionCard.laundryIndex(
          precipitationProbability: 0.2,
          humidity: 80,
          windSpeed: 1.0,
        );

        expect(card1.data['humidity'], 30);
        expect(card2.data['humidity'], 80);
        expect(card1.data['windSpeed'], 5.0);
        expect(card2.data['windSpeed'], 1.0);
      });
    });
  });

  group('WeatherCardType Extension Tests', () {
    test('displayName returns correct values', () {
      expect(WeatherCardType.heatWave.displayName, 'Heat/Cold Wave');
      expect(WeatherCardType.coldWave.displayName, 'Cold Wave');
      expect(WeatherCardType.uvIndex.displayName, 'UV Index');
      expect(WeatherCardType.airQuality.displayName, 'Air Quality');
      expect(WeatherCardType.strongWind.displayName, 'Strong Wind/Typhoon');
      expect(WeatherCardType.typhoon.displayName, 'Typhoon');
      expect(WeatherCardType.carWashIndex.displayName, 'Car Wash Index');
      expect(WeatherCardType.laundryIndex.displayName, 'Laundry Index');
    });

    test('settingsKey returns correct values', () {
      expect(WeatherCardType.heatWave.settingsKey, 'heat_cold_alerts');
      expect(WeatherCardType.coldWave.settingsKey, 'heat_cold_alerts');
      expect(WeatherCardType.uvIndex.settingsKey, 'uv_alerts');
      expect(WeatherCardType.airQuality.settingsKey, 'air_quality_alerts');
      expect(WeatherCardType.strongWind.settingsKey, 'wind_alerts');
      expect(WeatherCardType.typhoon.settingsKey, 'wind_alerts');
      expect(WeatherCardType.carWashIndex.settingsKey, 'activity_indices');
      expect(WeatherCardType.laundryIndex.settingsKey, 'activity_indices');
    });

    test('all enum values have corresponding display names', () {
      for (final type in WeatherCardType.values) {
        expect(type.displayName, isNotEmpty);
        expect(type.settingsKey, isNotEmpty);
      }
    });
  });

  group('WeatherCardSeverity Extension Tests', () {
    test('colorHex returns correct values', () {
      expect(WeatherCardSeverity.info.colorHex, '#2196F3');
      expect(WeatherCardSeverity.warning.colorHex, '#FF9800');
      expect(WeatherCardSeverity.danger.colorHex, '#F44336');
    });

    test('all severity values have corresponding colors', () {
      for (final severity in WeatherCardSeverity.values) {
        expect(severity.colorHex, isNotEmpty);
        expect(severity.colorHex, startsWith('#'));
        expect(severity.colorHex.length, 7); // #RRGGBB format
      }
    });

    test('color hex values are valid hex colors', () {
      for (final severity in WeatherCardSeverity.values) {
        final colorHex = severity.colorHex;
        expect(RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(colorHex), true);
      }
    });
  });

  group('Edge Cases and Data Validation Tests', () {
    test('handles extreme temperature values', () {
      final heatCard = WeatherConditionCard.heatWave(
        temperature: 50.0,
        cityName: 'Death Valley',
        severity: WeatherCardSeverity.danger,
      );

      final coldCard = WeatherConditionCard.coldWave(
        temperature: -50.0,
        cityName: 'Antarctica',
        severity: WeatherCardSeverity.danger,
      );

      expect(heatCard.message, contains('50°C'));
      expect(coldCard.message, contains('-50°C'));
      expect(heatCard.data['temperature'], 50.0);
      expect(coldCard.data['temperature'], -50.0);
    });

    test('handles very high UV index values', () {
      final card = WeatherConditionCard.uvAlert(
        uvIndex: 15.0,
        severity: WeatherCardSeverity.danger,
      );

      expect(card.data['uvIndex'], 15.0);
      expect(card.severity, WeatherCardSeverity.danger);
    });

    test('handles extreme air quality values', () {
      final card = WeatherConditionCard.airQualityAlert(
        pm25: 999.0,
        pm10: 1500.0,
        aqi: 5,
        cityName: 'Hazardous City',
        severity: WeatherCardSeverity.danger,
      );

      expect(card.data['pm25'], 999.0);
      expect(card.data['pm10'], 1500.0);
      expect(card.data['aqi'], 5);
    });

    test('handles extreme wind speeds', () {
      final card = WeatherConditionCard.strongWind(
        windSpeed: 100.0,
        cityName: 'Hurricane Alley',
        severity: WeatherCardSeverity.danger,
      );

      expect(card.message, contains('100.0m/s'));
      expect(card.data['windSpeed'], 100.0);
    });

    test('handles city names with special characters', () {
      final card = WeatherConditionCard.heatWave(
        temperature: 35.0,
        cityName: 'São Paulo',
        severity: WeatherCardSeverity.warning,
      );

      expect(card.message, contains('São Paulo'));
      expect(card.data['cityName'], 'São Paulo');
    });

    test('handles very long city names', () {
      const longCityName = 'Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu';
      final card = WeatherConditionCard.coldWave(
        temperature: 5.0,
        cityName: longCityName,
        severity: WeatherCardSeverity.warning,
      );

      expect(card.message, contains(longCityName));
      expect(card.data['cityName'], longCityName);
    });

    test('handles zero and fractional values', () {
      final uvCard = WeatherConditionCard.uvAlert(
        uvIndex: 0.0,
        severity: WeatherCardSeverity.info,
      );

      final windCard = WeatherConditionCard.strongWind(
        windSpeed: 0.1,
        cityName: 'Calm City',
        severity: WeatherCardSeverity.warning,
      );

      expect(uvCard.data['uvIndex'], 0.0);
      expect(windCard.data['windSpeed'], 0.1);
      expect(windCard.message, contains('0.1m/s'));
    });
  });

  group('Enum Completeness Tests', () {
    test('WeatherCardType enum has expected number of values', () {
      expect(WeatherCardType.values.length, 8);
    });

    test('WeatherCardSeverity enum has expected number of values', () {
      expect(WeatherCardSeverity.values.length, 3);
    });

    test('all WeatherCardType values are covered in extensions', () {
      for (final type in WeatherCardType.values) {
        expect(() => type.displayName, returnsNormally);
        expect(() => type.settingsKey, returnsNormally);
      }
    });

    test('all WeatherCardSeverity values are covered in extensions', () {
      for (final severity in WeatherCardSeverity.values) {
        expect(() => severity.colorHex, returnsNormally);
      }
    });
  });

  group('Data Structure Tests', () {
    test('card data contains expected fields for each type', () {
      final heatCard = WeatherConditionCard.heatWave(
        temperature: 35.0,
        cityName: 'Test',
        severity: WeatherCardSeverity.warning,
      );
      expect(heatCard.data.keys, containsAll(['temperature', 'cityName']));

      final uvCard = WeatherConditionCard.uvAlert(
        uvIndex: 8.0,
        severity: WeatherCardSeverity.warning,
      );
      expect(uvCard.data.keys, contains('uvIndex'));

      final airCard = WeatherConditionCard.airQualityAlert(
        pm25: 50.0,
        pm10: 90.0,
        aqi: 4,
        cityName: 'Test',
        severity: WeatherCardSeverity.warning,
      );
      expect(airCard.data.keys, containsAll(['pm25', 'pm10', 'aqi', 'cityName']));

      final windCard = WeatherConditionCard.strongWind(
        windSpeed: 15.0,
        cityName: 'Test',
        severity: WeatherCardSeverity.warning,
      );
      expect(windCard.data.keys, containsAll(['windSpeed', 'cityName']));

      final carCard = WeatherConditionCard.carWashIndex(
        precipitationProbability: 0.1,
        airQuality: 2,
      );
      expect(carCard.data.keys, containsAll(['precipitationProbability', 'airQuality']));

      final laundryCard = WeatherConditionCard.laundryIndex(
        precipitationProbability: 0.1,
        humidity: 50,
        windSpeed: 3.0,
      );
      expect(laundryCard.data.keys, containsAll(['precipitationProbability', 'humidity', 'windSpeed']));
    });

    test('timestamp is properly set in all factory methods', () {
      final before = DateTime.now();
      
      final cards = [
        WeatherConditionCard.heatWave(temperature: 35.0, cityName: 'Test', severity: WeatherCardSeverity.warning),
        WeatherConditionCard.coldWave(temperature: -10.0, cityName: 'Test', severity: WeatherCardSeverity.warning),
        WeatherConditionCard.uvAlert(uvIndex: 8.0, severity: WeatherCardSeverity.warning),
        WeatherConditionCard.airQualityAlert(pm25: 50.0, pm10: 90.0, aqi: 4, cityName: 'Test', severity: WeatherCardSeverity.warning),
        WeatherConditionCard.strongWind(windSpeed: 15.0, cityName: 'Test', severity: WeatherCardSeverity.warning),
        WeatherConditionCard.carWashIndex(precipitationProbability: 0.1, airQuality: 2),
        WeatherConditionCard.laundryIndex(precipitationProbability: 0.1, humidity: 50, windSpeed: 3.0),
      ];
      
      final after = DateTime.now();

      for (final card in cards) {
        expect(card.timestamp.isAfter(before.subtract(Duration(seconds: 1))), true);
        expect(card.timestamp.isBefore(after.add(Duration(seconds: 1))), true);
      }
    });
  });
}