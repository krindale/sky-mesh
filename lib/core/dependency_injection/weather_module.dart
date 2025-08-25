/// 날씨 관련 의존성 주입 모듈
/// 
/// 이 파일은 SkyMesh 앱의 날씨 관련 모든 서비스와 의존성을 설정합니다.
/// DIP(Dependency Inversion Principle)을 따라 구현되어 있으며,
/// 모든 날씨 관련 컴포넌트들 간의 의존성 관계를 정의합니다.
/// 
/// ## 아키텍처 특징
/// - **Module Pattern**: 관련 서비스들을 그룹화하여 관리
/// - **Interface Segregation**: ISP를 따라 역할별 인터페이스 분리
/// - **Dependency Inversion**: 구체적 구현이 아닌 추상화에 의존
/// - **Singleton Pattern**: 앱 전체에서 단일 인스턴스 보장
/// 
/// ## 등록되는 서비스들
/// ### 1. 핵심 서비스
/// - LocationService: GPS 위치 조회 서비스
/// - ImageService: 위치별 이미지 매핑 서비스
/// 
/// ### 2. 날씨 서비스 (ISP 원칙)
/// - WeatherRepository: 통합 날씨 데이터 리포지토리
/// - CurrentWeatherService: 현재 날씨 조회 전용
/// - WeatherForecastService: 날씨 예보 조회 전용
/// - RandomWeatherService: 랜덤 도시 날씨 조회 전용
/// 
/// ### 3. 지원 서비스
/// - WeatherConfigurationService: API 설정 관리
/// - WeatherDataValidator: 데이터 유효성 검증
/// 
/// @author krindale
/// @since 1.0.0

// 인터페이스 imports (DIP를 위한 추상화 계층)
import '../interfaces/weather_repository.dart';      // 날씨 데이터 리포지토리 인터페이스
import '../interfaces/location_service.dart';        // 위치 서비스 인터페이스
import '../interfaces/image_service.dart';           // 이미지 서비스 인터페이스
import '../interfaces/weather_interfaces.dart';      // ISP를 위한 세분화된 날씨 인터페이스들
import '../models/weather_data.dart';                // WeatherData 모델

// 구체적 구현체 imports (실제 비즈니스 로직)
import '../../data/services/openweather_api_service.dart';    // OpenWeatherMap API 구현체
import '../../data/services/geolocator_service.dart';         // Geolocator 기반 위치 서비스
import '../../data/services/location_image_service_impl.dart'; // 위치-이미지 매핑 구현체

