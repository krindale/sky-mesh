import '../models/weather_data.dart';
import '../models/hourly_weather_data.dart';
import '../models/weekly_weather_data.dart';

/// Strategy interface for different weather data sources
/// Follows OCP - open for extension, closed for modification
abstract class WeatherStrategy {
  Future<WeatherData> getCurrentWeather();
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude);
  Future<HourlyWeatherData> getHourlyWeather();
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude);
  Future<WeeklyWeatherData> getWeeklyWeather();
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude);
}

/// Concrete strategy for OpenWeatherMap API
class OpenWeatherMapStrategy implements WeatherStrategy {
  final String apiKey;
  final String baseUrl;
  final String forecastUrl;

  OpenWeatherMapStrategy({
    required this.apiKey,
    this.baseUrl = 'https://api.openweathermap.org/data/2.5/weather',
    this.forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast',
  });

  @override
  Future<WeatherData> getCurrentWeather() async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }

  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }

  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    // Implementation would go here
    throw UnimplementedError('OpenWeatherMap strategy implementation');
  }
}

/// Mock strategy for testing and development
class MockWeatherStrategy implements WeatherStrategy {
  @override
  Future<WeatherData> getCurrentWeather() async {
    // Return mock data
    return WeatherData(
      temperature: 22,
      feelsLike: 24,
      humidity: 65,
      windSpeed: 3.2,
      description: 'Partly Cloudy',
      iconCode: '02d',
      cityName: 'Seoul',
      country: 'KR',
      pressure: 1013,
      visibility: 10000,
      uvIndex: 5,
      airQuality: 2,
      latitude: 37.5665,
      longitude: 126.9780,
    );
  }

  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    return getCurrentWeather();
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    final now = DateTime.now();
    final hourlyForecasts = <HourlyWeatherForecast>[];
    
    for (int i = 0; i < 24; i++) {
      hourlyForecasts.add(HourlyWeatherForecast(
        dateTime: now.add(Duration(hours: i)),
        temperature: 20.0 + i,
        description: 'Clear',
        iconCode: '01d',
        humidity: 50,
        windSpeed: 3.0,
        pressure: 1013,
      ));
    }
    
    return HourlyWeatherData(
      cityName: 'Seoul',
      country: 'KR',
      hourlyForecasts: hourlyForecasts,
    );
  }

  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    return getHourlyWeather();
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    final now = DateTime.now();
    final dailyForecasts = <DailyWeatherForecast>[];
    
    for (int i = 0; i < 7; i++) {
      dailyForecasts.add(DailyWeatherForecast(
        date: now.add(Duration(days: i)),
        maxTemperature: 25.0 + i,
        minTemperature: 15.0 + i,
        description: 'Sunny',
        iconCode: '01d',
        humidity: 50,
        windSpeed: 3.0,
        pressure: 1013,
      ));
    }
    
    return WeeklyWeatherData(
      cityName: 'Seoul',
      country: 'KR',
      dailyForecasts: dailyForecasts,
    );
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    return getWeeklyWeather();
  }
}