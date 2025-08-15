import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/weather_service.dart';

class WeatherDisplayWidget extends StatefulWidget {
  final WeatherData? weatherData;
  final HourlyWeatherData? hourlyWeatherData;
  final WeeklyWeatherData? weeklyWeatherData;
  final bool isLoading;
  final String? error;
  final VoidCallback onRefresh;
  final ScrollController? scrollController;

  const WeatherDisplayWidget({
    super.key,
    this.weatherData,
    this.hourlyWeatherData,
    this.weeklyWeatherData,
    required this.isLoading,
    this.error,
    required this.onRefresh,
    this.scrollController,
  });

  @override
  State<WeatherDisplayWidget> createState() => _WeatherDisplayWidgetState();
}

class _WeatherDisplayWidgetState extends State<WeatherDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // 초기 데이터가 있으면 애니메이션 시작
    if (widget.weatherData != null && !widget.isLoading) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(WeatherDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 로딩 상태가 변경되었을 때 애니메이션 제어
    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
        // 로딩 시작 시 페이드 아웃
        _fadeController.reverse();
      } else if (widget.weatherData != null) {
        // 로딩 완료 시 페이드 인
        _fadeController.forward();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.isLoading) {
      return _buildLoadingState();
    }
    
    if (widget.error != null) {
      return _buildErrorState();
    }
    
    if (widget.weatherData == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * 20),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Main weather content (상단 고정, 하단 스크롤)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top section with location and temperature (고정)
                      _buildTopSection(context),
                      
                      const SizedBox(height: 20),
                      
                      // Scrollable content (스크롤 가능한 하단 영역)
                      Expanded(
                        child: SingleChildScrollView(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // Weather details cards
                              _buildWeatherDetailsCards(context),
                              
                              const SizedBox(height: 20),
                              
                              // Hourly weather section
                              if (widget.hourlyWeatherData != null)
                                _buildHourlyWeatherSection(context),
                              
                              const SizedBox(height: 20),
                              
                              // Weekly weather section
                              if (widget.weeklyWeatherData != null)
                                _buildWeeklyWeatherSection(context),
                              
                              const SizedBox(height: 120), // 하단 여백 (FAB 공간 확보)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Refresh button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildRefreshButton(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading weather...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load weather',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.error ?? 'Unknown error occurred',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location
          Text(
            '${widget.weatherData!.cityName}, ${widget.weatherData!.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Current time
          Text(
            _getCurrentTime(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Main temperature
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.weatherData!.temperatureString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.w200,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      widget.weatherData!.capitalizedDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like ${widget.weatherData!.feelsLikeString}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // First row of cards
          Row(
            children: [
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.air,
                  title: 'WIND',
                  number: widget.weatherData!.windSpeedNumber,
                  unit: widget.weatherData!.windSpeedUnit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.water_drop_outlined,
                  title: 'HUMIDITY',
                  number: widget.weatherData!.humidityNumber,
                  unit: widget.weatherData!.humidityUnit,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Second row of cards
          Row(
            children: [
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.speed,
                  title: 'PRESSURE',
                  number: widget.weatherData!.pressureNumber,
                  unit: widget.weatherData!.pressureUnit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.visibility,
                  title: 'VISIBILITY',
                  number: widget.weatherData!.visibilityNumber,
                  unit: widget.weatherData!.visibilityUnit,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Third row - Air Quality and UV Index side by side
          Row(
            children: [
              Expanded(
                child: _buildAirQualityCard(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUVIndexCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCardWithUnit({
    required IconData icon,
    required String title,
    required String number,
    required String unit,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    bool isFullWidth = false,
  }) {
    return Container(
      height: isFullWidth ? 115 : 120,
      padding: EdgeInsets.all(isFullWidth ? 10 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          SizedBox(height: isFullWidth ? 8 : 12),
          
          Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          if (subtitle != null) ...[
            SizedBox(height: isFullWidth ? 2 : 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isFullWidth ? 12 : 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onRefresh();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.refresh,
          color: Colors.white.withOpacity(0.8),
          size: 22,
        ),
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildHourlyWeatherSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'HOURLY FORECAST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.hourlyWeatherData!.hourlyForecasts.length,
              itemBuilder: (context, index) {
                final forecast = widget.hourlyWeatherData!.hourlyForecasts[index];
                return _buildHourlyWeatherCard(forecast, index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyWeatherCard(HourlyWeatherForecast forecast, bool isFirst) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 12, left: isFirst ? 0 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isFirst ? 'Now' : forecast.hour,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWeatherIcon(forecast.iconCode),
              color: Colors.white.withOpacity(0.9),
              size: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            forecast.temperatureString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${forecast.humidity}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01': return Icons.wb_sunny;
      case '02': return Icons.wb_sunny_outlined;
      case '03':
      case '04': return Icons.cloud;
      case '09':
      case '10': return Icons.grain;
      case '11': return Icons.flash_on;
      case '13': return Icons.ac_unit;
      case '50': return Icons.foggy;
      default: return Icons.wb_sunny;
    }
  }

  Widget _buildWeeklyWeatherSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '7-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.weeklyWeatherData!.dailyForecasts
                .map((forecast) => _buildDailyWeatherRow(forecast))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyWeatherRow(DailyWeatherForecast forecast) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // 요일
          SizedBox(
            width: 40,
            child: Text(
              forecast.isToday ? '오늘' : forecast.dayOfWeek,
              style: TextStyle(
                color: forecast.isToday ? Colors.white : Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: forecast.isToday ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날짜
          SizedBox(
            width: 40,
            child: Text(
              forecast.dateString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날씨 아이콘
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWeatherIcon(forecast.iconCode),
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날씨 설명 (축약된 버전)
          Expanded(
            child: Text(
              _getShortWeatherDescription(forecast.description),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 최저 온도
          SizedBox(
            width: 35,
            child: Text(
              forecast.minTemperatureString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // 최고 온도
          SizedBox(
            width: 35,
            child: Text(
              forecast.maxTemperatureString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getShortWeatherDescription(String description) {
    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('clear')) return '맑음';
    if (lowerDesc.contains('few clouds')) return '약간 흐림';
    if (lowerDesc.contains('scattered') || lowerDesc.contains('broken')) return '흐림';
    if (lowerDesc.contains('overcast')) return '덮음';
    if (lowerDesc.contains('rain')) return '비';
    if (lowerDesc.contains('snow')) return '눈';
    if (lowerDesc.contains('mist') || lowerDesc.contains('fog')) return '안개';
    if (lowerDesc.contains('thunderstorm')) return '뇌우';
    return '흐림';
  }

  Widget _buildAirQualityCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.air,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AIR QUALITY',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Air Quality number and unit only
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.weatherData!.airQualityString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AQI',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUVIndexCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'UV INDEX',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // UV Index number and description in same row
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // UV Index number on the left
                Text(
                  widget.weatherData!.uvIndexString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Description on the right
                Text(
                  _getUVIndexDescription(widget.weatherData!.uvIndex),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUVIndexDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  String _getAirQualityDescription(int airQuality) {
    switch (airQuality) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Moderate';
      case 4: return 'Poor';
      case 5: return 'Very Poor';
      default: return 'Unknown';
    }
  }
}