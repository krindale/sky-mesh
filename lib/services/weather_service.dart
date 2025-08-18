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
  }) : _weatherRepository = weatherRepository ?? ServiceLocator().get<WeatherRepository>(),
       _imageService = imageService ?? ServiceLocator().get<ImageService>();

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
  ///   print('랜덤 도시: ${randomWeather.cityName}');
  ///   print('온도: ${randomWeather.temperatureString}');
  /// } catch (e) {
  ///   print('랜덤 날씨 조회 실패: $e');
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
  ///   print('현재 위치: ${currentWeather.cityName}');
  ///   print('온도: ${currentWeather.temperatureString}');
  /// } catch (e) {
  ///   print('현재 날씨 조회 실패: $e');
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
  ///   print('서울 날씨: ${seoulWeather.temperatureString}');
  /// } catch (e) {
  ///   print('좌표별 날씨 조회 실패: $e');
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
  ///     print('${forecast.hour}: ${forecast.temperatureString}');
  ///   }
  /// } catch (e) {
  ///   print('시간별 날씨 조회 실패: $e');
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
  ///   print('도쿄 내일 오전 9시: ${tokyoHourly.hourlyForecasts[9].temperatureString}');
  /// } catch (e) {
  ///   print('좌표별 시간별 날씨 조회 실패: $e');
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
  ///     print('${daily.dayOfWeek}: ${daily.maxTemperatureString}/${daily.minTemperatureString}');
  ///   }
  /// } catch (e) {
  ///   print('주간 날씨 조회 실패: $e');
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
  ///   print('파리 주말 날씨: ${parisWeekly.dailyForecasts[6].description}');
  /// } catch (e) {
  ///   print('좌표별 주간 날씨 조회 실패: $e');
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
  /// // 결과: "assets/location_images/regions/asia/seoul_sunny.png"
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
  }) {
    return _imageService.selectBackgroundImage(
      cityName: cityName,
      countryCode: countryCode,
      weatherDescription: weatherDescription,
      latitude: latitude,
      longitude: longitude,
    );
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
  /// // "assets/location_images/regions/europe/paris_sunset.png"
  /// // "assets/location_images/regions/asia/tokyo_rainy.png"
  /// // "assets/location_images/regional_fallback/oceania_extended/oceania_extended_cloudy.png"
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
}