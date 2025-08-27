import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/models/hourly_weather_data.dart';

void main() {
  group('HourlyWeatherData Model Tests', () {
    late HourlyWeatherForecast testForecast;
    late HourlyWeatherData testHourlyData;
    late Map<String, dynamic> mockApiResponse;

    setUp(() {
      testForecast = HourlyWeatherForecast(
        dateTime: DateTime(2024, 1, 15, 14, 30),
        temperature: 22.5,
        description: 'partly cloudy',
        iconCode: '02d',
        humidity: 65,
        windSpeed: 3.4,
        pressure: 1013,
      );

      testHourlyData = HourlyWeatherData(
        cityName: 'Seoul',
        country: 'KR',
        hourlyForecasts: [
          testForecast,
          HourlyWeatherForecast(
            dateTime: DateTime(2024, 1, 15, 15, 30),
            temperature: 23.2,
            description: 'sunny',
            iconCode: '01d',
            humidity: 62,
            windSpeed: 2.8,
            pressure: 1014,
          ),
        ],
      );

      mockApiResponse = {
        'city': {
          'name': 'Seoul',
          'country': 'KR',
        },
        'list': [
          {
            'dt': 1705326600, // 2024-01-15 14:30:00 UTC timestamp
            'main': {
              'temp': 22.5,
              'humidity': 65,
              'pressure': 1013,
            },
            'weather': [
              {
                'description': 'partly cloudy',
                'icon': '02d',
              }
            ],
            'wind': {
              'speed': 3.4,
            }
          },
          {
            'dt': 1705330200, // 2024-01-15 15:30:00 UTC timestamp
            'main': {
              'temp': 23.2,
              'humidity': 62,
              'pressure': 1014,
            },
            'weather': [
              {
                'description': 'sunny',
                'icon': '01d',
              }
            ],
            'wind': {
              'speed': 2.8,
            }
          },
        ]
      };
    });

    group('HourlyWeatherForecast Tests', () {
      group('Constructor Tests', () {
        testWidgets('creates forecast with all required fields', (WidgetTester tester) async {
          final forecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 6, 20, 12, 0),
            temperature: 28.0,
            description: 'clear sky',
            iconCode: '01d',
            humidity: 45,
            windSpeed: 2.1,
            pressure: 1018,
          );

          expect(forecast.dateTime, DateTime(2024, 6, 20, 12, 0));
          expect(forecast.temperature, 28.0);
          expect(forecast.description, 'clear sky');
          expect(forecast.iconCode, '01d');
          expect(forecast.humidity, 45);
          expect(forecast.windSpeed, 2.1);
          expect(forecast.pressure, 1018);
        });

        testWidgets('accepts valid data types', (WidgetTester tester) async {
          expect(testForecast.dateTime, isA<DateTime>());
          expect(testForecast.temperature, isA<double>());
          expect(testForecast.description, isA<String>());
          expect(testForecast.iconCode, isA<String>());
          expect(testForecast.humidity, isA<int>());
          expect(testForecast.windSpeed, isA<double>());
          expect(testForecast.pressure, isA<int>());
        });
      });

      group('fromJson Factory Tests', () {
        testWidgets('creates forecast from valid API response', (WidgetTester tester) async {
          final json = {
            'dt': 1705326600, // 2024-01-15 14:30:00 UTC
            'main': {
              'temp': 25.3,
              'humidity': 70,
              'pressure': 1015,
            },
            'weather': [
              {
                'description': 'light rain',
                'icon': '10d',
              }
            ],
            'wind': {
              'speed': 4.5,
            }
          };

          final forecast = HourlyWeatherForecast.fromJson(json);

          expect(forecast.dateTime, DateTime.fromMillisecondsSinceEpoch(1705326600 * 1000, isUtc: true));
          expect(forecast.temperature, 25.3);
          expect(forecast.description, 'light rain');
          expect(forecast.iconCode, '10d');
          expect(forecast.humidity, 70);
          expect(forecast.windSpeed, 4.5);
          expect(forecast.pressure, 1015);
        });

        testWidgets('handles integer temperature values', (WidgetTester tester) async {
          final json = {
            'dt': 1705326600,
            'main': {
              'temp': 20, // Integer instead of double
              'humidity': 60,
              'pressure': 1010,
            },
            'weather': [
              {
                'description': 'cloudy',
                'icon': '04d',
              }
            ],
            'wind': {
              'speed': 3, // Integer instead of double
            }
          };

          final forecast = HourlyWeatherForecast.fromJson(json);

          expect(forecast.temperature, 20.0);
          expect(forecast.windSpeed, 3.0);
        });

        testWidgets('handles different timestamp formats correctly', (WidgetTester tester) async {
          final json = {
            'dt': 1672531200, // 2023-01-01 00:00:00 UTC
            'main': {
              'temp': 15.0,
              'humidity': 80,
              'pressure': 1005,
            },
            'weather': [
              {
                'description': 'overcast',
                'icon': '04d',
              }
            ],
            'wind': {
              'speed': 5.2,
            }
          };

          final forecast = HourlyWeatherForecast.fromJson(json);

          expect(forecast.dateTime.year, 2023);
          expect(forecast.dateTime.month, 1);
          expect(forecast.dateTime.day, 1);
          expect(forecast.dateTime.hour, 0);
          expect(forecast.dateTime.minute, 0);
        });
      });

      group('Getter Tests', () {
        testWidgets('temperatureString formats correctly', (WidgetTester tester) async {
          expect(testForecast.temperatureString, '23°');
          
          final coldForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 1, 1, 8, 0),
            temperature: -5.7,
            description: 'snow',
            iconCode: '13d',
            humidity: 85,
            windSpeed: 4.2,
            pressure: 1020,
          );
          
          expect(coldForecast.temperatureString, '-6°');
        });

        testWidgets('hour formats correctly', (WidgetTester tester) async {
          expect(testForecast.hour, '14:30');
          
          final morningForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 3, 10, 7, 5),
            temperature: 12.0,
            description: 'clear',
            iconCode: '01d',
            humidity: 55,
            windSpeed: 1.8,
            pressure: 1012,
          );
          
          expect(morningForecast.hour, '07:05');
          
          final nightForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 8, 25, 23, 45),
            temperature: 18.5,
            description: 'clear night',
            iconCode: '01n',
            humidity: 68,
            windSpeed: 2.3,
            pressure: 1018,
          );
          
          expect(nightForecast.hour, '23:45');
        });

        testWidgets('capitalizedDescription formats correctly', (WidgetTester tester) async {
          expect(testForecast.capitalizedDescription, 'Partly Cloudy');
          
          final singleWordForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 5, 15, 16, 0),
            temperature: 26.0,
            description: 'sunny',
            iconCode: '01d',
            humidity: 40,
            windSpeed: 1.5,
            pressure: 1020,
          );
          
          expect(singleWordForecast.capitalizedDescription, 'Sunny');
          
          final complexForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 11, 3, 19, 30),
            temperature: 16.8,
            description: 'light intensity shower rain',
            iconCode: '09d',
            humidity: 92,
            windSpeed: 6.1,
            pressure: 995,
          );
          
          expect(complexForecast.capitalizedDescription, 'Light Intensity Shower Rain');
        });
      });

      group('Edge Cases Tests', () {
        testWidgets('handles midnight hour correctly', (WidgetTester tester) async {
          final midnightForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 12, 31, 0, 0),
            temperature: 8.0,
            description: 'clear night',
            iconCode: '01n',
            humidity: 75,
            windSpeed: 2.0,
            pressure: 1015,
          );
          
          expect(midnightForecast.hour, '00:00');
        });

        testWidgets('handles extreme temperatures', (WidgetTester tester) async {
          final hotForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 7, 15, 14, 0),
            temperature: 45.0,
            description: 'extreme heat',
            iconCode: '01d',
            humidity: 20,
            windSpeed: 1.0,
            pressure: 1005,
          );
          
          expect(hotForecast.temperatureString, '45°');
          
          final freezingForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 2, 1, 6, 0),
            temperature: -25.0,
            description: 'extreme cold',
            iconCode: '13d',
            humidity: 60,
            windSpeed: 8.5,
            pressure: 1030,
          );
          
          expect(freezingForecast.temperatureString, '-25°');
        });

        testWidgets('handles zero and fractional values', (WidgetTester tester) async {
          final zeroForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 4, 10, 0, 0),
            temperature: 0.0,
            description: 'freezing',
            iconCode: '13d',
            humidity: 100,
            windSpeed: 0.0,
            pressure: 1000,
          );
          
          expect(zeroForecast.temperatureString, '0°');
          
          final fractionalForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 9, 20, 18, 45),
            temperature: 22.7,
            description: 'pleasant',
            iconCode: '02d',
            humidity: 55,
            windSpeed: 2.3,
            pressure: 1018,
          );
          
          expect(fractionalForecast.temperatureString, '23°'); // Rounds correctly
        });

        testWidgets('handles empty and special character descriptions', (WidgetTester tester) async {
          final specialForecast = HourlyWeatherForecast(
            dateTime: DateTime(2024, 6, 5, 11, 15),
            temperature: 19.0,
            description: 'light rain-drizzle',
            iconCode: '09d',
            humidity: 88,
            windSpeed: 3.7,
            pressure: 1008,
          );
          
          expect(specialForecast.capitalizedDescription, 'Light Rain-drizzle');
        });
      });
    });

    group('HourlyWeatherData Tests', () {
      group('Constructor Tests', () {
        testWidgets('creates hourly data with all required fields', (WidgetTester tester) async {
          final hourlyData = HourlyWeatherData(
            cityName: 'Tokyo',
            country: 'JP',
            hourlyForecasts: [
              HourlyWeatherForecast(
                dateTime: DateTime(2024, 3, 15, 10, 0),
                temperature: 15.0,
                description: 'cloudy',
                iconCode: '04d',
                humidity: 70,
                windSpeed: 3.0,
                pressure: 1010,
              ),
            ],
          );

          expect(hourlyData.cityName, 'Tokyo');
          expect(hourlyData.country, 'JP');
          expect(hourlyData.hourlyForecasts, isA<List<HourlyWeatherForecast>>());
          expect(hourlyData.hourlyForecasts.length, 1);
        });

        testWidgets('accepts empty forecasts list', (WidgetTester tester) async {
          final emptyHourlyData = HourlyWeatherData(
            cityName: 'Empty City',
            country: 'EC',
            hourlyForecasts: [],
          );

          expect(emptyHourlyData.hourlyForecasts, isEmpty);
        });

        testWidgets('accepts multiple forecasts', (WidgetTester tester) async {
          expect(testHourlyData.hourlyForecasts.length, 2);
          expect(testHourlyData.hourlyForecasts[0].temperature, 22.5);
          expect(testHourlyData.hourlyForecasts[1].temperature, 23.2);
        });
      });

      group('fromJson Factory Tests', () {
        testWidgets('creates hourly data from valid API response', (WidgetTester tester) async {
          final hourlyData = HourlyWeatherData.fromJson(mockApiResponse);

          expect(hourlyData.cityName, 'Seoul');
          expect(hourlyData.country, 'KR');
          expect(hourlyData.hourlyForecasts.length, 2);
          expect(hourlyData.hourlyForecasts[0].temperature, 22.5);
          expect(hourlyData.hourlyForecasts[1].temperature, 23.2);
        });

        testWidgets('limits to 24 forecasts max', (WidgetTester tester) async {
          final longListResponse = {
            'city': {
              'name': 'Test City',
              'country': 'TC',
            },
            'list': List.generate(48, (index) => {
              'dt': 1705326600 + (index * 3600), // Hourly increments
              'main': {
                'temp': 20.0 + index,
                'humidity': 60,
                'pressure': 1010,
              },
              'weather': [
                {
                  'description': 'test weather $index',
                  'icon': '01d',
                }
              ],
              'wind': {
                'speed': 2.0,
              }
            }),
          };

          final hourlyData = HourlyWeatherData.fromJson(longListResponse);

          expect(hourlyData.hourlyForecasts.length, 24); // Limited to 24
          expect(hourlyData.hourlyForecasts[0].temperature, 20.0);
          expect(hourlyData.hourlyForecasts[23].temperature, 43.0);
        });

        testWidgets('handles empty list gracefully', (WidgetTester tester) async {
          final emptyListResponse = {
            'city': {
              'name': 'Empty City',
              'country': 'EC',
            },
            'list': [],
          };

          final hourlyData = HourlyWeatherData.fromJson(emptyListResponse);

          expect(hourlyData.cityName, 'Empty City');
          expect(hourlyData.country, 'EC');
          expect(hourlyData.hourlyForecasts, isEmpty);
        });

        testWidgets('handles single forecast correctly', (WidgetTester tester) async {
          final singleForecastResponse = {
            'city': {
              'name': 'Single City',
              'country': 'SC',
            },
            'list': [
              {
                'dt': 1705326600,
                'main': {
                  'temp': 18.5,
                  'humidity': 75,
                  'pressure': 1012,
                },
                'weather': [
                  {
                    'description': 'single forecast',
                    'icon': '03d',
                  }
                ],
                'wind': {
                  'speed': 2.8,
                }
              }
            ],
          };

          final hourlyData = HourlyWeatherData.fromJson(singleForecastResponse);

          expect(hourlyData.hourlyForecasts.length, 1);
          expect(hourlyData.hourlyForecasts[0].temperature, 18.5);
          expect(hourlyData.hourlyForecasts[0].description, 'single forecast');
        });
      });

      group('Data Structure Tests', () {
        testWidgets('maintains forecast order', (WidgetTester tester) async {
          final orderedResponse = {
            'city': {
              'name': 'Order City',
              'country': 'OC',
            },
            'list': [
              {
                'dt': 1705326600, // Earlier time
                'main': {'temp': 10.0, 'humidity': 50, 'pressure': 1000},
                'weather': [{'description': 'first', 'icon': '01d'}],
                'wind': {'speed': 1.0}
              },
              {
                'dt': 1705330200, // Later time
                'main': {'temp': 15.0, 'humidity': 60, 'pressure': 1005},
                'weather': [{'description': 'second', 'icon': '02d'}],
                'wind': {'speed': 2.0}
              },
              {
                'dt': 1705333800, // Even later time
                'main': {'temp': 20.0, 'humidity': 70, 'pressure': 1010},
                'weather': [{'description': 'third', 'icon': '03d'}],
                'wind': {'speed': 3.0}
              }
            ],
          };

          final hourlyData = HourlyWeatherData.fromJson(orderedResponse);

          expect(hourlyData.hourlyForecasts[0].temperature, 10.0);
          expect(hourlyData.hourlyForecasts[0].description, 'first');
          expect(hourlyData.hourlyForecasts[1].temperature, 15.0);
          expect(hourlyData.hourlyForecasts[1].description, 'second');
          expect(hourlyData.hourlyForecasts[2].temperature, 20.0);
          expect(hourlyData.hourlyForecasts[2].description, 'third');
        });

        testWidgets('city information is preserved correctly', (WidgetTester tester) async {
          expect(testHourlyData.cityName, 'Seoul');
          expect(testHourlyData.country, 'KR');
          expect(testHourlyData.cityName, isA<String>());
          expect(testHourlyData.country, isA<String>());
        });
      });

      group('Edge Cases Tests', () {
        testWidgets('handles special characters in city names', (WidgetTester tester) async {
          final specialCityResponse = {
            'city': {
              'name': 'São Paulo',
              'country': 'BR',
            },
            'list': [
              {
                'dt': 1705326600,
                'main': {'temp': 25.0, 'humidity': 80, 'pressure': 1015},
                'weather': [{'description': 'humid', 'icon': '10d'}],
                'wind': {'speed': 1.5}
              }
            ],
          };

          final hourlyData = HourlyWeatherData.fromJson(specialCityResponse);

          expect(hourlyData.cityName, 'São Paulo');
          expect(hourlyData.country, 'BR');
        });

        testWidgets('handles different weather conditions across hours', (WidgetTester tester) async {
          final variedWeatherResponse = {
            'city': {
              'name': 'Variable City',
              'country': 'VC',
            },
            'list': [
              {
                'dt': 1705326600,
                'main': {'temp': 15.0, 'humidity': 90, 'pressure': 1000},
                'weather': [{'description': 'heavy rain', 'icon': '10d'}],
                'wind': {'speed': 8.0}
              },
              {
                'dt': 1705330200,
                'main': {'temp': 18.0, 'humidity': 70, 'pressure': 1005},
                'weather': [{'description': 'light rain', 'icon': '09d'}],
                'wind': {'speed': 5.0}
              },
              {
                'dt': 1705333800,
                'main': {'temp': 22.0, 'humidity': 50, 'pressure': 1015},
                'weather': [{'description': 'partly cloudy', 'icon': '02d'}],
                'wind': {'speed': 2.0}
              },
              {
                'dt': 1705337400,
                'main': {'temp': 25.0, 'humidity': 30, 'pressure': 1020},
                'weather': [{'description': 'sunny', 'icon': '01d'}],
                'wind': {'speed': 1.0}
              }
            ],
          };

          final hourlyData = HourlyWeatherData.fromJson(variedWeatherResponse);

          expect(hourlyData.hourlyForecasts.length, 4);
          expect(hourlyData.hourlyForecasts[0].description, 'heavy rain');
          expect(hourlyData.hourlyForecasts[1].description, 'light rain');
          expect(hourlyData.hourlyForecasts[2].description, 'partly cloudy');
          expect(hourlyData.hourlyForecasts[3].description, 'sunny');
          
          // Verify temperature progression
          expect(hourlyData.hourlyForecasts[0].temperature, 15.0);
          expect(hourlyData.hourlyForecasts[1].temperature, 18.0);
          expect(hourlyData.hourlyForecasts[2].temperature, 22.0);
          expect(hourlyData.hourlyForecasts[3].temperature, 25.0);
        });
      });
    });
  });
}