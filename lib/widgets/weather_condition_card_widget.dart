import 'package:flutter/material.dart';
import '../core/models/weather_condition_card.dart';
import '../design_system/design_system.dart';

/// Weather condition card widget that displays contextual weather alerts
///
/// This widget renders individual weather condition cards with appropriate
/// styling based on severity levels and card types. It provides a consistent
/// UI for displaying various weather alerts and activity indices.
///
/// ## Features
/// - Severity-based color coding (info/warning/danger)
/// - Responsive design with proper spacing
/// - Icon and text content layout
/// - Tap interactions for detailed information
/// - Accessibility support
///
/// ## Usage
///
/// ```dart
/// WeatherConditionCardWidget(
///   card: WeatherConditionCard.heatWave(
///     temperature: 35.0,
///     cityName: 'Seoul',
///     severity: WeatherCardSeverity.danger,
///   ),
///   onTap: (card) {
///     // Handle card tap
///     showDetailDialog(card);
///   },
/// )
/// ```
class WeatherConditionCardWidget extends StatelessWidget {
  final WeatherConditionCard card;
  final Function(WeatherConditionCard)? onTap;

  const WeatherConditionCardWidget({Key? key, required this.card, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(card) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: _getCardColor().withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: _getCardColor().withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Icon section
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCardColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  card.iconCode,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.title,
                          style: LowPolyTypography.labelLarge.copyWith(
                            color: _getCardColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_shouldShowSeverityBadge())
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: _getCardColor(),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _getSeverityText(),
                            style: LowPolyTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Message
                  Text(
                    card.message,
                    style: LowPolyTypography.bodyMedium.copyWith(
                      color: LowPolyColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Chevron icon for tappable cards
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: _getCardColor().withOpacity(0.6),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Gets the card background color based on severity
  Color _getCardBackgroundColor() {
    switch (card.severity) {
      case WeatherCardSeverity.info:
        return LowPolyColors.primaryBlue.withOpacity(0.02);
      case WeatherCardSeverity.warning:
        return const Color(0xFFFF9800).withOpacity(0.02);
      case WeatherCardSeverity.danger:
        return const Color(0xFFFF5722).withOpacity(0.02);
    }
  }

  /// Gets the card accent color based on severity
  Color _getCardColor() {
    switch (card.severity) {
      case WeatherCardSeverity.info:
        return LowPolyColors.primaryBlue;
      case WeatherCardSeverity.warning:
        return const Color(0xFFFF9800); // Orange
      case WeatherCardSeverity.danger:
        return const Color(0xFFFF5722); // Red
    }
  }

  /// Checks if severity badge should be shown (for warning/danger only)
  bool _shouldShowSeverityBadge() {
    return card.severity != WeatherCardSeverity.info;
  }

  /// Gets severity text for badge
  String _getSeverityText() {
    switch (card.severity) {
      case WeatherCardSeverity.warning:
        return 'CAUTION';
      case WeatherCardSeverity.danger:
        return 'WARNING';
      case WeatherCardSeverity.info:
        return '';
    }
  }
}

/// Weather condition cards list widget
///
/// Displays a scrollable list of weather condition cards with proper spacing
/// and animations. Handles empty states and provides a consistent container
/// for multiple cards.
///
/// ## Usage
///
/// ```dart
/// WeatherConditionCardsWidget(
///   cards: weatherCards,
///   onCardTap: (card) {
///     Navigator.of(context).push(
///       MaterialPageRoute(
///         builder: (context) => WeatherCardDetailPage(card: card),
///       ),
///     );
///   },
/// )
/// ```
class WeatherConditionCardsWidget extends StatelessWidget {
  final List<WeatherConditionCard> cards;
  final Function(WeatherConditionCard)? onCardTap;

  const WeatherConditionCardsWidget({
    Key? key,
    required this.cards,
    this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cards list
          ...cards.map(
            (card) => WeatherConditionCardWidget(card: card, onTap: onCardTap),
          ),
        ],
      ),
    );
  }
}

/// Weather condition card detail dialog
///
/// Shows detailed information about a specific weather condition card
/// when tapped. Provides additional context, explanations, and actionable
/// advice related to the weather condition.
class WeatherConditionCardDetailDialog extends StatelessWidget {
  final WeatherConditionCard card;

  const WeatherConditionCardDetailDialog({Key? key, required this.card})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCardColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      card.iconCode,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    card.title,
                    style: LowPolyTypography.headlineSmall.copyWith(
                      color: _getCardColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Message
            Text(
              card.message,
              style: LowPolyTypography.bodyLarge.copyWith(
                color: LowPolyColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Additional information based on card type
            if (_getAdditionalInfo().isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _getCardColor().withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _getAdditionalInfo(),
                  style: LowPolyTypography.bodyMedium.copyWith(
                    color: LowPolyColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getCardColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor() {
    switch (card.severity) {
      case WeatherCardSeverity.info:
        return LowPolyColors.primaryBlue;
      case WeatherCardSeverity.warning:
        return const Color(0xFFFF9800);
      case WeatherCardSeverity.danger:
        return const Color(0xFFFF5722);
    }
  }

  String _getAdditionalInfo() {
    switch (card.type) {
      case WeatherCardType.heatWave:
        return 'Heat Wave Safety Tips:\n• Stay hydrated with plenty of water\n• Avoid outdoor activities 11 AM - 3 PM\n• Take breaks in cool, shaded areas';
      case WeatherCardType.coldWave:
        return 'Cold Wave Safety Tips:\n• Keep warm and dress in layers\n• Maintain proper indoor temperature\n• Watch for signs of frostbite';
      case WeatherCardType.uvIndex:
        return 'UV Protection Methods:\n• Use SPF 30+ sunscreen\n• Wear hat and sunglasses\n• Stay in shaded areas';
      case WeatherCardType.airQuality:
        return 'Air Quality Protection:\n• Wear mask when outdoors\n• Keep windows closed\n• Use air purifiers indoors';
      case WeatherCardType.strongWind:
        return 'Strong Wind Precautions:\n• Watch for falling objects\n• Secure outdoor items\n• Limit outdoor activities';
      case WeatherCardType.carWashIndex:
      case WeatherCardType.laundryIndex:
        return 'Perfect weather conditions! Now is a great opportunity!';
      case WeatherCardType.typhoon:
        return 'Typhoon Preparations:\n• Monitor latest weather updates\n• Prepare emergency supplies\n• Avoid outdoor activities';
    }
  }

  /// Shows the weather condition card detail dialog
  static void show(BuildContext context, WeatherConditionCard card) {
    showDialog(
      context: context,
      builder: (context) => WeatherConditionCardDetailDialog(card: card),
    );
  }
}
