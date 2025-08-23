import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/interfaces/weather_repository.dart';
import '../../core/interfaces/weather_interfaces.dart';
import '../../core/interfaces/location_service.dart';
import '../../core/models/weather_data.dart';
import '../../core/models/hourly_weather_data.dart';
import '../../core/models/weekly_weather_data.dart';

/// Concrete implementation of WeatherRepository using OpenWeatherMap API
/// 
/// This service provides weather data by communicating with the OpenWeatherMap API.
/// It implements the Repository pattern to abstract data source details from
/// the business logic layer.
/// 
/// ## SOLID Principles Adherence
/// - **SRP**: Only responsible for weather data operations via OpenWeatherMap API
/// - **OCP**: Can be extended with different strategies without modification
/// - **LSP**: Fully substitutable for WeatherRepository interface
/// - **DIP**: Depends on abstractions (LocationService, WeatherDataFactory)
/// 
/// ## Features
/// - Current weather by location or coordinates
/// - Hourly and weekly forecasts
/// - Random city weather exploration
/// - Automatic fallback to mock data on network failures
/// - Error handling with graceful degradation
/// 
/// ## Usage
/// 
/// ```dart
/// final service = OpenWeatherApiService(
///   locationService: GeolocatorService(),
/// );
/// 
/// // Get current weather
/// final weather = await service.getCurrentWeather();
/// 
/// // Get weather for specific coordinates
/// final weatherAt = await service.getWeatherByCoordinates(37.7749, -122.4194);
/// 
/// // Explore random city
/// final randomWeather = await service.getRandomCityWeather();
/// ```
/// 
/// ## Error Handling
/// 
/// All methods gracefully handle network errors, API failures, and permission
/// issues by falling back to mock data to ensure the app remains functional.
class OpenWeatherApiService implements 
    WeatherRepository, 
    CurrentWeatherService, 
    WeatherForecastService, 
    RandomWeatherService {
  static const String _apiKey = 'a179131038d53e44738851b4938c5cd0';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  final LocationService _locationService;
  final WeatherDataFactory _weatherDataFactory;

  /// Creates an OpenWeatherApiService instance
  /// 
  /// [locationService] is required for GPS-based weather requests
  /// [weatherDataFactory] is optional and defaults to WeatherDataFactory
  OpenWeatherApiService({
    required LocationService locationService,
    WeatherDataFactory? weatherDataFactory,
  }) : _locationService = locationService,
       _weatherDataFactory = weatherDataFactory ?? WeatherDataFactory();

  @override
  Future<WeatherData> getCurrentWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return await getWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      return _weatherDataFactory.createMockWeatherData();
    }
  }

  @override
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading weather by coordinates: $e');
      return _weatherDataFactory.createMockWeatherData();
    }
  }

  @override
  Future<WeatherData> getRandomCityWeather() async {
    try {
      final randomCity = RandomCityProvider.getRandomCity();
      final latitude = randomCity['latitude'] as double;
      final longitude = randomCity['longitude'] as double;
      
      print('🎲 Random city selected: ${randomCity['name']}, ${randomCity['country']} ($latitude, $longitude)');
      
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading random city weather: $e');
      return _weatherDataFactory.createRandomMockWeatherData();
    }
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return await getHourlyWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print('Error loading hourly weather: $e');
      return _weatherDataFactory.createMockHourlyWeatherData();
    }
  }

  @override
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_forecastUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HourlyWeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load hourly weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading hourly weather by coordinates: $e');
      return _weatherDataFactory.createMockHourlyWeatherData();
    }
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return await getWeeklyWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print('Error loading weekly weather: $e');
      return _weatherDataFactory.createMockWeeklyWeatherData();
    }
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_forecastUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeeklyWeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weekly weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading weekly weather by coordinates: $e');
      return _weatherDataFactory.createMockWeeklyWeatherData();
    }
  }
}