/// DIP(Dependency Inversion Principle)을 따르는 날씨 모듈
/// 
/// 이 클래스는 날씨 관련 모든 의존성을 설정하고 관리합니다.
/// 각 서비스는 인터페이스를 통해 등록되어 구체적 구현체로부터 분리됩니다.
/// 
/// ## 설계 원칙
/// - **SRP**: 날씨 관련 의존성 설정만 담당
/// - **OCP**: 새로운 구현체 추가 시 기존 코드 수정 불필요
/// - **ISP**: 역할별로 분리된 인터페이스 사용
/// - **DIP**: 추상화에 의존하여 구체적 구현체와 분리
/// 
/// ## 의존성 그래프
/// ```
/// WeatherRepository ←→ LocationService
///         ↓
/// OpenWeatherApiService ←→ GeolocatorService
///         ↓
/// WeatherConfigurationService, WeatherDataValidator
/// ```
/// 
/// ## 생명주기 관리
/// - 모든 서비스는 Singleton으로 등록
/// - 지연 로딩: 첫 사용 시점에 인스턴스 생성
/// - 순환 의존성 방지: 의존성 순서 고려하여 등록
class WeatherModule {
  /// 날씨 관련 모든 서비스를 컨테이너에 등록
  /// 
  /// 이 메서드는 ServiceLocator에서 호출되며, 모든 날씨 관련 서비스를
  /// 올바른 의존성 순서로 등록합니다.
  /// 
  /// @param container 서비스 등록을 위한 DI 컨테이너
  /// 
  /// ## 등록 순서
  /// 1. 핵심 서비스 (의존성 없음)
  /// 2. 날씨 서비스 (핵심 서비스에 의존)
  /// 3. 지원 서비스 (독립적)
  /// 
  /// ## 주의사항
  /// - 의존성 순서를 변경할 때는 순환 의존성 주의
  /// - 새로운 서비스 추가 시 인터페이스 우선 등록
  static void configureServices(ServiceContainer container) {
    // === 1단계: 핵심 서비스 등록 (의존성 없음) ===
    
    /// GPS 기반 위치 서비스 등록
    /// Geolocator 패키지를 사용하여 현재 위치를 조회
    /// 권한 관리 및 오류 처리 포함
    container.registerSingleton<LocationService>(() => GeolocatorService());
    
    /// 위치-이미지 매핑 서비스 등록
    /// 위치와 날씨 조건에 따라 적절한 로우폴리 배경 이미지 선택
    /// 68개 주요 도시의 이미지 매핑 로직 포함
    container.registerSingleton<ImageService>(() => LocationImageServiceImpl());
    
    // === 2단계: 날씨 서비스 등록 (ISP 원칙 준수) ===
    
    /// 통합 날씨 데이터 리포지토리 등록
    /// OpenWeatherMap API를 사용하여 현재 날씨, 예보 등 모든 날씨 데이터 제공
    /// LocationService에 의존하여 GPS 기반 날씨 조회 가능
    container.registerSingleton<WeatherRepository>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    /// ISP(Interface Segregation Principle)를 따른 세분화된 날씨 서비스들
    /// 클라이언트는 필요한 기능만 의존하도록 인터페이스 분리
    
    /// 현재 날씨 조회 전용 서비스
    /// UI에서 현재 날씨만 필요한 경우 사용
    container.registerSingleton<CurrentWeatherService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    /// 날씨 예보 조회 전용 서비스
    /// 시간별/주간 예보가 필요한 경우 사용
    container.registerSingleton<WeatherForecastService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    /// 랜덤 도시 날씨 조회 전용 서비스
    /// 전 세계 도시 탐색 기능에서 사용
    container.registerSingleton<RandomWeatherService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    // === 3단계: 지원 서비스 등록 (독립적) ===
    
    /// 날씨 API 설정 관리 서비스
    /// API 키, 단위, 타임아웃 등의 설정을 관리
    /// 런타임에 설정 변경 가능
    container.registerSingleton<WeatherConfigurationService>(() => WeatherConfiguration());
    
    /// 날씨 데이터 유효성 검증 서비스
    /// API 응답 데이터의 무결성 및 합리성 검증
    /// 온도, 습도, 좌표 등의 유효 범위 체크
    container.registerSingleton<WeatherDataValidator>(() => WeatherDataValidatorImpl());
  }
}

/// 의존성 주입을 위한 간단한 서비스 컨테이너
/// 
/// 이 클래스는 서비스의 등록, 조회, 생명주기 관리를 담당합니다.
/// Singleton과 Transient 라이프사이클을 지원하며, 타입 안전성을 보장합니다.
/// 
/// ## 지원하는 라이프사이클
/// - **Singleton**: 앱 전체에서 하나의 인스턴스만 생성 및 재사용
/// - **Transient**: 매번 새로운 인스턴스 생성 (현재 구현에서는 미사용)
/// 
/// ## 내부 구조
/// - _factories: 타입별 팩토리 함수를 저장하는 맵
/// - _singletons: 생성된 Singleton 인스턴스를 캐시하는 맵
/// 
/// ## 사용 패턴
/// ```dart
/// final container = ServiceContainer();
/// 
/// // 서비스 등록
/// container.registerSingleton<MyService>(() => MyServiceImpl());
/// 
/// // 서비스 조회
/// final service = container.get<MyService>();
/// ```
class ServiceContainer {
  /// 타입별 팩토리 함수를 저장하는 맵
  /// Key: 서비스 타입 (Type), Value: 인스턴스 생성 팩토리 함수
  final Map<Type, dynamic Function()> _factories = {};
  
  /// 생성된 Singleton 인스턴스를 캐시하는 맵
  /// Key: 서비스 타입 (Type), Value: 생성된 인스턴스
  /// 메모리 효율성과 성능을 위해 한 번 생성된 인스턴스를 재사용
  final Map<Type, dynamic> _singletons = {};

