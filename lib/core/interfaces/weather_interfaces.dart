import '../models/weather_data.dart';
import '../models/hourly_weather_data.dart';
import '../models/weekly_weather_data.dart';

/// Interface segregation following ISP (Interface Segregation Principle)
/// Split large interfaces into smaller, more specific ones

/// Interface for current weather operations
abstract class CurrentWeatherService {
  Future<WeatherData> getCurrentWeather();
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude);
}

/// Interface for forecast operations
abstract class WeatherForecastService {
  Future<HourlyWeatherData> getHourlyWeather();
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude);
  Future<WeeklyWeatherData> getWeeklyWeather();
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude);
}

/// Interface for random weather exploration
abstract class RandomWeatherService {
  Future<WeatherData> getRandomCityWeather();
}

/// Interface for location-based operations
abstract class LocationWeatherService {
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude);
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude);
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude);
}

/// Interface for weather data caching
abstract class WeatherCacheService {
  Future<void> cacheWeatherData(String key, WeatherData data);
  Future<WeatherData?> getCachedWeatherData(String key);
  Future<void> clearCache();
  Future<bool> isCacheValid(String key);
}

/// Interface for weather data validation
abstract class WeatherDataValidator {
  bool isValidWeatherData(WeatherData data);
  bool isValidCoordinates(double latitude, double longitude);
  bool isValidTemperature(double temperature);
  bool isValidHumidity(int humidity);
}

/// Composite interface that can implement multiple specific interfaces
/// This maintains backward compatibility while following ISP
abstract class ComprehensiveWeatherRepository 
    implements CurrentWeatherService, WeatherForecastService, RandomWeatherService, LocationWeatherService {
  // This interface combines all weather operations for classes that need everything
}

/// Minimal interface for basic weather display
abstract class BasicWeatherService {
  Future<WeatherData> getCurrentWeather();
  Future<HourlyWeatherData> getHourlyWeather();
}

/// Interface for weather settings and configuration
abstract class WeatherConfigurationService {
  void setApiKey(String apiKey);
  void setUnits(String units); // metric, imperial, kelvin
  void setTimeout(Duration timeout);
  String get currentUnits;
  Duration get currentTimeout;
}