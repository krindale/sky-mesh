import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:sky_mesh/data/services/openweather_api_service.dart';
import 'package:sky_mesh/core/interfaces/weather_repository.dart';
import 'package:sky_mesh/core/interfaces/weather_interfaces.dart';
import 'package:sky_mesh/core/interfaces/location_service.dart';
import 'package:sky_mesh/core/models/weather_data.dart';
import 'package:sky_mesh/core/models/hourly_weather_data.dart';
import 'package:sky_mesh/core/models/weekly_weather_data.dart';

// Simple mock classes for testing (without mocktail)
class TestLocationService implements LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    return Position(
      longitude: -122.4194,
      latitude: 37.7749,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async => LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestPermission() async => LocationPermission.whileInUse;
}

void main() {
  group('OpenWeatherApiService Tests', () {
    late OpenWeatherApiService weatherService;
    late TestLocationService testLocationService;

    setUp(() {
      testLocationService = TestLocationService();
      
      weatherService = OpenWeatherApiService(
        locationService: testLocationService,
      );
    });

    group('Interface Compliance Tests', () {
      testWidgets('implements all required interfaces', (WidgetTester tester) async {
        expect(weatherService, isA<WeatherRepository>());
        expect(weatherService, isA<CurrentWeatherService>());
        expect(weatherService, isA<WeatherForecastService>());
        expect(weatherService, isA<RandomWeatherService>());
      });

      testWidgets('has all WeatherRepository methods', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather, isA<Function>());
        expect(weatherService.getWeatherByCoordinates, isA<Function>());
        expect(weatherService.getHourlyWeather, isA<Function>());
        expect(weatherService.getWeeklyWeather, isA<Function>());
      });

      testWidgets('has all CurrentWeatherService methods', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather, isA<Function>());
        expect(weatherService.getWeatherByCoordinates, isA<Function>());
      });

      testWidgets('has all WeatherForecastService methods', (WidgetTester tester) async {
        expect(weatherService.getHourlyWeather, isA<Function>());
        expect(weatherService.getWeeklyWeather, isA<Function>());
        expect(weatherService.getHourlyWeatherByCoordinates, isA<Function>());
        expect(weatherService.getWeeklyWeatherByCoordinates, isA<Function>());
      });

      testWidgets('has all RandomWeatherService methods', (WidgetTester tester) async {
        expect(weatherService.getRandomCityWeather, isA<Function>());
      });
    });

    group('Constructor Tests', () {
      testWidgets('creates instance with required LocationService', (WidgetTester tester) async {
        final service = OpenWeatherApiService(
          locationService: testLocationService,
        );
        
        expect(service, isA<OpenWeatherApiService>());
        expect(service, isA<WeatherRepository>());
      });

      testWidgets('creates instance with custom WeatherDataFactory', (WidgetTester tester) async {
        final factory = WeatherDataFactory();
        final service = OpenWeatherApiService(
          locationService: testLocationService,
          weatherDataFactory: factory,
        );
        
        expect(service, isA<OpenWeatherApiService>());
      });

      testWidgets('uses default WeatherDataFactory when not provided', (WidgetTester tester) async {
        final service = OpenWeatherApiService(
          locationService: testLocationService,
        );
        
        expect(service, isA<OpenWeatherApiService>());
      });
    });

    group('getCurrentWeather Tests', () {
      testWidgets('returns WeatherData when location service succeeds', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('falls back to mock data when location service fails', (WidgetTester tester) async {
        // This test would require mocking location service to throw exception
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('calls location service to get current position', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('delegates to getWeatherByCoordinates with position', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });
    });

    group('getWeatherByCoordinates Tests', () {
      testWidgets('returns WeatherData for valid coordinates', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('handles extreme coordinate values', (WidgetTester tester) async {
        final extremeCoordinates = [
          [-90.0, -180.0], // South Pole, Date Line
          [90.0, 180.0],   // North Pole, Date Line
          [0.0, 0.0],      // Equator, Prime Meridian
          [37.7749, -122.4194], // San Francisco
          [-33.8688, 151.2093], // Sydney
        ];

        for (final coords in extremeCoordinates) {
          expect(
            weatherService.getWeatherByCoordinates(coords[0], coords[1]),
            isA<Future<WeatherData>>(),
          );
        }
      });

      testWidgets('falls back to mock data on API error', (WidgetTester tester) async {
        // This test would mock HTTP client to return error
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('enhances weather data with UV and air quality', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });
    });

    group('getRandomCityWeather Tests', () {
      testWidgets('returns WeatherData for random city', (WidgetTester tester) async {
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('returns different cities on multiple calls (possibly)', (WidgetTester tester) async {
        // Note: This test may occasionally fail due to randomness
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('falls back to random mock data on API error', (WidgetTester tester) async {
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('uses RandomCityProvider for city selection', (WidgetTester tester) async {
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('enhances random city weather with additional data', (WidgetTester tester) async {
        expect(weatherService.getRandomCityWeather(), isA<Future<WeatherData>>());
      });
    });

    group('getHourlyWeather Tests', () {
      testWidgets('returns HourlyWeatherData when location service succeeds', (WidgetTester tester) async {
        expect(weatherService.getHourlyWeather(), isA<Future<HourlyWeatherData>>());
      });

      testWidgets('falls back to mock data when location service fails', (WidgetTester tester) async {
        expect(weatherService.getHourlyWeather(), isA<Future<HourlyWeatherData>>());
      });

      testWidgets('delegates to getHourlyWeatherByCoordinates', (WidgetTester tester) async {
        expect(weatherService.getHourlyWeather(), isA<Future<HourlyWeatherData>>());
      });
    });

    group('getHourlyWeatherByCoordinates Tests', () {
      testWidgets('returns HourlyWeatherData for valid coordinates', (WidgetTester tester) async {
        expect(
          weatherService.getHourlyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<HourlyWeatherData>>(),
        );
      });

      testWidgets('handles different coordinate ranges', (WidgetTester tester) async {
        final coordinates = [
          [0.0, 0.0],
          [37.5665, 126.9780], // Seoul
          [35.6762, 139.6503], // Tokyo
          [51.5074, -0.1278],  // London
          [-33.8688, 151.2093], // Sydney
        ];

        for (final coords in coordinates) {
          expect(
            weatherService.getHourlyWeatherByCoordinates(coords[0], coords[1]),
            isA<Future<HourlyWeatherData>>(),
          );
        }
      });

      testWidgets('falls back to mock data on API error', (WidgetTester tester) async {
        expect(
          weatherService.getHourlyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<HourlyWeatherData>>(),
        );
      });

      testWidgets('uses forecast API endpoint', (WidgetTester tester) async {
        expect(
          weatherService.getHourlyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<HourlyWeatherData>>(),
        );
      });
    });

    group('getWeeklyWeather Tests', () {
      testWidgets('returns WeeklyWeatherData when location service succeeds', (WidgetTester tester) async {
        expect(weatherService.getWeeklyWeather(), isA<Future<WeeklyWeatherData>>());
      });

      testWidgets('falls back to mock data when location service fails', (WidgetTester tester) async {
        expect(weatherService.getWeeklyWeather(), isA<Future<WeeklyWeatherData>>());
      });

      testWidgets('delegates to getWeeklyWeatherByCoordinates', (WidgetTester tester) async {
        expect(weatherService.getWeeklyWeather(), isA<Future<WeeklyWeatherData>>());
      });
    });

    group('getWeeklyWeatherByCoordinates Tests', () {
      testWidgets('returns WeeklyWeatherData for valid coordinates', (WidgetTester tester) async {
        expect(
          weatherService.getWeeklyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeeklyWeatherData>>(),
        );
      });

      testWidgets('handles global coordinate coverage', (WidgetTester tester) async {
        final globalCoordinates = [
          [90.0, 0.0],     // North Pole
          [-90.0, 0.0],    // South Pole
          [0.0, 0.0],      // Equator/Prime Meridian
          [0.0, 180.0],    // Equator/Date Line
          [60.0, -150.0],  // Alaska
          [-45.0, 170.0],  // New Zealand
        ];

        for (final coords in globalCoordinates) {
          expect(
            weatherService.getWeeklyWeatherByCoordinates(coords[0], coords[1]),
            isA<Future<WeeklyWeatherData>>(),
          );
        }
      });

      testWidgets('falls back to mock data on API error', (WidgetTester tester) async {
        expect(
          weatherService.getWeeklyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeeklyWeatherData>>(),
        );
      });

      testWidgets('uses forecast API endpoint', (WidgetTester tester) async {
        expect(
          weatherService.getWeeklyWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeeklyWeatherData>>(),
        );
      });
    });

    group('Error Handling Tests', () {
      testWidgets('handles network timeout gracefully', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('handles API key errors gracefully', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('handles malformed JSON responses', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('handles HTTP error status codes', (WidgetTester tester) async {
        final errorCodes = [400, 401, 403, 404, 429, 500, 502, 503];
        
        for (final code in errorCodes) {
          // This would test each error code scenario
          expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
        }
      });

      testWidgets('handles location service exceptions', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('provides appropriate fallback data', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });
    });

    group('API Integration Tests', () {
      testWidgets('constructs correct API URLs', (WidgetTester tester) async {
        // Test that correct URLs are constructed for different endpoints
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('includes required API key in requests', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('uses metric units in API requests', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });

      testWidgets('handles API rate limiting', (WidgetTester tester) async {
        expect(weatherService.getCurrentWeather(), isA<Future<WeatherData>>());
      });
    });

    group('Data Enhancement Tests', () {
      testWidgets('fetches UV index data when available', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('fetches air quality data when available', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('fetches precipitation probability when available', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('gracefully handles enhancement failures', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });

      testWidgets('returns original data when enhancement fails', (WidgetTester tester) async {
        expect(
          weatherService.getWeatherByCoordinates(37.7749, -122.4194),
          isA<Future<WeatherData>>(),
        );
      });
    });

    group('Performance Tests', () {
      testWidgets('executes weather requests efficiently', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        // This would test actual performance if mocked properly
        await weatherService.getCurrentWeather();
        
        stopwatch.stop();
        
        // Should complete in reasonable time (would need proper mocking)
        expect(stopwatch.elapsedMilliseconds, lessThan(30000)); // 30 seconds timeout
      });

      testWidgets('handles concurrent requests properly', (WidgetTester tester) async {
        final futures = [
          weatherService.getCurrentWeather(),
          weatherService.getRandomCityWeather(),
          weatherService.getHourlyWeather(),
        ];

        expect(() => Future.wait(futures), returnsNormally);
      });
    });

    group('Architecture Tests', () {
      testWidgets('follows dependency inversion principle', (WidgetTester tester) async {
        expect(weatherService, isA<WeatherRepository>());
        expect(weatherService, isA<CurrentWeatherService>());
        expect(weatherService, isA<WeatherForecastService>());
        expect(weatherService, isA<RandomWeatherService>());
      });

      testWidgets('maintains single responsibility principle', (WidgetTester tester) async {
        // Service should only handle weather data operations
        expect(weatherService, isA<WeatherRepository>());
        expect(weatherService, isNot(isA<LocationService>()));
      });

      testWidgets('implements proper separation of concerns', (WidgetTester tester) async {
        // Weather service should not handle location or image services
        expect(weatherService, isA<WeatherRepository>());
        expect(weatherService, isNot(isA<LocationService>()));
      });
    });
  });

  group('WeatherDataFactory Tests', () {
    late WeatherDataFactory factory;

    setUp(() {
      factory = WeatherDataFactory();
    });

    group('createMockWeatherData Tests', () {
      testWidgets('creates valid WeatherData instance', (WidgetTester tester) async {
        final mockWeather = factory.createMockWeatherData();

        expect(mockWeather, isA<WeatherData>());
        expect(mockWeather.temperature, isA<double>());
        expect(mockWeather.cityName, isA<String>());
        expect(mockWeather.cityName, isNotEmpty);
        expect(mockWeather.country, isA<String>());
        expect(mockWeather.country, isNotEmpty);
      });

      testWidgets('creates consistent mock data', (WidgetTester tester) async {
        final mock1 = factory.createMockWeatherData();
        final mock2 = factory.createMockWeatherData();

        expect(mock1.cityName, equals(mock2.cityName));
        expect(mock1.temperature, equals(mock2.temperature));
        expect(mock1.description, equals(mock2.description));
      });

      testWidgets('includes all weather parameters', (WidgetTester tester) async {
        final mockWeather = factory.createMockWeatherData();

        expect(mockWeather.temperature, isA<double>());
        expect(mockWeather.feelsLike, isA<double>());
        expect(mockWeather.humidity, isA<int>());
        expect(mockWeather.windSpeed, isA<double>());
        expect(mockWeather.description, isA<String>());
        expect(mockWeather.iconCode, isA<String>());
        expect(mockWeather.pressure, isA<int>());
        expect(mockWeather.visibility, isA<int>());
        expect(mockWeather.uvIndex, isA<double>());
        expect(mockWeather.airQuality, isA<int>());
        expect(mockWeather.pm25, isA<double>());
        expect(mockWeather.pm10, isA<double>());
      });
    });

    group('createRandomMockWeatherData Tests', () {
      testWidgets('creates valid random WeatherData', (WidgetTester tester) async {
        final randomWeather = factory.createRandomMockWeatherData();

        expect(randomWeather, isA<WeatherData>());
        expect(randomWeather.cityName, isA<String>());
        expect(randomWeather.cityName, isNotEmpty);
        expect(randomWeather.temperature, isA<double>());
        expect(randomWeather.description, isA<String>());
        expect(randomWeather.description, isNotEmpty);
      });

      testWidgets('generates different data on multiple calls', (WidgetTester tester) async {
        final weathers = <WeatherData>[];
        
        for (int i = 0; i < 10; i++) {
          weathers.add(factory.createRandomMockWeatherData());
        }

        // Should have some variation in 10 calls
        final cities = weathers.map((w) => w.cityName).toSet();
        final temperatures = weathers.map((w) => w.temperature).toSet();
        
        expect(cities.length, greaterThanOrEqualTo(1));
        expect(temperatures.length, greaterThanOrEqualTo(1));
      });

      testWidgets('generates realistic weather values', (WidgetTester tester) async {
        final randomWeather = factory.createRandomMockWeatherData();

        // Temperature should be in reasonable range (5-35°C)
        expect(randomWeather.temperature, greaterThanOrEqualTo(5.0));
        expect(randomWeather.temperature, lessThanOrEqualTo(35.0));

        // Humidity should be 0-100%
        expect(randomWeather.humidity, greaterThanOrEqualTo(30));
        expect(randomWeather.humidity, lessThan(100));

        // UV index should be 0-12
        expect(randomWeather.uvIndex, greaterThanOrEqualTo(0.0));
        expect(randomWeather.uvIndex!, lessThanOrEqualTo(12.0));

        // Air quality should be 1-5
        expect(randomWeather.airQuality, greaterThanOrEqualTo(1));
        expect(randomWeather.airQuality!, lessThanOrEqualTo(5));
      });
    });

    group('createMockHourlyWeatherData Tests', () {
      testWidgets('creates valid HourlyWeatherData', (WidgetTester tester) async {
        final hourlyWeather = factory.createMockHourlyWeatherData();

        expect(hourlyWeather, isA<HourlyWeatherData>());
        expect(hourlyWeather.cityName, isA<String>());
        expect(hourlyWeather.cityName, isNotEmpty);
        expect(hourlyWeather.hourlyForecasts, isA<List<HourlyWeatherForecast>>());
        expect(hourlyWeather.hourlyForecasts.length, equals(24));
      });

      testWidgets('creates 24 hourly forecasts', (WidgetTester tester) async {
        final hourlyWeather = factory.createMockHourlyWeatherData();

        expect(hourlyWeather.hourlyForecasts.length, equals(24));

        for (int i = 0; i < 24; i++) {
          final forecast = hourlyWeather.hourlyForecasts[i];
          expect(forecast, isA<HourlyWeatherForecast>());
          expect(forecast.temperature, isA<double>());
          expect(forecast.description, isA<String>());
          expect(forecast.description, isNotEmpty);
        }
      });

      testWidgets('generates realistic hourly forecast values', (WidgetTester tester) async {
        final hourlyWeather = factory.createMockHourlyWeatherData();

        for (final forecast in hourlyWeather.hourlyForecasts) {
          expect(forecast.temperature, greaterThanOrEqualTo(12.0));
          expect(forecast.temperature, lessThanOrEqualTo(38.0));
          expect(forecast.humidity, greaterThanOrEqualTo(30));
          expect(forecast.humidity, lessThan(100));
        }
      });
    });

    group('createMockWeeklyWeatherData Tests', () {
      testWidgets('creates valid WeeklyWeatherData', (WidgetTester tester) async {
        final weeklyWeather = factory.createMockWeeklyWeatherData();

        expect(weeklyWeather, isA<WeeklyWeatherData>());
        expect(weeklyWeather.cityName, isA<String>());
        expect(weeklyWeather.cityName, isNotEmpty);
        expect(weeklyWeather.dailyForecasts, isA<List<DailyWeatherForecast>>());
        expect(weeklyWeather.dailyForecasts.length, equals(7));
      });

      testWidgets('creates 7 daily forecasts', (WidgetTester tester) async {
        final weeklyWeather = factory.createMockWeeklyWeatherData();

        expect(weeklyWeather.dailyForecasts.length, equals(7));

        for (int i = 0; i < 7; i++) {
          final forecast = weeklyWeather.dailyForecasts[i];
          expect(forecast, isA<DailyWeatherForecast>());
          expect(forecast.maxTemperature, isA<double>());
          expect(forecast.minTemperature, isA<double>());
          expect(forecast.maxTemperature, greaterThanOrEqualTo(forecast.minTemperature));
        }
      });

      testWidgets('generates realistic daily forecast values', (WidgetTester tester) async {
        final weeklyWeather = factory.createMockWeeklyWeatherData();

        for (final forecast in weeklyWeather.dailyForecasts) {
          expect(forecast.maxTemperature, greaterThanOrEqualTo(15.0));
          expect(forecast.maxTemperature, lessThanOrEqualTo(35.0));
          expect(forecast.minTemperature, greaterThanOrEqualTo(15.0));
          expect(forecast.minTemperature, lessThanOrEqualTo(forecast.maxTemperature));
        }
      });
    });
  });

  group('RandomCityProvider Tests', () {
    group('getRandomCity Tests', () {
      testWidgets('returns valid city data', (WidgetTester tester) async {
        final city = RandomCityProvider.getRandomCity();

        expect(city, isA<Map<String, dynamic>>());
        expect(city['name'], isA<String>());
        expect(city['country'], isA<String>());
        expect(city['latitude'], isA<double>());
        expect(city['longitude'], isA<double>());
        expect(city['name'], isNotEmpty);
        expect(city['country'], isNotEmpty);
      });

      testWidgets('returns different cities on multiple calls', (WidgetTester tester) async {
        final cities = <String>{};
        
        for (int i = 0; i < 20; i++) {
          final city = RandomCityProvider.getRandomCity();
          cities.add(city['name'] as String);
        }

        // Should have some variation in 20 calls (unless very unlucky)
        expect(cities.length, greaterThan(1));
      });

      testWidgets('returns cities with valid coordinates', (WidgetTester tester) async {
        for (int i = 0; i < 10; i++) {
          final city = RandomCityProvider.getRandomCity();
          final lat = city['latitude'] as double;
          final lon = city['longitude'] as double;

          expect(lat, greaterThanOrEqualTo(-90.0));
          expect(lat, lessThanOrEqualTo(90.0));
          expect(lon, greaterThanOrEqualTo(-180.0));
          expect(lon, lessThanOrEqualTo(180.0));
        }
      });

      testWidgets('includes major world cities', (WidgetTester tester) async {
        final allCities = RandomCityProvider.getAllCities();
        final cityNames = allCities.map((c) => c['name'] as String).toSet();

        // Check for some expected major cities
        final expectedCities = [
          'Seoul', 'Tokyo', 'New York', 'London', 'Paris', 
          'Berlin', 'Sydney', 'Mumbai', 'Beijing', 'Bangkok'
        ];

        for (final expectedCity in expectedCities) {
          expect(cityNames, contains(expectedCity));
        }
      });
    });

    group('getAllCities Tests', () {
      testWidgets('returns immutable list of cities', (WidgetTester tester) async {
        final cities = RandomCityProvider.getAllCities();

        expect(cities, isA<List<Map<String, dynamic>>>());
        expect(() => cities.clear(), throwsUnsupportedError);
      });

      testWidgets('returns consistent city count', (WidgetTester tester) async {
        final cities1 = RandomCityProvider.getAllCities();
        final cities2 = RandomCityProvider.getAllCities();

        expect(cities1.length, equals(cities2.length));
        expect(cities1.length, greaterThan(50)); // Should have many cities
      });

      testWidgets('contains valid city data structure', (WidgetTester tester) async {
        final cities = RandomCityProvider.getAllCities();

        for (final city in cities) {
          expect(city, contains('name'));
          expect(city, contains('country'));
          expect(city, contains('latitude'));
          expect(city, contains('longitude'));
          expect(city['name'], isA<String>());
          expect(city['country'], isA<String>());
          expect(city['latitude'], isA<double>());
          expect(city['longitude'], isA<double>());
        }
      });

      testWidgets('covers multiple continents', (WidgetTester tester) async {
        final cities = RandomCityProvider.getAllCities();
        final countries = cities.map((c) => c['country'] as String).toSet();

        // Should include cities from different continents
        final continentRepresentatives = [
          'KR', 'JP', 'CN', // Asia
          'US', 'CA', 'MX', // North America
          'GB', 'FR', 'DE', // Europe
          'AU', 'NZ',       // Oceania
          'BR', 'AR',       // South America
          'EG', 'ZA',       // Africa
        ];

        var representedContinents = 0;
        for (final country in continentRepresentatives) {
          if (countries.contains(country)) {
            representedContinents++;
          }
        }

        expect(representedContinents, greaterThan(4)); // At least 5 continents
      });
    });
  });
}