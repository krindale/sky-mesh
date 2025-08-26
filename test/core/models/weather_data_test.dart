import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/models/weather_data.dart';

void main() {
  group('WeatherData Model Tests', () {
    late WeatherData testWeatherData;
    late Map<String, dynamic> mockApiResponse;

    setUp(() {
      testWeatherData = WeatherData(
        temperature: 22.5,
        feelsLike: 24.2,
        humidity: 65,
        windSpeed: 3.4,
        description: 'partly cloudy',
        iconCode: '02d',
        cityName: 'Seoul',
        country: 'KR',
        pressure: 1013,
        visibility: 10000,
        uvIndex: 5.2,
        airQuality: 2,
        pm25: 15.3,
        pm10: 28.7,
        precipitationProbability: 0.25,
        latitude: 37.5665,
        longitude: 126.9780,
        sunrise: DateTime(2024, 1, 1, 7, 30),
        sunset: DateTime(2024, 1, 1, 17, 45),
      );

      mockApiResponse = {
        'main': {
          'temp': 22.5,
          'feels_like': 24.2,
          'humidity': 65,
          'pressure': 1013,
        },
        'wind': {
          'speed': 3.4,
        },
        'weather': [
          {
            'description': 'partly cloudy',
            'icon': '02d',
          }
        ],
        'name': 'Seoul',
        'sys': {
          'country': 'KR',
          'sunrise': 1641009000,
          'sunset': 1641046500,
        },
        'visibility': 10000,
        'coord': {
          'lat': 37.5665,
          'lon': 126.9780,
        }
      };
    });

    group('Constructor Tests', () {
      testWidgets('creates WeatherData with all required fields', (WidgetTester tester) async {
        final weather = WeatherData(
          temperature: 20.0,
          feelsLike: 22.0,
          humidity: 60,
          windSpeed: 2.5,
          description: 'clear sky',
          iconCode: '01d',
          cityName: 'Tokyo',
          country: 'JP',
          pressure: 1015,
          visibility: 8000,
          pm25: 12.0,
          pm10: 25.0,
          precipitationProbability: 0.1,
        );

        expect(weather.temperature, 20.0);
        expect(weather.feelsLike, 22.0);
        expect(weather.humidity, 60);
        expect(weather.windSpeed, 2.5);
        expect(weather.description, 'clear sky');
        expect(weather.iconCode, '01d');
        expect(weather.cityName, 'Tokyo');
        expect(weather.country, 'JP');
        expect(weather.pressure, 1015);
        expect(weather.visibility, 8000);
        expect(weather.pm25, 12.0);
        expect(weather.pm10, 25.0);
        expect(weather.precipitationProbability, 0.1);
      });

      testWidgets('handles optional fields correctly', (WidgetTester tester) async {
        final weather = WeatherData(
          temperature: 25.0,
          feelsLike: 27.0,
          humidity: 70,
          windSpeed: 4.0,
          description: 'sunny',
          iconCode: '01d',
          cityName: 'Bangkok',
          country: 'TH',
          pressure: 1008,
          visibility: 15000,
          uvIndex: 8.5,
          airQuality: 3,
          pm25: 35.2,
          pm10: 55.8,
          precipitationProbability: 0.05,
          latitude: 13.7563,
          longitude: 100.5018,
          sunrise: DateTime(2024, 6, 15, 6, 0),
          sunset: DateTime(2024, 6, 15, 18, 30),
        );

        expect(weather.uvIndex, 8.5);
        expect(weather.airQuality, 3);
        expect(weather.latitude, 13.7563);
        expect(weather.longitude, 100.5018);
        expect(weather.sunrise, isA<DateTime>());
        expect(weather.sunset, isA<DateTime>());
      });

      testWidgets('handles null optional fields gracefully', (WidgetTester tester) async {
        final weather = WeatherData(
          temperature: 15.0,
          feelsLike: 13.0,
          humidity: 80,
          windSpeed: 5.2,
          description: 'rainy',
          iconCode: '10d',
          cityName: 'London',
          country: 'GB',
          pressure: 995,
          visibility: 5000,
          pm25: 18.5,
          pm10: 32.1,
          precipitationProbability: 0.85,
        );

        expect(weather.uvIndex, isNull);
        expect(weather.airQuality, isNull);
        expect(weather.latitude, isNull);
        expect(weather.longitude, isNull);
        expect(weather.sunrise, isNull);
        expect(weather.sunset, isNull);
      });
    });

    group('fromJson Factory Tests', () {
      testWidgets('creates WeatherData from valid API response', (WidgetTester tester) async {
        final weather = WeatherData.fromJson(mockApiResponse);

        expect(weather.temperature, 22.5);
        expect(weather.feelsLike, 24.2);
        expect(weather.humidity, 65);
        expect(weather.windSpeed, 3.4);
        expect(weather.description, 'partly cloudy');
        expect(weather.iconCode, '02d');
        expect(weather.cityName, 'Seoul');
        expect(weather.country, 'KR');
        expect(weather.pressure, 1013);
        expect(weather.visibility, 10000);
        expect(weather.latitude, 37.5665);
        expect(weather.longitude, 126.9780);
        expect(weather.sunrise, isA<DateTime>());
        expect(weather.sunset, isA<DateTime>());
      });

      testWidgets('handles missing visibility with default value', (WidgetTester tester) async {
        final responseWithoutVisibility = Map<String, dynamic>.from(mockApiResponse);
        responseWithoutVisibility.remove('visibility');

        final weather = WeatherData.fromJson(responseWithoutVisibility);

        expect(weather.visibility, 10000); // Default value
      });

      testWidgets('handles missing coordinate data gracefully', (WidgetTester tester) async {
        final responseWithoutCoords = Map<String, dynamic>.from(mockApiResponse);
        responseWithoutCoords.remove('coord');

        final weather = WeatherData.fromJson(responseWithoutCoords);

        expect(weather.latitude, isNull);
        expect(weather.longitude, isNull);
      });

      testWidgets('handles missing sunrise/sunset data gracefully', (WidgetTester tester) async {
        final responseWithoutSunTimes = Map<String, dynamic>.from(mockApiResponse);
        responseWithoutSunTimes['sys'].remove('sunrise');
        responseWithoutSunTimes['sys'].remove('sunset');

        final weather = WeatherData.fromJson(responseWithoutSunTimes);

        expect(weather.sunrise, isNull);
        expect(weather.sunset, isNull);
      });

      testWidgets('sets default values for UV and air quality data', (WidgetTester tester) async {
        final weather = WeatherData.fromJson(mockApiResponse);

        expect(weather.uvIndex, isNull);
        expect(weather.airQuality, isNull);
        expect(weather.pm25, 0.0);
        expect(weather.pm10, 0.0);
        expect(weather.precipitationProbability, 0.0);
      });

      testWidgets('handles integer temperature values correctly', (WidgetTester tester) async {
        final responseWithIntTemp = Map<String, dynamic>.from(mockApiResponse);
        responseWithIntTemp['main']['temp'] = 25;
        responseWithIntTemp['main']['feels_like'] = 27;

        final weather = WeatherData.fromJson(responseWithIntTemp);

        expect(weather.temperature, 25.0);
        expect(weather.feelsLike, 27.0);
      });
    });

    group('Formatted String Getters Tests', () {
      testWidgets('temperatureString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.temperatureString, '23°');
        
        final coldWeather = WeatherData(
          temperature: -5.3,
          feelsLike: -8.1,
          humidity: 45,
          windSpeed: 2.1,
          description: 'snow',
          iconCode: '13d',
          cityName: 'Moscow',
          country: 'RU',
          pressure: 1020,
          visibility: 3000,
          pm25: 8.2,
          pm10: 15.5,
          precipitationProbability: 0.9,
        );
        
        expect(coldWeather.temperatureString, '-5°');
      });

      testWidgets('feelsLikeString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.feelsLikeString, '24°');
      });

      testWidgets('windSpeedString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.windSpeedString, '3.4 m/s');
        
        final highWindWeather = WeatherData(
          temperature: 18.0,
          feelsLike: 16.0,
          humidity: 55,
          windSpeed: 12.67,
          description: 'windy',
          iconCode: '03d',
          cityName: 'Chicago',
          country: 'US',
          pressure: 1005,
          visibility: 12000,
          pm25: 22.1,
          pm10: 38.9,
          precipitationProbability: 0.3,
        );
        
        expect(highWindWeather.windSpeedString, '12.7 m/s');
      });

      testWidgets('humidityString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.humidityString, '65%');
      });

      testWidgets('pressureString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.pressureString, '1013 hPa');
      });

      testWidgets('visibilityString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.visibilityString, '10.0 km');
        
        final foggyWeather = WeatherData(
          temperature: 12.0,
          feelsLike: 10.0,
          humidity: 95,
          windSpeed: 0.5,
          description: 'fog',
          iconCode: '50d',
          cityName: 'San Francisco',
          country: 'US',
          pressure: 1016,
          visibility: 500,
          pm25: 12.3,
          pm10: 20.8,
          precipitationProbability: 0.15,
        );
        
        expect(foggyWeather.visibilityString, '0.5 km');
      });

      testWidgets('uvIndexString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.uvIndexString, '5');
        
        final weatherWithoutUV = WeatherData(
          temperature: 20.0,
          feelsLike: 22.0,
          humidity: 60,
          windSpeed: 2.0,
          description: 'cloudy',
          iconCode: '04d',
          cityName: 'Berlin',
          country: 'DE',
          pressure: 1012,
          visibility: 8000,
          pm25: 14.5,
          pm10: 26.3,
          precipitationProbability: 0.4,
        );
        
        expect(weatherWithoutUV.uvIndexString, '-');
      });

      testWidgets('airQualityString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.airQualityString, '2');
        
        final weatherWithoutAQ = WeatherData(
          temperature: 28.0,
          feelsLike: 32.0,
          humidity: 75,
          windSpeed: 1.5,
          description: 'hot',
          iconCode: '01d',
          cityName: 'Dubai',
          country: 'AE',
          pressure: 1010,
          visibility: 15000,
          pm25: 45.2,
          pm10: 78.6,
          precipitationProbability: 0.02,
        );
        
        expect(weatherWithoutAQ.airQualityString, '-');
      });

      testWidgets('pm25String and pm10String format correctly', (WidgetTester tester) async {
        expect(testWeatherData.pm25String, '15.3 µg/m³');
        expect(testWeatherData.pm10String, '28.7 µg/m³');
      });

      testWidgets('precipitationProbabilityString formats correctly', (WidgetTester tester) async {
        expect(testWeatherData.precipitationProbabilityString, '25%');
        
        final rainyWeather = WeatherData(
          temperature: 16.0,
          feelsLike: 15.0,
          humidity: 90,
          windSpeed: 4.8,
          description: 'heavy rain',
          iconCode: '10d',
          cityName: 'Mumbai',
          country: 'IN',
          pressure: 998,
          visibility: 2000,
          pm25: 65.4,
          pm10: 98.7,
          precipitationProbability: 0.95,
        );
        
        expect(rainyWeather.precipitationProbabilityString, '95%');
      });
    });

    group('Separated Number and Unit Getters Tests', () {
      testWidgets('wind speed number and unit separated correctly', (WidgetTester tester) async {
        expect(testWeatherData.windSpeedNumber, '3.4');
        expect(testWeatherData.windSpeedUnit, 'm/s');
      });

      testWidgets('humidity number and unit separated correctly', (WidgetTester tester) async {
        expect(testWeatherData.humidityNumber, '65');
        expect(testWeatherData.humidityUnit, '%');
      });

      testWidgets('pressure number and unit separated correctly', (WidgetTester tester) async {
        expect(testWeatherData.pressureNumber, '1013');
        expect(testWeatherData.pressureUnit, 'hPa');
      });

      testWidgets('visibility number and unit separated correctly', (WidgetTester tester) async {
        expect(testWeatherData.visibilityNumber, '10.0');
        expect(testWeatherData.visibilityUnit, 'km');
      });
    });

    group('Description Capitalization Tests', () {
      testWidgets('capitalizes single word descriptions correctly', (WidgetTester tester) async {
        final sunnyWeather = WeatherData(
          temperature: 30.0,
          feelsLike: 35.0,
          humidity: 40,
          windSpeed: 2.0,
          description: 'sunny',
          iconCode: '01d',
          cityName: 'Phoenix',
          country: 'US',
          pressure: 1015,
          visibility: 20000,
          pm25: 8.1,
          pm10: 16.3,
          precipitationProbability: 0.0,
        );
        
        expect(sunnyWeather.capitalizedDescription, 'Sunny');
      });

      testWidgets('capitalizes multi-word descriptions correctly', (WidgetTester tester) async {
        expect(testWeatherData.capitalizedDescription, 'Partly Cloudy');
        
        final stormyWeather = WeatherData(
          temperature: 19.0,
          feelsLike: 17.0,
          humidity: 85,
          windSpeed: 8.5,
          description: 'heavy thunderstorm with rain',
          iconCode: '11d',
          cityName: 'Miami',
          country: 'US',
          pressure: 990,
          visibility: 3000,
          pm25: 28.4,
          pm10: 45.6,
          precipitationProbability: 0.98,
        );
        
        expect(stormyWeather.capitalizedDescription, 'Heavy Thunderstorm With Rain');
      });

      testWidgets('handles descriptions with special characters', (WidgetTester tester) async {
        final specialWeather = WeatherData(
          temperature: 14.0,
          feelsLike: 12.0,
          humidity: 78,
          windSpeed: 3.2,
          description: 'light rain-shower',
          iconCode: '09d',
          cityName: 'Amsterdam',
          country: 'NL',
          pressure: 1008,
          visibility: 6000,
          pm25: 16.7,
          pm10: 29.4,
          precipitationProbability: 0.6,
        );
        
        expect(specialWeather.capitalizedDescription, 'Light Rain-shower');
      });

      testWidgets('handles empty word components gracefully', (WidgetTester tester) async {
        final emptyWeather = WeatherData(
          temperature: 21.0,
          feelsLike: 23.0,
          humidity: 58,
          windSpeed: 2.8,
          description: ' scattered  clouds ',
          iconCode: '03d',
          cityName: 'Madrid',
          country: 'ES',
          pressure: 1018,
          visibility: 12000,
          pm25: 11.2,
          pm10: 19.8,
          precipitationProbability: 0.12,
        );
        
        expect(emptyWeather.capitalizedDescription, ' Scattered  Clouds ');
      });
    });

    group('Edge Cases and Boundary Values Tests', () {
      testWidgets('handles zero values correctly', (WidgetTester tester) async {
        final zeroWeather = WeatherData(
          temperature: 0.0,
          feelsLike: 0.0,
          humidity: 0,
          windSpeed: 0.0,
          description: 'calm',
          iconCode: '01d',
          cityName: 'Antarctica',
          country: 'AQ',
          pressure: 1000,
          visibility: 0,
          pm25: 0.0,
          pm10: 0.0,
          precipitationProbability: 0.0,
        );

        expect(zeroWeather.temperatureString, '0°');
        expect(zeroWeather.feelsLikeString, '0°');
        expect(zeroWeather.humidityString, '0%');
        expect(zeroWeather.windSpeedString, '0.0 m/s');
        expect(zeroWeather.visibilityString, '0.0 km');
        expect(zeroWeather.pm25String, '0.0 µg/m³');
        expect(zeroWeather.pm10String, '0.0 µg/m³');
        expect(zeroWeather.precipitationProbabilityString, '0%');
      });

      testWidgets('handles extreme high values correctly', (WidgetTester tester) async {
        final extremeWeather = WeatherData(
          temperature: 50.0,
          feelsLike: 60.0,
          humidity: 100,
          windSpeed: 50.0,
          description: 'extreme heat',
          iconCode: '01d',
          cityName: 'Death Valley',
          country: 'US',
          pressure: 1050,
          visibility: 50000,
          uvIndex: 15.0,
          airQuality: 5,
          pm25: 500.0,
          pm10: 1000.0,
          precipitationProbability: 1.0,
        );

        expect(extremeWeather.temperatureString, '50°');
        expect(extremeWeather.feelsLikeString, '60°');
        expect(extremeWeather.humidityString, '100%');
        expect(extremeWeather.windSpeedString, '50.0 m/s');
        expect(extremeWeather.visibilityString, '50.0 km');
        expect(extremeWeather.uvIndexString, '15');
        expect(extremeWeather.airQualityString, '5');
        expect(extremeWeather.pm25String, '500.0 µg/m³');
        expect(extremeWeather.pm10String, '1000.0 µg/m³');
        expect(extremeWeather.precipitationProbabilityString, '100%');
      });

      testWidgets('handles negative extreme values correctly', (WidgetTester tester) async {
        final coldWeather = WeatherData(
          temperature: -40.0,
          feelsLike: -50.0,
          humidity: 20,
          windSpeed: 15.0,
          description: 'extreme cold',
          iconCode: '13d',
          cityName: 'Siberia',
          country: 'RU',
          pressure: 1040,
          visibility: 1000,
          pm25: 2.0,
          pm10: 5.0,
          precipitationProbability: 0.1,
        );

        expect(coldWeather.temperatureString, '-40°');
        expect(coldWeather.feelsLikeString, '-50°');
        expect(coldWeather.visibilityString, '1.0 km');
      });

      testWidgets('handles decimal precision correctly', (WidgetTester tester) async {
        final preciseWeather = WeatherData(
          temperature: 22.678,
          feelsLike: 24.123,
          humidity: 67,
          windSpeed: 3.456789,
          description: 'precise conditions',
          iconCode: '02d',
          cityName: 'Precision City',
          country: 'XX',
          pressure: 1013,
          visibility: 9876,
          pm25: 15.6789,
          pm10: 28.1234,
          precipitationProbability: 0.2567,
        );

        expect(preciseWeather.temperatureString, '23°'); // Rounds correctly
        expect(preciseWeather.feelsLikeString, '24°'); // Rounds correctly
        expect(preciseWeather.windSpeedString, '3.5 m/s'); // 1 decimal place
        expect(preciseWeather.visibilityString, '9.9 km'); // 1 decimal place
        expect(preciseWeather.pm25String, '15.7 µg/m³'); // 1 decimal place
        expect(preciseWeather.pm10String, '28.1 µg/m³'); // 1 decimal place
        expect(preciseWeather.precipitationProbabilityString, '26%'); // Rounds percentage
      });
    });

    group('Data Type Validation Tests', () {
      testWidgets('all required fields are non-null', (WidgetTester tester) async {
        expect(testWeatherData.temperature, isNotNull);
        expect(testWeatherData.feelsLike, isNotNull);
        expect(testWeatherData.humidity, isNotNull);
        expect(testWeatherData.windSpeed, isNotNull);
        expect(testWeatherData.description, isNotNull);
        expect(testWeatherData.iconCode, isNotNull);
        expect(testWeatherData.cityName, isNotNull);
        expect(testWeatherData.country, isNotNull);
        expect(testWeatherData.pressure, isNotNull);
        expect(testWeatherData.visibility, isNotNull);
        expect(testWeatherData.pm25, isNotNull);
        expect(testWeatherData.pm10, isNotNull);
        expect(testWeatherData.precipitationProbability, isNotNull);
      });

      testWidgets('numeric fields have correct types', (WidgetTester tester) async {
        expect(testWeatherData.temperature, isA<double>());
        expect(testWeatherData.feelsLike, isA<double>());
        expect(testWeatherData.humidity, isA<int>());
        expect(testWeatherData.windSpeed, isA<double>());
        expect(testWeatherData.pressure, isA<int>());
        expect(testWeatherData.visibility, isA<int>());
        expect(testWeatherData.pm25, isA<double>());
        expect(testWeatherData.pm10, isA<double>());
        expect(testWeatherData.precipitationProbability, isA<double>());
      });

      testWidgets('string fields have correct types', (WidgetTester tester) async {
        expect(testWeatherData.description, isA<String>());
        expect(testWeatherData.iconCode, isA<String>());
        expect(testWeatherData.cityName, isA<String>());
        expect(testWeatherData.country, isA<String>());
      });

      testWidgets('optional fields can be null', (WidgetTester tester) async {
        final weatherWithNulls = WeatherData(
          temperature: 20.0,
          feelsLike: 22.0,
          humidity: 60,
          windSpeed: 3.0,
          description: 'test',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          pm25: 10.0,
          pm10: 20.0,
          precipitationProbability: 0.1,
        );

        expect(weatherWithNulls.uvIndex, isNull);
        expect(weatherWithNulls.airQuality, isNull);
        expect(weatherWithNulls.latitude, isNull);
        expect(weatherWithNulls.longitude, isNull);
        expect(weatherWithNulls.sunrise, isNull);
        expect(weatherWithNulls.sunset, isNull);
      });
    });
  });
}