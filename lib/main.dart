/// SkyMesh 애플리케이션의 진입점
/// 
/// 이 파일은 SkyMesh 날씨 앱의 main entry point로, 다음과 같은 역할을 수행합니다:
/// - 의존성 주입 초기화 (DIP 원칙 준수)
/// - MaterialApp 설정 및 테마 적용
/// - 메인 홈페이지 위젯 정의
/// - 날씨 데이터 관리 및 UI 상태 관리
/// 
/// ## 아키텍처 특징
/// - SOLID 원칙을 준수하는 클린 아키텍처
/// - 의존성 주입을 통한 느슨한 결합
/// - 단일 책임 원칙에 따른 컴포넌트 분리
/// - 반응형 UI와 상태 관리
/// 
/// ## 주요 기능
/// - 실시간 GPS 기반 위치 추적
/// - OpenWeatherMap API를 통한 날씨 데이터 조회
/// - 위치와 날씨에 맞는 동적 배경 이미지
/// - 랜덤 도시 날씨 탐색 기능
/// - 30분 주기 자동 날씨 갱신
/// 
/// @author krindale
/// @version 1.0.0
/// @since 2024

// Flutter 프레임워크 관련 imports
import 'package:flutter/material.dart';      // Material Design 컴포넌트
import 'package:flutter/services.dart';     // 시스템 서비스 (현재 미사용, 향후 확장용)
import 'dart:async';                        // 비동기 프로그래밍 (Timer 등)

// 애플리케이션 모듈 imports (계층별로 구성)
import 'design_system/design_system.dart';           // 디자인 시스템 (색상, 타이포그래피 등)
import 'widgets/background_image_widget.dart';       // 배경 이미지 위젯 (현재 미사용)
import 'utils/image_assets.dart';                    // 이미지 에셋 관리 유틸리티
import 'services/weather_service.dart';              // 날씨 서비스 파사드
import 'services/location_image_service.dart';       // 위치-이미지 매핑 서비스
import 'widgets/weather_display_widget.dart';        // 날씨 정보 표시 위젯
import 'core/dependency_injection/service_locator.dart'; // DI 컨테이너
import 'core/models/weather_data.dart';              // 날씨 데이터 모델
import 'core/models/hourly_weather_data.dart';       // 시간별 날씨 데이터 모델
import 'core/models/weekly_weather_data.dart';       // 주간 날씨 데이터 모델

/// 애플리케이션 진입점
/// 
/// 앱 시작 시 다음 작업을 수행합니다:
/// 1. 의존성 주입 컨테이너 초기화 (DIP 원칙 준수)
/// 2. 모든 서비스 및 리포지토리 등록
/// 3. Flutter 앱 실행
/// 
/// ## 의존성 주입 패턴
/// - Service Locator 패턴 사용
/// - 인터페이스 기반 의존성 관리
/// - 테스트 가능한 구조 제공
void main() {
  // DIP(Dependency Inversion Principle)을 따라 의존성 주입 초기화
  // 모든 서비스와 리포지토리를 인터페이스 기반으로 등록
  ServiceLocator().registerDependencies();
  
  // Flutter 애플리케이션 실행
  runApp(const SkyMeshApp());
}

/// SkyMesh 애플리케이션의 루트 위젯
/// 
/// 이 클래스는 MaterialApp을 설정하고 전체 앱의 테마와 라우팅을 관리합니다.
/// StatelessWidget을 상속받아 불변 위젯으로 구현되었습니다.
/// 
/// ## 주요 역할
/// - Material Design 테마 설정 (라이트/다크 모드)
/// - 앱 타이틀 및 메타데이터 설정
/// - 홈페이지 라우팅 설정
/// - 시스템 테마 모드 자동 감지
/// 
/// ## 테마 전략
/// - LowPolyTheme을 통한 커스텀 디자인 시스템 적용
/// - 시스템 설정에 따른 자동 라이트/다크 모드 전환
/// - 일관된 색상 팔레트 및 타이포그래피 적용
class SkyMeshApp extends StatelessWidget {
  /// SkyMeshApp 위젯 생성자
  /// 
  /// [key]: 위젯 식별을 위한 선택적 키
  const SkyMeshApp({super.key});

