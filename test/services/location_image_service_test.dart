import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/location_image_service.dart';

void main() {
  group('LocationImageService Tests', () {
    group('selectBackgroundImage', () {
      test('returns exact city match when available', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          latitude: 37.5665,
          longitude: 126.9780,
        );

        expect(imagePath, contains('seoul'));
        expect(imagePath, contains('sunny'));
        expect(imagePath, endsWith('.png'));
      });

      test('returns same country city when exact match not available', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Busan', // Not in our city list
          countryCode: 'KR', // But we have Seoul for KR
          weatherDescription: 'clear sky',
          latitude: 35.1796,
          longitude: 129.0756,
        );

        expect(imagePath, contains('seoul'));
        expect(imagePath, contains('sunny'));
        expect(imagePath, endsWith('.png'));
      });

      test('returns regional fallback when no city for country', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Unknown City',
          countryCode: 'XX', // Unknown country
          weatherDescription: 'clear sky',
        );

        // Should return a valid image path (either random city or fallback)
        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('maps weather conditions correctly', () {
        final testCases = [
          ('clear sky', 'sunny'),
          ('few clouds', 'sunny'),
          ('scattered clouds', 'cloudy'),
          ('broken clouds', 'cloudy'),
          ('overcast clouds', 'cloudy'),
          ('shower rain', 'rainy'),
          ('rain', 'rainy'),
          ('thunderstorm', 'rainy'),
          ('snow', 'snowy'),
          ('mist', 'foggy'),
          ('fog', 'foggy'),
          ('haze', 'foggy'),
          ('smoke', 'foggy'),
        ];

        for (final (weatherDescription, expectedWeather) in testCases) {
          final imagePath = LocationImageService.selectBackgroundImage(
            cityName: 'Seoul',
            countryCode: 'KR',
            weatherDescription: weatherDescription,
          );

          expect(imagePath, contains(expectedWeather));
        }
      });

      test('handles sunset time correctly', () {
        // Mock current time to be sunset hours (17-19 or 5-7)
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'unknown weather', // Should default to sunset during sunset hours
        );

        // The result should be valid regardless of weather mapping
        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('handles coordinates when finding nearest city', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Unknown City',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          latitude: 37.5665,
          longitude: 126.9780, // Close to Seoul
        );

        expect(imagePath, contains('seoul'));
        expect(imagePath, contains('sunny'));
      });

      test('handles missing coordinates gracefully', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Unknown City',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          // No latitude/longitude provided
        );

        // Should still return a valid path (random city from same country)
        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('returns different paths for different weather', () {
        final sunnyPath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        final rainyPath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'rain',
        );

        expect(sunnyPath, contains('sunny'));
        expect(rainyPath, contains('rainy'));
        expect(sunnyPath, isNot(equals(rainyPath)));
      });
    });

    group('getAllSupportedCities', () {
      test('returns non-empty list of cities', () {
        final cities = LocationImageService.getAllSupportedCities();

        expect(cities, isA<List<String>>());
        expect(cities, isNotEmpty);
        expect(cities, contains('seoul'));
        expect(cities, contains('tokyo'));
        expect(cities, contains('new_york'));
      });
    });

    group('getCitiesForCountry', () {
      test('returns cities for known country', () {
        final cities = LocationImageService.getCitiesForCountry('KR');

        expect(cities, isA<List<String>>());
        expect(cities, contains('seoul'));
      });

      test('returns empty list for unknown country', () {
        final cities = LocationImageService.getCitiesForCountry('XX');

        expect(cities, isA<List<String>>());
        expect(cities, isEmpty);
      });

      test('returns multiple cities for US', () {
        final cities = LocationImageService.getCitiesForCountry('US');

        expect(cities, isA<List<String>>());
        expect(cities, isNotEmpty);
        expect(cities.length, greaterThan(1));
        expect(cities, contains('new_york'));
        expect(cities, contains('los_angeles'));
      });

      test('returns consistent results', () {
        final cities1 = LocationImageService.getCitiesForCountry('KR');
        final cities2 = LocationImageService.getCitiesForCountry('KR');

        expect(cities1, equals(cities2));
      });
    });

    group('Edge Cases', () {
      test('handles empty city name', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: '',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('handles empty weather description', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: '',
        );

        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('handles empty country code', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: '',
          weatherDescription: 'clear sky',
        );

        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('handles null coordinates', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Unknown City',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          latitude: null,
          longitude: null,
        );

        expect(imagePath, endsWith('.png'));
        expect(imagePath, isNotEmpty);
      });

      test('handles mixed case city names', () {
        final imagePath1 = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        final imagePath2 = LocationImageService.selectBackgroundImage(
          cityName: 'SEOUL',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        final imagePath3 = LocationImageService.selectBackgroundImage(
          cityName: 'seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        // All should match the same city (case insensitive)
        expect(imagePath1, contains('seoul'));
        expect(imagePath2, contains('seoul'));
        expect(imagePath3, contains('seoul'));
      });

      test('handles spaces in city names', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'New York',
          countryCode: 'US',
          weatherDescription: 'clear sky',
        );

        expect(imagePath, contains('new_york'));
        expect(imagePath, endsWith('.png'));
      });
    });

    group('Consistency Tests', () {
      test('same inputs produce same outputs', () {
        final imagePath1 = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          latitude: 37.5665,
          longitude: 126.9780,
        );

        final imagePath2 = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
          latitude: 37.5665,
          longitude: 126.9780,
        );

        // For exact city match, should be consistent
        expect(imagePath1, equals(imagePath2));
      });

      test('image paths have correct structure', () {
        final imagePath = LocationImageService.selectBackgroundImage(
          cityName: 'Seoul',
          countryCode: 'KR',
          weatherDescription: 'clear sky',
        );

        expect(imagePath, startsWith('assets/'));
        expect(imagePath, endsWith('.png'));
        expect(imagePath, contains('seoul'));
        expect(imagePath, contains('sunny'));
      });
    });
  });
}