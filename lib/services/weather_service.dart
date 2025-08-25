/// 날씨 서비스 파사드 클래스
/// 
/// 이 파일은 UI 레이어를 위한 단순화된 날씨 서비스 인터페이스를 제공합니다.
/// Facade Pattern을 사용하여 복잡한 WeatherRepository와 ImageService의
/// 기능을 하나의 간편한 인터페이스로 통합합니다.
/// 
/// ## 아키텍처 패턴
/// - **Facade Pattern**: 복잡한 서브시스템을 단순한 인터페이스로 래핑
/// - **Dependency Injection**: ServiceLocator를 통한 의존성 주입
/// - **Composition**: WeatherRepository와 ImageService 조합
/// 
/// ## SOLID 원칙 준수
/// - **SRP**: UI를 위한 통합 인터페이스 제공만 담당
/// - **OCP**: 새로운 기능 추가 시 기존 코드 수정 불필요
/// - **LSP**: 각 리포지토리의 인터페이스 계약 준수
/// - **ISP**: 클라이언트가 필요한 기능만 노출
/// - **DIP**: 구체적 구현이 아닌 추상화에 의존
/// 
/// ## 제공 기능
/// - 현재 날씨 조회 (GPS 기반 / 좌표 기반)
/// - 랜덤 도시 날씨 조회
/// - 시간별 날씨 예보 (24시간)
/// - 주간 날씨 예보 (7일)
/// - 위치별 배경 이미지 선택
/// - 랜덤 배경 이미지 조회
/// 
/// @author krindale
/// @since 1.0.0

// 인터페이스 imports
import '../core/interfaces/weather_repository.dart';      // 날씨 데이터 리포지토리 인터페이스
import '../core/interfaces/image_service.dart';           // 이미지 서비스 인터페이스

// 모델 imports
import '../core/models/weather_data.dart';               // 현재 날씨 데이터 모델
import '../core/models/hourly_weather_data.dart';        // 시간별 날씨 예보 모델
import '../core/models/weekly_weather_data.dart';        // 주간 날씨 예보 모델
import '../core/models/weather_condition_card.dart';     // 날씨 컨디션 카드 모델

// 서비스 imports
import '../core/services/weather_condition_rule_engine.dart'; // 날씨 컨디션 규칙 엔진

// 의존성 주입 imports
import '../core/dependency_injection/service_locator.dart';  // 서비스 로케이터

/// UI 레이어를 위한 날씨 서비스 파사드
/// 
/// 이 클래스는 복잡한 날씨 관련 서비스들을 하나의 간단한 인터페이스로 통합합니다.
/// UI 컴포넌트는 이 클래스만 알면 되며, 내부의 복잡한 의존성은 숨겨집니다.
/// 
/// ## Facade Pattern의 장점
/// - **단순화**: 복잡한 서브시스템을 간단한 메서드로 접근
/// - **결합도 감소**: UI가 여러 서비스에 직접 의존하지 않음
/// - **유지보수성**: 내부 구현 변경 시 UI 코드 영향 최소화
/// - **테스트 용이성**: 단일 인터페이스로 목킹이 간편
/// 
/// ## 사용 예시
/// ```dart
/// final weatherService = WeatherService();
/// 
/// // 현재 날씨 조회
/// final currentWeather = await weatherService.getCurrentWeather();
/// 
/// // 배경 이미지 선택
/// final imagePath = weatherService.selectBackgroundImage(
///   cityName: currentWeather.cityName,
///   countryCode: currentWeather.country,
///   weatherDescription: currentWeather.description,
/// );
/// ```
class WeatherService {
  /// 날씨 데이터 조회를 담당하는 리포지토리
  /// WeatherRepository 인터페이스를 통해 실제 구현체와 분리
  final WeatherRepository _weatherRepository;
  
  /// 이미지 선택을 담당하는 서비스
  /// ImageService 인터페이스를 통해 위치별 배경 이미지 관리
  final ImageService _imageService;

