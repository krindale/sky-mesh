import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_system/design_system.dart';
import 'widgets/background_image_widget.dart';
import 'utils/image_assets.dart';

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
  String currentImagePath = 'assets/location_images/timezones/utc_plus_1/paris_sunny.png';
  String nextImagePath = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isAnimating = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeRandomImage() {
    if (_isAnimating) return; // 애니메이션 중에는 클릭 무시
    
    setState(() {
      _isAnimating = true;
      nextImagePath = ImageAssets.getRandomImagePath();
    });
    
    _animationController.forward().then((_) {
      setState(() {
        currentImagePath = nextImagePath;
        _isAnimating = false;
      });
      _animationController.reset();
    });
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
              image: DecorationImage(
                image: AssetImage(currentImagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  debugPrint('Failed to load current image: $currentImagePath');
                },
              ),
            ),
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
          
          // SafeArea 컨테이너
          SafeArea(
            child: Container(), // 깔끔한 배경만 표시
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeRandomImage,
        backgroundColor: LowPolyColors.primaryBlue.withOpacity(0.9),
        foregroundColor: LowPolyColors.textOnDark,
        elevation: 8,
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
              size: 28,
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
