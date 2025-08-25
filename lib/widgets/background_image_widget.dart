import 'package:flutter/material.dart';
import '../utils/image_assets.dart';

/// 찌그러짐 없이 화면을 꽉 채우는 배경 이미지 위젯
class BackgroundImageWidget extends StatelessWidget {
  final String? imagePath;
  final Widget? child;
  final BoxFit fit;
  
  const BackgroundImageWidget({
    super.key,
    this.imagePath,
    this.child,
    this.fit = BoxFit.cover,
  });
  
  /// 랜덤 이미지로 배경을 생성하는 팩토리 생성자
  factory BackgroundImageWidget.random({
    Key? key,
    Widget? child,
    BoxFit fit = BoxFit.cover,
  }) {
    return BackgroundImageWidget(
      key: key,
      imagePath: ImageAssets.getRandomImagePath(),
      child: child,
      fit: fit,
    );
  }
  
  /// 특정 날씨의 랜덤 이미지로 배경을 생성하는 팩토리 생성자
  factory BackgroundImageWidget.randomByWeather({
    Key? key,
    required String weather,
    Widget? child,
    BoxFit fit = BoxFit.cover,
  }) {
    return BackgroundImageWidget(
      key: key,
      imagePath: ImageAssets.getRandomImagePathByWeather(weather),
      child: child,
      fit: fit,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final String imageToUse = imagePath ?? ImageAssets.getRandomImagePath();
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageToUse),
          fit: fit,
          // 이미지 로딩 실패 시 대체 처리
          onError: (exception, stackTrace) {
            debugPrint('Failed to load image: $imageToUse');
            debugPrint('Error: $exception');
          },
        ),
      ),
      child: child,
    );
  }
}

/// 배경 이미지 위에 반투명 오버레이를 추가하는 위젯
class BackgroundImageWithOverlay extends StatelessWidget {
  final String? imagePath;
  final Widget? child;
  final Color overlayColor;
  final double overlayOpacity;
  final BoxFit fit;
  
  const BackgroundImageWithOverlay({
    super.key,
    this.imagePath,
    this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.3,
    this.fit = BoxFit.cover,
  });
  
  /// 랜덤 이미지로 오버레이 배경을 생성하는 팩토리 생성자
  factory BackgroundImageWithOverlay.random({
    Key? key,
    Widget? child,
    Color overlayColor = Colors.black,
    double overlayOpacity = 0.3,
    BoxFit fit = BoxFit.cover,
  }) {
    return BackgroundImageWithOverlay(
      key: key,
      imagePath: ImageAssets.getRandomImagePath(),
      child: child,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      fit: fit,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final String imageToUse = imagePath ?? ImageAssets.getRandomImagePath();
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageToUse),
          fit: fit,
          onError: (exception, stackTrace) {
            debugPrint('Failed to load image: $imageToUse');
            debugPrint('Error: $exception');
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: overlayColor.withValues(alpha: overlayOpacity),
        ),
        child: child,
      ),
    );
  }
}

/// 애니메이션으로 배경 이미지가 변경되는 위젯
class AnimatedBackgroundImage extends StatefulWidget {
  final Duration duration;
  final Duration changeInterval;
  final Widget? child;
  final BoxFit fit;
  final String? weather; // 특정 날씨로 제한하려면 사용
  
  const AnimatedBackgroundImage({
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.changeInterval = const Duration(seconds: 10),
    this.child,
    this.fit = BoxFit.cover,
    this.weather,
  });
  
  @override
  State<AnimatedBackgroundImage> createState() => _AnimatedBackgroundImageState();
}

class _AnimatedBackgroundImageState extends State<AnimatedBackgroundImage>
    with SingleTickerProviderStateMixin {
  late String currentImagePath;
  late String nextImagePath;
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // 초기 이미지 설정
    currentImagePath = widget.weather != null
        ? ImageAssets.getRandomImagePathByWeather(widget.weather!)
        : ImageAssets.getRandomImagePath();
    nextImagePath = widget.weather != null
        ? ImageAssets.getRandomImagePathByWeather(widget.weather!)
        : ImageAssets.getRandomImagePath();
    
    // 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // 주기적으로 이미지 변경
    _startImageChangeTimer();
  }
  
  void _startImageChangeTimer() {
    Future.delayed(widget.changeInterval, () {
      if (mounted) {
        _changeImage();
        _startImageChangeTimer();
      }
    });
  }
  
  void _changeImage() {
    setState(() {
      currentImagePath = nextImagePath;
      nextImagePath = widget.weather != null
          ? ImageAssets.getRandomImagePathByWeather(widget.weather!)
          : ImageAssets.getRandomImagePath();
    });
    
    _controller.reset();
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // 현재 이미지
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(currentImagePath),
                  fit: widget.fit,
                  onError: (exception, stackTrace) {
                    debugPrint('Failed to load current image: $currentImagePath');
                  },
                ),
              ),
            ),
            
            // 다음 이미지 (페이드 인)
            Opacity(
              opacity: _animation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(nextImagePath),
                    fit: widget.fit,
                    onError: (exception, stackTrace) {
                      debugPrint('Failed to load next image: $nextImagePath');
                    },
                  ),
                ),
              ),
            ),
            
            // 자식 위젯
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}