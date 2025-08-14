import 'package:flutter/material.dart';
import 'dart:math';

/// 구름이 좌에서 우로 자연스럽게 움직이는 애니메이션 위젯
class CloudAnimationWidget extends StatefulWidget {
  final double screenHeight;
  final String currentWeather;
  
  const CloudAnimationWidget({
    super.key,
    required this.screenHeight,
    this.currentWeather = 'cloudy',
  });

  @override
  State<CloudAnimationWidget> createState() => _CloudAnimationWidgetState();
}

class _CloudAnimationWidgetState extends State<CloudAnimationWidget>
    with TickerProviderStateMixin {
  late List<CloudData> clouds;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 30), // 30초로 더 느리게
      vsync: this,
    )..repeat(); // 무한 반복
    
    _initializeClouds();
  }

  void _initializeClouds() {
    final random = Random();
    clouds = List.generate(5, (index) {
      // 화면 상단 1/3 지점의 랜덤한 위치에 구름 배치
      final maxY = widget.screenHeight * 0.33;  // 상단 1/3 지점
      final minY = 30.0; // 최소 높이
      
      return CloudData(
        imagePath: _getCloudImagePath(),
        initialX: -300.0 - (index * 100) - (random.nextDouble() * 200), // 랜덤한 시작 위치 (좀 더 가깝게)
        y: minY + random.nextDouble() * (maxY - minY), // 가변적인 높이
        speed: 0.3 + random.nextDouble() * 0.2, // 0.3 ~ 0.5 배속 (더 느리게)
        scale: 0.8 + random.nextDouble() * 0.6, // 0.8 ~ 1.4 배율 (다양한 크기)
        opacity: 0.6 + random.nextDouble() * 0.3, // 0.6 ~ 0.9 투명도
        verticalOffset: random.nextDouble() * 20 - 10, // -10 ~ +10 수직 오프셋
        windPhase: random.nextDouble() * 2 * 3.14159, // 바람 효과 위상
      );
    });
    print('구름 초기화 완료: ${clouds.length}개 구름 생성');
  }

  String _getCloudImagePath() {
    final random = Random();
    
    // 현재 날씨에 따라 구름 이미지 선택
    List<String> cloudImages;
    switch (widget.currentWeather.toLowerCase()) {
      case 'sunny':
        cloudImages = [
          'assets/clouds/sunny_01.png',
          'assets/clouds/sunny_02.png', 
          'assets/clouds/sunny_03.png',
          'assets/clouds/sunny_04.png',
          'assets/clouds/sunny_05.png',
        ];
        break;
      case 'cloudy':
        cloudImages = [
          'assets/clouds/cloudy_01.png',
          'assets/clouds/cloudy_02.png',
          'assets/clouds/cloudy_03.png',
          'assets/clouds/cloudy_04.png',
          'assets/clouds/cloudy_05.png',
        ];
        break;
      case 'sunset':
        cloudImages = [
          'assets/clouds/sunset_cityscape_01.png',
          'assets/clouds/sunset_cityscape_02.png',
          'assets/clouds/sunset_cityscape_03.png',
        ];
        break;
      default:
        cloudImages = [
          'assets/clouds/overcast_gray_01.png',
          'assets/clouds/overcast_gray_02.png',
          'assets/clouds/overcast_gray_03.png',
        ];
    }
    
    return cloudImages[random.nextInt(cloudImages.length)];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('구름 애니메이션 build 호출됨, 구름 개수: ${clouds.length}');
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: clouds.asMap().entries.map((entry) {
            final index = entry.key;
            final cloud = entry.value;
            
            // 현재 X 위치 계산 (좌에서 우로 이동)
            final screenWidth = MediaQuery.of(context).size.width;
            final totalDistance = screenWidth + 500; // 화면 너비 + 구름 크기 여유분
            final currentX = cloud.initialX + (totalDistance * _animationController.value * cloud.speed);
            
            // 화면을 벗어나면 다시 왼쪽에서 시작
            final displayX = currentX > screenWidth + 500 
                ? currentX - totalDistance - 1000 
                : currentX;
            
            // 선선한 바람 효과: 부드러운 수직 움직임과 살짝 흔들리는 효과
            final windEffect = sin((_animationController.value * 2 * 3.14159 * 2) + cloud.windPhase) * 8; // 8px 수직 흔들림
            final gentleSway = sin((_animationController.value * 2 * 3.14159 * 0.7) + cloud.windPhase) * 3; // 3px 좌우 흔들림
            final finalY = cloud.y + cloud.verticalOffset + windEffect;
            final finalX = displayX + gentleSway;
            
            // 디버깅 정보 출력
            if (index == 0 && _animationController.value < 0.1) {
              print('구름 $index: initialX=${cloud.initialX}, currentX=$currentX, displayX=$displayX, finalX=$finalX, finalY=$finalY');
              print('화면 너비: $screenWidth, 애니메이션 값: ${_animationController.value}');
            }

            return Positioned(
              left: finalX,
              top: finalY,
              child: Opacity(
                opacity: cloud.opacity,
                child: Transform.scale(
                  scale: cloud.scale,
                  child: Image.asset(
                    cloud.imagePath,
                    width: 360, // 가로 360으로 증가
                    height: 240, // 비율 유지하여 세로도 증가
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('구름 이미지 로딩 실패: ${cloud.imagePath} - $error');
                      // 이미지 로딩 실패 시 기본 구름 아이콘 표시
                      return Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.cloud,
                          size: 60,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// 개별 구름의 데이터를 저장하는 클래스
class CloudData {
  final String imagePath;
  final double initialX;
  final double y;
  final double speed;
  final double scale;
  final double opacity;
  final double verticalOffset; // 수직 흔들림 오프셋
  final double windPhase; // 바람 효과 위상

  CloudData({
    required this.imagePath,
    required this.initialX,
    required this.y,
    required this.speed,
    required this.scale,
    required this.opacity,
    this.verticalOffset = 0.0,
    this.windPhase = 0.0,
  });
}

/// 날씨에 따른 구름 애니메이션을 자동으로 관리하는 위젯
class WeatherBasedCloudAnimation extends StatelessWidget {
  final String weather;
  
  const WeatherBasedCloudAnimation({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return CloudAnimationWidget(
      screenHeight: screenHeight,
      currentWeather: weather,
    );
  }
}

/// 간단한 구름 애니메이션 (기본 설정)
class SimpleCloudAnimation extends StatelessWidget {
  const SimpleCloudAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return CloudAnimationWidget(
      screenHeight: screenHeight,
      currentWeather: 'cloudy',
    );
  }
}