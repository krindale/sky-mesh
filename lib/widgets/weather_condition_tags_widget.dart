import 'package:flutter/material.dart';
import '../core/models/weather_condition_card.dart';
import '../design_system/design_system.dart';

/// Weather condition tags widget that displays condition keywords as tags
///
/// This widget renders weather condition cards as small, pill-shaped tags
/// that provide a quick overview of current weather conditions and alerts.
///
/// ## Features
/// - Compact tag design with icon and text
/// - Severity-based color coding
/// - Horizontal scrollable layout
/// - Tap to view detailed information
///
/// ## Usage
///
/// ```dart
/// WeatherConditionTagsWidget(
///   cards: weatherConditionCards,
///   onTagTap: (card) {
///     // Handle tag tap
///     showDetailDialog(card);
///   },
/// )
/// ```
class WeatherConditionTagsWidget extends StatelessWidget {
  final List<WeatherConditionCard> cards;
  final Function(WeatherConditionCard)? onTagTap;

  const WeatherConditionTagsWidget({
    Key? key,
    required this.cards,
    this.onTagTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 26, // Fixed height for tags
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 6),
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildTag(context, card);
        },
      ),
    );
  }

  /// Builds individual weather condition tag
  Widget _buildTag(BuildContext context, WeatherConditionCard card) {
    return GestureDetector(
      onTap: onTagTap != null ? () => onTagTap!(card) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        decoration: BoxDecoration(
          color: _getTagBackgroundColor(card.severity),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getTagBorderColor(card.severity),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Text(card.iconCode, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            // Tag text
            Text(
              _getTagText(card),
              style: TextStyle(
                color: _getTagTextColor(card.severity),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets short tag text based on card type
  String _getTagText(WeatherConditionCard card) {
    switch (card.type) {
      case WeatherCardType.heatWave:
        return 'Heat Wave';
      case WeatherCardType.coldWave:
        return 'Cold Wave';
      case WeatherCardType.uvIndex:
        return 'High UV';
      case WeatherCardType.airQuality:
        return card.severity == WeatherCardSeverity.danger
            ? 'Very Poor Air'
            : 'Poor Air';
      case WeatherCardType.strongWind:
        return 'Strong Wind';
      case WeatherCardType.typhoon:
        return 'Typhoon';
      case WeatherCardType.carWashIndex:
        return 'Car Wash Day';
      case WeatherCardType.laundryIndex:
        return 'Laundry Day';
    }
  }

  /// Gets tag background color based on severity
  Color _getTagBackgroundColor(WeatherCardSeverity severity) {
    switch (severity) {
      case WeatherCardSeverity.info:
        return Colors.black.withValues(alpha: 0.2);
      case WeatherCardSeverity.warning:
        return Colors.orange.withValues(alpha: 0.2);
      case WeatherCardSeverity.danger:
        return Colors.red.withValues(alpha: 0.2);
    }
  }

  /// Gets tag border color based on severity
  Color _getTagBorderColor(WeatherCardSeverity severity) {
    switch (severity) {
      case WeatherCardSeverity.info:
        return Colors.white.withValues(alpha: 0.3);
      case WeatherCardSeverity.warning:
        return Colors.orange.withValues(alpha: 0.5);
      case WeatherCardSeverity.danger:
        return Colors.red.withValues(alpha: 0.5);
    }
  }

  /// Gets tag text color based on severity
  Color _getTagTextColor(WeatherCardSeverity severity) {
    switch (severity) {
      case WeatherCardSeverity.info:
        return Colors.white.withValues(alpha: 0.9);
      case WeatherCardSeverity.warning:
        return Colors.orange.shade100;
      case WeatherCardSeverity.danger:
        return Colors.red.shade100;
    }
  }
}
