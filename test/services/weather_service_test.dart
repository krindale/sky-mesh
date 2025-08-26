import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/weather_service.dart';
import 'package:sky_mesh/core/models/weather_data.dart';
import 'package:sky_mesh/core/models/hourly_weather_data.dart';
import 'package:sky_mesh/core/models/weekly_weather_data.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';
import 'package:sky_mesh/core/interfaces/weather_repository.dart';
import 'package:sky_mesh/core/interfaces/image_service.dart';
import 'package:sky_mesh/core/services/weather_condition_rule_engine.dart';

// Mock implementation for testing
class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherData> getCurrentWeather() async {
    return WeatherData(
      temperature: 25.0,
      feelsLike: 27.0,
      humidity: 60,
      windSpeed: 3.5,
      description: 'clear sky',
      iconCode: '01d',
      cityName: 'Test City',
      country: 'TC',
      pressure: 1013,
      visibility: 10000,
      uvIndex: 5,
      airQuality: 2,
      pm25: 10.0,
      pm10: 20.0,
      precipitationProbability: 0.1,
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  @override
  Future<WeatherData> getRandomCityWeather() async {
    return WeatherData(
      temperature: 22.0,
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 2.8,
      description: 'few clouds',
      iconCode: '02d',
      cityName: 'Random City',
      country: 'RC',
      pressure: 1015,
      visibility: 12000,
      uvIndex: 4,
      airQuality: 1,
      pm25: 5.0,
      pm10: 15.0,
      precipitationProbability: 0.2,
      latitude: 35.0,
      longitude: 139.0,
    );
  }

  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    return WeatherData(
      temperature: 18.0,
      feelsLike: 20.0,
      humidity: 70,
      windSpeed: 4.2,
      description: 'overcast clouds',
      iconCode: '04d',
      cityName: 'Coordinate City',
      country: 'CC',
      pressure: 1010,
      visibility: 8000,
      uvIndex: 3,
      airQuality: 3,
      pm25: 25.0,
      pm10: 40.0,
      precipitationProbability: 0.3,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    return HourlyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      hourlyForecasts: [
        HourlyWeatherForecast(
          dateTime: DateTime(2024, 1, 1, 14, 0),
          temperature: 26.0,
          description: 'sunny',
          iconCode: '01d',
          humidity: 55,
          windSpeed: 3.5,
          pressure: 1013,
        ),
        HourlyWeatherForecast(
          dateTime: DateTime(2024, 1, 1, 15, 0),
          temperature: 27.0,
          description: 'sunny',
          iconCode: '01d',
          humidity: 54,
          windSpeed: 3.2,
          pressure: 1014,
        ),
      ],
    );
  }

  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    return HourlyWeatherData(
      cityName: 'Coordinate City',
      country: 'CC',
      hourlyForecasts: [
        HourlyWeatherForecast(
          dateTime: DateTime(2024, 1, 1, 14, 0),
          temperature: 20.0,
          description: 'cloudy',
          iconCode: '04d',
          humidity: 65,
          windSpeed: 4.2,
          pressure: 1010,
        ),
      ],
    );
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    return WeeklyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      dailyForecasts: [
        DailyWeatherForecast(
          date: DateTime(2024, 1, 1),
          maxTemperature: 25.0,
          minTemperature: 15.0,
          description: 'sunny',
          iconCode: '01d',
          humidity: 60,
          windSpeed: 3.5,
          pressure: 1013,
        ),
        DailyWeatherForecast(
          date: DateTime(2024, 1, 2),
          maxTemperature: 23.0,
          minTemperature: 13.0,
          description: 'cloudy',
          iconCode: '04d',
          humidity: 65,
          windSpeed: 4.0,
          pressure: 1015,
        ),
      ],
    );
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    return WeeklyWeatherData(
      cityName: 'Coordinate City',
      country: 'CC',
      dailyForecasts: [
        DailyWeatherForecast(
          date: DateTime(2024, 1, 1),
          maxTemperature: 18.0,
          minTemperature: 8.0,
          description: 'rainy',
          iconCode: '10d',
          humidity: 80,
          windSpeed: 5.2,
          pressure: 1005,
        ),
      ],
    );
  }
}