  /// Singleton 라이프사이클로 서비스 등록
  /// 
  /// 앱 전체에서 하나의 인스턴스만 생성되며, 첫 번째 조회 시점에 생성됩니다.
  /// 이후 동일한 타입의 서비스 조회 시 동일한 인스턴스를 반환합니다.
  /// 
  /// @param T 등록할 서비스의 타입 (일반적으로 인터페이스)
  /// @param factory 인스턴스를 생성하는 팩토리 함수
  /// 
  /// ## 사용 예시
  /// ```dart
  /// container.registerSingleton<WeatherRepository>(() => OpenWeatherApiService());
  /// ```
  /// 
  /// ## 장점
  /// - 메모리 효율성: 하나의 인스턴스만 유지
  /// - 상태 공유: 앱 전체에서 동일한 상태 공유 가능
  /// - 성능: 인스턴스 생성 비용 최소화
  void registerSingleton<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// Transient 라이프사이클로 서비스 등록 (현재 미사용)
  /// 
  /// 매번 새로운 인스턴스를 생성합니다. 상태를 공유하지 않는 
  /// 독립적인 서비스에 사용됩니다.
  /// 
  /// @param T 등록할 서비스의 타입
  /// @param factory 인스턴스를 생성하는 팩토리 함수
  /// 
  /// ## 주의사항
  /// - 현재 구현에서는 실제로 Transient로 동작하지 않음
  /// - 향후 확장을 위해 남겨둔 메서드
  void registerTransient<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// 등록된 서비스 인스턴스 조회
  /// 
  /// 제네릭 타입 T에 해당하는 서비스 인스턴스를 반환합니다.
  /// Singleton의 경우 캐시된 인스턴스를 반환하고, 
  /// 처음 조회하는 경우 팩토리 함수를 실행하여 인스턴스를 생성합니다.
  /// 
  /// @param T 조회할 서비스의 타입
  /// @return T 타입의 서비스 인스턴스
  /// @throws Exception 서비스가 등록되지 않은 경우
  /// 
  /// ## 실행 과정
  /// 1. 캐시에서 기존 인스턴스 확인
  /// 2. 있으면 기존 인스턴스 반환 (Singleton 특성)
  /// 3. 없으면 팩토리 함수로 새 인스턴스 생성
  /// 4. 생성된 인스턴스를 캐시에 저장 후 반환
  T get<T>() {
    // 1단계: 이미 생성된 Singleton 인스턴스가 있는지 확인
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    // 2단계: 등록된 팩토리 함수 조회
    final factory = _factories[T];
    if (factory == null) {
      throw Exception('Service of type $T is not registered');
    }

    // 3단계: 팩토리 함수를 사용하여 새 인스턴스 생성
    final instance = factory() as T;
    
    // 4단계: Singleton 캐시에 저장하여 향후 재사용
    _singletons[T] = instance;
    
    return instance;
  }

  /// 특정 타입의 서비스가 등록되었는지 확인
  /// 
  /// 서비스 조회 전에 등록 여부를 미리 확인하거나,
  /// 조건부 로직에서 사용할 수 있습니다.
  /// 
  /// @param T 확인할 서비스의 타입
  /// @return bool 등록 여부 (true: 등록됨, false: 등록되지 않음)
  /// 
  /// ## 사용 예시
  /// ```dart
  /// if (container.isRegistered<WeatherRepository>()) {
  ///   final repo = container.get<WeatherRepository>();
  /// }
  /// ```
  bool isRegistered<T>() {
    return _factories.containsKey(T);
  }

  /// 모든 서비스와 캐시 정리
  /// 
  /// 등록된 모든 팩토리 함수와 생성된 인스턴스를 제거합니다.
  /// 주로 테스트 환경에서 상태 초기화 목적으로 사용됩니다.
  /// 
  /// ## 정리되는 데이터
  /// - 모든 팩토리 함수 (_factories)
  /// - 모든 Singleton 인스턴스 (_singletons)
  /// 
  /// ## 주의사항
  /// - 이 메서드 호출 후에는 모든 서비스를 다시 등록해야 함
  /// - 기존 인스턴스를 참조하고 있는 코드에서 오류 발생 가능
  /// - 프로덕션 환경에서는 일반적으로 호출하지 않음
  void clear() {
    _factories.clear();
    _singletons.clear();
  }
}

