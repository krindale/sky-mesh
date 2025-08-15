/// Daily weather forecast model following SRP (Single Responsibility Principle)
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

/// Container for weekly weather data following SRP
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
    
    // Group 5-day forecast data by day (8 data points per day: 3-hour intervals)
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
    
    // Calculate max/min temperatures for each day
    for (var entry in dailyData.entries) {
      if (dailyForecasts.length >= 7) break; // Maximum 7 days
      
      final dayData = entry.value;
      if (dayData.isEmpty) continue;
      
      double maxTemp = dayData.first['main']['temp_max'].toDouble();
      double minTemp = dayData.first['main']['temp_min'].toDouble();
      String description = dayData.first['weather'][0]['description'];
      String iconCode = dayData.first['weather'][0]['icon'];
      
      // Find max/min temperatures for the day
      for (var data in dayData) {
        maxTemp = [maxTemp, data['main']['temp_max'].toDouble()].reduce((a, b) => a > b ? a : b);
        minTemp = [minTemp, data['main']['temp_min'].toDouble()].reduce((a, b) => a < b ? a : b);
      }
      
      // Use weather information from noon time (around 12 PM)
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