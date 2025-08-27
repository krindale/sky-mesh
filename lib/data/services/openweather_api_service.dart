import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/interfaces/weather_repository.dart';
import '../../core/interfaces/weather_interfaces.dart';
import '../../core/interfaces/location_service.dart';
import '../../core/models/weather_data.dart';
import '../../core/models/hourly_weather_data.dart';
import '../../core/models/weekly_weather_data.dart';
import '../../core/utils/logger.dart';

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
  static const String _uvUrl = 'http://api.openweathermap.org/data/2.5/uvi';
  static const String _airPollutionUrl = 'http://api.openweathermap.org/data/2.5/air_pollution';

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
      // Get basic weather data
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var weather = WeatherData.fromJson(data);
        
        // Enhance with UV index and air quality data
        weather = await _enhanceWeatherData(weather, latitude, longitude);
        
        return weather;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      Logger.debug('Error loading weather by coordinates: $e');
      return _weatherDataFactory.createMockWeatherData();
    }
  }
  
  /// Enhances weather data with UV index and air quality information
  Future<WeatherData> _enhanceWeatherData(WeatherData weather, double latitude, double longitude) async {
    try {
      // Get UV index data
      double? uvIndex = weather.uvIndex;
      try {
        final uvResponse = await http.get(
          Uri.parse('$_uvUrl?lat=$latitude&lon=$longitude&appid=$_apiKey'),
        );
        
        if (uvResponse.statusCode == 200) {
          final uvData = json.decode(uvResponse.body);
          uvIndex = uvData['value']?.toDouble();
          Logger.debug('📊 UV Index API: $uvIndex');
        }
      } catch (e) {
        Logger.warning('Failed to fetch UV index: $e');
      }
      
      // Get air quality data
      int? airQuality = weather.airQuality;
      double pm25 = weather.pm25;
      double pm10 = weather.pm10;
      
      try {
        final airResponse = await http.get(
          Uri.parse('$_airPollutionUrl?lat=$latitude&lon=$longitude&appid=$_apiKey'),
        );
        
        if (airResponse.statusCode == 200) {
          final airData = json.decode(airResponse.body);
          final components = airData['list'][0]['components'];
          
          airQuality = airData['list'][0]['main']['aqi'];
          pm25 = components['pm2_5']?.toDouble() ?? pm25;
          pm10 = components['pm10']?.toDouble() ?? pm10;
          
          Logger.debug('📊 Air Quality API: AQI=$airQuality, PM2.5=$pm25, PM10=$pm10');
        }
      } catch (e) {
        Logger.warning('Failed to fetch air quality: $e');
      }
      
      // Get precipitation probability from forecast
      double precipitationProbability = weather.precipitationProbability;
      try {
        final forecastResponse = await http.get(
          Uri.parse('$_forecastUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
        );
        
        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          final forecasts = forecastData['list'] as List;
          
          if (forecasts.isNotEmpty) {
            // Use first forecast entry for current precipitation probability
            precipitationProbability = forecasts[0]['pop']?.toDouble() ?? precipitationProbability;
            Logger.debug('📊 Precipitation probability: ${(precipitationProbability * 100).round()}%');
          }
        }
      } catch (e) {
        Logger.warning('Failed to fetch precipitation data: $e');
      }
      
      // Create enhanced weather data
      return WeatherData(
        temperature: weather.temperature,
        feelsLike: weather.feelsLike,
        humidity: weather.humidity,
        windSpeed: weather.windSpeed,
        description: weather.description,
        iconCode: weather.iconCode,
        cityName: weather.cityName,
        country: weather.country,
        pressure: weather.pressure,
        visibility: weather.visibility,
        uvIndex: uvIndex,
        airQuality: airQuality,
        pm25: pm25,
        pm10: pm10,
        precipitationProbability: precipitationProbability,
        latitude: weather.latitude,
        longitude: weather.longitude,
        sunrise: weather.sunrise,
        sunset: weather.sunset,
        timezone: weather.timezone, // 타임존 정보 추가
      );
      
    } catch (e) {
      Logger.warning('Error enhancing weather data: $e');
      return weather; // Return original data if enhancement fails
    }
  }

  @override
  Future<WeatherData> getRandomCityWeather() async {
    try {
      final randomCity = RandomCityProvider.getRandomCity();
      final latitude = randomCity['latitude'] as double;
      final longitude = randomCity['longitude'] as double;
      
      Logger.debug('🎲 Random city selected: ${randomCity['name']}, ${randomCity['country']} ($latitude, $longitude)');
      
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var weather = WeatherData.fromJson(data);
        
        // Enhance with UV index and air quality data
        weather = await _enhanceWeatherData(weather, latitude, longitude);
        
        return weather;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      Logger.debug('Error loading random city weather: $e');
      return _weatherDataFactory.createRandomMockWeatherData();
    }
  }

  @override
  Future<HourlyWeatherData> getHourlyWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return await getHourlyWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      Logger.debug('Error loading hourly weather: $e');
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
      Logger.debug('Error loading hourly weather by coordinates: $e');
      return _weatherDataFactory.createMockHourlyWeatherData();
    }
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return await getWeeklyWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      Logger.debug('Error loading weekly weather: $e');
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
      Logger.debug('Error loading weekly weather by coordinates: $e');
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
      uvIndex: 5.0,
      airQuality: 2,
      pm25: 15.0,
      pm10: 25.0,
      precipitationProbability: 0.2,
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
      uvIndex: Random().nextDouble() * 12, // 0-12 UV index
      airQuality: 1 + Random().nextInt(5),
      pm25: 5.0 + Random().nextDouble() * 50, // 5-55 µg/m³
      pm10: 10.0 + Random().nextDouble() * 80, // 10-90 µg/m³
      precipitationProbability: Random().nextDouble(), // 0.0-1.0
      latitude: randomCity['latitude'] as double,
      longitude: randomCity['longitude'] as double,
    );
  }

  HourlyWeatherData createMockHourlyWeatherData([String? cityName, String? countryCode]) {
    // 현재 선택된 도시의 timezone 정보 사용
    final timezone = (cityName != null && countryCode != null) 
        ? CityTimezoneProvider.getTimezone(cityName, countryCode)
        : null;
    
    final currentCityName = cityName ?? 'Seoul';
    final currentCountryCode = countryCode ?? 'KR';
    
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
        timezone: timezone, // 현재 선택된 도시의 시간대 사용
      ));
    }
    
    return HourlyWeatherData(
      cityName: currentCityName,
      country: currentCountryCode,
      hourlyForecasts: hourlyForecasts,
      timezone: timezone, // 현재 선택된 도시의 시간대 사용
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
/// Logger.debug(${city['name']}, ${city['country']}'); // "Tokyo, JP"
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
    {'latitude': 28.7041, 'longitude': 77.1025, 'name': 'Delhi', 'country': 'IN'},
    {'latitude': 31.2304, 'longitude': 121.4737, 'name': 'Shanghai', 'country': 'CN'},
    {'latitude': 25.0330, 'longitude': 121.5654, 'name': 'Taipei', 'country': 'TW'},
    {'latitude': 34.6937, 'longitude': 135.5023, 'name': 'Osaka', 'country': 'JP'},
    
    // 새로 추가된 아시아 도시들
    {'latitude': 43.0642, 'longitude': 141.3469, 'name': 'Sapporo', 'country': 'JP'},
    {'latitude': -8.3405, 'longitude': 115.0920, 'name': 'Bali', 'country': 'ID'},
    {'latitude': 7.8804, 'longitude': 98.3923, 'name': 'Phuket', 'country': 'TH'},
    {'latitude': 13.4125, 'longitude': 103.8670, 'name': 'Angkor Wat', 'country': 'KH'},
    {'latitude': 3.2028, 'longitude': 73.2207, 'name': 'Maldives', 'country': 'MV'},
    
    {'latitude': 25.2048, 'longitude': 55.2708, 'name': 'Dubai', 'country': 'AE'},
    {'latitude': 35.6892, 'longitude': 51.3890, 'name': 'Tehran', 'country': 'IR'},
    {'latitude': 24.7136, 'longitude': 46.6753, 'name': 'Riyadh', 'country': 'SA'},
    {'latitude': 32.0853, 'longitude': 34.7818, 'name': 'Tel Aviv', 'country': 'IL'},
    {'latitude': 25.2854, 'longitude': 51.5310, 'name': 'Doha', 'country': 'QA'},
    {'latitude': 30.3285, 'longitude': 35.4444, 'name': 'Petra', 'country': 'JO'},
    {'latitude': 48.8566, 'longitude': 2.3522, 'name': 'Paris', 'country': 'FR'},
    {'latitude': 51.5074, 'longitude': -0.1278, 'name': 'London', 'country': 'GB'},
    {'latitude': 52.5200, 'longitude': 13.4050, 'name': 'Berlin', 'country': 'DE'},
    {'latitude': 41.9028, 'longitude': 12.4964, 'name': 'Rome', 'country': 'IT'},
    {'latitude': 52.3676, 'longitude': 4.9041, 'name': 'Amsterdam', 'country': 'NL'},
    {'latitude': 41.3851, 'longitude': 2.1734, 'name': 'Barcelona', 'country': 'ES'},
    {'latitude': 40.4168, 'longitude': -3.7038, 'name': 'Madrid', 'country': 'ES'},
    {'latitude': 45.4642, 'longitude': 9.1900, 'name': 'Milan', 'country': 'IT'},
    {'latitude': 50.0755, 'longitude': 14.4378, 'name': 'Prague', 'country': 'CZ'},
    {'latitude': 59.3293, 'longitude': 18.0686, 'name': 'Stockholm', 'country': 'SE'},
    {'latitude': 48.2082, 'longitude': 16.3738, 'name': 'Vienna', 'country': 'AT'},
    {'latitude': 47.3769, 'longitude': 8.5417, 'name': 'Zurich', 'country': 'CH'},
    {'latitude': 55.7558, 'longitude': 37.6176, 'name': 'Moscow', 'country': 'RU'},
    {'latitude': 41.0082, 'longitude': 28.9784, 'name': 'Istanbul', 'country': 'TR'},
    
    // 새로 추가된 유럽 도시들
    {'latitude': 42.6420, 'longitude': 18.1081, 'name': 'Dubrovnik', 'country': 'HR'},
    {'latitude': 46.0207, 'longitude': 7.7491, 'name': 'Zermatt', 'country': 'CH'},
    {'latitude': 36.3932, 'longitude': 25.4615, 'name': 'Santorini', 'country': 'GR'},
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
    {'latitude': 45.5017, 'longitude': -73.5673, 'name': 'Montreal', 'country': 'CA'},
    {'latitude': 19.4326, 'longitude': -99.1332, 'name': 'Mexico City', 'country': 'MX'},
    
    // 새로 추가된 북미 도시들
    {'latitude': 21.1619, 'longitude': -86.8515, 'name': 'Cancun', 'country': 'MX'},
    {'latitude': 39.1911, 'longitude': -106.8175, 'name': 'Aspen', 'country': 'US'},
    {'latitude': -34.6118, 'longitude': -58.3960, 'name': 'Buenos Aires', 'country': 'AR'},
    {'latitude': -22.9068, 'longitude': -43.1729, 'name': 'Rio de Janeiro', 'country': 'BR'},
    {'latitude': -33.4489, 'longitude': -70.6693, 'name': 'Santiago', 'country': 'CL'},
    {'latitude': -23.5505, 'longitude': -46.6333, 'name': 'São Paulo', 'country': 'BR'},
    {'latitude': 4.7110, 'longitude': -74.0721, 'name': 'Bogotá', 'country': 'CO'},
    
    // 새로 추가된 남미 도시들
    {'latitude': -13.1631, 'longitude': -72.5450, 'name': 'Machu Picchu', 'country': 'PE'},
    {'latitude': 30.0444, 'longitude': 31.2357, 'name': 'Cairo', 'country': 'EG'},
    {'latitude': -26.2041, 'longitude': 28.0473, 'name': 'Johannesburg', 'country': 'ZA'},
    {'latitude': -1.2921, 'longitude': 36.8219, 'name': 'Nairobi', 'country': 'KE'},
    {'latitude': 33.5731, 'longitude': -7.5898, 'name': 'Casablanca', 'country': 'MA'},
    {'latitude': -33.9249, 'longitude': 18.4241, 'name': 'Cape Town', 'country': 'ZA'},
    {'latitude': -33.8688, 'longitude': 151.2093, 'name': 'Sydney', 'country': 'AU'},
    
    // 새로 추가된 오세아니아 도시들
    {'latitude': 21.3099, 'longitude': -157.8581, 'name': 'Hawaii', 'country': 'US'},
    {'latitude': -17.6797, 'longitude': -149.4068, 'name': 'Tahiti', 'country': 'PF'},
    {'latitude': -45.0312, 'longitude': 168.6626, 'name': 'Queenstown', 'country': 'NZ'},
  ];

  // 최근에 보여준 도시들을 저장하는 버퍼
  static final Set<String> _recentlyShownCities = <String>{};
  
  static Map<String, dynamic> getRandomCity() {
    // 사용 가능한 도시들 (최근에 보여준 도시들 제외)
    final availableCities = _cities.where((city) {
      return !_recentlyShownCities.contains(city['name']);
    }).toList();
    
    // 모든 도시가 보여졌다면 버퍼를 리셋
    if (availableCities.isEmpty) {
      _recentlyShownCities.clear();
      // 버퍼 리셋 후 다시 사용 가능한 도시들을 가져옴
      final allCities = List<Map<String, dynamic>>.from(_cities);
      final randomIndex = Random().nextInt(allCities.length);
      final selectedCity = allCities[randomIndex];
      
      // 선택된 도시를 버퍼에 추가
      _recentlyShownCities.add(selectedCity['name']);
      return selectedCity;
    }
    
    // 사용 가능한 도시 중에서 랜덤 선택
    final randomIndex = Random().nextInt(availableCities.length);
    final selectedCity = availableCities[randomIndex];
    
    // 선택된 도시를 버퍼에 추가
    _recentlyShownCities.add(selectedCity['name']);
    
    return selectedCity;
  }

  static List<Map<String, dynamic>> getAllCities() => List.unmodifiable(_cities);
  
  // 버퍼 상태 확인용 메서드 (디버깅/테스트용)
  static Set<String> getRecentlyShownCities() => Set.unmodifiable(_recentlyShownCities);
  
  // 버퍼 수동 리셋 메서드 (필요시 사용)
  static void resetRecentlyShownBuffer() {
    _recentlyShownCities.clear();
  }
}