  /// 날씨 컨디션 카드 규칙을 평가하는 엔진
  /// 날씨 조건에 따라 적절한 알림 카드를 생성
  final WeatherConditionRuleEngine _ruleEngine;

  /// WeatherService 생성자
  /// 
  /// 의존성 주입을 통해 서비스들을 초기화합니다.
  /// 파라미터로 전달되지 않으면 ServiceLocator에서 자동으로 가져옵니다.
  /// 
  /// @param weatherRepository 날씨 데이터 리포지토리 (선택적)
  /// @param imageService 이미지 서비스 (선택적)
  /// 
  /// ## 의존성 주입 패턴
  /// - **생성자 주입**: 명시적인 의존성 전달 가능
  /// - **서비스 로케이터**: 기본값으로 자동 해결
  /// - **테스트 지원**: 목 객체 주입으로 단위 테스트 용이
  /// 
  /// ## 사용 방법
  /// ```dart
  /// // 기본 사용 (ServiceLocator 의존)
  /// final service = WeatherService();
  /// 
  /// // 테스트용 목 객체 주입
  /// final service = WeatherService(
  ///   weatherRepository: mockWeatherRepository,
  ///   imageService: mockImageService,
  /// );
  /// ```
  WeatherService({
    WeatherRepository? weatherRepository,
    ImageService? imageService,
    WeatherConditionRuleEngine? ruleEngine,
  }) : _weatherRepository = weatherRepository ?? ServiceLocator().get<WeatherRepository>(),
       _imageService = imageService ?? ServiceLocator().get<ImageService>(),
       _ruleEngine = ruleEngine ?? WeatherConditionRuleEngine();

  // ====================================================================
  // 날씨 데이터 조회 메서드들
  // SRP와 DIP 원칙에 따라 WeatherRepository에 위임
  // ====================================================================

  /// 랜덤 도시의 날씨 정보 조회
  /// 
  /// 전 세계 68개 주요 도시 중에서 랜덤으로 선택된 도시의 현재 날씨를 반환합니다.
  /// 사용자가 다른 지역의 날씨를 탐색하거나 미리보기 데이터로 사용할 때 유용합니다.
  /// 
  /// @return Future<WeatherData> 랜덤 도시의 날씨 데이터
  /// @throws Exception 네트워크 오류, API 키 오류, 데이터 파싱 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   final randomWeather = await weatherService.getRandomCityWeather();
  ///   Logger.debug(랜덤 도시: ${randomWeather.cityName}');
  ///   Logger.debug(온도: ${randomWeather.temperatureString}');
  /// } catch (e) {
  ///   Logger.debug(랜덤 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 기대 동작
  /// - 68개 도시 중 무작위 선택
  /// - 선택된 도시의 현재 날씨 정보 조회
  /// - 전체 WeatherData 모델 반환 (온도, 습도, 풍속 등 포함)
  Future<WeatherData> getRandomCityWeather() async {
    return await _weatherRepository.getRandomCityWeather();
  }

  /// 디바이스 현재 위치의 날씨 정보 조회
  /// 
  /// GPS를 사용하여 디바이스의 현재 위치를 감지하고,
  /// 해당 위치의 날씨 정보를 조회합니다.
  /// 
  /// @return Future<WeatherData> 현재 위치의 날씨 데이터
  /// @throws Exception GPS 비활성화, 위치 권한 거부, 네트워크 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   final currentWeather = await weatherService.getCurrentWeather();
  ///   Logger.debug(현재 위치: ${currentWeather.cityName}');
  ///   Logger.debug(온도: ${currentWeather.temperatureString}');
  /// } catch (e) {
  ///   Logger.debug(현재 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 전제 조건
  /// - 위치 서비스 활성화 필요
  /// - 앱 위치 권한 허용 필요
  /// - 인터넷 연결 필요
  /// 
  /// ## 기대 동작
  /// - GPS로 현재 위치 감지
  /// - 해당 좌표의 날씨 데이터 조회
  /// - 도시명 자동 인식 및 매핑
  Future<WeatherData> getCurrentWeather() async {
    return await _weatherRepository.getCurrentWeather();
  }