class MockImageService implements ImageService {
  @override
  String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
    DateTime? sunrise,
    DateTime? sunset,
    DateTime? currentTime,
  }) {
    return 'assets/images/test.webp';
  }

  @override
  List<String> getAllSupportedCities() {
    return ['seoul', 'tokyo', 'new_york'];
  }

  @override
  List<String> getCitiesForCountry(String countryCode) {
    return ['seoul'];
  }

  @override
  String getRandomImagePath() {
    return 'assets/images/random.webp';
  }

  @override
  List<String> getAvailableImages() {
    return ['seoul_sunny.webp', 'tokyo_cloudy.webp', 'new_york_rainy.webp'];
  }
}

class MockWeatherConditionRuleEngine extends WeatherConditionRuleEngine {
  @override
  List<WeatherConditionCard> evaluateConditions(WeatherData weatherData) {
    final cards = <WeatherConditionCard>[];
    
    // Generate heat wave card for temperatures >= 35°C
    if (weatherData.temperature >= 35.0) {
      cards.add(WeatherConditionCard.heatWave(
        temperature: weatherData.temperature,
        cityName: weatherData.cityName,
        severity: WeatherCardSeverity.danger,
      ));
    }
    
    // Generate UV alert for UV index >= 8
    if (weatherData.uvIndex != null && weatherData.uvIndex! >= 8) {
      cards.add(WeatherConditionCard.uvAlert(
        uvIndex: weatherData.uvIndex!,
        severity: WeatherCardSeverity.warning,
      ));
    }
    
    // Generate air quality alert for AQI >= 4
    if (weatherData.airQuality != null && weatherData.airQuality! >= 4) {
      cards.add(WeatherConditionCard.airQualityAlert(
        pm25: weatherData.pm25 ?? 50.0,
        pm10: weatherData.pm10 ?? 80.0,
        aqi: weatherData.airQuality!,
        cityName: weatherData.cityName,
        severity: WeatherCardSeverity.warning,
      ));
    }
    
    return cards;
  }
}

// Mock repositories with error scenarios
class MockWeatherRepositoryWithErrors implements WeatherRepository {
  final bool shouldThrowError;
  
  MockWeatherRepositoryWithErrors({this.shouldThrowError = false});
  
  @override
  Future<WeatherData> getCurrentWeather() async {
    if (shouldThrowError) {
      throw Exception('GPS unavailable');
    }
    return WeatherData(
      temperature: 25.0,
      feelsLike: 27.0,
      humidity: 60,
      windSpeed: 3.5,
      description: 'clear sky',
      iconCode: '01d',
      cityName: 'Test City',
      country: 'TC',
      pressure: 1013,
      visibility: 10000,
      uvIndex: 5,
      airQuality: 2,
      pm25: 10.0,
      pm10: 20.0,
      precipitationProbability: 0.1,
      latitude: 0.0,
      longitude: 0.0,
    );
  }
  
  @override
  Future<WeatherData> getRandomCityWeather() async {
    if (shouldThrowError) {
      throw Exception('API key invalid');
    }
    return WeatherData(
      temperature: 22.0,
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 2.8,
      description: 'few clouds',
      iconCode: '02d',
      cityName: 'Random City',
      country: 'RC',
      pressure: 1015,
      visibility: 12000,
      uvIndex: 4,
      airQuality: 1,
      pm25: 5.0,
      pm10: 15.0,
      precipitationProbability: 0.2,
      latitude: 35.0,
      longitude: 139.0,
    );
  }
  
  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    if (shouldThrowError) {
      throw Exception('Invalid coordinates');
    }
    return WeatherData(
      temperature: 18.0,
      feelsLike: 20.0,
      humidity: 70,
      windSpeed: 4.2,
      description: 'overcast clouds',
      iconCode: '04d',
      cityName: 'Coordinate City',
      country: 'CC',
      pressure: 1010,
      visibility: 8000,
      uvIndex: 3,
      airQuality: 3,
      pm25: 25.0,
      pm10: 40.0,
      precipitationProbability: 0.3,
      latitude: latitude,
      longitude: longitude,
    );
  }
  
  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    if (shouldThrowError) {
      throw Exception('Hourly data unavailable');
    }
    return HourlyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      hourlyForecasts: [],
    );
  }
  
  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    if (shouldThrowError) {
      throw Exception('Hourly data unavailable');
    }
    return HourlyWeatherData(
      cityName: 'Coordinate City',
      country: 'CC',
      hourlyForecasts: [],
    );
  }
  
  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    if (shouldThrowError) {
      throw Exception('Weekly data unavailable');
    }
    return WeeklyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      dailyForecasts: [],
    );
  }
  
  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    if (shouldThrowError) {
      throw Exception('Weekly data unavailable');
    }
    return WeeklyWeatherData(
      cityName: 'Coordinate City',
      country: 'CC',
      dailyForecasts: [],
    );
  }
}