/// 날씨 API 설정 관리 서비스 구현체
/// 
/// WeatherConfigurationService 인터페이스의 구체적 구현으로,
/// OpenWeatherMap API와 관련된 모든 설정을 관리합니다.
/// 런타임에 설정 변경이 가능하며, 유효성 검증을 포함합니다.
/// 
/// ## 관리하는 설정들
/// - **API Key**: OpenWeatherMap API 인증키
/// - **Units**: 온도 단위 (metric/imperial/kelvin)
/// - **Timeout**: API 호출 타임아웃 설정
/// 
/// ## 기본값
/// - API Key: 개발용 키 (프로덕션에서는 변경 필요)
/// - Units: metric (섭씨 온도)
/// - Timeout: 10초
/// 
/// ## 사용 예시
/// ```dart
/// final config = WeatherConfiguration();
/// config.setApiKey('your-api-key');
/// config.setUnits('imperial'); // 화씨 온도로 변경
/// config.setTimeout(Duration(seconds: 15));
/// ```
class WeatherConfiguration implements WeatherConfigurationService {
  /// OpenWeatherMap API 인증키
  /// 기본값은 개발/테스트용이며, 프로덕션에서는 보안이 적용된 키로 변경 필요
  String _apiKey = 'a179131038d53e44738851b4938c5cd0';
  
  /// 온도 및 기타 측정 단위
  /// - metric: 섭씨, m/s, hPa (기본값)
  /// - imperial: 화씨, mph, hPa
  /// - kelvin: 켈빈, m/s, hPa
  String _units = 'metric';
  
  /// API 호출 타임아웃 설정
  /// 네트워크 상태가 불안정한 환경을 고려하여 10초로 설정
  Duration _timeout = const Duration(seconds: 10);

  /// OpenWeatherMap API 키 설정
  /// 
  /// API 호출 시 사용할 인증키를 설정합니다.
  /// 프로덕션 환경에서는 환경변수나 보안 저장소에서 로드해야 합니다.
  /// 
  /// @param apiKey 유효한 OpenWeatherMap API 키
  /// 
  /// ## 보안 고려사항
  /// - API 키는 소스코드에 하드코딩하지 말 것
  /// - 환경변수나 암호화된 설정 파일 사용 권장
  /// - 키 로테이션 정책 수립 필요
  @override
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  /// 측정 단위 시스템 설정
  /// 
  /// OpenWeatherMap API에서 지원하는 단위 시스템을 설정합니다.
  /// 잘못된 단위 입력 시 ArgumentError가 발생합니다.
  /// 
  /// @param units 측정 단위 ('metric', 'imperial', 'kelvin' 중 하나)
  /// @throws ArgumentError 지원하지 않는 단위 입력 시
  /// 
  /// ## 지원 단위
  /// - **metric**: 섭씨(°C), 미터/초(m/s), 헥토파스칼(hPa)
  /// - **imperial**: 화씨(°F), 마일/시(mph), 헥토파스칼(hPa)  
  /// - **kelvin**: 켈빈(K), 미터/초(m/s), 헥토파스칼(hPa)
  @override
  void setUnits(String units) {
    if (['metric', 'imperial', 'kelvin'].contains(units)) {
      _units = units;
    } else {
      throw ArgumentError('Invalid units: $units. Must be metric, imperial, or kelvin');
    }
  }

  /// API 호출 타임아웃 설정
  /// 
  /// 네트워크 요청의 최대 대기 시간을 설정합니다.
  /// 너무 짧으면 타임아웃 오류가 빈번하고, 너무 길면 사용자 경험이 저하됩니다.
  /// 
  /// @param timeout 타임아웃 Duration (권장: 5-30초)
  /// 
  /// ## 권장 설정
  /// - 모바일 네트워크: 15-20초
  /// - WiFi 환경: 10-15초
  /// - 테스트 환경: 5-10초
  @override
  void setTimeout(Duration timeout) {
    _timeout = timeout;
  }

