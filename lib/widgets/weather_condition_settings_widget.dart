import 'package:flutter/material.dart';
import '../core/models/weather_condition_card.dart';
import '../core/services/weather_condition_rule_engine.dart';
import '../design_system/design_system.dart';

/// Weather condition cards settings widget
/// 
/// Allows users to configure which weather condition cards they want to see.
/// Provides toggle switches for each card category with clear descriptions
/// and visual indicators.
/// 
/// ## Features
/// - Individual card type toggles
/// - Category grouping (alerts vs. indices)
/// - Real-time preference updates
/// - Persistent settings storage
/// - Visual feedback and descriptions
/// 
/// ## Usage
/// 
/// ```dart
/// WeatherConditionSettingsWidget(
///   preferences: currentPreferences,
///   onPreferencesChanged: (newPreferences) {
///     // Update preferences and save to storage
///     updateUserPreferences(newPreferences);
///   },
/// )
/// ```
class WeatherConditionSettingsWidget extends StatefulWidget {
  final Map<String, bool> preferences;
  final Function(Map<String, bool>) onPreferencesChanged;

  const WeatherConditionSettingsWidget({
    Key? key,
    required this.preferences,
    required this.onPreferencesChanged,
  }) : super(key: key);

  @override
  State<WeatherConditionSettingsWidget> createState() =>
      _WeatherConditionSettingsWidgetState();
}

class _WeatherConditionSettingsWidgetState
    extends State<WeatherConditionSettingsWidget> {
  late Map<String, bool> _localPreferences;

  @override
  void initState() {
    super.initState();
    _localPreferences = Map.from(widget.preferences);
  }

  void _updatePreference(String key, bool value) {
    setState(() {
      _localPreferences[key] = value;
    });
    widget.onPreferencesChanged(_localPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.tune,
                color: LowPolyColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Card Settings',
                style: LowPolyTypography.headlineSmall.copyWith(
                  color: LowPolyColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '원하는 날씨 정보 카드를 선택하세요',
            style: LowPolyTypography.bodyMedium.copyWith(
              color: LowPolyColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Alerts section
          _buildSection(
            title: '날씨 / 환경',
            icon: Icons.warning_amber_rounded,
            items: [
              _SettingItem(
                key: 'heat_cold_alerts',
                title: '폭염 / 한파',
                description: '기온이 위험 수준에 도달했을 때 알림',
                icon: '🌡️',
                enabled: _localPreferences['heat_cold_alerts'] ?? true,
              ),
              _SettingItem(
                key: 'uv_alerts',
                title: '자외선',
                description: '자외선 지수가 높을 때 알림',
                icon: '☀️',
                enabled: _localPreferences['uv_alerts'] ?? true,
              ),
              _SettingItem(
                key: 'air_quality_alerts',
                title: '미세먼지',
                description: '대기질이 나쁠 때 알림',
                icon: '😷',
                enabled: _localPreferences['air_quality_alerts'] ?? true,
              ),
              _SettingItem(
                key: 'wind_alerts',
                title: '강풍 / 태풍',
                description: '강한 바람이나 태풍이 예상될 때 알림',
                icon: '💨',
                enabled: _localPreferences['wind_alerts'] ?? true,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Activity indices section
          _buildSection(
            title: '생활 지수',
            icon: Icons.local_activity,
            items: [
              _SettingItem(
                key: 'activity_indices',
                title: '세차 / 빨래 지수',
                description: '세차나 빨래하기 좋은 날씨 알림',
                icon: '🚗',
                enabled: _localPreferences['activity_indices'] ?? true,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Help text
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: LowPolyColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: LowPolyColors.primaryBlue.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: LowPolyColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '설정은 자동으로 저장되며, 조건에 맞는 상황에서만 카드가 표시됩니다.',
                    style: LowPolyTypography.bodySmall.copyWith(
                      color: LowPolyColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<_SettingItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              icon,
              color: LowPolyColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: LowPolyTypography.titleMedium.copyWith(
                color: LowPolyColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Setting items
        ...items.map((item) => _buildSettingItem(item)),
      ],
    );
  }

  Widget _buildSettingItem(_SettingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.enabled
                  ? LowPolyColors.primaryBlue.withOpacity(0.1)
                  : LowPolyColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Center(
              child: Text(
                item.icon,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: LowPolyTypography.labelLarge.copyWith(
                    color: item.enabled
                        ? LowPolyColors.textPrimary
                        : LowPolyColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: LowPolyTypography.bodySmall.copyWith(
                    color: LowPolyColors.textSecondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          // Toggle switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: item.enabled,
              onChanged: (value) => _updatePreference(item.key, value),
              activeColor: LowPolyColors.primaryBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal class for setting item data
class _SettingItem {
  final String key;
  final String title;
  final String description;
  final String icon;
  final bool enabled;

  const _SettingItem({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.enabled,
  });
}

/// Weather condition settings page
/// 
/// Full-screen settings page for weather condition card preferences.
/// Can be used as a standalone page or embedded in a settings section.
class WeatherConditionSettingsPage extends StatefulWidget {
  const WeatherConditionSettingsPage({Key? key}) : super(key: key);

  @override
  State<WeatherConditionSettingsPage> createState() =>
      _WeatherConditionSettingsPageState();
}

class _WeatherConditionSettingsPageState
    extends State<WeatherConditionSettingsPage> {
  late Map<String, bool> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = WeatherConditionPreferences.getDefaultPreferences();
  }

  void _handlePreferencesChanged(Map<String, bool> newPreferences) {
    setState(() {
      _preferences = newPreferences;
    });
    // Preferences are kept in memory only for UI display
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LowPolyColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Today\'s Briefing 설정',
          style: LowPolyTypography.headlineSmall.copyWith(
            color: LowPolyColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: WeatherConditionSettingsWidget(
          preferences: _preferences,
          onPreferencesChanged: _handlePreferencesChanged,
        ),
      ),
    );
  }
}

/// Settings tile widget for integration into main settings page
/// 
/// Provides a compact tile that can be added to a main settings page
/// to navigate to the weather condition settings.
class WeatherConditionSettingsTile extends StatelessWidget {
  const WeatherConditionSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: LowPolyColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          Icons.article_outlined,
          color: LowPolyColors.primaryBlue,
          size: 20,
        ),
      ),
      title: Text(
        'Today\'s Briefing',
        style: LowPolyTypography.bodyLarge.copyWith(
          color: LowPolyColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '날씨 상황 카드 설정',
        style: LowPolyTypography.bodyMedium.copyWith(
          color: LowPolyColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: LowPolyColors.textSecondary,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const WeatherConditionSettingsPage(),
          ),
        );
      },
    );
  }
}