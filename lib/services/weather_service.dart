import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  // OpenWeatherMap API key
  static const String _apiKey = 'a179131038d53e44738851b4938c5cd0';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // 랜덤 도시 목록 (위도, 경도, 도시명, 국가코드)
  static const List<List<dynamic>> _randomCities = [
    [37.5665, 126.9780, 'Seoul', 'KR'],
    [35.6762, 139.6503, 'Tokyo', 'JP'],
    [39.9042, 116.4074, 'Beijing', 'CN'],
    [13.7563, 100.5018, 'Bangkok', 'TH'],
    [1.3521, 103.8198, 'Singapore', 'SG'],
    [14.5995, 120.9842, 'Manila', 'PH'],
    [-6.2088, 106.8456, 'Jakarta', 'ID'],
    [3.1390, 101.6869, 'Kuala Lumpur', 'MY'],
    [10.8231, 106.6297, 'Ho Chi Minh City', 'VN'],
    [12.9716, 77.5946, 'Bangalore', 'IN'],
    [19.0760, 72.8777, 'Mumbai', 'IN'],
    
    [25.2048, 55.2708, 'Dubai', 'AE'],
    [35.6892, 51.3890, 'Tehran', 'IR'],
    [24.7136, 46.6753, 'Riyadh', 'SA'],
    [32.0853, 34.7818, 'Tel Aviv', 'IL'],
    
    [48.8566, 2.3522, 'Paris', 'FR'],
    [51.5074, -0.1278, 'London', 'GB'],
    [52.5200, 13.4050, 'Berlin', 'DE'],
    [41.9028, 12.4964, 'Rome', 'IT'],
    [52.3676, 4.9041, 'Amsterdam', 'NL'],
    [41.3851, 2.1734, 'Barcelona', 'ES'],
    [50.0755, 14.4378, 'Prague', 'CZ'],
    [59.3293, 18.0686, 'Stockholm', 'SE'],
    [48.2082, 16.3738, 'Vienna', 'AT'],
    [47.3769, 8.5417, 'Zurich', 'CH'],
    [55.7558, 37.6176, 'Moscow', 'RU'],
    [41.0082, 28.9784, 'Istanbul', 'TR'],
    
    [40.7128, -74.0060, 'New York', 'US'],
    [34.0522, -118.2437, 'Los Angeles', 'US'],
    [37.7749, -122.4194, 'San Francisco', 'US'],
    [47.6062, -122.3321, 'Seattle', 'US'],
    [41.8781, -87.6298, 'Chicago', 'US'],
    [42.3601, -71.0589, 'Boston', 'US'],
    [25.7617, -80.1918, 'Miami', 'US'],
    [38.9072, -77.0369, 'Washington DC', 'US'],
    [43.6532, -79.3832, 'Toronto', 'CA'],
    [49.2827, -123.1207, 'Vancouver', 'CA'],
    [19.4326, -99.1332, 'Mexico City', 'MX'],
    
    [-34.6118, -58.3960, 'Buenos Aires', 'AR'],
    [-22.9068, -43.1729, 'Rio de Janeiro', 'BR'],
    [-33.4489, -70.6693, 'Santiago', 'CL'],
    [-23.5505, -46.6333, 'São Paulo', 'BR'],
    
    [30.0444, 31.2357, 'Cairo', 'EG'],
    [-26.2041, 28.0473, 'Johannesburg', 'ZA'],
    [-1.2921, 36.8219, 'Nairobi', 'KE'],
    [33.5731, -7.5898, 'Casablanca', 'MA'],
    
    [-33.8688, 151.2093, 'Sydney', 'AU'],
  ];

  Future<WeatherData> getRandomCityWeather() async {
    try {
      // 랜덤 도시 선택
      final randomIndex = Random().nextInt(_randomCities.length);
      final cityData = _randomCities[randomIndex];
      
      final latitude = cityData[0];
      final longitude = cityData[1];
      final cityName = cityData[2];
      final countryCode = cityData[3];
      
      print('🎲 Random city selected: $cityName, $countryCode ($latitude, $longitude)');
      
      // 선택된 도시의 날씨 데이터 가져오기
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
      // 실패 시 랜덤 목 데이터 반환
      return _getRandomMockWeatherData();
    }
  }

  Future<WeatherData> getCurrentWeather() async {
    try {
      // Get current location
      Position position = await _getCurrentLocation();
      
      // Fetch weather data
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return _getMockWeatherData();
    }
  }

  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      // Fetch weather data by coordinates
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
      // Return mock data for development
      return _getMockWeatherData();
    }
  }

  Future<Position> _getCurrentLocation() async {
    // Check if running on web and provide specific guidance
    if (kIsWeb) {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled. Please enable location in your browser settings.');
        }
      } catch (e) {
        throw Exception('Web location not available. Please use HTTPS or allow location access.');
      }
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kIsWeb) {
          throw Exception('Location permission denied. Please allow location access in your browser.');
        } else {
          throw Exception('Location permissions are denied');
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kIsWeb) {
        throw Exception('Location permanently blocked. Please reset site permissions in browser settings.');
      } else {
        throw Exception('Location permissions are permanently denied. Please enable in app settings.');
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kIsWeb) {
        throw Exception('Cannot get location. Please ensure you\'re using HTTPS and allow location access.');
      } else {
        throw Exception('Failed to get current location: $e');
      }
    }
  }

  WeatherData _getMockWeatherData() {
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
      latitude: 37.5665,
      longitude: 126.9780,
    );
  }

  WeatherData _getRandomMockWeatherData() {
    final randomIndex = Random().nextInt(_randomCities.length);
    final cityData = _randomCities[randomIndex];
    
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
    final randomTemp = 5 + Random().nextInt(30); // 5-35도
    
    return WeatherData(
      temperature: randomTemp.toDouble(),
      feelsLike: randomTemp + Random().nextInt(5).toDouble() - 2,
      humidity: 30 + Random().nextInt(60), // 30-90%
      windSpeed: Random().nextDouble() * 8, // 0-8 m/s
      description: randomWeather,
      iconCode: randomIcon,
      cityName: cityData[2],
      country: cityData[3],
      pressure: 980 + Random().nextInt(60), // 980-1040 hPa
      visibility: 5000 + Random().nextInt(10000), // 5-15km
      uvIndex: Random().nextInt(11), // 0-10
      latitude: cityData[0],
      longitude: cityData[1],
    );
  }
}

class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final String cityName;
  final String country;
  final int pressure;
  final int visibility;
  final int uvIndex;
  final double? latitude;
  final double? longitude;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.cityName,
    required this.country,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    this.latitude,
    this.longitude,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      cityName: json['name'],
      country: json['sys']['country'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'] ?? 10000,
      uvIndex: 5, // UV index requires separate API call
      latitude: json['coord']['lat']?.toDouble(),
      longitude: json['coord']['lon']?.toDouble(),
    );
  }

  String get temperatureString => '${temperature.round()}°';
  String get feelsLikeString => '${feelsLike.round()}°';
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} m/s';
  String get humidityString => '$humidity%';
  String get pressureString => '${pressure} hPa';
  String get visibilityString => '${(visibility / 1000).toStringAsFixed(1)} km';
  String get uvIndexString => uvIndex.toString();
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}