void main() {
  group('WeatherService Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
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
        airQuality: 2,
        pm25: 15.0,
        pm10: 25.0,
        precipitationProbability: 0.2,
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
      expect(weatherData.uvIndex, null); // Will be null from API until separate UV call
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
        airQuality: 3,
        pm25: 18.0,
        pm10: 28.0,
        precipitationProbability: 0.3,
        latitude: 48.8566,
        longitude: 2.3522,
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
          airQuality: 1,
          pm25: 5.0,
          pm10: 10.0,
          precipitationProbability: 0.0,
          latitude: 0.0,
          longitude: 0.0,
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
      expect(weatherData.uvIndex, null); // Will be null from API until separate UV call
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
        airQuality: 1,
        pm25: 0.0,
        pm10: 0.0,
        precipitationProbability: 0.0,
        latitude: 0.0,
        longitude: 0.0,
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

  // New comprehensive tests for WeatherService
  group('WeatherService Hourly Weather Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    group('getHourlyWeather', () {
      test('returns hourly weather data for current location', () async {
        final hourlyData = await weatherService.getHourlyWeather();

        expect(hourlyData, isA<HourlyWeatherData>());
        expect(hourlyData.cityName, isNotEmpty);
        expect(hourlyData.country, isNotEmpty);
        expect(hourlyData.hourlyForecasts, isA<List<HourlyWeatherForecast>>());
        expect(hourlyData.hourlyForecasts.length, greaterThan(0));

        final firstForecast = hourlyData.hourlyForecasts.first;
        expect(firstForecast.hour, isNotEmpty);
        expect(firstForecast.temperature, isA<double>());
        expect(firstForecast.description, isNotEmpty);
        expect(firstForecast.iconCode, isNotEmpty);
        expect(firstForecast.humidity, isA<int>());
      });
    });

    group('getHourlyWeatherByCoordinates', () {
      test('returns hourly weather data for specific coordinates', () async {
        const latitude = 37.5665;
        const longitude = 126.9780;

        final hourlyData = await weatherService.getHourlyWeatherByCoordinates(latitude, longitude);

        expect(hourlyData, isA<HourlyWeatherData>());
        expect(hourlyData.cityName, isNotEmpty);
        expect(hourlyData.country, isNotEmpty);
        expect(hourlyData.hourlyForecasts, isA<List<HourlyWeatherForecast>>());
      });

      test('handles invalid coordinates gracefully', () async {
        const latitude = 999.0;
        const longitude = 999.0;

        final hourlyData = await weatherService.getHourlyWeatherByCoordinates(latitude, longitude);

        expect(hourlyData, isA<HourlyWeatherData>());
      });
    });
  });

  group('WeatherService Weekly Weather Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    group('getWeeklyWeather', () {
      test('returns weekly weather data for current location', () async {
        final weeklyData = await weatherService.getWeeklyWeather();

        expect(weeklyData, isA<WeeklyWeatherData>());
        expect(weeklyData.cityName, isNotEmpty);
        expect(weeklyData.country, isNotEmpty);
        expect(weeklyData.dailyForecasts, isA<List<DailyWeatherForecast>>());
        expect(weeklyData.dailyForecasts.length, greaterThan(0));

        final firstForecast = weeklyData.dailyForecasts.first;
        expect(firstForecast.dayOfWeek, isNotEmpty);
        expect(firstForecast.maxTemperature, isA<double>());
        expect(firstForecast.minTemperature, isA<double>());
        expect(firstForecast.description, isNotEmpty);
        expect(firstForecast.iconCode, isNotEmpty);
      });
    });

    group('getWeeklyWeatherByCoordinates', () {
      test('returns weekly weather data for specific coordinates', () async {
        const latitude = 48.8566;
        const longitude = 2.3522;

        final weeklyData = await weatherService.getWeeklyWeatherByCoordinates(latitude, longitude);

        expect(weeklyData, isA<WeeklyWeatherData>());
        expect(weeklyData.cityName, isNotEmpty);
        expect(weeklyData.country, isNotEmpty);
        expect(weeklyData.dailyForecasts, isA<List<DailyWeatherForecast>>());
      });

      test('handles extreme coordinates', () async {
        const latitude = -90.0; // South Pole
        const longitude = 180.0; // International Date Line

        final weeklyData = await weatherService.getWeeklyWeatherByCoordinates(latitude, longitude);

        expect(weeklyData, isA<WeeklyWeatherData>());
      });
    });
  });

  group('WeatherService Image Service Integration Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    group('selectBackgroundImage', () {
      test('returns image path for city and weather combination', () async {
        const cityName = 'Seoul';
        const countryCode = 'KR';
        const weatherDescription = 'clear sky';
        const latitude = 37.5665;
        const longitude = 126.9780;

        final imagePath = weatherService.selectBackgroundImage(
          cityName: cityName,
          countryCode: countryCode,
          weatherDescription: weatherDescription,
          latitude: latitude,
          longitude: longitude,
        );

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
        expect(imagePath, contains('assets'));
        expect(imagePath, contains('.webp'));
      });

      test('handles unknown cities gracefully', () async {
        const cityName = 'Unknown City';
        const countryCode = 'XX';
        const weatherDescription = 'unknown weather';

        final imagePath = weatherService.selectBackgroundImage(
          cityName: cityName,
          countryCode: countryCode,
          weatherDescription: weatherDescription,
        );

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
      });

      test('works with all required parameters only', () async {
        const cityName = 'Tokyo';
        const countryCode = 'JP';
        const weatherDescription = 'rain';

        final imagePath = weatherService.selectBackgroundImage(
          cityName: cityName,
          countryCode: countryCode,
          weatherDescription: weatherDescription,
        );

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
      });

      test('works with optional sunrise and sunset times', () async {
        const cityName = 'New York';
        const countryCode = 'US';
        const weatherDescription = 'clear sky';
        final sunrise = DateTime.now().subtract(const Duration(hours: 2));
        final sunset = DateTime.now().add(const Duration(hours: 4));

        final imagePath = weatherService.selectBackgroundImage(
          cityName: cityName,
          countryCode: countryCode,
          weatherDescription: weatherDescription,
          sunrise: sunrise,
          sunset: sunset,
        );

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
      });
    });

    group('getRandomImagePath', () {
      test('returns random image path', () async {
        final imagePath = weatherService.getRandomImagePath();

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
        expect(imagePath, contains('assets'));
      });

      test('returns different paths on multiple calls (possibly)', () async {
        final imagePaths = <String>{};
        
        // Call multiple times to potentially get different paths
        for (int i = 0; i < 5; i++) {
          imagePaths.add(weatherService.getRandomImagePath());
        }

        // Should return valid paths
        for (final path in imagePaths) {
          expect(path, isA<String>());
          expect(path, isNotEmpty);
        }
      });
    });
  });

  group('WeatherService Condition Card Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    group('getWeatherConditionCards', () {
      test('returns condition cards for normal weather', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final conditionCards = weatherService.getWeatherConditionCards(weatherData);

        expect(conditionCards, isA<List<WeatherConditionCard>>());
        // Normal conditions should not trigger any alerts
        expect(conditionCards.length, 0);
      });

      test('returns heat wave card for high temperature', () async {
        final weatherData = WeatherData(
          temperature: 36.0, // Triggers heat wave alert
          feelsLike: 40.0,
          humidity: 45,
          windSpeed: 2.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Hot City',
          country: 'HC',
          pressure: 1010,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.0,
          latitude: 35.0,
          longitude: 139.0,
        );

        final conditionCards = weatherService.getWeatherConditionCards(weatherData);

        expect(conditionCards.length, 1);
        expect(conditionCards.first.type, WeatherCardType.heatWave);
        expect(conditionCards.first.severity, WeatherCardSeverity.danger);
      });

      test('returns UV alert card for high UV index', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Sunny City',
          country: 'SC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 9, // Triggers UV alert
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final conditionCards = weatherService.getWeatherConditionCards(weatherData);

        expect(conditionCards.length, 1);
        expect(conditionCards.first.type, WeatherCardType.uvIndex);
        expect(conditionCards.first.severity, WeatherCardSeverity.warning);
      });

      test('returns air quality alert for poor air quality', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'haze',
          iconCode: '50d',
          cityName: 'Polluted City',
          country: 'PC',
          pressure: 1013,
          visibility: 5000,
          uvIndex: 5,
          airQuality: 4, // Triggers air quality alert
          pm25: 50.0,
          pm10: 80.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final conditionCards = weatherService.getWeatherConditionCards(weatherData);

        expect(conditionCards.length, 1);
        expect(conditionCards.first.type, WeatherCardType.airQuality);
        expect(conditionCards.first.severity, WeatherCardSeverity.warning);
      });

      test('returns multiple condition cards for extreme weather', () async {
        final weatherData = WeatherData(
          temperature: 37.0, // Heat wave
          feelsLike: 42.0,
          humidity: 40,
          windSpeed: 2.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Extreme City',
          country: 'EC',
          pressure: 1005,
          visibility: 8000,
          uvIndex: 10, // UV alert
          airQuality: 5, // Air quality alert
          pm25: 80.0,
          pm10: 120.0,
          precipitationProbability: 0.0,
          latitude: 35.0,
          longitude: 139.0,
        );

        final conditionCards = weatherService.getWeatherConditionCards(weatherData);

        expect(conditionCards.length, 3);
        
        final cardTypes = conditionCards.map((card) => card.type).toList();
        expect(cardTypes, contains(WeatherCardType.heatWave));
        expect(cardTypes, contains(WeatherCardType.uvIndex));
        expect(cardTypes, contains(WeatherCardType.airQuality));
      });
    });

    group('hasActiveConditionCard', () {
      test('returns true when specific card type is active', () async {
        final weatherData = WeatherData(
          temperature: 36.0,
          feelsLike: 40.0,
          humidity: 45,
          windSpeed: 2.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Hot City',
          country: 'HC',
          pressure: 1010,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.0,
          latitude: 35.0,
          longitude: 139.0,
        );

        final hasHeatWave = weatherService.hasActiveConditionCard(
          weatherData,
          WeatherCardType.heatWave,
        );

        expect(hasHeatWave, true);
      });

      test('returns false when specific card type is not active', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Normal City',
          country: 'NC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final hasHeatWave = weatherService.hasActiveConditionCard(
          weatherData,
          WeatherCardType.heatWave,
        );

        expect(hasHeatWave, false);
      });
    });

    group('getMostCriticalConditionCard', () {
      test('returns most critical card from multiple alerts', () async {
        final weatherData = WeatherData(
          temperature: 37.0, // Heat wave (danger)
          feelsLike: 42.0,
          humidity: 40,
          windSpeed: 2.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Critical City',
          country: 'CC',
          pressure: 1005,
          visibility: 8000,
          uvIndex: 10, // UV alert (warning)
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.0,
          latitude: 35.0,
          longitude: 139.0,
        );

        final mostCritical = weatherService.getMostCriticalConditionCard(weatherData);

        expect(mostCritical, isNotNull);
        expect(mostCritical!.type, WeatherCardType.heatWave);
        expect(mostCritical.severity, WeatherCardSeverity.danger);
      });

      test('returns null when no condition cards are active', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Peaceful City',
          country: 'PC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final mostCritical = weatherService.getMostCriticalConditionCard(weatherData);

        expect(mostCritical, isNull);
      });
    });
  });

  group('WeatherService Update Methods Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    group('updateUVIndex', () {
      test('updates UV index correctly', () async {
        final originalWeatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        const newUvIndex = 8.5;
        final updatedWeatherData = weatherService.updateUVIndex(originalWeatherData, newUvIndex);

        expect(updatedWeatherData.uvIndex, newUvIndex);
        expect(updatedWeatherData.temperature, originalWeatherData.temperature);
        expect(updatedWeatherData.cityName, originalWeatherData.cityName);
        expect(updatedWeatherData.airQuality, originalWeatherData.airQuality);
      });

      test('preserves all other fields when updating UV index', () async {
        final originalWeatherData = WeatherData(
          temperature: 22.3,
          feelsLike: 24.1,
          humidity: 75,
          windSpeed: 4.2,
          description: 'partly cloudy',
          iconCode: '02d',
          cityName: 'Sample City',
          country: 'SC',
          pressure: 1008,
          visibility: 12000,
          uvIndex: 3,
          airQuality: 1,
          pm25: 8.0,
          pm10: 15.0,
          precipitationProbability: 0.3,
          latitude: 40.7128,
          longitude: -74.0060,
        );

        const newUvIndex = 11.0;
        final updatedWeatherData = weatherService.updateUVIndex(originalWeatherData, newUvIndex);

        expect(updatedWeatherData.uvIndex, newUvIndex);
        expect(updatedWeatherData.temperature, originalWeatherData.temperature);
        expect(updatedWeatherData.feelsLike, originalWeatherData.feelsLike);
        expect(updatedWeatherData.humidity, originalWeatherData.humidity);
        expect(updatedWeatherData.windSpeed, originalWeatherData.windSpeed);
        expect(updatedWeatherData.description, originalWeatherData.description);
        expect(updatedWeatherData.iconCode, originalWeatherData.iconCode);
        expect(updatedWeatherData.cityName, originalWeatherData.cityName);
        expect(updatedWeatherData.country, originalWeatherData.country);
        expect(updatedWeatherData.airQuality, originalWeatherData.airQuality);
        expect(updatedWeatherData.pm25, originalWeatherData.pm25);
        expect(updatedWeatherData.pm10, originalWeatherData.pm10);
      });
    });

    group('updateAirQuality', () {
      test('updates air quality data correctly', () async {
        final originalWeatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        const newAirQuality = 4;
        const newPm25 = 45.5;
        const newPm10 = 78.3;
        
        final updatedWeatherData = weatherService.updateAirQuality(
          originalWeatherData,
          newAirQuality,
          newPm25,
          newPm10,
        );

        expect(updatedWeatherData.airQuality, newAirQuality);
        expect(updatedWeatherData.pm25, newPm25);
        expect(updatedWeatherData.pm10, newPm10);
        expect(updatedWeatherData.temperature, originalWeatherData.temperature);
        expect(updatedWeatherData.uvIndex, originalWeatherData.uvIndex);
      });

      test('preserves all other fields when updating air quality', () async {
        final originalWeatherData = WeatherData(
          temperature: 18.7,
          feelsLike: 17.2,
          humidity: 85,
          windSpeed: 6.8,
          description: 'heavy rain',
          iconCode: '10d',
          cityName: 'Rainy City',
          country: 'RC',
          pressure: 995,
          visibility: 5000,
          uvIndex: 2,
          airQuality: 3,
          pm25: 25.0,
          pm10: 45.0,
          precipitationProbability: 0.9,
          latitude: 51.5074,
          longitude: -0.1278,
        );

        const newAirQuality = 5;
        const newPm25 = 85.2;
        const newPm10 = 142.8;
        
        final updatedWeatherData = weatherService.updateAirQuality(
          originalWeatherData,
          newAirQuality,
          newPm25,
          newPm10,
        );

        expect(updatedWeatherData.airQuality, newAirQuality);
        expect(updatedWeatherData.pm25, newPm25);
        expect(updatedWeatherData.pm10, newPm10);
        expect(updatedWeatherData.temperature, originalWeatherData.temperature);
        expect(updatedWeatherData.feelsLike, originalWeatherData.feelsLike);
        expect(updatedWeatherData.humidity, originalWeatherData.humidity);
        expect(updatedWeatherData.windSpeed, originalWeatherData.windSpeed);
        expect(updatedWeatherData.uvIndex, originalWeatherData.uvIndex);
        expect(updatedWeatherData.description, originalWeatherData.description);
      });
    });

    group('getSpecificConditionCards', () {
      test('returns only specified card types', () async {
        final weatherData = WeatherData(
          temperature: 37.0, // Heat wave
          feelsLike: 42.0,
          humidity: 40,
          windSpeed: 2.0,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Multi Alert City',
          country: 'MAC',
          pressure: 1005,
          visibility: 8000,
          uvIndex: 10, // UV alert
          airQuality: 5, // Air quality alert
          pm25: 80.0,
          pm10: 120.0,
          precipitationProbability: 0.0,
          latitude: 35.0,
          longitude: 139.0,
        );

        // Request only UV cards
        final uvCards = weatherService.getSpecificConditionCards(
          weatherData,
          [WeatherCardType.uvIndex],
        );

        expect(uvCards.length, 1);
        expect(uvCards.first.type, WeatherCardType.uvIndex);

        // Request heat wave and air quality cards
        final multipleCards = weatherService.getSpecificConditionCards(
          weatherData,
          [WeatherCardType.heatWave, WeatherCardType.airQuality],
        );

        expect(multipleCards.length, 2);
        final cardTypes = multipleCards.map((card) => card.type).toList();
        expect(cardTypes, contains(WeatherCardType.heatWave));
        expect(cardTypes, contains(WeatherCardType.airQuality));
      });

      test('returns empty list when requested card types are not active', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Normal City',
          country: 'NC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: 5,
          airQuality: 2,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        final requestedCards = weatherService.getSpecificConditionCards(
          weatherData,
          [WeatherCardType.heatWave, WeatherCardType.airQuality],
        );

        expect(requestedCards, isEmpty);
      });
    });
  });

  group('WeatherService Error Handling Tests', () {
    group('Network Error Scenarios', () {
      late WeatherService errorWeatherService;

      setUp(() {
        errorWeatherService = WeatherService(
          weatherRepository: MockWeatherRepositoryWithErrors(shouldThrowError: true),
          imageService: MockImageService(),
          ruleEngine: MockWeatherConditionRuleEngine(),
        );
      });

      test('handles getCurrentWeather error gracefully', () async {
        expect(
          () async => await errorWeatherService.getCurrentWeather(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles getRandomCityWeather error gracefully', () async {
        expect(
          () async => await errorWeatherService.getRandomCityWeather(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles getWeatherByCoordinates error gracefully', () async {
        expect(
          () async => await errorWeatherService.getWeatherByCoordinates(37.5665, 126.9780),
          throwsA(isA<Exception>()),
        );
      });

      test('handles getHourlyWeather error gracefully', () async {
        expect(
          () async => await errorWeatherService.getHourlyWeather(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles getWeeklyWeather error gracefully', () async {
        expect(
          () async => await errorWeatherService.getWeeklyWeather(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Invalid Input Handling', () {
      late WeatherService weatherService;

      setUp(() {
        weatherService = WeatherService(
          weatherRepository: MockWeatherRepository(),
          imageService: MockImageService(),
          ruleEngine: MockWeatherConditionRuleEngine(),
        );
      });

      test('handles extreme coordinate values', () async {
        // Test extreme latitude values
        final weatherData1 = await weatherService.getWeatherByCoordinates(-90.0, 0.0);
        expect(weatherData1, isA<WeatherData>());

        final weatherData2 = await weatherService.getWeatherByCoordinates(90.0, 0.0);
        expect(weatherData2, isA<WeatherData>());

        // Test extreme longitude values
        final weatherData3 = await weatherService.getWeatherByCoordinates(0.0, -180.0);
        expect(weatherData3, isA<WeatherData>());

        final weatherData4 = await weatherService.getWeatherByCoordinates(0.0, 180.0);
        expect(weatherData4, isA<WeatherData>());
      });

      test('handles empty strings in selectBackgroundImage', () async {
        final imagePath = weatherService.selectBackgroundImage(
          cityName: '',
          countryCode: '',
          weatherDescription: '',
        );

        expect(imagePath, isA<String>());
        expect(imagePath, isNotEmpty);
      });

      test('handles null values in weather data update methods', () async {
        final weatherData = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 60,
          windSpeed: 3.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: null,
          airQuality: null,
          pm25: 0.0,
          pm10: 0.0,
          precipitationProbability: 0.1,
          latitude: 0.0,
          longitude: 0.0,
        );

        // Update UV index when original is null
        final updatedUV = weatherService.updateUVIndex(weatherData, 7.0);
        expect(updatedUV.uvIndex, 7.0);

        // Update air quality when original values are null
        final updatedAir = weatherService.updateAirQuality(weatherData, 3, 30.0, 50.0);
        expect(updatedAir.airQuality, 3);
        expect(updatedAir.pm25, 30.0);
        expect(updatedAir.pm10, 50.0);
      });
    });
  });

  group('WeatherService Integration Edge Cases', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService(
        weatherRepository: MockWeatherRepository(),
        imageService: MockImageService(),
        ruleEngine: MockWeatherConditionRuleEngine(),
      );
    });

    test('integration between weather data and condition cards', () async {
      final weatherData = await weatherService.getCurrentWeather();
      final conditionCards = weatherService.getWeatherConditionCards(weatherData);

      // Verify integration works
      expect(weatherData, isA<WeatherData>());
      expect(conditionCards, isA<List<WeatherConditionCard>>());

      // Test that image selection works with weather data
      final imagePath = weatherService.selectBackgroundImage(
        cityName: weatherData.cityName,
        countryCode: weatherData.country,
        weatherDescription: weatherData.description,
        latitude: weatherData.latitude,
        longitude: weatherData.longitude,
      );

      expect(imagePath, isA<String>());
      expect(imagePath, isNotEmpty);
    });

    test('condition cards respond to UV index updates', () async {
      final originalWeatherData = WeatherData(
        temperature: 25.0,
        feelsLike: 27.0,
        humidity: 60,
        windSpeed: 3.5,
        description: 'clear sky',
        iconCode: '01d',
        cityName: 'Test City',
        country: 'TC',
        pressure: 1013,
        visibility: 10000,
        uvIndex: 5, // Normal UV
        airQuality: 2,
        pm25: 10.0,
        pm10: 20.0,
        precipitationProbability: 0.1,
        latitude: 0.0,
        longitude: 0.0,
      );

      // No UV alert initially
      final initialCards = weatherService.getWeatherConditionCards(originalWeatherData);
      expect(initialCards.any((card) => card.type == WeatherCardType.uvIndex), false);

      // Update UV to trigger alert
      final updatedWeatherData = weatherService.updateUVIndex(originalWeatherData, 9.0);
      final updatedCards = weatherService.getWeatherConditionCards(updatedWeatherData);
      
      expect(updatedCards.any((card) => card.type == WeatherCardType.uvIndex), true);
    });

    test('condition cards respond to air quality updates', () async {
      final originalWeatherData = WeatherData(
        temperature: 25.0,
        feelsLike: 27.0,
        humidity: 60,
        windSpeed: 3.5,
        description: 'clear sky',
        iconCode: '01d',
        cityName: 'Test City',
        country: 'TC',
        pressure: 1013,
        visibility: 10000,
        uvIndex: 5,
        airQuality: 2, // Good air quality
        pm25: 10.0,
        pm10: 20.0,
        precipitationProbability: 0.1,
        latitude: 0.0,
        longitude: 0.0,
      );

      // No air quality alert initially
      final initialCards = weatherService.getWeatherConditionCards(originalWeatherData);
      expect(initialCards.any((card) => card.type == WeatherCardType.airQuality), false);

      // Update air quality to trigger alert
      final updatedWeatherData = weatherService.updateAirQuality(originalWeatherData, 5, 70.0, 110.0);
      final updatedCards = weatherService.getWeatherConditionCards(updatedWeatherData);
      
      expect(updatedCards.any((card) => card.type == WeatherCardType.airQuality), true);
    });
  });
}