  /// 위젯 빌드 메서드
  /// 
  /// MaterialApp을 구성하고 다음 설정을 적용합니다:
  /// - 앱 제목: 'SkyMesh'
  /// - 커스텀 라이트/다크 테마
  /// - 시스템 테마 모드 자동 감지
  /// - HomePage를 기본 홈 화면으로 설정
  /// 
  /// @param context 빌드 컨텍스트
  /// @return 구성된 MaterialApp 위젯
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyMesh',                        // 앱 타이틀 (작업 관리자 등에서 표시)
      theme: LowPolyTheme.lightTheme,          // 라이트 모드 테마 (로우폴리 디자인)
      darkTheme: LowPolyTheme.darkTheme,       // 다크 모드 테마 (로우폴리 디자인)
      themeMode: ThemeMode.system,             // 시스템 설정에 따른 자동 테마 전환
      home: const HomePage(),                  // 기본 홈 화면 위젯
    );
  }
}

/// 메인 홈페이지 위젯
/// 
/// SkyMesh 앱의 주 화면을 담당하는 StatefulWidget입니다.
/// 날씨 정보 표시, 배경 이미지 관리, 사용자 인터랙션을 처리합니다.
/// 
/// ## 주요 기능
/// - 현재 위치 기반 날씨 정보 표시
/// - 전 세계 랜덤 도시 날씨 탐색
/// - 위치와 날씨에 맞는 동적 배경 이미지
/// - 시간별/주간 날씨 예보
/// - 30분 주기 자동 데이터 갱신
/// 
/// ## UI 구성
/// - 배경: 로우폴리 스타일 이미지 (위치별/날씨별)
/// - 오버레이: 날씨 정보 표시 위젯
/// - 플로팅 버튼: 랜덤 탐색/홈 복귀 기능
class HomePage extends StatefulWidget {
  /// HomePage 위젯 생성자
  /// 
  /// [key]: 위젯 식별을 위한 선택적 키
  const HomePage({super.key});

  /// State 객체 생성
  /// 
  /// _HomePageState 인스턴스를 생성하여 위젯의 상태를 관리합니다.
  @override
  State<HomePage> createState() => _HomePageState();
}

