import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/data/services/openweather_api_service.dart';

void main() {
  group('RandomCityProvider Buffer Tests', () {
    setUp(() {
      // 각 테스트 전에 버퍼를 리셋
      RandomCityProvider.resetRecentlyShownBuffer();
    });

    test('should return different cities without repetition until all shown', () {
      final allCities = RandomCityProvider.getAllCities();
      final totalCities = allCities.length;
      final shownCities = <String>{};

      print('총 도시 수: $totalCities');

      // 모든 도시가 한 번씩 나올 때까지 테스트
      for (int i = 0; i < totalCities; i++) {
        final randomCity = RandomCityProvider.getRandomCity();
        final cityName = randomCity['name'];
        
        // 이미 보여진 도시가 다시 선택되지 않았는지 확인
        expect(shownCities.contains(cityName), false, 
               reason: '도시 "$cityName"가 이미 보여졌는데 다시 선택됨 (${i + 1}번째 시도)');
        
        shownCities.add(cityName);
        
        print('${i + 1}번째: $cityName');
        
        // 버퍼에 올바르게 추가되었는지 확인
        final recentCities = RandomCityProvider.getRecentlyShownCities();
        expect(recentCities.contains(cityName), true);
        expect(recentCities.length, i + 1);
      }

      // 모든 도시가 선택되었는지 확인
      expect(shownCities.length, totalCities);
    });

    test('should reset buffer and allow repetition after all cities shown', () {
      final allCities = RandomCityProvider.getAllCities();
      final totalCities = allCities.length;

      // 먼저 모든 도시를 한 번씩 선택
      for (int i = 0; i < totalCities; i++) {
        RandomCityProvider.getRandomCity();
      }

      // 모든 도시가 선택된 후 버퍼가 가득 찬 상태 확인
      expect(RandomCityProvider.getRecentlyShownCities().length, totalCities);

      // 한 번 더 선택하면 버퍼가 리셋되고 새로운 도시가 선택되어야 함
      final nextCity = RandomCityProvider.getRandomCity();
      
      // 버퍼가 리셋되어 1개만 있어야 함
      expect(RandomCityProvider.getRecentlyShownCities().length, 1);
      expect(RandomCityProvider.getRecentlyShownCities().contains(nextCity['name']), true);
      
      print('버퍼 리셋 후 선택된 도시: ${nextCity['name']}');
    });

    test('should include all newly added cities', () {
      final allCities = RandomCityProvider.getAllCities();
      final cityNames = allCities.map((city) => city['name']).toSet();

      // 새로 추가된 8개 도시들이 포함되어 있는지 확인
      final newCities = [
        'Delhi', 'Osaka', 'Doha', 'Madrid',
        'Milan', 'Montreal', 'Bogotá', 'Cape Town'
      ];

      for (final cityName in newCities) {
        expect(cityNames.contains(cityName), true, 
               reason: '새로 추가된 도시 "$cityName"가 목록에 없음');
      }

      print('새로 추가된 도시들이 모두 포함되어 있음: ${newCities.length}개');
    });

    test('should maintain randomness while avoiding repetition', () {
      RandomCityProvider.resetRecentlyShownBuffer();
      
      final selectedCities = <String>[];
      const testIterations = 10;

      // 10개의 도시를 선택하여 모두 다른지 확인
      for (int i = 0; i < testIterations; i++) {
        final city = RandomCityProvider.getRandomCity();
        final cityName = city['name'];
        
        expect(selectedCities.contains(cityName), false,
               reason: '도시 "$cityName"가 ${i + 1}번째에 중복 선택됨');
        
        selectedCities.add(cityName);
      }

      expect(selectedCities.length, testIterations);
      print('10번 연속 다른 도시 선택 성공');
    });

    test('should handle buffer reset correctly when full', () {
      final allCities = RandomCityProvider.getAllCities();
      final totalCities = allCities.length;
      
      // 모든 도시를 선택
      for (int i = 0; i < totalCities; i++) {
        RandomCityProvider.getRandomCity();
      }
      
      // 버퍼가 가득 찬 상태
      expect(RandomCityProvider.getRecentlyShownCities().length, totalCities);
      
      // 다음 선택 시 버퍼 리셋
      final cityAfterReset = RandomCityProvider.getRandomCity();
      
      // 버퍼가 리셋되어 1개만 있어야 함
      final bufferAfterReset = RandomCityProvider.getRecentlyShownCities();
      expect(bufferAfterReset.length, 1);
      expect(bufferAfterReset.contains(cityAfterReset['name']), true);
      
      print('버퍼 리셋 검증 완료');
    });
  });
}