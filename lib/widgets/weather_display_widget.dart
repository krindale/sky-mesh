import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/weather_service.dart';
import '../design_system/design_system.dart';

class WeatherDisplayWidget extends StatelessWidget {
  final WeatherData? weatherData;
  final bool isLoading;
  final String? error;
  final VoidCallback onRefresh;

  const WeatherDisplayWidget({
    super.key,
    this.weatherData,
    required this.isLoading,
    this.error,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    if (isLoading) {
      return _buildLoadingState();
    }
    
    if (error != null) {
      return _buildErrorState();
    }
    
    if (weatherData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Main weather content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with location and temperature
              _buildTopSection(context),
              
              const SizedBox(height: 20),
              
              // Weather details cards
              Expanded(
                child: _buildWeatherDetailsCards(context),
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
              error ?? 'Unknown error occurred',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRefresh,
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
            '${weatherData!.cityName}, ${weatherData!.country}',
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
                weatherData!.temperatureString,
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
                      weatherData!.capitalizedDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like ${weatherData!.feelsLikeString}',
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
                child: _buildWeatherCard(
                  icon: Icons.air,
                  title: 'WIND',
                  value: weatherData!.windSpeedString,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCard(
                  icon: Icons.water_drop_outlined,
                  title: 'HUMIDITY',
                  value: weatherData!.humidityString,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Second row of cards
          Row(
            children: [
              Expanded(
                child: _buildWeatherCard(
                  icon: Icons.speed,
                  title: 'PRESSURE',
                  value: weatherData!.pressureString,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCard(
                  icon: Icons.visibility,
                  title: 'VISIBILITY',
                  value: weatherData!.visibilityString,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Third row - UV Index (full width)
          _buildWeatherCard(
            icon: Icons.wb_sunny_outlined,
            title: 'UV INDEX',
            value: weatherData!.uvIndexString,
            subtitle: _getUVIndexDescription(weatherData!.uvIndex),
            isFullWidth: true,
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
      height: isFullWidth ? 100 : 120,
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
          
          const Spacer(),
          
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
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
        onRefresh();
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

  String _getUVIndexDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }
}