  /// 현재 설정된 측정 단위 조회
  /// 
  /// API 호출 시 실제로 사용되는 단위 시스템을 반환합니다.
  /// 
  /// @return 현재 단위 시스템 문자열
  @override
  String get currentUnits => _units;

  /// 현재 설정된 타임아웃 시간 조회
  /// 
  /// API 호출 시 적용되는 타임아웃 설정을 반환합니다.
  /// 
  /// @return 현재 타임아웃 Duration
  @override
  Duration get currentTimeout => _timeout;

  /// 현재 설정된 API 키 조회
  /// 
  /// API 호출 시 사용되는 인증키를 반환합니다.
  /// 보안상 로깅이나 디버깅 시에는 마스킹 처리 권장합니다.
  /// 
  /// @return 현재 API 키
  /// 
  /// ## 보안 주의사항
  /// - 로그에 API 키가 노출되지 않도록 주의
  /// - 디버그 모드에서만 전체 키 노출 허용
  String get apiKey => _apiKey;
}

/// 날씨 데이터 유효성 검증 서비스 구현체
/// 
/// WeatherDataValidator 인터페이스의 구체적 구현으로,
/// API로부터 받은 날씨 데이터의 무결성과 합리성을 검증합니다.
/// 잘못된 데이터로 인한 앱 오류를 방지하고 사용자 경험을 보장합니다.
/// 
/// ## 검증 대상
/// - **온도 데이터**: 물리적으로 가능한 온도 범위 확인
/// - **습도 데이터**: 0-100% 범위 확인
/// - **좌표 데이터**: 지구상 유효한 위도/경도 범위 확인
/// - **날씨 객체**: 필수 필드 존재 및 유효성 확인
/// 
/// ## 검증 기준
/// - 온도: -100°C ~ +60°C (지구상 기록된 극한 온도 고려)
/// - 습도: 0% ~ 100% (물리적 한계)
/// - 위도: -90° ~ +90° (남극점 ~ 북극점)
/// - 경도: -180° ~ +180° (국제날짜변경선 기준)
/// 
/// ## 사용 목적
/// - API 응답 데이터 신뢰성 확보
/// - 예외상황에서의 앱 안정성 보장
/// - 데이터 오염으로 인한 UI 오류 방지
class WeatherDataValidatorImpl implements WeatherDataValidator {
  /// 날씨 데이터 객체의 전체적인 유효성 검증
  /// 
  /// WeatherData 객체의 모든 필수 필드와 주요 데이터 값들을
  /// 종합적으로 검증합니다. 하나라도 유효하지 않으면 false를 반환합니다.
  /// 
  /// @param data 검증할 WeatherData 객체 (null 가능)
  /// @return bool 전체 데이터의 유효성 (true: 유효, false: 무효)
  /// 
  /// ## 검증 항목
  /// 1. **null 체크**: 객체 자체가 null이 아닌지 확인
  /// 2. **온도 유효성**: 물리적으로 가능한 온도 범위인지 확인
  /// 3. **습도 유효성**: 0-100% 범위 내인지 확인
  /// 4. **도시명**: 비어있지 않은 유효한 문자열인지 확인
  /// 5. **국가코드**: 비어있지 않은 유효한 문자열인지 확인
  /// 6. **날씨설명**: 비어있지 않은 유효한 문자열인지 확인
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final validator = WeatherDataValidatorImpl();
  /// final weatherData = await weatherService.getCurrentWeather();
  /// 
  /// if (validator.isValidWeatherData(weatherData)) {
  ///   // 유효한 데이터로 UI 업데이트
  ///   updateUI(weatherData);
  /// } else {
  ///   // 오류 처리 또는 기본 데이터 사용
  ///   showErrorMessage();
  /// }
  /// ```
  @override
  bool isValidWeatherData(WeatherData data) {
    // WeatherData is non-nullable, so we can skip null check
    
    // 2단계: 모든 필수 필드의 유효성을 논리 AND로 결합
    // 하나라도 실패하면 전체가 false가 됨
    return isValidTemperature(data.temperature) &&      // 온도 범위 확인
           isValidHumidity(data.humidity) &&            // 습도 범위 확인
           data.cityName.isNotEmpty &&                  // 도시명 존재 확인
           data.country.isNotEmpty &&                   // 국가코드 존재 확인
           data.description.isNotEmpty;                 // 날씨설명 존재 확인
  }

