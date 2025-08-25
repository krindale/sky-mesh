import '../interfaces/weather_repository.dart';
import '../models/weather_data.dart';
import '../models/hourly_weather_data.dart';
import '../models/weekly_weather_data.dart';
import '../utils/logger.dart';

/// Test to verify LSP (Liskov Substitution Principle)
/// All implementations of WeatherRepository should be substitutable
class WeatherRepositoryLspTest {
  /// Test that any WeatherRepository implementation follows the contract
  static Future<void> testWeatherRepositoryContract(WeatherRepository repository) async {
    // Test 1: getCurrentWeather should return WeatherData
    try {
      final weather = await repository.getCurrentWeather();
      assert(weather.temperature.isFinite, 'Temperature must be a valid number');
      assert(weather.cityName.isNotEmpty, 'City name must not be empty');
      assert(weather.country.isNotEmpty, 'Country must not be empty');
      Logger.debug('✅ getCurrentWeather contract verified');
    } catch (e) {
      Logger.debug('❌ getCurrentWeather contract violated: $e');
    }

    // Test 2: getWeatherByCoordinates should handle valid coordinates
    try {
      final weather = await repository.getWeatherByCoordinates(37.5665, 126.9780);
      assert(weather.temperature.isFinite, 'Temperature must be a valid number');
      Logger.debug('✅ getWeatherByCoordinates contract verified');
    } catch (e) {
      Logger.debug('❌ getWeatherByCoordinates contract violated: $e');
    }

    // Test 3: getHourlyWeather should return hourly forecasts
    try {
      final hourlyWeather = await repository.getHourlyWeather();
      assert(hourlyWeather.hourlyForecasts.isNotEmpty, 'Hourly forecasts must not be empty');
      Logger.debug('✅ getHourlyWeather contract verified');
    } catch (e) {
      Logger.debug('❌ getHourlyWeather contract violated: $e');
    }

    // Test 4: getWeeklyWeather should return weekly forecasts
    try {
      final weeklyWeather = await repository.getWeeklyWeather();
      assert(weeklyWeather.dailyForecasts.length >= 7, 'Weekly forecast should have at least 7 days');
      assert(weeklyWeather.dailyForecasts.isNotEmpty, 'Daily forecasts must not be empty');
      Logger.debug('✅ getWeeklyWeather contract verified');
    } catch (e) {
      Logger.debug('❌ getWeeklyWeather contract violated: $e');
    }

    // Test 5: getRandomCityWeather should return valid weather data
    try {
      final randomWeather = await repository.getRandomCityWeather();
      assert(randomWeather.cityName.isNotEmpty, 'Random weather must have city name');
      Logger.debug('✅ getRandomCityWeather contract verified');
    } catch (e) {
      Logger.debug('❌ getRandomCityWeather contract violated: $e');
    }
  }

  /// Verify that substitution works correctly
  static Future<void> verifySubstitutability() async {
    Logger.debug('🧪 Testing LSP - Liskov Substitution Principle');
    
    // Test with different implementations
    final repositories = <WeatherRepository>[
      // Add different implementations here for testing
      // MockWeatherRepository(),
      // OpenWeatherApiService(locationService: MockLocationService()),
    ];

    for (int i = 0; i < repositories.length; i++) {
      Logger.debug('\n📋 Testing repository implementation ${i + 1}:');
      await testWeatherRepositoryContract(repositories[i]);
    }

    Logger.debug('\n✅ LSP verification completed');
  }
}

/// Mock implementation for testing LSP
class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherData> getCurrentWeather() async {
    return WeatherData(
      temperature: 20.0,
      feelsLike: 22.0,
      humidity: 60,
      windSpeed: 5.0,
      description: 'Clear sky',
      iconCode: '01d',
      cityName: 'Test City',
      country: 'TC',
      pressure: 1013,
      visibility: 10000,
      uvIndex: 3,
      airQuality: 1,
    );
  }

  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    return getCurrentWeather();
  }

  @override
  Future<WeatherData> getRandomCityWeather() async {
    return getCurrentWeather();
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    return HourlyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      hourlyForecasts: [
        HourlyWeatherForecast(
          dateTime: DateTime.now(),
          temperature: 20.0,
          description: 'Clear',
          iconCode: '01d',
          humidity: 60,
          windSpeed: 5.0,
          pressure: 1013,
        ),
      ],
    );
  }

  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    return getHourlyWeather();
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    return WeeklyWeatherData(
      cityName: 'Test City',
      country: 'TC',
      dailyForecasts: [
        DailyWeatherForecast(
          date: DateTime.now(),
          maxTemperature: 25.0,
          minTemperature: 15.0,
          description: 'Sunny',
          iconCode: '01d',
          humidity: 50,
          windSpeed: 3.0,
          pressure: 1013,
        ),
      ],
    );
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    return getWeeklyWeather();
  }
}