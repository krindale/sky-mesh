import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/location_image_service.dart';

void main() {
  group('Chinese Municipalities Mapping Tests', () {
    
    test('should map Chinese municipalities to correct cities', () {
      final testCases = [
        {'input': 'Shanghai Municipality', 'expected': 'shanghai'},
        {'input': 'Beijing Municipality', 'expected': 'beijing'},
        {'input': 'Tianjin Municipality', 'expected': 'beijing'},
        {'input': 'Chongqing Municipality', 'expected': 'beijing'},
        {'input': 'Washington', 'expected': 'washington_dc'},
      ];

      for (final testCase in testCases) {
        final input = testCase['input']!;
        final expected = testCase['expected']!;
        
        final result = LocationImageService.selectBackgroundImage(
          cityName: input,
          countryCode: 'CN',
          weatherDescription: 'clear sky',
        );

        expect(result, contains('${expected}_sunny.webp'), 
               reason: '$input should map to $expected image');
        expect(result, isNot(contains('china_inland')), 
               reason: '$input should not use China inland fallback');
        
        print('✅ $input → ${expected}_sunny.webp');
      }
    });

    test('should handle case variations for all municipalities', () {
      final testCases = [
        'shanghai municipality',
        'SHANGHAI MUNICIPALITY', 
        'Shanghai Municipality',
        'beijing municipality',
        'BEIJING MUNICIPALITY',
        'Beijing Municipality'
      ];

      for (final cityName in testCases) {
        final result = LocationImageService.selectBackgroundImage(
          cityName: cityName,
          countryCode: 'CN',
          weatherDescription: 'overcast clouds',
        );
        
        // Beijing 또는 Shanghai 이미지를 사용해야 하고, china_inland fallback은 사용하면 안됨
        expect(
          result.contains('beijing_cloudy.webp') || result.contains('shanghai_cloudy.webp'),
          true,
          reason: '$cityName should map to beijing or shanghai, not china_inland'
        );
        expect(result, isNot(contains('china_inland')), 
               reason: '$cityName should not use China inland fallback');
        
        print('✅ $cityName → specific city image (not china_inland)');
      }
    });
  });
}