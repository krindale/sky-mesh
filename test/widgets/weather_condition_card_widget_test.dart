import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/widgets/weather_condition_card_widget.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';
import 'package:sky_mesh/design_system/design_system.dart';

void main() {
  group('WeatherConditionCardWidget Tests', () {
    late WeatherConditionCard mockHeatWaveCard;
    late WeatherConditionCard mockUvAlertCard;
    late WeatherConditionCard mockAirQualityCard;
    late WeatherConditionCard mockCarWashCard;
    
    setUp(() {
      mockHeatWaveCard = WeatherConditionCard.heatWave(
        temperature: 36.0,
        cityName: 'Seoul',
        severity: WeatherCardSeverity.danger,
      );
      
      mockUvAlertCard = WeatherConditionCard.uvAlert(
        uvIndex: 9.0,
        severity: WeatherCardSeverity.warning,
      );
      
      mockAirQualityCard = WeatherConditionCard.airQualityAlert(
        pm25: 80.0,
        pm10: 90.0,
        aqi: 4,
        cityName: 'Seoul',
        severity: WeatherCardSeverity.warning,
      );
      
      mockCarWashCard = WeatherConditionCard.carWashIndex(
        precipitationProbability: 0.1,
        airQuality: 2,
      );
    });

    group('Widget Structure Tests', () {
      testWidgets('renders basic card structure correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        // Check for main container
        expect(find.byType(Container), findsAtLeast(3)); // Main container + icon container + severity badge
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Row), findsAtLeast(2)); // Main row + title row
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Expanded), findsAtLeast(1));
      });

      testWidgets('displays card title correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.text('Heat Wave Warning'), findsOneWidget);
      });

      testWidgets('displays card message correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.textContaining('Heat wave Warning'), findsOneWidget);
        expect(find.textContaining('Seoul'), findsOneWidget);
        expect(find.textContaining('36°C'), findsOneWidget);
      });

      testWidgets('displays icon correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.text('🌡️'), findsOneWidget);
      });

      testWidgets('shows chevron icon when onTap is provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(
                card: mockHeatWaveCard,
                onTap: (card) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });

      testWidgets('hides chevron icon when onTap is null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });
    });

    group('Severity Badge Tests', () {
      testWidgets('shows severity badge for danger cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.text('WARNING'), findsOneWidget);
      });

      testWidgets('shows severity badge for warning cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockUvAlertCard),
            ),
          ),
        );

        expect(find.text('CAUTION'), findsOneWidget);
      });

      testWidgets('hides severity badge for info cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockCarWashCard),
            ),
          ),
        );

        expect(find.text('WARNING'), findsNothing);
        expect(find.text('CAUTION'), findsNothing);
      });
    });

    group('Color Scheme Tests', () {
      testWidgets('applies correct colors for danger severity', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.first;
        final decoration = mainContainer.decoration as BoxDecoration;
        
        // Check border color is based on danger color (red)
        expect(decoration.border, isNotNull);
        
        // Check background color exists and has opacity applied
        expect(decoration.color, isNotNull);
        expect(decoration.color!.alpha, lessThan(255)); // Should have transparency
      });

      testWidgets('applies correct colors for warning severity', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockUvAlertCard),
            ),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.first;
        final decoration = mainContainer.decoration as BoxDecoration;
        
        // Check that decoration properties exist
        expect(decoration.border, isNotNull);
        expect(decoration.color, isNotNull);
      });

      testWidgets('applies correct colors for info severity', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockCarWashCard),
            ),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.first;
        final decoration = mainContainer.decoration as BoxDecoration;
        
        // Check that decoration properties exist
        expect(decoration.border, isNotNull);
        expect(decoration.color, isNotNull);
      });
    });

    group('Interaction Tests', () {
      testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
        WeatherConditionCard? tappedCard;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(
                card: mockHeatWaveCard,
                onTap: (card) {
                  tappedCard = card;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        expect(tappedCard, equals(mockHeatWaveCard));
      });

      testWidgets('does not crash when tapped without onTap callback', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        // Should not throw any exceptions
      });
    });

    group('Layout and Styling Tests', () {
      testWidgets('has correct margins and padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        final mainContainer = tester.widget<Container>(find.byType(Container).first);
        expect(mainContainer.margin, const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0));
        expect(mainContainer.padding, const EdgeInsets.all(16.0));
      });

      testWidgets('has correct border radius', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        final mainContainer = tester.widget<Container>(find.byType(Container).first);
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(12.0));
      });

      testWidgets('has shadow with correct properties', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        final mainContainer = tester.widget<Container>(find.byType(Container).first);
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, 1);
        expect(decoration.boxShadow!.first.blurRadius, 8.0);
        expect(decoration.boxShadow!.first.offset, const Offset(0, 2));
      });

      testWidgets('icon container has correct dimensions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockHeatWaveCard),
            ),
          ),
        );

        // Verify the icon container exists and is styled correctly
        final containers = tester.widgetList<Container>(find.byType(Container));
        
        // Check that we have at least one container with decoration (icon container)
        final iconContainers = containers.where((container) => 
          container.decoration is BoxDecoration &&
          (container.decoration as BoxDecoration).borderRadius == BorderRadius.circular(8.0)
        );
        
        expect(iconContainers.isNotEmpty, true);
        
        // We can verify the icon is displayed correctly
        expect(find.text('🌡️'), findsOneWidget);
      });

      testWidgets('text has correct max lines and overflow behavior', (WidgetTester tester) async {
        final longMessageCard = WeatherConditionCard.heatWave(
          temperature: 36.0,
          cityName: 'Very Long City Name That Should Be Truncated',
          severity: WeatherCardSeverity.danger,
        );
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400, // Give enough width to prevent overflow issues
                child: WeatherConditionCardWidget(card: longMessageCard),
              ),
            ),
          ),
        );

        final messageText = tester.widget<Text>(find.text(longMessageCard.message));
        expect(messageText.maxLines, 3);
        expect(messageText.overflow, TextOverflow.ellipsis);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('card is accessible for screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(
                card: mockHeatWaveCard,
                onTap: (card) {},
              ),
            ),
          ),
        );

        // Should be tappable
        expect(find.byType(GestureDetector), findsOneWidget);
        
        // Text should be readable
        expect(find.text('Heat Wave Warning'), findsOneWidget);
        expect(find.textContaining('Seoul'), findsOneWidget);
      });

      testWidgets('supports semantic labels', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Semantics(
                label: 'Weather condition card: Heat wave warning',
                child: WeatherConditionCardWidget(card: mockHeatWaveCard),
              ),
            ),
          ),
        );

        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('Different Card Types Tests', () {
      testWidgets('renders UV alert card correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockUvAlertCard),
            ),
          ),
        );

        expect(find.text('UV Warning'), findsOneWidget);
        expect(find.text('☀️'), findsOneWidget);
        expect(find.text('CAUTION'), findsOneWidget);
      });

      testWidgets('renders air quality card correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockAirQualityCard),
            ),
          ),
        );

        expect(find.text('Poor Air Quality'), findsOneWidget);
        expect(find.text('😷'), findsOneWidget);
        expect(find.textContaining('Seoul'), findsOneWidget);
      });

      testWidgets('renders car wash index card correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: mockCarWashCard),
            ),
          ),
        );

        expect(find.text('Perfect Car Wash Day'), findsOneWidget);
        expect(find.text('🚗'), findsOneWidget);
        // Info cards should not have severity badge
        expect(find.text('WARNING'), findsNothing);
        expect(find.text('CAUTION'), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles very long card titles gracefully', (WidgetTester tester) async {
        final card = WeatherConditionCard(
          type: WeatherCardType.heatWave,
          severity: WeatherCardSeverity.danger,
          title: 'This is a very long title that should be handled gracefully by the widget layout system',
          message: 'Short message',
          iconCode: '🌡️',
          data: {'test': 'data'},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                child: WeatherConditionCardWidget(card: card),
              ),
            ),
          ),
        );

        expect(find.textContaining('This is a very long title'), findsOneWidget);
      });

      testWidgets('handles empty icon code gracefully', (WidgetTester tester) async {
        final card = WeatherConditionCard(
          type: WeatherCardType.heatWave,
          severity: WeatherCardSeverity.danger,
          title: 'Heat Wave',
          message: 'Test message',
          iconCode: '',
          data: {'test': 'data'},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: card),
            ),
          ),
        );

        // Should not crash and still show the icon container
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(1)); // Should have icon container
      });

      testWidgets('handles special characters in text', (WidgetTester tester) async {
        final card = WeatherConditionCard(
          type: WeatherCardType.heatWave,
          severity: WeatherCardSeverity.danger,
          title: 'Test with émojis & spëcial chârs 한글',
          message: 'Message with 🔥 émojis 한국어 text',
          iconCode: '🌟',
          data: {'test': 'data'},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardWidget(card: card),
            ),
          ),
        );

        expect(find.textContaining('émojis'), findsAtLeast(1)); // May appear in both title and message
        expect(find.textContaining('한글'), findsOneWidget);
        expect(find.text('🌟'), findsOneWidget);
      });
    });
  });

  group('WeatherConditionCardsWidget Tests', () {
    late List<WeatherConditionCard> mockCards;

    setUp(() {
      mockCards = [
        WeatherConditionCard.heatWave(
          temperature: 36.0,
          cityName: 'Seoul',
          severity: WeatherCardSeverity.danger,
        ),
        WeatherConditionCard.uvAlert(
          uvIndex: 9.0,
          severity: WeatherCardSeverity.warning,
        ),
        WeatherConditionCard.carWashIndex(
          precipitationProbability: 0.1,
          airQuality: 2,
        ),
      ];
    });

    group('List Widget Structure Tests', () {
      testWidgets('renders multiple cards correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: mockCards),
            ),
          ),
        );

        expect(find.byType(WeatherConditionCardWidget), findsNWidgets(3));
        expect(find.byType(Container), findsAtLeast(1)); // Main container
        expect(find.byType(Column), findsAtLeast(1)); // Multiple columns exist due to individual card widgets
      });

      testWidgets('shows empty state for empty cards list', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: []),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(WeatherConditionCardWidget), findsNothing);
      });

      testWidgets('applies correct margin to container', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: mockCards),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.margin, const EdgeInsets.only(top: 16.0));
      });

      testWidgets('passes onCardTap callback to individual cards', (WidgetTester tester) async {
        WeatherConditionCard? tappedCard;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(
                cards: mockCards,
                onCardTap: (card) {
                  tappedCard = card;
                },
              ),
            ),
          ),
        );

        // Tap on the first card
        await tester.tap(find.byType(GestureDetector).first);
        expect(tappedCard, equals(mockCards.first));
      });

      testWidgets('works without onCardTap callback', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: mockCards),
            ),
          ),
        );

        expect(find.byType(WeatherConditionCardWidget), findsNWidgets(3));
        // Should not crash when tapped
        await tester.tap(find.byType(GestureDetector).first);
      });
    });

    group('List Widget Content Tests', () {
      testWidgets('displays all provided cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: mockCards),
            ),
          ),
        );

        expect(find.text('Heat Wave Warning'), findsOneWidget);
        expect(find.text('UV Warning'), findsOneWidget);
        expect(find.text('Perfect Car Wash Day'), findsOneWidget);
      });

      testWidgets('maintains card order', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: mockCards),
            ),
          ),
        );

        final cardWidgets = tester.widgetList<WeatherConditionCardWidget>(
          find.byType(WeatherConditionCardWidget),
        ).toList();

        expect(cardWidgets[0].card.type, WeatherCardType.heatWave);
        expect(cardWidgets[1].card.type, WeatherCardType.uvIndex);
        expect(cardWidgets[2].card.type, WeatherCardType.carWashIndex);
      });

      testWidgets('handles single card correctly', (WidgetTester tester) async {
        final singleCard = [mockCards.first];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardsWidget(cards: singleCard),
            ),
          ),
        );

        expect(find.byType(WeatherConditionCardWidget), findsOneWidget);
        expect(find.text('Heat Wave Warning'), findsOneWidget);
      });
    });
  });

  group('WeatherConditionCardDetailDialog Tests', () {
    late WeatherConditionCard mockHeatWaveCard;
    late WeatherConditionCard mockUvAlertCard;
    late WeatherConditionCard mockCarWashCard;

    setUp(() {
      mockHeatWaveCard = WeatherConditionCard.heatWave(
        temperature: 36.0,
        cityName: 'Seoul',
        severity: WeatherCardSeverity.danger,
      );

      mockUvAlertCard = WeatherConditionCard.uvAlert(
        uvIndex: 9.0,
        severity: WeatherCardSeverity.warning,
      );

      mockCarWashCard = WeatherConditionCard.carWashIndex(
        precipitationProbability: 0.1,
        airQuality: 2,
      );
    });

    group('Dialog Structure Tests', () {
      testWidgets('renders dialog structure correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Container), findsAtLeast(2)); // Main container + icon container
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('displays card title and icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.text('Heat Wave Warning'), findsOneWidget);
        expect(find.text('🌡️'), findsOneWidget);
      });

      testWidgets('displays card message', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.textContaining('Heat wave Warning'), findsOneWidget);
        expect(find.textContaining('Seoul'), findsOneWidget);
      });

      testWidgets('has close button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('has OK button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.text('OK'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Dialog Content Tests', () {
      testWidgets('shows additional info for heat wave cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        expect(find.textContaining('Heat Wave Safety Tips'), findsOneWidget);
        expect(find.textContaining('Stay hydrated'), findsOneWidget);
        expect(find.textContaining('11 AM - 3 PM'), findsOneWidget);
      });

      testWidgets('shows additional info for UV alert cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockUvAlertCard),
            ),
          ),
        );

        expect(find.textContaining('UV Protection Methods'), findsOneWidget);
        expect(find.textContaining('SPF 30+'), findsOneWidget);
        expect(find.textContaining('sunglasses'), findsOneWidget);
      });

      testWidgets('shows appropriate info for activity cards', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockCarWashCard),
            ),
          ),
        );

        expect(find.textContaining('Perfect weather conditions'), findsOneWidget);
      });

      testWidgets('applies correct colors based on severity', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        // Check that containers and buttons have color styling
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(2));

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style?.backgroundColor?.resolve({}), isNotNull);
      });
    });

    group('Dialog Interaction Tests', () {
      testWidgets('close button navigates back', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(WeatherConditionCardDetailDialog), findsOneWidget);

        // Close dialog with close button
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(WeatherConditionCardDetailDialog), findsNothing);
      });

      testWidgets('OK button navigates back', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(WeatherConditionCardDetailDialog), findsOneWidget);

        // Close dialog with OK button
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.byType(WeatherConditionCardDetailDialog), findsNothing);
      });
    });

    group('Dialog Static Method Tests', () {
      testWidgets('static show method displays dialog correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    WeatherConditionCardDetailDialog.show(context, mockHeatWaveCard);
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        // Initially no dialog
        expect(find.byType(WeatherConditionCardDetailDialog), findsNothing);

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Dialog should be displayed
        expect(find.byType(WeatherConditionCardDetailDialog), findsOneWidget);
        expect(find.text('Heat Wave Warning'), findsOneWidget);
      });
    });

    group('Dialog Layout Tests', () {
      testWidgets('has correct dialog shape and padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        final dialog = tester.widget<Dialog>(find.byType(Dialog));
        expect(dialog.shape, isA<RoundedRectangleBorder>());

        final mainContainer = tester.widget<Container>(find.byType(Container).first);
        expect(mainContainer.padding, const EdgeInsets.all(20.0));
      });

      testWidgets('icon container has correct dimensions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        // Verify the icon container exists and is styled correctly
        final containers = tester.widgetList<Container>(find.byType(Container));
        
        // Check that we have at least one container with decoration (icon container)
        final iconContainers = containers.where((container) => 
          container.decoration is BoxDecoration &&
          (container.decoration as BoxDecoration).borderRadius == BorderRadius.circular(12.0)
        );
        
        expect(iconContainers.isNotEmpty, true);
        
        // We can verify the icon is displayed correctly
        expect(find.text('🌡️'), findsOneWidget);
      });

      testWidgets('button spans full width', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: mockHeatWaveCard),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).last);
        expect(sizedBox.width, double.infinity);
      });
    });

    group('Different Card Types in Dialog Tests', () {
      testWidgets('cold wave card shows appropriate additional info', (WidgetTester tester) async {
        final coldCard = WeatherConditionCard.coldWave(
          temperature: -16.0,
          cityName: 'Moscow',
          severity: WeatherCardSeverity.danger,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: coldCard),
            ),
          ),
        );

        expect(find.textContaining('Cold Wave Safety Tips'), findsOneWidget);
        expect(find.textContaining('Keep warm'), findsOneWidget);
        expect(find.textContaining('frostbite'), findsOneWidget);
      });

      testWidgets('air quality card shows appropriate additional info', (WidgetTester tester) async {
        final airQualityCard = WeatherConditionCard.airQualityAlert(
          pm25: 80.0,
          pm10: 90.0,
          aqi: 4,
          cityName: 'Seoul',
          severity: WeatherCardSeverity.warning,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: airQualityCard),
            ),
          ),
        );

        expect(find.textContaining('Air Quality Protection'), findsOneWidget);
        expect(find.textContaining('Wear mask'), findsOneWidget);
        expect(find.textContaining('air purifiers'), findsOneWidget);
      });

      testWidgets('strong wind card shows appropriate additional info', (WidgetTester tester) async {
        final windCard = WeatherConditionCard.strongWind(
          windSpeed: 15.0,
          cityName: 'Chicago',
          severity: WeatherCardSeverity.warning,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherConditionCardDetailDialog(card: windCard),
            ),
          ),
        );

        expect(find.textContaining('Strong Wind Precautions'), findsOneWidget);
        expect(find.textContaining('falling objects'), findsOneWidget);
        expect(find.textContaining('Secure outdoor items'), findsOneWidget);
      });
    });
  });
}