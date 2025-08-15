/// Hourly weather forecast model following SRP (Single Responsibility Principle)
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

/// Container for hourly weather data following SRP
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