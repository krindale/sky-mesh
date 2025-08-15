import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  // OpenWeatherMap API key
  static const String _apiKey = 'a179131038d53e44738851b4938c5cd0';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

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

  Future<HourlyWeatherData> getHourlyWeather() async {
    try {
      Position position = await _getCurrentLocation();
      
      final response = await http.get(
        Uri.parse('$_forecastUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HourlyWeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load hourly weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading hourly weather: $e');
      return _getMockHourlyWeatherData();
    }
  }

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
      return _getMockHourlyWeatherData();
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
      airQuality: 2,
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
      airQuality: 1 + Random().nextInt(5), // 1-5 (Good to Hazardous)
      latitude: cityData[0],
      longitude: cityData[1],
    );
  }

  HourlyWeatherData _getMockHourlyWeatherData() {
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
      final baseTemp = 15 + Random().nextInt(20); // 15-35도
      final tempVariation = Random().nextInt(6) - 3; // -3~+3도 변화
      
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

  Future<WeeklyWeatherData> getWeeklyWeather() async {
    try {
      Position position = await _getCurrentLocation();
      
      final response = await http.get(
        Uri.parse('$_forecastUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeeklyWeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weekly weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading weekly weather: $e');
      return _getMockWeeklyWeatherData();
    }
  }

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
      return _getMockWeeklyWeatherData();
    }
  }

  WeeklyWeatherData _getMockWeeklyWeatherData() {
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
      final baseTemp = 15 + Random().nextInt(15); // 15-30도
      final tempVariation = Random().nextInt(8) + 5; // 5-12도 차이
      
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
  final int airQuality; // 대기질 추가
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
    required this.airQuality,
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
      airQuality: 2, // Air quality - mock data (1-5 scale)
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
  String get airQualityString => airQuality.toString();
  
  // 숫자와 단위 분리된 버전
  String get windSpeedNumber => windSpeed.toStringAsFixed(1);
  String get windSpeedUnit => 'm/s';
  String get humidityNumber => humidity.toString();
  String get humidityUnit => '%';
  String get pressureNumber => pressure.toString();
  String get pressureUnit => 'hPa';
  String get visibilityNumber => (visibility / 1000).toStringAsFixed(1);
  String get visibilityUnit => 'km';
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}

class HourlyWeatherData {
  final String cityName;
  final String country;
  final List<HourlyWeatherForecast> hourlyForecasts;

  HourlyWeatherData({
    required this.cityName,
    required this.country,
    required this.hourlyForecasts,
  });

  factory HourlyWeatherData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    final hourlyForecasts = list.take(24).map((item) => 
      HourlyWeatherForecast.fromJson(item)
    ).toList();
    
    return HourlyWeatherData(
      cityName: json['city']['name'],
      country: json['city']['country'],
      hourlyForecasts: hourlyForecasts,
    );
  }
}

class HourlyWeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;

  HourlyWeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  factory HourlyWeatherForecast.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
    );
  }

  String get temperatureString => '${temperature.round()}°';
  String get hour => '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}

class WeeklyWeatherData {
  final String cityName;
  final String country;
  final List<DailyWeatherForecast> dailyForecasts;

  WeeklyWeatherData({
    required this.cityName,
    required this.country,
    required this.dailyForecasts,
  });

  factory WeeklyWeatherData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    
    // 5일 예보 데이터를 일별로 그룹화 (하루에 8개 데이터: 3시간 간격)
    final Map<String, List<dynamic>> dailyData = {};
    
    for (var item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = [];
      }
      dailyData[dateKey]!.add(item);
    }
    
    final dailyForecasts = <DailyWeatherForecast>[];
    
    // 일별 데이터에서 최고/최저 온도 계산
    for (var entry in dailyData.entries) {
      if (dailyForecasts.length >= 7) break; // 최대 7일
      
      final dayData = entry.value;
      if (dayData.isEmpty) continue;
      
      double maxTemp = dayData.first['main']['temp_max'].toDouble();
      double minTemp = dayData.first['main']['temp_min'].toDouble();
      String description = dayData.first['weather'][0]['description'];
      String iconCode = dayData.first['weather'][0]['icon'];
      
      // 하루 중 최고/최저 온도 찾기
      for (var data in dayData) {
        maxTemp = [maxTemp, data['main']['temp_max'].toDouble()].reduce((a, b) => a > b ? a : b);
        minTemp = [minTemp, data['main']['temp_min'].toDouble()].reduce((a, b) => a < b ? a : b);
      }
      
      // 낮 시간대의 날씨 정보 사용 (12시 근처)
      var noonData = dayData.firstWhere(
        (data) {
          final dt = DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000);
          return dt.hour >= 12 && dt.hour <= 15;
        },
        orElse: () => dayData.first,
      );
      
      description = noonData['weather'][0]['description'];
      iconCode = noonData['weather'][0]['icon'];
      
      dailyForecasts.add(DailyWeatherForecast(
        date: DateTime.fromMillisecondsSinceEpoch(dayData.first['dt'] * 1000),
        maxTemperature: maxTemp,
        minTemperature: minTemp,
        description: description,
        iconCode: iconCode,
        humidity: noonData['main']['humidity'],
        windSpeed: noonData['wind']['speed'].toDouble(),
        pressure: noonData['main']['pressure'],
      ));
    }
    
    return WeeklyWeatherData(
      cityName: json['city']['name'],
      country: json['city']['country'],
      dailyForecasts: dailyForecasts,
    );
  }
}

class DailyWeatherForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;

  DailyWeatherForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  String get maxTemperatureString => '${maxTemperature.round()}°';
  String get minTemperatureString => '${minTemperature.round()}°';
  
  String get dayOfWeek {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return weekdays[date.weekday % 7];
  }
  
  String get dateString => '${date.month}/${date.day}';
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
  
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}