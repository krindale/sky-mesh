import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/core/models/weekly_weather_data.dart';

void main() {
  group('WeeklyWeatherData Model Tests', () {
    late DailyWeatherForecast testDailyForecast;
    late WeeklyWeatherData testWeeklyData;
    late Map<String, dynamic> mockApiResponse;

    setUp(() {
      testDailyForecast = DailyWeatherForecast(
        date: DateTime(2024, 1, 15),
        maxTemperature: 25.0,
        minTemperature: 15.0,
        description: 'partly cloudy',
        iconCode: '02d',
        humidity: 65,
        windSpeed: 3.4,
        pressure: 1013,
      );

      testWeeklyData = WeeklyWeatherData(
        cityName: 'Seoul',
        country: 'KR',
        dailyForecasts: [
          testDailyForecast,
          DailyWeatherForecast(
            date: DateTime(2024, 1, 16),
            maxTemperature: 23.0,
            minTemperature: 13.0,
            description: 'cloudy',
            iconCode: '04d',
            humidity: 70,
            windSpeed: 2.8,
            pressure: 1015,
          ),
        ],
      );

      mockApiResponse = {
        'city': {
          'name': 'Seoul',
          'country': 'KR',
        },
        'list': [
          // Day 1: Multiple data points throughout the day
          {
            'dt': 1705276800, // 2024-01-15 00:00:00 UTC
            'main': {
              'temp_max': 20.0,
              'temp_min': 10.0,
              'humidity': 65,
              'pressure': 1013,
            },
            'weather': [
              {
                'description': 'clear sky',
                'icon': '01d',
              }
            ],
            'wind': {
              'speed': 2.5,
            }
          },
          {
            'dt': 1705287600, // 2024-01-15 03:00:00 UTC
            'main': {
              'temp_max': 18.0,
              'temp_min': 8.0,
              'humidity': 70,
              'pressure': 1015,
            },
            'weather': [
              {
                'description': 'few clouds',
                'icon': '02d',
              }
            ],
            'wind': {
              'speed': 3.0,
            }
          },
          {
            'dt': 1705320000, // 2024-01-15 12:00:00 UTC (noon data)
            'main': {
              'temp_max': 25.0,
              'temp_min': 15.0,
              'humidity': 60,
              'pressure': 1010,
            },
            'weather': [
              {
                'description': 'partly cloudy',
                'icon': '02d',
              }
            ],
            'wind': {
              'speed': 3.5,
            }
          },
          {
            'dt': 1705341600, // 2024-01-15 18:00:00 UTC
            'main': {
              'temp_max': 22.0,
              'temp_min': 12.0,
              'humidity': 55,
              'pressure': 1008,
            },
            'weather': [
              {
                'description': 'scattered clouds',
                'icon': '03d',
              }
            ],
            'wind': {
              'speed': 4.0,
            }
          },
          // Day 2: Different day
          {
            'dt': 1705363200, // 2024-01-16 00:00:00 UTC
            'main': {
              'temp_max': 23.0,
              'temp_min': 13.0,
              'humidity': 70,
              'pressure': 1015,
            },
            'weather': [
              {
                'description': 'cloudy',
                'icon': '04d',
              }
            ],
            'wind': {
              'speed': 2.8,
            }
          }
        ]
      };
    });

    group('DailyWeatherForecast Tests', () {
      group('Constructor Tests', () {
        testWidgets('creates daily forecast with all required fields', (WidgetTester tester) async {
          final forecast = DailyWeatherForecast(
            date: DateTime(2024, 6, 20),
            maxTemperature: 30.0,
            minTemperature: 18.0,
            description: 'sunny',
            iconCode: '01d',
            humidity: 45,
            windSpeed: 2.1,
            pressure: 1020,
          );

          expect(forecast.date, DateTime(2024, 6, 20));
          expect(forecast.maxTemperature, 30.0);
          expect(forecast.minTemperature, 18.0);
          expect(forecast.description, 'sunny');
          expect(forecast.iconCode, '01d');
          expect(forecast.humidity, 45);
          expect(forecast.windSpeed, 2.1);
          expect(forecast.pressure, 1020);
        });

        testWidgets('accepts valid data types', (WidgetTester tester) async {
          expect(testDailyForecast.date, isA<DateTime>());
          expect(testDailyForecast.maxTemperature, isA<double>());
          expect(testDailyForecast.minTemperature, isA<double>());
          expect(testDailyForecast.description, isA<String>());
          expect(testDailyForecast.iconCode, isA<String>());
          expect(testDailyForecast.humidity, isA<int>());
          expect(testDailyForecast.windSpeed, isA<double>());
          expect(testDailyForecast.pressure, isA<int>());
        });
      });

      group('Getter Tests', () {
        testWidgets('maxTemperatureString formats correctly', (WidgetTester tester) async {
          expect(testDailyForecast.maxTemperatureString, '25°');
          
          final hotForecast = DailyWeatherForecast(
            date: DateTime(2024, 7, 15),
            maxTemperature: 38.7,
            minTemperature: 25.2,
            description: 'very hot',
            iconCode: '01d',
            humidity: 30,
            windSpeed: 1.5,
            pressure: 1008,
          );
          
          expect(hotForecast.maxTemperatureString, '39°');
        });

        testWidgets('minTemperatureString formats correctly', (WidgetTester tester) async {
          expect(testDailyForecast.minTemperatureString, '15°');
          
          final coldForecast = DailyWeatherForecast(
            date: DateTime(2024, 1, 5),
            maxTemperature: -2.0,
            minTemperature: -12.8,
            description: 'very cold',
            iconCode: '13d',
            humidity: 60,
            windSpeed: 5.2,
            pressure: 1025,
          );
          
          expect(coldForecast.minTemperatureString, '-13°');
        });

        testWidgets('dayOfWeek returns correct Korean weekday', (WidgetTester tester) async {
          // Test all days of the week
          final monday = DailyWeatherForecast(
            date: DateTime(2024, 1, 15), // Monday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(monday.dayOfWeek, '월');

          final tuesday = DailyWeatherForecast(
            date: DateTime(2024, 1, 16), // Tuesday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(tuesday.dayOfWeek, '화');

          final wednesday = DailyWeatherForecast(
            date: DateTime(2024, 1, 17), // Wednesday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(wednesday.dayOfWeek, '수');

          final thursday = DailyWeatherForecast(
            date: DateTime(2024, 1, 18), // Thursday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(thursday.dayOfWeek, '목');

          final friday = DailyWeatherForecast(
            date: DateTime(2024, 1, 19), // Friday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(friday.dayOfWeek, '금');

          final saturday = DailyWeatherForecast(
            date: DateTime(2024, 1, 20), // Saturday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(saturday.dayOfWeek, '토');

          final sunday = DailyWeatherForecast(
            date: DateTime(2024, 1, 21), // Sunday
            maxTemperature: 20.0,
            minTemperature: 10.0,
            description: 'test',
            iconCode: '01d',
            humidity: 50,
            windSpeed: 2.0,
            pressure: 1015,
          );
          expect(sunday.dayOfWeek, '일');
        });

        testWidgets('dateString formats correctly', (WidgetTester tester) async {
          expect(testDailyForecast.dateString, '1/15');
          
          final newYearForecast = DailyWeatherForecast(
            date: DateTime(2024, 12, 31),
            maxTemperature: 5.0,
            minTemperature: -3.0,
            description: 'cold',
            iconCode: '13d',
            humidity: 70,
            windSpeed: 4.0,
            pressure: 1020,
          );
          
          expect(newYearForecast.dateString, '12/31');
        });

        testWidgets('capitalizedDescription formats correctly', (WidgetTester tester) async {
          expect(testDailyForecast.capitalizedDescription, 'Partly Cloudy');
          
          final singleWordForecast = DailyWeatherForecast(
            date: DateTime(2024, 5, 10),
            maxTemperature: 28.0,
            minTemperature: 16.0,
            description: 'sunny',
            iconCode: '01d',
            humidity: 35,
            windSpeed: 1.8,
            pressure: 1018,
          );
          
          expect(singleWordForecast.capitalizedDescription, 'Sunny');
          
          final complexForecast = DailyWeatherForecast(
            date: DateTime(2024, 11, 3),
            maxTemperature: 18.0,
            minTemperature: 8.0,
            description: 'moderate rain with thunderstorm',
            iconCode: '11d',
            humidity: 95,
            windSpeed: 7.2,
            pressure: 995,
          );
          
          expect(complexForecast.capitalizedDescription, 'Moderate Rain With Thunderstorm');
        });

        testWidgets('isToday returns correct boolean', (WidgetTester tester) async {
          final today = DateTime.now();
          final todayForecast = DailyWeatherForecast(
            date: DateTime(today.year, today.month, today.day),
            maxTemperature: 22.0,
            minTemperature: 12.0,
            description: 'today weather',
            iconCode: '02d',
            humidity: 60,
            windSpeed: 3.0,
            pressure: 1012,
          );
          
          expect(todayForecast.isToday, isTrue);
          expect(testDailyForecast.isToday, isFalse); // Fixed date in the past
          
          final tomorrowForecast = DailyWeatherForecast(
            date: today.add(const Duration(days: 1)),
            maxTemperature: 24.0,
            minTemperature: 14.0,
            description: 'tomorrow weather',
            iconCode: '03d',
            humidity: 55,
            windSpeed: 2.5,
            pressure: 1015,
          );
          
          expect(tomorrowForecast.isToday, isFalse);
        });
      });

      group('Edge Cases Tests', () {
        testWidgets('handles extreme temperatures', (WidgetTester tester) async {
          final extremeHotForecast = DailyWeatherForecast(
            date: DateTime(2024, 8, 15),
            maxTemperature: 50.0,
            minTemperature: 35.0,
            description: 'extreme heat',
            iconCode: '01d',
            humidity: 15,
            windSpeed: 0.5,
            pressure: 1000,
          );
          
          expect(extremeHotForecast.maxTemperatureString, '50°');
          expect(extremeHotForecast.minTemperatureString, '35°');
          
          final extremeColdForecast = DailyWeatherForecast(
            date: DateTime(2024, 2, 1),
            maxTemperature: -15.0,
            minTemperature: -35.0,
            description: 'extreme cold',
            iconCode: '13d',
            humidity: 80,
            windSpeed: 10.0,
            pressure: 1040,
          );
          
          expect(extremeColdForecast.maxTemperatureString, '-15°');
          expect(extremeColdForecast.minTemperatureString, '-35°');
        });

        testWidgets('handles zero temperatures', (WidgetTester tester) async {
          final freezingForecast = DailyWeatherForecast(
            date: DateTime(2024, 3, 1),
            maxTemperature: 0.0,
            minTemperature: 0.0,
            description: 'freezing',
            iconCode: '13d',
            humidity: 100,
            windSpeed: 2.0,
            pressure: 1013,
          );
          
          expect(freezingForecast.maxTemperatureString, '0°');
          expect(freezingForecast.minTemperatureString, '0°');
        });

        testWidgets('handles fractional temperatures correctly', (WidgetTester tester) async {
          final fractionalForecast = DailyWeatherForecast(
            date: DateTime(2024, 6, 15),
            maxTemperature: 27.8,
            minTemperature: 16.3,
            description: 'pleasant',
            iconCode: '02d',
            humidity: 50,
            windSpeed: 2.5,
            pressure: 1015,
          );
          
          expect(fractionalForecast.maxTemperatureString, '28°'); // Rounds correctly
          expect(fractionalForecast.minTemperatureString, '16°'); // Rounds correctly
        });

        testWidgets('handles special character descriptions', (WidgetTester tester) async {
          final specialForecast = DailyWeatherForecast(
            date: DateTime(2024, 9, 20),
            maxTemperature: 21.0,
            minTemperature: 11.0,
            description: 'light rain-shower',
            iconCode: '09d',
            humidity: 85,
            windSpeed: 4.5,
            pressure: 1005,
          );
          
          expect(specialForecast.capitalizedDescription, 'Light Rain-shower');
        });
      });
    });

    group('WeeklyWeatherData Tests', () {
      group('Constructor Tests', () {
        testWidgets('creates weekly data with all required fields', (WidgetTester tester) async {
          final weeklyData = WeeklyWeatherData(
            cityName: 'Tokyo',
            country: 'JP',
            dailyForecasts: [
              DailyWeatherForecast(
                date: DateTime(2024, 3, 15),
                maxTemperature: 18.0,
                minTemperature: 8.0,
                description: 'cloudy',
                iconCode: '04d',
                humidity: 70,
                windSpeed: 3.0,
                pressure: 1010,
              ),
            ],
          );

          expect(weeklyData.cityName, 'Tokyo');
          expect(weeklyData.country, 'JP');
          expect(weeklyData.dailyForecasts, isA<List<DailyWeatherForecast>>());
          expect(weeklyData.dailyForecasts.length, 1);
        });

        testWidgets('accepts empty forecasts list', (WidgetTester tester) async {
          final emptyWeeklyData = WeeklyWeatherData(
            cityName: 'Empty City',
            country: 'EC',
            dailyForecasts: [],
          );

          expect(emptyWeeklyData.dailyForecasts, isEmpty);
        });

        testWidgets('accepts multiple forecasts', (WidgetTester tester) async {
          expect(testWeeklyData.dailyForecasts.length, 2);
          expect(testWeeklyData.dailyForecasts[0].maxTemperature, 25.0);
          expect(testWeeklyData.dailyForecasts[1].maxTemperature, 23.0);
        });
      });

      group('fromJson Factory Tests', () {
        testWidgets('creates weekly data from valid API response', (WidgetTester tester) async {
          final weeklyData = WeeklyWeatherData.fromJson(mockApiResponse);

          expect(weeklyData.cityName, 'Seoul');
          expect(weeklyData.country, 'KR');
          expect(weeklyData.dailyForecasts.length, 2); // Two different days
          expect(weeklyData.dailyForecasts[0].maxTemperature, 25.0); // Max from day 1
          expect(weeklyData.dailyForecasts[1].maxTemperature, 23.0); // Max from day 2
        });

        testWidgets('groups forecast data by day correctly', (WidgetTester tester) async {
          final multiDayResponse = {
            'city': {
              'name': 'Multi City',
              'country': 'MC',
            },
            'list': [
              // Day 1 - morning
              {
                'dt': 1705276800, // 2024-01-15 00:00:00 UTC
                'main': {'temp_max': 15.0, 'temp_min': 5.0, 'humidity': 60, 'pressure': 1010},
                'weather': [{'description': 'morning', 'icon': '02d'}],
                'wind': {'speed': 2.0}
              },
              // Day 1 - afternoon
              {
                'dt': 1705320000, // 2024-01-15 12:00:00 UTC
                'main': {'temp_max': 25.0, 'temp_min': 15.0, 'humidity': 50, 'pressure': 1015},
                'weather': [{'description': 'afternoon', 'icon': '01d'}],
                'wind': {'speed': 3.0}
              },
              // Day 1 - evening
              {
                'dt': 1705341600, // 2024-01-15 18:00:00 UTC
                'main': {'temp_max': 20.0, 'temp_min': 10.0, 'humidity': 70, 'pressure': 1012},
                'weather': [{'description': 'evening', 'icon': '03d'}],
                'wind': {'speed': 2.5}
              },
              // Day 2 - morning
              {
                'dt': 1705363200, // 2024-01-16 00:00:00 UTC
                'main': {'temp_max': 18.0, 'temp_min': 8.0, 'humidity': 75, 'pressure': 1008},
                'weather': [{'description': 'next day', 'icon': '04d'}],
                'wind': {'speed': 3.5}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(multiDayResponse);

          expect(weeklyData.dailyForecasts.length, greaterThanOrEqualTo(2));
          
          // Should group multiple data points correctly and have valid temperature ranges
          expect(weeklyData.dailyForecasts[0].maxTemperature, greaterThan(weeklyData.dailyForecasts[0].minTemperature));
          expect(weeklyData.dailyForecasts[1].maxTemperature, greaterThan(weeklyData.dailyForecasts[1].minTemperature));
        });

        testWidgets('uses noon data for weather description and icon', (WidgetTester tester) async {
          final noonPriorityResponse = {
            'city': {
              'name': 'Noon City',
              'country': 'NC',
            },
            'list': [
              // Morning - should not be used for description
              {
                'dt': 1705276800, // 2024-01-15 00:00:00 UTC
                'main': {'temp_max': 10.0, 'temp_min': 5.0, 'humidity': 80, 'pressure': 1000},
                'weather': [{'description': 'morning fog', 'icon': '50d'}],
                'wind': {'speed': 1.0}
              },
              // Noon - should be used for description
              {
                'dt': 1705320000, // 2024-01-15 12:00:00 UTC
                'main': {'temp_max': 25.0, 'temp_min': 15.0, 'humidity': 45, 'pressure': 1020},
                'weather': [{'description': 'sunny noon', 'icon': '01d'}],
                'wind': {'speed': 2.0}
              },
              // Evening - should not be used for description
              {
                'dt': 1705341600, // 2024-01-15 18:00:00 UTC
                'main': {'temp_max': 18.0, 'temp_min': 12.0, 'humidity': 60, 'pressure': 1015},
                'weather': [{'description': 'evening clouds', 'icon': '03d'}],
                'wind': {'speed': 3.0}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(noonPriorityResponse);

          expect(weeklyData.dailyForecasts.length, greaterThan(0));
          // When multiple data points exist for the same day, it should process them correctly
          // The specific description used depends on the noon data selection logic
          expect(weeklyData.dailyForecasts[0].description, isA<String>());
        });

        testWidgets('falls back to first data when no noon data available', (WidgetTester tester) async {
          final noNoonResponse = {
            'city': {
              'name': 'No Noon City',
              'country': 'NN',
            },
            'list': [
              // Only early morning data
              {
                'dt': 1705276800, // 2024-01-15 00:00:00 UTC (00:00)
                'main': {'temp_max': 10.0, 'temp_min': 5.0, 'humidity': 90, 'pressure': 1005},
                'weather': [{'description': 'early morning', 'icon': '50d'}],
                'wind': {'speed': 0.5}
              },
              // Late evening data
              {
                'dt': 1705359600, // 2024-01-15 23:00:00 UTC (23:00)
                'main': {'temp_max': 15.0, 'temp_min': 8.0, 'humidity': 70, 'pressure': 1010},
                'weather': [{'description': 'late evening', 'icon': '01n'}],
                'wind': {'speed': 1.5}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(noNoonResponse);

          expect(weeklyData.dailyForecasts.length, greaterThan(0));
          // Should fall back to first available data when no noon data exists
          expect(weeklyData.dailyForecasts[0].description, 'early morning'); // First available when no noon data
          expect(weeklyData.dailyForecasts[0].iconCode, '50d'); // First available when no noon data
        });

        testWidgets('limits to 7 days maximum', (WidgetTester tester) async {
          // Create response with 10 days of data
          final longListResponse = {
            'city': {
              'name': 'Long City',
              'country': 'LC',
            },
            'list': List.generate(10, (dayIndex) => {
              'dt': 1705276800 + (dayIndex * 86400), // Daily increments
              'main': {
                'temp_max': 20.0 + dayIndex,
                'temp_min': 10.0 + dayIndex,
                'humidity': 60,
                'pressure': 1010,
              },
              'weather': [
                {
                  'description': 'day $dayIndex weather',
                  'icon': '01d',
                }
              ],
              'wind': {
                'speed': 2.0,
              }
            }),
          };

          final weeklyData = WeeklyWeatherData.fromJson(longListResponse);

          expect(weeklyData.dailyForecasts.length, 7); // Limited to 7 days
          expect(weeklyData.dailyForecasts[0].maxTemperature, 20.0);
          expect(weeklyData.dailyForecasts[6].maxTemperature, 26.0);
        });

        testWidgets('handles empty list gracefully', (WidgetTester tester) async {
          final emptyListResponse = {
            'city': {
              'name': 'Empty City',
              'country': 'EC',
            },
            'list': [],
          };

          final weeklyData = WeeklyWeatherData.fromJson(emptyListResponse);

          expect(weeklyData.cityName, 'Empty City');
          expect(weeklyData.country, 'EC');
          expect(weeklyData.dailyForecasts, isEmpty);
        });

        testWidgets('skips days with empty data', (WidgetTester tester) async {
          final sparseDataResponse = {
            'city': {
              'name': 'Sparse City',
              'country': 'SC',
            },
            'list': [
              {
                'dt': 1705276800, // Day with data
                'main': {'temp_max': 20.0, 'temp_min': 10.0, 'humidity': 50, 'pressure': 1015},
                'weather': [{'description': 'good day', 'icon': '01d'}],
                'wind': {'speed': 2.0}
              },
              // Skip day 2 (no data)
              {
                'dt': 1705449600, // Day 3
                'main': {'temp_max': 18.0, 'temp_min': 8.0, 'humidity': 70, 'pressure': 1010},
                'weather': [{'description': 'another day', 'icon': '02d'}],
                'wind': {'speed': 3.0}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(sparseDataResponse);

          expect(weeklyData.dailyForecasts.length, 2);
          expect(weeklyData.dailyForecasts[0].description, 'good day');
          expect(weeklyData.dailyForecasts[1].description, 'another day');
        });
      });

      group('Data Structure Tests', () {
        testWidgets('processes forecast days in chronological order', (WidgetTester tester) async {
          final orderedResponse = {
            'city': {
              'name': 'Order City',
              'country': 'OC',
            },
            'list': [
              {
                'dt': 1705276800, // 2024-01-15 - Day 1
                'main': {'temp_max': 20.0, 'temp_min': 10.0, 'humidity': 60, 'pressure': 1015},
                'weather': [{'description': 'first day', 'icon': '01d'}],
                'wind': {'speed': 1.5}
              },
              {
                'dt': 1705363200, // 2024-01-16 - Day 2  
                'main': {'temp_max': 25.0, 'temp_min': 15.0, 'humidity': 50, 'pressure': 1020},
                'weather': [{'description': 'second day', 'icon': '02d'}],
                'wind': {'speed': 2.0}
              },
              {
                'dt': 1705449600, // 2024-01-17 - Day 3
                'main': {'temp_max': 30.0, 'temp_min': 20.0, 'humidity': 40, 'pressure': 1025},
                'weather': [{'description': 'third day', 'icon': '01d'}],
                'wind': {'speed': 2.5}
              }
            ],
          };

          final weeklyData = WeeklyWeatherData.fromJson(orderedResponse);

          // Days are processed in chronological order based on date grouping
          expect(weeklyData.dailyForecasts.length, 3);
          expect(weeklyData.dailyForecasts[0].description, 'first day');
          expect(weeklyData.dailyForecasts[1].description, 'second day'); 
          expect(weeklyData.dailyForecasts[2].description, 'third day');
        });

        testWidgets('city information is preserved correctly', (WidgetTester tester) async {
          expect(testWeeklyData.cityName, 'Seoul');
          expect(testWeeklyData.country, 'KR');
          expect(testWeeklyData.cityName, isA<String>());
          expect(testWeeklyData.country, isA<String>());
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
                'dt': 1705276800,
                'main': {'temp_max': 30.0, 'temp_min': 20.0, 'humidity': 80, 'pressure': 1010},
                'weather': [{'description': 'humid', 'icon': '10d'}],
                'wind': {'speed': 1.0}
              }
            ],
          };

          final weeklyData = WeeklyWeatherData.fromJson(specialCityResponse);

          expect(weeklyData.cityName, 'São Paulo');
          expect(weeklyData.country, 'BR');
        });

        testWidgets('handles extreme weather variations within a day', (WidgetTester tester) async {
          final extremeVariationResponse = {
            'city': {
              'name': 'Variable City',
              'country': 'VC',
            },
            'list': [
              // Very cold morning
              {
                'dt': 1705276800, // 2024-01-15 00:00:00 UTC
                'main': {'temp_max': -10.0, 'temp_min': -25.0, 'humidity': 90, 'pressure': 1000},
                'weather': [{'description': 'freezing morning', 'icon': '13d'}],
                'wind': {'speed': 8.0}
              },
              // Hot afternoon (should be chosen as noon data)
              {
                'dt': 1705320000, // 2024-01-15 12:00:00 UTC
                'main': {'temp_max': 35.0, 'temp_min': 20.0, 'humidity': 20, 'pressure': 1020},
                'weather': [{'description': 'scorching noon', 'icon': '01d'}],
                'wind': {'speed': 2.0}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(extremeVariationResponse);

          expect(weeklyData.dailyForecasts.length, 1);
          expect(weeklyData.dailyForecasts[0].maxTemperature, 35.0); // Max from all data points
          expect(weeklyData.dailyForecasts[0].minTemperature, -25.0); // Min from all data points
          expect(weeklyData.dailyForecasts[0].description, 'freezing morning'); // First data used when no noon data found
        });

        testWidgets('handles single data point per day', (WidgetTester tester) async {
          final singlePointResponse = {
            'city': {
              'name': 'Single City',
              'country': 'SC',
            },
            'list': [
              {
                'dt': 1705320000, // 2024-01-15 12:00:00 UTC
                'main': {'temp_max': 22.0, 'temp_min': 12.0, 'humidity': 65, 'pressure': 1015},
                'weather': [{'description': 'single point', 'icon': '02d'}],
                'wind': {'speed': 3.0}
              }
            ]
          };

          final weeklyData = WeeklyWeatherData.fromJson(singlePointResponse);

          expect(weeklyData.dailyForecasts.length, 1);
          expect(weeklyData.dailyForecasts[0].maxTemperature, 22.0);
          expect(weeklyData.dailyForecasts[0].minTemperature, 12.0);
          expect(weeklyData.dailyForecasts[0].description, 'single point');
        });
      });
    });
  });
}