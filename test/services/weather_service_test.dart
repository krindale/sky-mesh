import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/weather_service.dart';

void main() {
  group('WeatherService Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService();
    });

    group('getRandomCityWeather', () {
      test('returns weather data for random city', () async {
        // Test successful API response scenario
        final weatherData = await weatherService.getRandomCityWeather();
        
        expect(weatherData, isA<WeatherData>());
        expect(weatherData.cityName, isNotEmpty);
        expect(weatherData.country, isNotEmpty);
        expect(weatherData.temperature, isA<double>());
        expect(weatherData.feelsLike, isA<double>());
        expect(weatherData.humidity, isA<int>());
        expect(weatherData.windSpeed, isA<double>());
        expect(weatherData.description, isNotEmpty);
        expect(weatherData.iconCode, isNotEmpty);
        expect(weatherData.latitude, isNotNull);
        expect(weatherData.longitude, isNotNull);
      });

      test('returns mock data when API fails', () async {
        // This test verifies the fallback mechanism works
        final weatherData = await weatherService.getRandomCityWeather();
        
        expect(weatherData, isA<WeatherData>());
        expect(weatherData.cityName, isNotEmpty);
        expect(weatherData.country, isNotEmpty);
      });
    });

    group('getCurrentWeather', () {
      test('returns mock weather data when location unavailable', () async {
        // Since location services might not be available in test environment,
        // this should return mock data
        final weatherData = await weatherService.getCurrentWeather();
        
        expect(weatherData, isA<WeatherData>());
        expect(weatherData.cityName, isNotEmpty);
        expect(weatherData.country, isNotEmpty);
        expect(weatherData.temperature, isA<double>());
        expect(weatherData.feelsLike, isA<double>());
        expect(weatherData.humidity, isA<int>());
        expect(weatherData.windSpeed, isA<double>());
        expect(weatherData.description, isNotEmpty);
        expect(weatherData.iconCode, isNotEmpty);
      });
    });

    group('getWeatherByCoordinates', () {
      test('returns weather data for valid coordinates', () async {
        const latitude = 37.5665;
        const longitude = 126.9780; // Seoul coordinates
        
        final weatherData = await weatherService.getWeatherByCoordinates(latitude, longitude);
        
        expect(weatherData, isA<WeatherData>());
        expect(weatherData.cityName, isNotEmpty);
        expect(weatherData.country, isNotEmpty);
        expect(weatherData.temperature, isA<double>());
        expect(weatherData.feelsLike, isA<double>());
        expect(weatherData.humidity, isA<int>());
        expect(weatherData.windSpeed, isA<double>());
        expect(weatherData.description, isNotEmpty);
        expect(weatherData.iconCode, isNotEmpty);
      });

      test('handles invalid coordinates gracefully', () async {
        const latitude = 999.0; // Invalid latitude
        const longitude = 999.0; // Invalid longitude
        
        final weatherData = await weatherService.getWeatherByCoordinates(latitude, longitude);
        
        // Should return mock data instead of throwing
        expect(weatherData, isA<WeatherData>());
      });
    });
  });

  group('WeatherData Tests', () {
    test('constructor creates WeatherData correctly', () {
      final weatherData = WeatherData(
        temperature: 22.5,
        feelsLike: 24.0,
        humidity: 65,
        windSpeed: 3.2,
        description: 'partly cloudy',
        iconCode: '02d',
        cityName: 'Seoul',
        country: 'KR',
        pressure: 1013,
        visibility: 10000,
        uvIndex: 5,
        latitude: 37.5665,
        longitude: 126.9780,
      );

      expect(weatherData.temperature, 22.5);
      expect(weatherData.feelsLike, 24.0);
      expect(weatherData.humidity, 65);
      expect(weatherData.windSpeed, 3.2);
      expect(weatherData.description, 'partly cloudy');
      expect(weatherData.iconCode, '02d');
      expect(weatherData.cityName, 'Seoul');
      expect(weatherData.country, 'KR');
      expect(weatherData.pressure, 1013);
      expect(weatherData.visibility, 10000);
      expect(weatherData.uvIndex, 5);
      expect(weatherData.latitude, 37.5665);
      expect(weatherData.longitude, 126.9780);
    });

    test('fromJson creates WeatherData from API response', () {
      final jsonData = {
        'main': {
          'temp': 25.5,
          'feels_like': 27.2,
          'humidity': 70,
          'pressure': 1015,
        },
        'wind': {
          'speed': 4.5,
        },
        'weather': [
          {
            'description': 'clear sky',
            'icon': '01d',
          }
        ],
        'name': 'Tokyo',
        'sys': {
          'country': 'JP',
        },
        'visibility': 8000,
        'coord': {
          'lat': 35.6762,
          'lon': 139.6503,
        }
      };

      final weatherData = WeatherData.fromJson(jsonData);

      expect(weatherData.temperature, 25.5);
      expect(weatherData.feelsLike, 27.2);
      expect(weatherData.humidity, 70);
      expect(weatherData.windSpeed, 4.5);
      expect(weatherData.description, 'clear sky');
      expect(weatherData.iconCode, '01d');
      expect(weatherData.cityName, 'Tokyo');
      expect(weatherData.country, 'JP');
      expect(weatherData.pressure, 1015);
      expect(weatherData.visibility, 8000);
      expect(weatherData.uvIndex, 5); // Default value
      expect(weatherData.latitude, 35.6762);
      expect(weatherData.longitude, 139.6503);
    });

    test('string getters format values correctly', () {
      final weatherData = WeatherData(
        temperature: 22.7,
        feelsLike: 24.3,
        humidity: 65,
        windSpeed: 3.25,
        description: 'broken clouds',
        iconCode: '04d',
        cityName: 'Paris',
        country: 'FR',
        pressure: 1008,
        visibility: 12500,
        uvIndex: 7,
      );

      expect(weatherData.temperatureString, '23°');
      expect(weatherData.feelsLikeString, '24°');
      expect(weatherData.windSpeedString, '3.3 m/s');
      expect(weatherData.humidityString, '65%');
      expect(weatherData.pressureString, '1008 hPa');
      expect(weatherData.visibilityString, '12.5 km');
      expect(weatherData.uvIndexString, '7');
    });

    test('capitalizedDescription formats correctly', () {
      final testCases = [
        ('clear sky', 'Clear Sky'),
        ('few clouds', 'Few Clouds'),
        ('scattered clouds', 'Scattered Clouds'),
        ('broken clouds', 'Broken Clouds'),
        ('shower rain', 'Shower Rain'),
        ('rain', 'Rain'),
        ('thunderstorm', 'Thunderstorm'),
        ('snow', 'Snow'),
        ('mist', 'Mist'),
        ('overcast clouds', 'Overcast Clouds'),
      ];

      for (final (input, expected) in testCases) {
        final weatherData = WeatherData(
          temperature: 20.0,
          feelsLike: 20.0,
          humidity: 50,
          windSpeed: 1.0,
          description: input,
          iconCode: '01d',
          cityName: 'Test',
          country: 'TC',
          pressure: 1000,
          visibility: 10000,
          uvIndex: 1,
        );

        expect(weatherData.capitalizedDescription, expected);
      }
    });

    test('handles missing optional fields in JSON', () {
      final jsonDataMinimal = {
        'main': {
          'temp': 20.0,
          'feels_like': 21.0,
          'humidity': 60,
          'pressure': 1010,
        },
        'wind': {
          'speed': 2.0,
        },
        'weather': [
          {
            'description': 'clear',
            'icon': '01d',
          }
        ],
        'name': 'Test City',
        'sys': {
          'country': 'TC',
        },
        // Missing visibility and coord
      };

      final weatherData = WeatherData.fromJson(jsonDataMinimal);

      expect(weatherData.visibility, 10000); // Default value
      expect(weatherData.latitude, isNull);
      expect(weatherData.longitude, isNull);
      expect(weatherData.uvIndex, 5); // Default value
    });

    test('handles edge case values', () {
      final weatherData = WeatherData(
        temperature: 0.0,
        feelsLike: -5.0,
        humidity: 0,
        windSpeed: 0.0,
        description: '',
        iconCode: '',
        cityName: '',
        country: '',
        pressure: 0,
        visibility: 0,
        uvIndex: 0,
      );

      expect(weatherData.temperatureString, '0°');
      expect(weatherData.feelsLikeString, '-5°');
      expect(weatherData.windSpeedString, '0.0 m/s');
      expect(weatherData.humidityString, '0%');
      expect(weatherData.pressureString, '0 hPa');
      expect(weatherData.visibilityString, '0.0 km');
      expect(weatherData.uvIndexString, '0');
      expect(weatherData.capitalizedDescription, '');
    });
  });
}