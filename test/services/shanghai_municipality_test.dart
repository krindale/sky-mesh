import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/location_image_service.dart';

void main() {
  group('Shanghai Municipality Mapping Tests', () {

    test('should map "Shanghai Municipality" to shanghai images', () {
      // 다양한 날씨 조건에 대해 테스트 (실제 OpenWeather API에서 오는 형태)
      final testCases = [
        {'weather': 'clear sky', 'expected': 'shanghai_sunny.webp'},
        {'weather': 'overcast clouds', 'expected': 'shanghai_cloudy.webp'},
        {'weather': 'light rain', 'expected': 'shanghai_rainy.webp'},
        {'weather': 'mist', 'expected': 'shanghai_foggy.webp'},
        {'weather': 'light snow', 'expected': 'shanghai_snowy.webp'},
      ];

      for (final testCase in testCases) {
        final weather = testCase['weather']!;
        final expected = testCase['expected']!;
        
        final result = LocationImageService.selectBackgroundImage(
          cityName: 'Shanghai Municipality',
          countryCode: 'CN',
          weatherDescription: weather,
        );

        expect(result, contains(expected), 
               reason: 'Shanghai Municipality with $weather should map to shanghai image');
        expect(result, contains('assets/location_images/regions/asia/$expected'),
               reason: 'Should return full path to shanghai image');
        
        print('✅ Shanghai Municipality + $weather → $result');
      }
    });

    test('should not fall back to China inland for Shanghai Municipality', () {
      final result = LocationImageService.selectBackgroundImage(
        cityName: 'Shanghai Municipality',
        countryCode: 'CN',
        weatherDescription: 'clear sky',
      );

      // China inland fallback이 아닌 정확한 shanghai 이미지를 반환해야 함
      expect(result, contains('shanghai_sunny.webp'));
      expect(result, isNot(contains('china_inland')), 
             reason: 'Should not use China inland fallback for Shanghai Municipality');
      
      print('✅ Shanghai Municipality는 China inland fallback을 사용하지 않음');
    });

    test('should handle both "shanghai" and "Shanghai Municipality" identically', () {
      final weather = 'clear sky';
      
      final shanghaiResult = LocationImageService.selectBackgroundImage(
        cityName: 'shanghai',
        countryCode: 'CN',
        weatherDescription: weather,
      );
      final municipalityResult = LocationImageService.selectBackgroundImage(
        cityName: 'Shanghai Municipality',
        countryCode: 'CN',
        weatherDescription: weather,
      );
      
      expect(shanghaiResult, equals(municipalityResult), 
             reason: '"shanghai"와 "Shanghai Municipality"는 동일한 이미지를 반환해야 함');
      
      print('✅ "shanghai"와 "Shanghai Municipality" 동일 처리 확인');
    });

    test('should properly handle case sensitivity', () {
      final testCases = [
        'Shanghai Municipality',
        'shanghai municipality',
        'SHANGHAI MUNICIPALITY',
        'Shanghai municipality',
        'shanghai Municipality'
      ];

      for (final cityName in testCases) {
        final result = LocationImageService.selectBackgroundImage(
          cityName: cityName,
          countryCode: 'CN',
          weatherDescription: 'overcast clouds',
        );
        
        expect(result, contains('shanghai_cloudy.webp'), 
               reason: '$cityName should be case-insensitive and map to shanghai');
        
        print('✅ $cityName → shanghai_cloudy.webp');
      }
    });
  });
}