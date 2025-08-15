import '../models/weather_data.dart';
import '../models/hourly_weather_data.dart';
import '../models/weekly_weather_data.dart';

/// Weather data repository interface following DIP (Dependency Inversion Principle)
abstract class WeatherRepository {
  Future<WeatherData> getCurrentWeather();
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude);
  Future<WeatherData> getRandomCityWeather();
  Future<HourlyWeatherData> getHourlyWeather();
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude);
  Future<WeeklyWeatherData> getWeeklyWeather();
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude);
}