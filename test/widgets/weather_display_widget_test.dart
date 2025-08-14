import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/widgets/weather_display_widget.dart';
import 'package:sky_mesh/services/weather_service.dart';

void main() {
  group('WeatherDisplayWidget Tests', () {
    final mockWeatherData = WeatherData(
      temperature: 22.0,
      feelsLike: 24.0,
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

    testWidgets('WeatherDisplayWidget shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: null,
              isLoading: true,
              error: null,
              onRefresh: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading weather...'), findsOneWidget);
    });

    testWidgets('WeatherDisplayWidget shows error state', (WidgetTester tester) async {
      const errorMessage = 'Network error occurred';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: null,
              isLoading: false,
              error: errorMessage,
              onRefresh: () {},
            ),
          ),
        ),
      );

      expect(find.text('Unable to load weather'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('WeatherDisplayWidget shows weather data correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: mockWeatherData,
              isLoading: false,
              error: null,
              onRefresh: () {},
            ),
          ),
        ),
      );

      // Check location display
      expect(find.text('Seoul, KR'), findsOneWidget);
      
      // Check temperature display
      expect(find.text('22°'), findsOneWidget);
      expect(find.text('Partly Cloudy'), findsOneWidget);
      expect(find.text('Feels like 24°'), findsOneWidget);
      
      // Check weather details
      expect(find.text('WIND'), findsOneWidget);
      expect(find.text('3.2 m/s'), findsOneWidget);
      expect(find.text('HUMIDITY'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
      expect(find.text('PRESSURE'), findsOneWidget);
      expect(find.text('1013 hPa'), findsOneWidget);
      expect(find.text('VISIBILITY'), findsOneWidget);
      expect(find.text('10.0 km'), findsOneWidget);
      expect(find.text('UV INDEX'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('WeatherDisplayWidget refresh button works', (WidgetTester tester) async {
      bool refreshCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: mockWeatherData,
              isLoading: false,
              error: null,
              onRefresh: () {
                refreshCalled = true;
              },
            ),
          ),
        ),
      );

      // Find and tap refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      
      await tester.tap(refreshButton);
      await tester.pump();
      
      expect(refreshCalled, isTrue);
    });

    testWidgets('WeatherDisplayWidget error retry button works', (WidgetTester tester) async {
      bool retryCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: null,
              isLoading: false,
              error: 'Test error',
              onRefresh: () {
                retryCalled = true;
              },
            ),
          ),
        ),
      );

      // Find and tap retry button
      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);
      
      await tester.tap(retryButton);
      await tester.pump();
      
      expect(retryCalled, isTrue);
    });

    testWidgets('WeatherDisplayWidget shows empty state when no data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: null,
              isLoading: false,
              error: null,
              onRefresh: () {},
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('WeatherDisplayWidget handles different UV index descriptions', (WidgetTester tester) async {
      final testCases = [
        (0, 'Low'),
        (2, 'Low'),
        (3, 'Moderate'),
        (5, 'Moderate'),
        (6, 'High'),
        (7, 'High'),
        (8, 'Very High'),
        (10, 'Very High'),
        (11, 'Extreme'),
      ];

      for (final (uvIndex, expectedDescription) in testCases) {
        final weatherDataWithUV = WeatherData(
          temperature: 22.0,
          feelsLike: 24.0,
          humidity: 65,
          windSpeed: 3.2,
          description: 'Clear',
          iconCode: '01d',
          cityName: 'Test City',
          country: 'TC',
          pressure: 1013,
          visibility: 10000,
          uvIndex: uvIndex,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherDisplayWidget(
                weatherData: weatherDataWithUV,
                isLoading: false,
                error: null,
                onRefresh: () {},
              ),
            ),
          ),
        );

        expect(find.text(expectedDescription), findsOneWidget);
        
        // Clear the widget for next test
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      }
    });

    testWidgets('WeatherDisplayWidget time format is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplayWidget(
              weatherData: mockWeatherData,
              isLoading: false,
              error: null,
              onRefresh: () {},
            ),
          ),
        ),
      );

      // Check that time is displayed in HH:MM format (should match current time)
      final now = DateTime.now();
      final expectedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      expect(find.text(expectedTime), findsOneWidget);
    });
  });

  group('WeatherData Model Tests', () {
    test('WeatherData fromJson constructor works correctly', () {
      final jsonData = {
        'main': {
          'temp': 25.5,
          'feels_like': 27.2,
          'humidity': 70,
          'pressure': 1015,
        },
        'wind': {
          'speed': 4.5,
        },
        'weather': [
          {
            'description': 'clear sky',
            'icon': '01d',
          }
        ],
        'name': 'Tokyo',
        'sys': {
          'country': 'JP',
        },
        'visibility': 8000,
        'coord': {
          'lat': 35.6762,
          'lon': 139.6503,
        }
      };

      final weatherData = WeatherData.fromJson(jsonData);

      expect(weatherData.temperature, 25.5);
      expect(weatherData.feelsLike, 27.2);
      expect(weatherData.humidity, 70);
      expect(weatherData.windSpeed, 4.5);
      expect(weatherData.description, 'clear sky');
      expect(weatherData.iconCode, '01d');
      expect(weatherData.cityName, 'Tokyo');
      expect(weatherData.country, 'JP');
      expect(weatherData.pressure, 1015);
      expect(weatherData.visibility, 8000);
      expect(weatherData.uvIndex, 5); // Default value
      expect(weatherData.latitude, 35.6762);
      expect(weatherData.longitude, 139.6503);
    });

    test('WeatherData string getters work correctly', () {
      final weatherData = WeatherData(
        temperature: 22.7,
        feelsLike: 24.3,
        humidity: 65,
        windSpeed: 3.25,
        description: 'partly cloudy',
        iconCode: '02d',
        cityName: 'Seoul',
        country: 'KR',
        pressure: 1013,
        visibility: 12500,
        uvIndex: 7,
      );

      expect(weatherData.temperatureString, '23°');
      expect(weatherData.feelsLikeString, '24°');
      expect(weatherData.windSpeedString, '3.3 m/s');
      expect(weatherData.humidityString, '65%');
      expect(weatherData.pressureString, '1013 hPa');
      expect(weatherData.visibilityString, '12.5 km');
      expect(weatherData.uvIndexString, '7');
      expect(weatherData.capitalizedDescription, 'Partly Cloudy');
    });

    test('WeatherData handles missing visibility in JSON', () {
      final jsonData = {
        'main': {
          'temp': 20.0,
          'feels_like': 22.0,
          'humidity': 60,
          'pressure': 1010,
        },
        'wind': {
          'speed': 2.0,
        },
        'weather': [
          {
            'description': 'clear',
            'icon': '01d',
          }
        ],
        'name': 'Test City',
        'sys': {
          'country': 'TC',
        },
        'coord': {
          'lat': 0.0,
          'lon': 0.0,
        }
      };

      final weatherData = WeatherData.fromJson(jsonData);
      expect(weatherData.visibility, 10000); // Default value
    });
  });
}