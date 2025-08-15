import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'design_system/design_system.dart';
import 'widgets/background_image_widget.dart';
import 'utils/image_assets.dart';
import 'services/weather_service.dart';
import 'services/location_image_service.dart';
import 'widgets/weather_display_widget.dart';

void main() {
  runApp(const SkyMeshApp());
}

class SkyMeshApp extends StatelessWidget {
  const SkyMeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyMesh',
      theme: LowPolyTheme.lightTheme,
      darkTheme: LowPolyTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String currentImagePath = '';
  String nextImagePath = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isAnimating = false;
  
  // Weather related variables
  final WeatherService _weatherService = WeatherService();
  WeatherData? _currentWeather;
  HourlyWeatherData? _hourlyWeather;
  WeeklyWeatherData? _weeklyWeather;
  bool _isLoadingWeather = true;
  String? _weatherError;
  bool _isCurrentLocation = true; // 현재 위치 표시 여부 추적
  Timer? _autoRefreshTimer; // 자동 갱신 타이머
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
      
      setState(() {
        _currentWeather = weatherData;
        _hourlyWeather = hourlyWeatherData;
        _weeklyWeather = weeklyWeatherData;
        currentImagePath = newImagePath;
        _isLoadingWeather = false;
        _isCurrentLocation = true; // 현재 위치 로드됨
      });
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
          
          // 다음 이미지 (페이드 인)
          if (_isAnimating && nextImagePath.isNotEmpty)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(nextImagePath),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          debugPrint('Failed to load next image: $nextImagePath');
                        },
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