/// HomePage의 상태 관리 클래스
/// 
/// SingleTickerProviderStateMixin을 사용하여 애니메이션 컨트롤러를 관리합니다.
/// 날씨 데이터 로딩, 배경 이미지 전환, 사용자 인터랙션을 처리합니다.
/// 
/// ## 상태 변수 구분
/// ### 1. 이미지 및 애니메이션 관련
/// - currentImagePath: 현재 표시 중인 배경 이미지 경로
/// - nextImagePath: 다음에 표시할 배경 이미지 경로
/// - _animationController: 페이드 애니메이션 컨트롤러
/// - _fadeAnimation: 페이드 효과 애니메이션
/// - _isAnimating: 애니메이션 진행 상태
/// 
/// ### 2. 날씨 데이터 관련
/// - _weatherService: 날씨 데이터 조회 서비스
/// - _currentWeather: 현재 날씨 정보
/// - _hourlyWeather: 시간별 날씨 예보
/// - _weeklyWeather: 주간 날씨 예보
/// - _isLoadingWeather: 날씨 데이터 로딩 상태
/// - _weatherError: 날씨 데이터 로딩 오류 메시지
/// 
/// ### 3. 사용자 인터랙션 관련
/// - _isCurrentLocation: 현재 위치 표시 여부 (랜덤 도시와 구분)
/// - _autoRefreshTimer: 30분 주기 자동 갱신 타이머
/// - _scrollController: 스크롤 위치 제어
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // === 이미지 및 애니메이션 관련 상태 변수 ===
  
  /// 현재 화면에 표시되고 있는 배경 이미지의 파일 경로
  /// 위치와 날씨 조건에 따라 LocationImageService에서 결정됨
  String currentImagePath = '';
  
  /// 페이드 애니메이션을 위한 다음 이미지 경로
  /// 이미지 전환 시 부드러운 애니메이션 효과를 위해 사용
  String nextImagePath = '';
  
  /// 이미지 전환 시 페이드 효과를 제어하는 애니메이션 컨트롤러
  /// 300ms 동안 0.0에서 1.0으로 변화하며 부드러운 전환 효과 제공
  late AnimationController _animationController;
  
  /// 투명도 변화를 위한 애니메이션 객체
  /// CurvedAnimation과 Tween을 조합하여 부드러운 페이드 효과 구현
  late Animation<double> _fadeAnimation;
  
  /// 현재 이미지 전환 애니메이션이 진행 중인지 나타내는 플래그
  /// true일 때 중복 애니메이션 방지 및 UI 블로킹
  bool _isAnimating = false;
  
  // === 날씨 데이터 관련 상태 변수 ===
  
  /// 날씨 정보를 조회하기 위한 서비스 인스턴스
  /// WeatherService는 Facade 패턴으로 구현되어 복잡한 API 호출을 단순화
  final WeatherService _weatherService = WeatherService();
  
  /// 현재 날씨 정보를 저장하는 객체
  /// null일 때는 데이터가 아직 로드되지 않았거나 오류가 발생한 상태
  WeatherData? _currentWeather;
  
  /// 24시간 시간별 날씨 예보 정보
  /// 사용자가 상세 예보를 확인할 때 사용
  HourlyWeatherData? _hourlyWeather;
  
  /// 7일간 주간 날씨 예보 정보
  /// 장기 날씨 트렌드 파악에 사용
  WeeklyWeatherData? _weeklyWeather;
  
  /// 날씨 데이터 로딩 상태를 나타내는 플래그
  /// true일 때 로딩 인디케이터 표시
  bool _isLoadingWeather = true;
  
  /// 날씨 데이터 조회 중 발생한 오류 메시지
  /// null이 아닐 때 오류 상태 UI 표시
  String? _weatherError;
  
  // === 사용자 인터랙션 관련 상태 변수 ===
  
  /// 현재 GPS 위치의 날씨를 표시하고 있는지 나타내는 플래그
  /// false일 때는 랜덤 도시의 날씨를 표시 중 (홈 버튼 표시)
  bool _isCurrentLocation = true;
  
  /// 30분 주기로 날씨 데이터를 자동 갱신하는 타이머
  /// 앱이 활성 상태일 때 백그라운드에서 주기적으로 실행
  Timer? _autoRefreshTimer;
  
  /// 날씨 정보 스크롤 영역의 스크롤 위치를 제어하는 컨트롤러
  /// 랜덤 도시 변경 시 스크롤을 최상단으로 이동시키는 데 사용
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // 더 부드러운 전환을 위해 증가
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic, // 더 자연스러운 커브
    ));
    
    // Set initial random image while loading weather data
    currentImagePath = ImageAssets.getRandomImagePath();
    
    _loadWeatherData();
    _startAutoRefreshTimer(); // 자동 갱신 타이머 시작
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoRefreshTimer?.cancel(); // 타이머 정리
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  Future<void> _loadWeatherData() async {
    try {
      setState(() {
        _isLoadingWeather = true;
        _weatherError = null;
      });
      
      final weatherData = await _weatherService.getCurrentWeather();
      
      // 위치와 날씨에 따른 배경 이미지 선택
      final newImagePath = LocationImageService.selectBackgroundImage(
        cityName: weatherData.cityName,
        countryCode: weatherData.country,
        weatherDescription: weatherData.description,
        latitude: weatherData.latitude,
        longitude: weatherData.longitude,
      );
      
      // 시간별 날씨와 일주일 날씨 데이터도 함께 로드
      final hourlyWeatherData = await _weatherService.getHourlyWeather();
      final weeklyWeatherData = await _weatherService.getWeeklyWeather();
      
      // 첫 번째 로딩이면서 이미지가 바뀌는 경우 애니메이션 적용
      bool shouldAnimate = currentImagePath.isNotEmpty && 
                          currentImagePath != newImagePath;
      
      if (shouldAnimate) {
        // 애니메이션과 함께 이미지 전환
        setState(() {
          nextImagePath = newImagePath;
          _currentWeather = weatherData;
          _hourlyWeather = hourlyWeatherData;
          _weeklyWeather = weeklyWeatherData;
          _isLoadingWeather = false;
          _isCurrentLocation = true;
          _isAnimating = true;
        });
        
        // 애니메이션 실행
        _animationController.forward().then((_) {
          setState(() {
            currentImagePath = nextImagePath;
            _isAnimating = false;
          });
          _animationController.reset();
        });
      } else {
        // 첫 로딩이거나 동일한 이미지인 경우 애니메이션 없이 직접 설정
        setState(() {
          _currentWeather = weatherData;
          _hourlyWeather = hourlyWeatherData;
          _weeklyWeather = weeklyWeatherData;
          currentImagePath = newImagePath;
          _isLoadingWeather = false;
          _isCurrentLocation = true;
        });
      }
    } catch (e) {
      setState(() {
        _weatherError = e.toString();
        _isLoadingWeather = false;
      });
    }
  }

  void _changeRandomImage() {
    if (_isAnimating) return; // 애니메이션 중에는 클릭 무시
    
    _loadRandomWeatherData();
  }

  Future<void> _loadRandomWeatherData() async {
    try {
      setState(() {
        _isAnimating = true;
      });
      
      // 랜덤 도시의 날씨 데이터 가져오기
      final randomWeatherData = await _weatherService.getRandomCityWeather();
      
      // 랜덤 도시의 위치와 날씨에 따른 배경 이미지 선택
      final newImagePath = LocationImageService.selectBackgroundImage(
        cityName: randomWeatherData.cityName,
        countryCode: randomWeatherData.country,
        weatherDescription: randomWeatherData.description,
        latitude: randomWeatherData.latitude,
        longitude: randomWeatherData.longitude,
      );
      
      // 랜덤 도시의 시간별 날씨와 일주일 날씨도 가져오기
      HourlyWeatherData? randomHourlyWeather;
      WeeklyWeatherData? randomWeeklyWeather;
      try {
        if (randomWeatherData.latitude != null && randomWeatherData.longitude != null) {
          randomHourlyWeather = await _weatherService.getHourlyWeatherByCoordinates(
            randomWeatherData.latitude!,
            randomWeatherData.longitude!,
          );
          randomWeeklyWeather = await _weatherService.getWeeklyWeatherByCoordinates(
            randomWeatherData.latitude!,
            randomWeatherData.longitude!,
          );
        }
      } catch (e) {
        print('시간별/일주일 날씨 로드 실패: $e');
      }
      
      setState(() {
        nextImagePath = newImagePath;
        _currentWeather = randomWeatherData;
        _hourlyWeather = randomHourlyWeather;
        _weeklyWeather = randomWeeklyWeather;
        _isCurrentLocation = false; // 랜덤 도시로 변경됨
      });
      
      _animationController.forward().then((_) {
        setState(() {
          currentImagePath = nextImagePath;
          _isAnimating = false;
        });
        _animationController.reset();
        
        // 스크롤을 맨 위로 이동
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isAnimating = false;
      });
      debugPrint('랜덤 날씨 데이터 로드 실패: $e');
    }
  }

  Future<void> _refreshCurrentWeather() async {
    if (_currentWeather == null) return;
    
    try {
      setState(() {
        _isLoadingWeather = true;
        _weatherError = null;
      });
      
      WeatherData updatedWeather;
      
      if (_isCurrentLocation) {
        // 현재 위치의 날씨 다시 가져오기
        updatedWeather = await _weatherService.getCurrentWeather();
      } else {
        // 현재 표시 중인 도시의 날씨 갱신 (위도/경도 사용)
        if (_currentWeather!.latitude != null && _currentWeather!.longitude != null) {
          updatedWeather = await _weatherService.getWeatherByCoordinates(
            _currentWeather!.latitude!,
            _currentWeather!.longitude!,
          );
        } else {
          // 좌표가 없으면 현재 위치로 리셋
          updatedWeather = await _weatherService.getCurrentWeather();
          _isCurrentLocation = true;
        }
      }
      
      // 갱신된 날씨에 따른 배경 이미지 선택
      final newImagePath = LocationImageService.selectBackgroundImage(
        cityName: updatedWeather.cityName,
        countryCode: updatedWeather.country,
        weatherDescription: updatedWeather.description,
        latitude: updatedWeather.latitude,
        longitude: updatedWeather.longitude,
      );
      
      // 갱신된 시간별 날씨와 일주일 날씨도 함께 로드
      HourlyWeatherData? updatedHourlyWeather;
      WeeklyWeatherData? updatedWeeklyWeather;
      try {
        if (_isCurrentLocation) {
          updatedHourlyWeather = await _weatherService.getHourlyWeather();
          updatedWeeklyWeather = await _weatherService.getWeeklyWeather();
        } else if (updatedWeather.latitude != null && updatedWeather.longitude != null) {
          updatedHourlyWeather = await _weatherService.getHourlyWeatherByCoordinates(
            updatedWeather.latitude!,
            updatedWeather.longitude!,
          );
          updatedWeeklyWeather = await _weatherService.getWeeklyWeatherByCoordinates(
            updatedWeather.latitude!,
            updatedWeather.longitude!,
          );
        }
      } catch (e) {
        print('시간별/일주일 날씨 갱신 실패: $e');
      }
      
      setState(() {
        _currentWeather = updatedWeather;
        _hourlyWeather = updatedHourlyWeather;
        _weeklyWeather = updatedWeeklyWeather;
        currentImagePath = newImagePath;
        _isLoadingWeather = false;
      });
    } catch (e) {
      setState(() {
        _weatherError = e.toString();
        _isLoadingWeather = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 현재 이미지 (배경)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: currentImagePath.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(currentImagePath),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        debugPrint('❌ Failed to load current image: $currentImagePath');
                        // Fallback to random image on error
                        setState(() {
                          final fallbackPath = ImageAssets.getRandomImagePath();
                          debugPrint('🔄 Fallback to: $fallbackPath');
                          currentImagePath = fallbackPath;
                        });
                      },
                    )
                  : null,
              color: currentImagePath.isEmpty ? Colors.black : null,
            ),
            child: currentImagePath.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          
          // 다음 이미지 (부드러운 페이드 인과 스케일 애니메이션)
          if (_isAnimating && nextImagePath.isNotEmpty)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: 1.0 + (0.05 * (1 - _fadeAnimation.value)), // 미세한 줌 효과
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(nextImagePath),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.1 * (1 - _fadeAnimation.value)),
                            BlendMode.darken,
                          ),
                          onError: (exception, stackTrace) {
                            debugPrint('Failed to load next image: $nextImagePath');
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Weather display overlay
          SafeArea(
            child: WeatherDisplayWidget(
              weatherData: _currentWeather,
              hourlyWeatherData: _hourlyWeather,
              weeklyWeatherData: _weeklyWeather,
              isLoading: _isLoadingWeather,
              error: _weatherError,
              onRefresh: _refreshCurrentWeather,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 홈 버튼 (현재 위치로 돌아가기)
          if (!_isCurrentLocation)
            FloatingActionButton(
              heroTag: "home_button",
              onPressed: _isAnimating ? null : _loadWeatherData,
              backgroundColor: LowPolyColors.primaryBlue.withOpacity(0.9),
              foregroundColor: LowPolyColors.textOnDark,
              elevation: 8,
              tooltip: 'Current Location Weather',
              child: const Icon(
                Icons.home,
                size: 24,
              ),
            ),
          if (!_isCurrentLocation) const SizedBox(height: 16),
          
          // 랜덤 버튼
          FloatingActionButton(
            heroTag: "random_button",
            onPressed: _isAnimating ? null : _changeRandomImage,
            backgroundColor: LowPolyColors.primaryBlue.withOpacity(0.9),
            foregroundColor: LowPolyColors.textOnDark,
            elevation: 8,
            tooltip: 'Random City Weather',
            child: _isAnimating 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(
                  Icons.shuffle,
                  size: 24,
                ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _startAutoRefreshTimer() {
    // 30분마다 자동으로 현재 선택된 지역의 날씨를 갱신
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      if (!_isLoadingWeather && _currentWeather != null) {
        print('🔄 자동 날씨 갱신 시작 (30분 주기)');
        _refreshCurrentWeather();
      }
    });
  }
}