  /// 지정된 좌표의 날씨 정보 조회
  /// 
  /// 사용자가 직접 지정한 위도와 경도 좌표에 대한 날씨 정보를 조회합니다.
  /// 지도에서 특정 지점을 선택하거나, 여행 계획 등에 유용합니다.
  /// 
  /// @param latitude 위도 (-90 ~ +90 범위)
  /// @param longitude 경도 (-180 ~ +180 범위)
  /// @return Future<WeatherData> 지정 좌표의 날씨 데이터
  /// @throws Exception 잘못된 좌표, 네트워크 오류, API 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   // 서울의 좌표
  ///   final seoulWeather = await weatherService.getWeatherByCoordinates(37.5665, 126.9780);
  ///   Logger.debug(서울 날씨: ${seoulWeather.temperatureString}');
  /// } catch (e) {
  ///   Logger.debug(좌표별 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 좌표 유효성 검증
  /// - 위도: -90도 (남극) ~ +90도 (북극)
  /// - 경도: -180도 ~ +180도 (국제날짜변경선 기준)
  /// - 육지 및 해상 모두 지원
  Future<WeatherData> getWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getWeatherByCoordinates(latitude, longitude);
  }

  /// 디바이스 현재 위치의 시간별 날씨 예보 조회
  /// 
  /// GPS를 사용하여 디바이스의 현재 위치를 감지하고,
  /// 24시간 동안의 시간별 날씨 예보를 조회합니다.
  /// 
  /// @return Future<HourlyWeatherData> 24시간 시간별 날씨 예보 데이터
  /// @throws Exception GPS 오류, 네트워크 오류, API 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   final hourlyData = await weatherService.getHourlyWeather();
  ///   for (final forecast in hourlyData.hourlyForecasts) {
  ///     Logger.debug(${forecast.hour}: ${forecast.temperatureString}');
  ///   }
  /// } catch (e) {
  ///   Logger.debug(시간별 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 제공 정보
  /// - 24시간 내 매시간 예보
  /// - 시간별 온도, 날씨 상태, 습도
  /// - 아이콘 코드로 날씨 상태 표현
  Future<HourlyWeatherData> getHourlyWeather() async {
    return await _weatherRepository.getHourlyWeather();
  }

  /// 지정된 좌표의 시간별 날씨 예보 조회
  /// 
  /// 사용자가 직접 지정한 위도와 경도 좌표에 대한 시간별 날씨 예보를 조회합니다.
  /// 여행지나 특정 지역의 하루 날씨 변화를 파악할 때 유용합니다.
  /// 
  /// @param latitude 위도 (-90 ~ +90 범위)
  /// @param longitude 경도 (-180 ~ +180 범위)
  /// @return Future<HourlyWeatherData> 지정 좌표의 시간별 날씨 예보
  /// @throws Exception 잘못된 좌표, 네트워크 오류, API 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   // 도쿄의 시간별 날씨
  ///   final tokyoHourly = await weatherService.getHourlyWeatherByCoordinates(35.6762, 139.6503);
  ///   Logger.debug(도쿄 내일 오전 9시: ${tokyoHourly.hourlyForecasts[9].temperatureString}');
  /// } catch (e) {
  ///   Logger.debug(좌표별 시간별 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 데이터 특징
  /// - 시간대 보정: UTC 기준에서 로컬 시간으로 자동 변환
  /// - 정확도: 1시간 단위로 비교적 정확한 예보
  /// - 상세 정보: 온도, 날씨 아이콘, 습도 포함
  Future<HourlyWeatherData> getHourlyWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getHourlyWeatherByCoordinates(latitude, longitude);
  }

  /// 디바이스 현재 위치의 주간 날씨 예보 조회
  /// 
  /// GPS를 사용하여 디바이스의 현재 위치를 감지하고,
  /// 7일간의 주간 날씨 예보를 조회합니다.
  /// 
  /// @return Future<WeeklyWeatherData> 7일간 주간 날씨 예보 데이터
  /// @throws Exception GPS 오류, 네트워크 오류, API 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   final weeklyData = await weatherService.getWeeklyWeather();
  ///   for (final daily in weeklyData.dailyForecasts) {
  ///     Logger.debug(${daily.dayOfWeek}: ${daily.maxTemperatureString}/${daily.minTemperatureString}');
  ///   }
  /// } catch (e) {
  ///   Logger.debug(주간 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 제공 정보
  /// - 7일간 일일 예보
  /// - 일별 최고/최저 온도
  /// - 날씨 상태와 아이콘
  /// - 요일별 정보 (오늘/내일/요일명)
  Future<WeeklyWeatherData> getWeeklyWeather() async {
    return await _weatherRepository.getWeeklyWeather();
  }

  /// 지정된 좌표의 주간 날씨 예보 조회
  /// 
  /// 사용자가 직접 지정한 위도와 경도 좌표에 대한 주간 날씨 예보를 조회합니다.
  /// 여행 계획이나 중장기 야외 활동 계획에 유용합니다.
  /// 
  /// @param latitude 위도 (-90 ~ +90 범위)
  /// @param longitude 경도 (-180 ~ +180 범위)
  /// @return Future<WeeklyWeatherData> 지정 좌표의 주간 날씨 예보
  /// @throws Exception 잘못된 좌표, 네트워크 오류, API 오류 등
  /// 
  /// ## 사용 예시
  /// ```dart
  /// try {
  ///   // 파리의 주간 날씨
  ///   final parisWeekly = await weatherService.getWeeklyWeatherByCoordinates(48.8566, 2.3522);
  ///   Logger.debug(파리 주말 날씨: ${parisWeekly.dailyForecasts[6].description}');
  /// } catch (e) {
  ///   Logger.debug(좌표별 주간 날씨 조회 실패: $e');
  /// }
  /// ```
  /// 
  /// ## 예보 정확도
  /// - 1-3일: 높은 정확도
  /// - 4-5일: 보통 정확도
  /// - 6-7일: 비교적 낮은 정확도 (참고용)
  Future<WeeklyWeatherData> getWeeklyWeatherByCoordinates(double latitude, double longitude) async {
    return await _weatherRepository.getWeeklyWeatherByCoordinates(latitude, longitude);
  }

  // ====================================================================
  // 이미지 선택 메서드들
  // ImageService에 위임하여 위치별 배경 이미지 관리
  // ====================================================================

  /// 위치와 날씨에 맞는 배경 이미지 선택
  /// 
  /// 도시명, 국가코드, 날씨 상태를 기반으로 가장 적합한 배경 이미지를 선택합닄다.
  /// 468개의 로우폴리 이미지 중에서 위치와 날씨에 최적화된 이미지를 반환합니다.
  /// 
  /// @param cityName 도시명 (예: "Seoul", "Tokyo")
  /// @param countryCode 국가코드 (예: "KR", "JP")
  /// @param weatherDescription 날씨 설명 (예: "clear sky", "light rain")
  /// @param latitude 위도 (선택적, 더 정확한 매칭을 위해)
  /// @param longitude 경도 (선택적, 더 정확한 매칭을 위해)
  /// @return String 선택된 배경 이미지의 에셉 경로
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final imagePath = weatherService.selectBackgroundImage(
  ///   cityName: "Seoul",
  ///   countryCode: "KR",
  ///   weatherDescription: "clear sky",
  ///   latitude: 37.5665,
  ///   longitude: 126.9780,
  /// );
  /// // 결과: "assets/location_images/regions/asia/seoul_sunny.webp"
  /// ```
  /// 
  /// ## 이미지 선택 로직
  /// 1. **도시 매칭**: 68개 주요 도시에서 직접 매칭
  /// 2. **지역 매칭**: 도시가 없으면 지역별 대체 이미지
  /// 3. **날씨 매칭**: 날씨 설명을 6가지 타입으로 분류
  /// 4. **랜덤 선택**: 모든 매칭이 실패하면 랜덤 이미지
  /// 
  /// ## 지원 날씨 타입
  /// - **cloudy**: 흐린 날씨
  /// - **foggy**: 안개 냀 날씨
  /// - **rainy**: 비 오는 날씨
  /// - **snowy**: 눈 오는 날씨
  /// - **sunny**: 맑은 날씨
  /// - **sunset**: 석양 시간대
  String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return _imageService.selectBackgroundImage(
      cityName: cityName,
      countryCode: countryCode,
      weatherDescription: weatherDescription,
      latitude: latitude,
      longitude: longitude,
      sunrise: sunrise,
      sunset: sunset,
    );
  }

  // ====================================================================
  // 날씨 컨디션 카드 메서드들
  // WeatherConditionRuleEngine에 위임하여 조건별 알림 카드 생성
  // ====================================================================

  /// 날씨 조건에 따른 컨디션 카드 목록 조회
  /// 
  /// 현재 날씨 데이터를 분석하여 사용자에게 유용한 정보를 제공하는
  /// 컨디션 카드들을 생성합니다. 폭염/한파, 자외선, 미세먼지, 강풍,
  /// 생활지수 등 다양한 카테고리의 알림을 포함합니다.
  /// 
  /// @param weatherData 분석할 날씨 데이터
  /// @return List<WeatherConditionCard> 적용되는 컨디션 카드들
  /// 
  /// ## 지원 카드 유형
  /// - **폭염/한파**: 33°C 이상 또는 -12°C 이하 시 알림
  /// - **자외선**: UV 지수 6 이상 시 알림
  /// - **미세먼지**: PM2.5 36µg/m³ 이상 또는 AQI 4 이상 시 알림
  /// - **강풍**: 풍속 9m/s 이상 시 알림
  /// - **생활지수**: 세차/빨래하기 좋은 조건 시 알림
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final currentWeather = await weatherService.getCurrentWeather();
  /// final conditionCards = weatherService.getWeatherConditionCards(currentWeather);
  /// 
  /// // UI에서 카드 표시
  /// for (final card in conditionCards) {
  ///   showWeatherCard(card);
  /// }
  /// ```
  /// 
  /// ## 카드 우선순위
  /// 1. **위험(danger)**: 빨간색 - 즉시 주의 필요
  /// 2. **경고(warning)**: 주황색 - 주의 필요  
  /// 3. **정보(info)**: 파란색 - 참고용 정보
  List<WeatherConditionCard> getWeatherConditionCards(
    WeatherData weatherData,
  ) {
    return _ruleEngine.evaluateConditions(weatherData);
  }

  /// 특정 카드 유형의 활성화 여부 확인
  /// 
  /// 현재 날씨 조건에서 특정 유형의 컨디션 카드가 표시되는지 확인합니다.
  /// UI에서 특정 카드의 존재 여부만 필요할 때 사용합니다.
  /// 
  /// @param weatherData 분석할 날씨 데이터
  /// @param cardType 확인할 카드 유형
  /// @return bool 해당 카드 유형이 활성화되었는지 여부
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final weather = await weatherService.getCurrentWeather();
  /// final hasHeatWaveAlert = weatherService.hasActiveConditionCard(
  ///   weather, 
  ///   WeatherCardType.heatWave,
  /// );
  /// 
  /// if (hasHeatWaveAlert) {
  ///   showHeatWaveIcon();
  /// }
  /// ```
  bool hasActiveConditionCard(
    WeatherData weatherData,
    WeatherCardType cardType,
  ) {
    final cards = getWeatherConditionCards(weatherData);
    return cards.any((card) => card.type == cardType);
  }

  /// 최고 심각도의 컨디션 카드 조회
  /// 
  /// 현재 활성화된 컨디션 카드 중에서 가장 높은 심각도를 가진
  /// 카드를 반환합니다. 메인 UI에서 대표 알림을 표시할 때 유용합니다.
  /// 
  /// @param weatherData 분석할 날씨 데이터
  /// @return WeatherConditionCard? 가장 심각한 카드 (없으면 null)
  /// 
  /// ## 심각도 순서
  /// 1. **danger** (위험): 즉시 행동 필요
  /// 2. **warning** (경고): 주의 필요
  /// 3. **info** (정보): 참고용
  WeatherConditionCard? getMostCriticalConditionCard(
    WeatherData weatherData,
  ) {
    final cards = getWeatherConditionCards(weatherData);
    if (cards.isEmpty) return null;
    
    // 이미 우선순위대로 정렬되어 반환되므로 첫 번째가 가장 심각
    return cards.first;
  }

  /// 랜덤 배경 이미지 경로 조회
  /// 
  /// 468개의 로우폴리 배경 이미지 중에서 무작위로 하나를 선택하여 반환합니다.
  /// 미리보기 화면이나 대기 화면에서 다양한 배경을 보여줄 때 유용합니다.
  /// 
  /// @return String 랜덤 선택된 배경 이미지의 에셉 경로
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final randomImagePath = weatherService.getRandomImagePath();
  /// // 가능한 결과 예시:
  /// // "assets/location_images/regions/europe/paris_sunset.webp"
  /// // "assets/location_images/regions/asia/tokyo_rainy.webp"
  /// // "assets/location_images/regional_fallback/oceania_extended/oceania_extended_cloudy.webp"
  /// ```
  /// 
  /// ## 이미지 풀
  /// - **68개 도시 이미지**: 주요 국제 도시들의 랜드마크 이미지
  /// - **10개 지역 이미지**: 지역별 대체 이미지
  /// - **6가지 날씨**: 각 위치별로 다양한 날씨 조건
  /// - **로우폴리 스타일**: 현대적이고 기하학적인 아트 스타일
  /// 
  /// ## 사용 용도
  /// - 스플래시 스크린 배경
  /// - 로딩 화면 배경
  /// - 대기 상태 시간 에 다양성 제공
  /// - 데모 모드나 미리보기 기능
  String getRandomImagePath() {
    return _imageService.getRandomImagePath();
  }

  // ====================================================================
  // 부분 업데이트 메서드들
  // 특정 API가 준비되었을 때 기존 날씨 데이터의 일부만 업데이트
  // ====================================================================

  /// UV 지수 데이터를 업데이트하고 관련 컨디션 카드를 갱신
  /// 
  /// UV API가 준비되었을 때 기존 WeatherData의 UV 지수만 업데이트하고,
  /// UV 관련 컨디션 카드를 재평가합니다.
  /// 
  /// @param weatherData 기존 날씨 데이터
  /// @param uvIndex 새로운 UV 지수 값
  /// @return WeatherData UV 지수가 업데이트된 날씨 데이터
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final updatedWeather = weatherService.updateUVIndex(
  ///   currentWeatherData,
  ///   7.5, // UV API에서 받은 값
  /// );
  /// 
  /// // 갱신된 컨디션 카드 조회
  /// final updatedCards = weatherService.getWeatherConditionCards(updatedWeather);
  /// ```
  WeatherData updateUVIndex(WeatherData weatherData, double uvIndex) {
    return WeatherData(
      temperature: weatherData.temperature,
      feelsLike: weatherData.feelsLike,
      humidity: weatherData.humidity,
      windSpeed: weatherData.windSpeed,
      description: weatherData.description,
      iconCode: weatherData.iconCode,
      cityName: weatherData.cityName,
      country: weatherData.country,
      pressure: weatherData.pressure,
      visibility: weatherData.visibility,
      uvIndex: uvIndex, // 업데이트된 UV 지수
      airQuality: weatherData.airQuality,
      pm25: weatherData.pm25,
      pm10: weatherData.pm10,
      precipitationProbability: weatherData.precipitationProbability,
      latitude: weatherData.latitude,
      longitude: weatherData.longitude,
      sunrise: weatherData.sunrise,
      sunset: weatherData.sunset,
    );
  }

  /// 대기질 데이터를 업데이트하고 관련 컨디션 카드를 갱신
  /// 
  /// 대기질 API가 준비되었을 때 기존 WeatherData의 대기질 정보만 업데이트하고,
  /// 대기질 관련 컨디션 카드를 재평가합니다.
  /// 
  /// @param weatherData 기존 날씨 데이터
  /// @param airQuality 대기질 지수 (1-5 스케일)
  /// @param pm25 PM2.5 농도 (µg/m³)
  /// @param pm10 PM10 농도 (µg/m³)
  /// @return WeatherData 대기질이 업데이트된 날씨 데이터
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final updatedWeather = weatherService.updateAirQuality(
  ///   currentWeatherData,
  ///   4, // AQI 지수
  ///   45.2, // PM2.5 농도
  ///   78.1, // PM10 농도
  /// );
  /// 
  /// // 갱신된 컨디션 카드 조회
  /// final updatedCards = weatherService.getWeatherConditionCards(updatedWeather);
  /// ```
  WeatherData updateAirQuality(
    WeatherData weatherData, 
    int airQuality, 
    double pm25, 
    double pm10,
  ) {
    return WeatherData(
      temperature: weatherData.temperature,
      feelsLike: weatherData.feelsLike,
      humidity: weatherData.humidity,
      windSpeed: weatherData.windSpeed,
      description: weatherData.description,
      iconCode: weatherData.iconCode,
      cityName: weatherData.cityName,
      country: weatherData.country,
      pressure: weatherData.pressure,
      visibility: weatherData.visibility,
      uvIndex: weatherData.uvIndex,
      airQuality: airQuality, // 업데이트된 대기질 지수
      pm25: pm25, // 업데이트된 PM2.5
      pm10: pm10, // 업데이트된 PM10
      precipitationProbability: weatherData.precipitationProbability,
      latitude: weatherData.latitude,
      longitude: weatherData.longitude,
      sunrise: weatherData.sunrise,
      sunset: weatherData.sunset,
    );
  }

  /// 특정 카드 유형의 컨디션 카드만 조회
  /// 
  /// 특정 API 데이터가 업데이트된 후 해당하는 컨디션 카드만 
  /// 선별적으로 조회할 때 사용합니다.
  /// 
  /// @param weatherData 분석할 날씨 데이터
  /// @param cardTypes 조회할 카드 유형들
  /// @return List<WeatherConditionCard> 지정된 유형의 컨디션 카드들
  /// 
  /// ## 사용 예시
  /// ```dart
  /// // UV 관련 카드만 조회
  /// final uvCards = weatherService.getSpecificConditionCards(
  ///   weatherData, 
  ///   [WeatherCardType.uvIndex],
  /// );
  /// 
  /// // 대기질 관련 카드만 조회  
  /// final airQualityCards = weatherService.getSpecificConditionCards(
  ///   weatherData, 
  ///   [WeatherCardType.airQuality],
  /// );
  /// ```
  List<WeatherConditionCard> getSpecificConditionCards(
    WeatherData weatherData,
    List<WeatherCardType> cardTypes,
  ) {
    final allCards = _ruleEngine.evaluateConditions(weatherData);
    return allCards.where((card) => cardTypes.contains(card.type)).toList();
  }
}