/// City timezone provider for all cities with images in the app
/// 
/// Provides timezone offset information (seconds from UTC) for all cities
/// that have image assets in the SkyMesh app.
class CityTimezoneProvider {
  static const Map<String, Map<String, int>> _cityTimezones = {
    // Asia
    'Seoul': {'KR': 32400}, // UTC+9
    'Tokyo': {'JP': 32400}, // UTC+9
    'Osaka': {'JP': 32400}, // UTC+9
    'Sapporo': {'JP': 32400}, // UTC+9
    'Beijing': {'CN': 28800}, // UTC+8
    'Shanghai': {'CN': 28800}, // UTC+8
    'Bangkok': {'TH': 25200}, // UTC+7
    'Ho Chi Minh City': {'VN': 25200}, // UTC+7
    'Singapore': {'SG': 28800}, // UTC+8
    'Kuala Lumpur': {'MY': 28800}, // UTC+8
    'Manila': {'PH': 28800}, // UTC+8
    'Jakarta': {'ID': 25200}, // UTC+7
    'Bali': {'ID': 28800}, // UTC+8
    'Phuket': {'TH': 25200}, // UTC+7
    'Angkor Wat': {'KH': 25200}, // UTC+7
    'Maldives': {'MV': 18000}, // UTC+5
    'Bangalore': {'IN': 19800}, // UTC+5:30
    'Mumbai': {'IN': 19800}, // UTC+5:30
    'Delhi': {'IN': 19800}, // UTC+5:30
    'Taipei': {'TW': 28800}, // UTC+8

    // Middle East
    'Dubai': {'AE': 14400}, // UTC+4
    'Tehran': {'IR': 16200}, // UTC+4:30
    'Riyadh': {'SA': 10800}, // UTC+3
    'Tel Aviv': {'IL': 7200}, // UTC+2
    'Doha': {'QA': 10800}, // UTC+3
    'Petra': {'JO': 7200}, // UTC+2

    // Europe
    'Paris': {'FR': 3600}, // UTC+1
    'London': {'GB': 0}, // UTC+0
    'Berlin': {'DE': 3600}, // UTC+1
    'Rome': {'IT': 3600}, // UTC+1
    'Amsterdam': {'NL': 3600}, // UTC+1
    'Barcelona': {'ES': 3600}, // UTC+1
    'Madrid': {'ES': 3600}, // UTC+1
    'Milan': {'IT': 3600}, // UTC+1
    'Prague': {'CZ': 3600}, // UTC+1
    'Stockholm': {'SE': 3600}, // UTC+1
    'Vienna': {'AT': 3600}, // UTC+1
    'Zurich': {'CH': 3600}, // UTC+1
    'Moscow': {'RU': 10800}, // UTC+3
    'Istanbul': {'TR': 10800}, // UTC+3
    'Dubrovnik': {'HR': 3600}, // UTC+1
    'Zermatt': {'CH': 3600}, // UTC+1
    'Santorini': {'GR': 7200}, // UTC+2

    // North America
    'New York': {'US': -18000}, // UTC-5
    'Los Angeles': {'US': -28800}, // UTC-8
    'San Francisco': {'US': -28800}, // UTC-8
    'Seattle': {'US': -28800}, // UTC-8
    'Chicago': {'US': -21600}, // UTC-6
    'Boston': {'US': -18000}, // UTC-5
    'Miami': {'US': -18000}, // UTC-5
    'Washington DC': {'US': -18000}, // UTC-5
    'Toronto': {'CA': -18000}, // UTC-5
    'Vancouver': {'CA': -28800}, // UTC-8
    'Montreal': {'CA': -18000}, // UTC-5
    'Mexico City': {'MX': -21600}, // UTC-6
    'Cancun': {'MX': -18000}, // UTC-5
    'Aspen': {'US': -25200}, // UTC-7

    // South America
    'Buenos Aires': {'AR': -10800}, // UTC-3
    'Rio de Janeiro': {'BR': -10800}, // UTC-3
    'Santiago': {'CL': -10800}, // UTC-3
    'São Paulo': {'BR': -10800}, // UTC-3
    'Bogotá': {'CO': -18000}, // UTC-5
    'Machu Picchu': {'PE': -18000}, // UTC-5

    // Africa
    'Cairo': {'EG': 7200}, // UTC+2
    'Johannesburg': {'ZA': 7200}, // UTC+2
    'Nairobi': {'KE': 10800}, // UTC+3
    'Casablanca': {'MA': 0}, // UTC+0
    'Cape Town': {'ZA': 7200}, // UTC+2
    'Lagos': {'NG': 3600}, // UTC+1

    // Oceania
    'Sydney': {'AU': 39600}, // UTC+11
    'Melbourne': {'AU': 39600}, // UTC+11
    'Hawaii': {'US': -36000}, // UTC-10
    'Tahiti': {'PF': -36000}, // UTC-10
    'Queenstown': {'NZ': 46800}, // UTC+13
  };

  /// Get timezone offset in seconds from UTC for a city
  /// Returns null if city is not found
  static int? getTimezone(String cityName, String countryCode) {
    return _cityTimezones[cityName]?[countryCode];
  }

  /// Get all available cities with timezone information
  static Map<String, Map<String, int>> getAllTimezones() {
    return Map.unmodifiable(_cityTimezones);
  }

  /// Check if a city has timezone information
  static bool hasTimezone(String cityName, String countryCode) {
    return _cityTimezones[cityName]?.containsKey(countryCode) ?? false;
  }
}