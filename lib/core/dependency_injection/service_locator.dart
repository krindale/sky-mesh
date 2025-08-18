/// 의존성 주입을 위한 서비스 로케이터
/// 
/// 이 파일은 SkyMesh 앱의 의존성 주입 컨테이너를 관리합니다.
/// DIP(Dependency Inversion Principle)을 따라 구현되어 있으며,
/// 모든 서비스와 리포지토리의 생명주기를 관리합니다.
/// 
/// ## 아키텍처 패턴
/// - **Service Locator Pattern**: 중앙집중식 의존성 관리
/// - **Singleton Pattern**: 앱 전체에서 하나의 인스턴스만 존재
/// - **Factory Pattern**: 지연 로딩을 통한 효율적인 인스턴스 생성
/// 
/// ## SOLID 원칙 준수
/// - **SRP**: 의존성 등록과 조회만 담당
/// - **OCP**: 새로운 서비스 추가 시 기존 코드 수정 불필요
/// - **DIP**: 구체적 구현체가 아닌 인터페이스에 의존
/// 
/// ## 사용법
/// ```dart
/// // 앱 시작 시 의존성 등록
/// ServiceLocator().registerDependencies();
/// 
/// // 서비스 조회
/// final weatherRepo = ServiceLocator().get<WeatherRepository>();
/// 
/// // 테스트용 목 서비스 등록
/// ServiceLocator().register<WeatherRepository>(() => MockWeatherRepository());
/// ```
/// 
/// @author krindale
/// @since 1.0.0

import 'weather_module.dart';

/// DIP(Dependency Inversion Principle)을 따르는 서비스 로케이터
/// 
/// 이 클래스는 앱 전체의 의존성 주입을 관리하며, 느슨한 결합을 보장하고
/// SOLID 원칙을 준수합니다. Singleton 패턴으로 구현되어 앱 전체에서
/// 하나의 인스턴스만 존재합니다.
/// 
/// ## 주요 특징
/// - **중앙집중식 의존성 관리**: 모든 서비스의 등록과 조회를 한 곳에서 관리
/// - **모듈화된 설정**: WeatherModule을 통한 관련 서비스 그룹화
/// - **테스트 지원**: 테스트용 목 객체 등록 및 초기화 지원
/// - **타입 안전성**: 제네릭을 활용한 컴파일 타임 타입 검증
/// 
/// ## 생명주기 관리
/// - 앱 시작 시 registerDependencies() 호출
/// - 서비스는 지연 로딩으로 첫 사용 시 생성
/// - 앱 종료 시까지 인스턴스 유지 (Singleton)
class ServiceLocator {
  /// Singleton 인스턴스 (앱 전체에서 단일 인스턴스 보장)
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  /// Factory 생성자 (항상 동일한 인스턴스 반환)
  factory ServiceLocator() => _instance;
  
  /// Private 생성자 (외부에서 인스턴스 생성 방지)
  ServiceLocator._internal();

  /// 실제 의존성 컨테이너 인스턴스
  /// ServiceContainer는 실제 서비스 등록과 조회를 담당
  final ServiceContainer _container = ServiceContainer();

  /// 모든 의존성을 모듈화된 방식으로 등록
  /// 
  /// 이 메서드는 앱 시작 시 main() 함수에서 호출되며,
  /// WeatherModule을 통해 날씨 관련 모든 서비스를 등록합니다.
  /// 
  /// ## 등록되는 서비스들
  /// - WeatherRepository: 날씨 데이터 조회 인터페이스
  /// - LocationService: GPS 위치 서비스 인터페이스
  /// - OpenWeatherApiService: OpenWeatherMap API 구현체
  /// - GeolocatorService: Geolocator 기반 위치 서비스 구현체
  /// 
  /// ## 모듈화 장점
  /// - 관련 서비스들의 그룹화
  /// - 설정의 중앙집중화
  /// - 테스트 시 모듈 단위 교체 가능
  void registerDependencies() {
    // WeatherModule을 사용하여 날씨 관련 모든 서비스 설정
    // 이 방식으로 관련 서비스들을 그룹화하고 의존성 관계를 명확히 함
    WeatherModule.configureServices(_container);
  }