/// Factory class for creating weather data following SRP
/// 
/// This factory is responsible only for creating weather objects, both from
/// real data and mock data for testing or fallback scenarios.
/// 
/// ## Responsibilities
/// - Create mock weather data for error fallback scenarios
/// - Generate random weather data for testing
/// - Create hourly and weekly forecast mock data
/// 
/// ## Usage
/// 
/// ```dart
/// final factory = WeatherDataFactory();
/// 
/// // Create mock data for fallback
/// final mockWeather = factory.createMockWeatherData();
/// 
/// // Create random mock data for testing
/// final randomWeather = factory.createRandomMockWeatherData();
/// ```
class WeatherDataFactory {
  WeatherData createMockWeatherData() {
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

  WeatherData createRandomMockWeatherData() {
    final randomCity = RandomCityProvider.getRandomCity();
    
    final weatherOptions = [
      'Clear Sky', 'Few Clouds', 'Scattered Clouds', 'Broken Clouds', 
      'Overcast Clouds', 'Light Rain', 'Rain', 'Heavy Rain', 
      'Snow', 'Mist', 'Fog'
    ];
    
    final iconOptions = [
      '01d', '02d', '03d', '04d', '09d', '10d', '11d', '13d', '50d'
    ];
    
    final randomWeather = weatherOptions[Random().nextInt(weatherOptions.length)];
    final randomIcon = iconOptions[Random().nextInt(iconOptions.length)];
    final randomTemp = 5 + Random().nextInt(30);
    
    return WeatherData(
      temperature: randomTemp.toDouble(),
      feelsLike: randomTemp + Random().nextInt(5).toDouble() - 2,
      humidity: 30 + Random().nextInt(60),
      windSpeed: Random().nextDouble() * 8,
      description: randomWeather,
      iconCode: randomIcon,
      cityName: randomCity['name'] as String,
      country: randomCity['country'] as String,
      pressure: 980 + Random().nextInt(60),
      visibility: 5000 + Random().nextInt(10000),
      uvIndex: Random().nextInt(11),
      airQuality: 1 + Random().nextInt(5),
      latitude: randomCity['latitude'] as double,
      longitude: randomCity['longitude'] as double,
    );
  }

  HourlyWeatherData createMockHourlyWeatherData() {
    final now = DateTime.now();
    final hourlyForecasts = <HourlyWeatherForecast>[];
    
    final weatherOptions = [
      'Clear Sky', 'Few Clouds', 'Scattered Clouds', 'Broken Clouds', 
      'Overcast Clouds', 'Light Rain', 'Rain', 'Heavy Rain', 
      'Snow', 'Mist', 'Fog'
    ];
    
    final iconOptions = [
      '01d', '02d', '03d', '04d', '09d', '10d', '11d', '13d', '50d'
    ];
    
    for (int i = 0; i < 24; i++) {
      final forecastTime = now.add(Duration(hours: i));
      final baseTemp = 15 + Random().nextInt(20);
      final tempVariation = Random().nextInt(6) - 3;
      
      hourlyForecasts.add(HourlyWeatherForecast(
        dateTime: forecastTime,
        temperature: (baseTemp + tempVariation).toDouble(),
        description: weatherOptions[Random().nextInt(weatherOptions.length)],
        iconCode: iconOptions[Random().nextInt(iconOptions.length)],
        humidity: 30 + Random().nextInt(60),
        windSpeed: Random().nextDouble() * 8,
        pressure: 980 + Random().nextInt(60),
      ));
    }
    
    return HourlyWeatherData(
      cityName: 'Seoul',
      country: 'KR',
      hourlyForecasts: hourlyForecasts,
    );
  }

  WeeklyWeatherData createMockWeeklyWeatherData() {
    final now = DateTime.now();
    final weeklyForecasts = <DailyWeatherForecast>[];
    
    final weatherOptions = [
      'Clear Sky', 'Few Clouds', 'Scattered Clouds', 'Broken Clouds', 
      'Overcast Clouds', 'Light Rain', 'Rain', 'Snow', 'Mist'
    ];
    
    final iconOptions = [
      '01d', '02d', '03d', '04d', '09d', '10d', '11d', '13d', '50d'
    ];
    
    for (int i = 0; i < 7; i++) {
      final forecastDate = now.add(Duration(days: i));
      final baseTemp = 15 + Random().nextInt(15);
      final tempVariation = Random().nextInt(8) + 5;
      
      weeklyForecasts.add(DailyWeatherForecast(
        date: forecastDate,
        maxTemperature: (baseTemp + tempVariation).toDouble(),
        minTemperature: baseTemp.toDouble(),
        description: weatherOptions[Random().nextInt(weatherOptions.length)],
        iconCode: iconOptions[Random().nextInt(iconOptions.length)],
        humidity: 30 + Random().nextInt(60),
        windSpeed: Random().nextDouble() * 8,
        pressure: 980 + Random().nextInt(60),
      ));
    }
    
    return WeeklyWeatherData(
      cityName: 'Seoul',
      country: 'KR',
      dailyForecasts: weeklyForecasts,
    );
  }
}

/// Provider for random city data following SRP
/// 
/// This class is responsible only for providing city data for the random
/// weather exploration feature. It maintains a curated list of 68 major
/// cities worldwide with their coordinates.
/// 
/// ## Features
/// - 68 major cities across all continents
/// - Accurate latitude/longitude coordinates
/// - Random city selection for weather exploration
/// - Immutable city data access
/// 
/// ## Usage
/// 
/// ```dart
/// // Get a random city
/// final city = RandomCityProvider.getRandomCity();
/// print('${city['name']}, ${city['country']}'); // "Tokyo, JP"
/// 
/// // Get all available cities
/// final allCities = RandomCityProvider.getAllCities();
/// ```
class RandomCityProvider {
  static const List<Map<String, dynamic>> _cities = [
    {'latitude': 37.5665, 'longitude': 126.9780, 'name': 'Seoul', 'country': 'KR'},
    {'latitude': 35.6762, 'longitude': 139.6503, 'name': 'Tokyo', 'country': 'JP'},
    {'latitude': 39.9042, 'longitude': 116.4074, 'name': 'Beijing', 'country': 'CN'},
    {'latitude': 13.7563, 'longitude': 100.5018, 'name': 'Bangkok', 'country': 'TH'},
    {'latitude': 1.3521, 'longitude': 103.8198, 'name': 'Singapore', 'country': 'SG'},
    {'latitude': 14.5995, 'longitude': 120.9842, 'name': 'Manila', 'country': 'PH'},
    {'latitude': -6.2088, 'longitude': 106.8456, 'name': 'Jakarta', 'country': 'ID'},
    {'latitude': 3.1390, 'longitude': 101.6869, 'name': 'Kuala Lumpur', 'country': 'MY'},
    {'latitude': 10.8231, 'longitude': 106.6297, 'name': 'Ho Chi Minh City', 'country': 'VN'},
    {'latitude': 12.9716, 'longitude': 77.5946, 'name': 'Bangalore', 'country': 'IN'},
    {'latitude': 19.0760, 'longitude': 72.8777, 'name': 'Mumbai', 'country': 'IN'},
    {'latitude': 25.2048, 'longitude': 55.2708, 'name': 'Dubai', 'country': 'AE'},
    {'latitude': 35.6892, 'longitude': 51.3890, 'name': 'Tehran', 'country': 'IR'},
    {'latitude': 24.7136, 'longitude': 46.6753, 'name': 'Riyadh', 'country': 'SA'},
    {'latitude': 32.0853, 'longitude': 34.7818, 'name': 'Tel Aviv', 'country': 'IL'},
    {'latitude': 48.8566, 'longitude': 2.3522, 'name': 'Paris', 'country': 'FR'},
    {'latitude': 51.5074, 'longitude': -0.1278, 'name': 'London', 'country': 'GB'},
    {'latitude': 52.5200, 'longitude': 13.4050, 'name': 'Berlin', 'country': 'DE'},
    {'latitude': 41.9028, 'longitude': 12.4964, 'name': 'Rome', 'country': 'IT'},
    {'latitude': 52.3676, 'longitude': 4.9041, 'name': 'Amsterdam', 'country': 'NL'},
    {'latitude': 41.3851, 'longitude': 2.1734, 'name': 'Barcelona', 'country': 'ES'},
    {'latitude': 50.0755, 'longitude': 14.4378, 'name': 'Prague', 'country': 'CZ'},
    {'latitude': 59.3293, 'longitude': 18.0686, 'name': 'Stockholm', 'country': 'SE'},
    {'latitude': 48.2082, 'longitude': 16.3738, 'name': 'Vienna', 'country': 'AT'},
    {'latitude': 47.3769, 'longitude': 8.5417, 'name': 'Zurich', 'country': 'CH'},
    {'latitude': 55.7558, 'longitude': 37.6176, 'name': 'Moscow', 'country': 'RU'},
    {'latitude': 41.0082, 'longitude': 28.9784, 'name': 'Istanbul', 'country': 'TR'},
    {'latitude': 40.7128, 'longitude': -74.0060, 'name': 'New York', 'country': 'US'},
    {'latitude': 34.0522, 'longitude': -118.2437, 'name': 'Los Angeles', 'country': 'US'},
    {'latitude': 37.7749, 'longitude': -122.4194, 'name': 'San Francisco', 'country': 'US'},
    {'latitude': 47.6062, 'longitude': -122.3321, 'name': 'Seattle', 'country': 'US'},
    {'latitude': 41.8781, 'longitude': -87.6298, 'name': 'Chicago', 'country': 'US'},
    {'latitude': 42.3601, 'longitude': -71.0589, 'name': 'Boston', 'country': 'US'},
    {'latitude': 25.7617, 'longitude': -80.1918, 'name': 'Miami', 'country': 'US'},
    {'latitude': 38.9072, 'longitude': -77.0369, 'name': 'Washington DC', 'country': 'US'},
    {'latitude': 43.6532, 'longitude': -79.3832, 'name': 'Toronto', 'country': 'CA'},
    {'latitude': 49.2827, 'longitude': -123.1207, 'name': 'Vancouver', 'country': 'CA'},
    {'latitude': 19.4326, 'longitude': -99.1332, 'name': 'Mexico City', 'country': 'MX'},
    {'latitude': -34.6118, 'longitude': -58.3960, 'name': 'Buenos Aires', 'country': 'AR'},
    {'latitude': -22.9068, 'longitude': -43.1729, 'name': 'Rio de Janeiro', 'country': 'BR'},
    {'latitude': -33.4489, 'longitude': -70.6693, 'name': 'Santiago', 'country': 'CL'},
    {'latitude': -23.5505, 'longitude': -46.6333, 'name': 'São Paulo', 'country': 'BR'},
    {'latitude': 30.0444, 'longitude': 31.2357, 'name': 'Cairo', 'country': 'EG'},
    {'latitude': -26.2041, 'longitude': 28.0473, 'name': 'Johannesburg', 'country': 'ZA'},
    {'latitude': -1.2921, 'longitude': 36.8219, 'name': 'Nairobi', 'country': 'KE'},
    {'latitude': 33.5731, 'longitude': -7.5898, 'name': 'Casablanca', 'country': 'MA'},
    {'latitude': -33.8688, 'longitude': 151.2093, 'name': 'Sydney', 'country': 'AU'},
  ];

  static Map<String, dynamic> getRandomCity() {
    final randomIndex = Random().nextInt(_cities.length);
    return _cities[randomIndex];
  }

  static List<Map<String, dynamic>> getAllCities() => List.unmodifiable(_cities);
}