  /// 지리적 좌표의 유효성 검증
  /// 
  /// 위도와 경도가 지구상에서 유효한 범위 내에 있는지 확인합니다.
  /// GPS 데이터나 API 응답의 좌표 정보 검증에 사용됩니다.
  /// 
  /// @param latitude 위도 (-90 ~ +90)
  /// @param longitude 경도 (-180 ~ +180)
  /// @return bool 좌표의 유효성 (true: 유효, false: 무효)
  /// 
  /// ## 검증 범위
  /// - **위도 (Latitude)**: -90° (남극점) ~ +90° (북극점)
  /// - **경도 (Longitude)**: -180° ~ +180° (국제날짜변경선 기준)
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final validator = WeatherDataValidatorImpl();
  /// 
  /// if (validator.isValidCoordinates(37.5665, 126.9780)) {
  ///   // 서울의 좌표는 유효함
  ///   fetchWeatherByCoordinates(37.5665, 126.9780);
  /// }
  /// ```
  @override
  bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 &&        // 위도는 -90° ~ +90°
           longitude >= -180 && longitude <= 180;       // 경도는 -180° ~ +180°
  }

  /// 온도 데이터의 유효성 검증
  /// 
  /// 입력된 온도가 지구상에서 물리적으로 가능한 범위 내에 있는지 확인합니다.
  /// 극한 환경을 고려하되, 명백히 잘못된 데이터는 걸러냅니다.
  /// 
  /// @param temperature 섭씨 온도 (Celsius)
  /// @return bool 온도의 유효성 (true: 유효, false: 무효)
  /// 
  /// ## 검증 범위: -100°C ~ +60°C
  /// - **하한선 (-100°C)**: 남극 최저 기록온도 (-89.2°C)보다 여유있게 설정
  /// - **상한선 (+60°C)**: 사막 지역 최고 기록온도 (+54.4°C)보다 여유있게 설정
  /// 
  /// ## 고려사항
  /// - 기후변화로 인한 극한 온도 가능성 고려
  /// - API 오류나 센서 이상으로 인한 비현실적 값 배제
  /// - 섭씨 기준이므로 화씨 변환 시 주의 필요
  /// 
  /// ## 참고 기록
  /// - 지구 최저온도: -89.2°C (남극 보스토크 기지, 1983년)
  /// - 지구 최고온도: +54.4°C (데스 밸리, 2013년)
  @override
  bool isValidTemperature(double temperature) {
    // 물리적으로 합리적인 온도 범위: -100°C ~ +60°C
    // 극한 환경을 고려하되 명백한 오류 데이터는 배제
    return temperature >= -100 && temperature <= 60;
  }

  /// 습도 데이터의 유효성 검증
  /// 
  /// 상대습도가 물리적으로 가능한 0-100% 범위 내에 있는지 확인합니다.
  /// 상대습도는 백분율로 표현되며 100%를 초과할 수 없습니다.
  /// 
  /// @param humidity 상대습도 백분율 (0-100)
  /// @return bool 습도의 유효성 (true: 유효, false: 무효)
  /// 
  /// ## 검증 범위: 0% ~ 100%
  /// - **0%**: 완전 건조 상태 (사막 등)
  /// - **100%**: 포화 상태 (안개, 비 등)
  /// 
  /// ## 물리적 의미
  /// - 상대습도는 현재 공기 중 수증기량 / 최대 가능 수증기량 × 100
  /// - 100%를 초과하면 결로(이슬) 현상 발생
  /// - 음수는 물리적으로 불가능
  /// 
  /// ## 일반적인 습도 범위
  /// - 사막: 10-30%
  /// - 일반적인 실내: 40-60%
  /// - 열대우림: 80-95%
  /// - 안개/비: 95-100%
  @override
  bool isValidHumidity(int humidity) {
    // 상대습도는 0%에서 100% 사이의 값만 물리적으로 가능
    return humidity >= 0 && humidity <= 100;
  }
}