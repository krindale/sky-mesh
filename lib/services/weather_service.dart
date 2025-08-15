import '../core/interfaces/weather_repository.dart';
import '../core/interfaces/image_service.dart';
import '../core/models/weather_data.dart';
import '../core/models/hourly_weather_data.dart';
import '../core/models/weekly_weather_data.dart';
import '../core/dependency_injection/service_locator.dart';

/// Weather service facade following SOLID principles
/// This is a simplified interface for the UI layer, delegating to proper repositories
class WeatherService {
  final WeatherRepository _weatherRepository;
  final ImageService _imageService;

  WeatherService({
    WeatherRepository? weatherRepository,
    ImageService? imageService,
  }) : _weatherRepository = weatherRepository ?? ServiceLocator().get<WeatherRepository>(),
       _imageService = imageService ?? ServiceLocator().get<ImageService>();

  /// Delegates to weather repository following SRP and DIP

  Future<WeatherData> getRandomCityWeather() async {
    return await _weatherRepository.getRandomCityWeather();
  }

  Future<WeatherData> getCurrentWeather() async {
    return await _weatherRepository.getCurrentWeather();
  }

  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getWeatherByCoordinates(latitude, longitude);
  }

  Future<HourlyWeatherData> getHourlyWeather() async {
    return await _weatherRepository.getHourlyWeather();
  }

  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getHourlyWeatherByCoordinates(latitude, longitude);
  }

  Future<WeeklyWeatherData> getWeeklyWeather() async {
    return await _weatherRepository.getWeeklyWeather();
  }

  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getWeeklyWeatherByCoordinates(latitude, longitude);
  }

  /// Get background image for location/weather (delegates to image service)
  String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
  }) {
    return _imageService.selectBackgroundImage(
      cityName: cityName,
      countryCode: countryCode,
      weatherDescription: weatherDescription,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Get random image path (delegates to image service)
  String getRandomImagePath() {
    return _imageService.getRandomImagePath();
  }
}