  /// 등록된 서비스 인스턴스 조회
  /// 
  /// 제네릭 타입 T에 해당하는 서비스를 컨테이너에서 조회합니다.
  /// 서비스가 등록되지 않았거나 타입이 맞지 않으면 예외가 발생합니다.
  /// 
  /// @param T 조회할 서비스의 타입 (일반적으로 인터페이스)
  /// @return T 타입의 서비스 인스턴스
  /// @throws Exception 서비스가 등록되지 않은 경우
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final weatherRepo = ServiceLocator().get<WeatherRepository>();
  /// final locationService = ServiceLocator().get<LocationService>();
  /// ```
  T get<T>() {
    return _container.get<T>();
  }

  /// 서비스 수동 등록 (주로 테스트용)
  /// 
  /// 테스트 환경에서 실제 서비스 대신 목(Mock) 객체를 등록할 때 사용합니다.
  /// 프로덕션 코드에서는 일반적으로 registerDependencies()를 사용합니다.
  /// 
  /// @param factory 서비스 인스턴스를 생성하는 팩토리 함수
  /// 
  /// ## 테스트 사용 예시
  /// ```dart
  /// // 테스트 시작 전
  /// ServiceLocator().register<WeatherRepository>(() => MockWeatherRepository());
  /// 
  /// // 테스트 실행
  /// final repo = ServiceLocator().get<WeatherRepository>(); // MockWeatherRepository 반환
  /// ```
  void register<T>(T Function() factory) {
    _container.registerSingleton<T>(factory);
  }

  /// 모든 서비스 정리 (주로 테스트용)
  /// 
  /// 테스트 간에 상태를 초기화하거나 메모리를 정리할 때 사용합니다.
  /// 프로덕션 환경에서는 일반적으로 호출하지 않습니다.
  /// 
  /// ## 주의사항
  /// - 이 메서드 호출 후에는 모든 서비스를 다시 등록해야 함
  /// - 기존 서비스를 참조하고 있는 코드에서 오류 발생 가능
  /// 
  /// ## 테스트 사용 예시
  /// ```dart
  /// setUp(() {
  ///   ServiceLocator().clear();
  ///   ServiceLocator().registerDependencies();
  /// });
  /// ```
  void clear() {
    _container.clear();
  }

  /// 특정 타입의 서비스가 등록되었는지 확인
  /// 
  /// 서비스 조회 전에 등록 여부를 확인하거나, 조건부 로직에서 사용합니다.
  /// 
  /// @param T 확인할 서비스의 타입
  /// @return bool 등록 여부 (true: 등록됨, false: 등록되지 않음)
  /// 
  /// ## 사용 예시
  /// ```dart
  /// if (ServiceLocator().isRegistered<WeatherRepository>()) {
  ///   final repo = ServiceLocator().get<WeatherRepository>();
  ///   // 서비스 사용
  /// } else {
  ///   // 대체 로직 또는 오류 처리
  /// }
  /// ```
  bool isRegistered<T>() {
    return _container.isRegistered<T>();
  }

  /// 고급 작업을 위한 컨테이너 직접 접근
  /// 
  /// 일반적인 용도로는 권장되지 않으며, 고급 설정이나 디버깅 목적으로만 사용합니다.
  /// 대부분의 경우 get(), register() 메서드로 충분합니다.
  /// 
  /// @return ServiceContainer 실제 컨테이너 인스턴스
  /// 
  /// ## 주의사항
  /// - 직접 컨테이너를 조작하면 Service Locator의 캡슐화가 깨질 수 있음
  /// - 가능한 한 공개된 API(get, register 등)를 사용할 것을 권장
  ServiceContainer get container => _container;
}