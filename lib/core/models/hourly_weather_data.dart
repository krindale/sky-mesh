/// Hourly weather forecast model following SRP (Single Responsibility Principle)
class HourlyWeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int? timezone; // 시간대 오프셋 (초 단위)

  HourlyWeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    this.timezone,
  });

  factory HourlyWeatherForecast.fromJson(Map<String, dynamic> json, {int? timezone}) {
    return HourlyWeatherForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      timezone: timezone,
    );
  }

  String get temperatureString => '${temperature.round()}°';
  String get hour {
    // 도시의 시간대를 사용하여 로컬 시간 계산
    DateTime displayTime;
    if (timezone != null) {
      // UTC 시간에 시간대 오프셋을 더해서 도시 로컬 시간 계산
      displayTime = dateTime.add(Duration(seconds: timezone!));
    } else {
      // 시간대 정보가 없으면 기기의 로컬 시간 사용 (기존 동작)
      displayTime = dateTime.toLocal();
    }
    return '${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}';
  }
  
  String get capitalizedDescription {
    return description.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }
}

/// Container for hourly weather data following SRP
class HourlyWeatherData {
  final String cityName;
  final String country;
  final List<HourlyWeatherForecast> hourlyForecasts;
  final int? timezone; // 시간대 오프셋 (초 단위)

  HourlyWeatherData({
    required this.cityName,
    required this.country,
    required this.hourlyForecasts,
    this.timezone,
  });

  factory HourlyWeatherData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    final timezone = json['city']['timezone'] as int?; // 시간대 오프셋 (초 단위)
    final hourlyForecasts = list.take(24).map((item) => 
      HourlyWeatherForecast.fromJson(item, timezone: timezone)
    ).toList();
    
    return HourlyWeatherData(
      cityName: json['city']['name'],
      country: json['city']['country'],
      hourlyForecasts: hourlyForecasts,
      timezone: timezone,
    );
  }
}