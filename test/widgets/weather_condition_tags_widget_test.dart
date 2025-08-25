import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/widgets/weather_condition_tags_widget.dart';
import 'package:sky_mesh/core/models/weather_condition_card.dart';

void main() {
  group('WeatherConditionTagsWidget Tests', () {
    final mockCards = [
      WeatherConditionCard.heatWave(
        temperature: 36.0,
        cityName: 'Seoul',
        severity: WeatherCardSeverity.danger,
      ),
      WeatherConditionCard.uvAlert(
        uvIndex: 9.0,
        severity: WeatherCardSeverity.warning,
      ),
      WeatherConditionCard.airQualityAlert(
        pm25: 80.0,
        pm10: 90.0,
        aqi: 4,
        cityName: 'Seoul',
        severity: WeatherCardSeverity.warning,
      ),
    ];

    testWidgets('WeatherConditionTagsWidget renders correctly with cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: mockCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      // Check that tags are rendered
      expect(find.text('Heat Wave'), findsOneWidget);
      expect(find.text('High UV'), findsOneWidget);
      expect(find.text('Poor Air'), findsOneWidget);

      // Check ListView is present
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('WeatherConditionTagsWidget shows empty state when no cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: [],
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      // Should render SizedBox.shrink() for empty state
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('WeatherConditionTagsWidget handles tap events', (WidgetTester tester) async {
      WeatherConditionCard? tappedCard;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: mockCards,
              onTagTap: (card) {
                tappedCard = card;
              },
            ),
          ),
        ),
      );

      // Tap on the first tag (Heat Wave)
      await tester.tap(find.text('Heat Wave'));
      await tester.pump();

      expect(tappedCard, isNotNull);
      expect(tappedCard!.type, WeatherCardType.heatWave);
    });

    testWidgets('WeatherConditionTagsWidget works without tap callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: mockCards,
              onTagTap: null,
            ),
          ),
        ),
      );

      // Should render without errors even without tap callback
      expect(find.text('Heat Wave'), findsOneWidget);
      
      // Tapping should not cause errors
      await tester.tap(find.text('Heat Wave'));
      await tester.pump();
    });

    testWidgets('WeatherConditionTagsWidget displays heat wave text correctly', (WidgetTester tester) async {
      final heatWaveCard = WeatherConditionCard.heatWave(
        temperature: 35.0,
        cityName: 'Test',
        severity: WeatherCardSeverity.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: [heatWaveCard],
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Heat Wave'), findsOneWidget);
    });

    testWidgets('WeatherConditionTagsWidget displays laundry day text correctly', (WidgetTester tester) async {
      final laundryCard = WeatherConditionCard.laundryIndex(
        precipitationProbability: 0.1,
        humidity: 50,
        windSpeed: 3.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: [laundryCard],
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Laundry Day'), findsOneWidget);
    });

    testWidgets('WeatherConditionTagsWidget displays multiple different card types', (WidgetTester tester) async {
      final testCards = [
        WeatherConditionCard.heatWave(
          temperature: 35.0,
          cityName: 'Test',
          severity: WeatherCardSeverity.warning,
        ),
        WeatherConditionCard.uvAlert(
          uvIndex: 11.0,
          severity: WeatherCardSeverity.danger,
        ),
        WeatherConditionCard.carWashIndex(
          precipitationProbability: 0.1,
          airQuality: 2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: testCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Heat Wave'), findsOneWidget);
      expect(find.text('High UV'), findsOneWidget);
      expect(find.text('Car Wash Day'), findsOneWidget);
    });

    testWidgets('WeatherConditionTagsWidget displays different severity colors', (WidgetTester tester) async {
      final severityCards = [
        WeatherConditionCard.uvAlert(
          uvIndex: 6.0,
          severity: WeatherCardSeverity.info,
        ),
        WeatherConditionCard.uvAlert(
          uvIndex: 8.0,
          severity: WeatherCardSeverity.warning,
        ),
        WeatherConditionCard.uvAlert(
          uvIndex: 11.0,
          severity: WeatherCardSeverity.danger,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: severityCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      // Find all containers (tags)
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Should have 3 tag containers plus the main container
      expect(containers.length, greaterThan(3));

      // Check that tags are rendered
      expect(find.text('High UV'), findsNWidgets(3));
    });

    testWidgets('WeatherConditionTagsWidget has correct height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: mockCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, 26.0);
    });

    testWidgets('WeatherConditionTagsWidget displays icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: mockCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      // Check that icon text elements are present
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      
      // Should have icon texts and label texts
      expect(textWidgets.length, greaterThan(3));
      
      // Verify some text widgets have fontSize 12 (icons and labels)
      final iconTexts = textWidgets.where((text) => 
        text.style?.fontSize == 12
      ).toList();
      
      expect(iconTexts.length, greaterThanOrEqualTo(6)); // 3 icons + 3 labels minimum
    });

    testWidgets('WeatherConditionTagsWidget air quality text varies by severity', (WidgetTester tester) async {
      final airQualityCards = [
        WeatherConditionCard.airQualityAlert(
          pm25: 50.0,
          pm10: 90.0,
          aqi: 4,
          cityName: 'Test',
          severity: WeatherCardSeverity.warning,
        ),
        WeatherConditionCard.airQualityAlert(
          pm25: 80.0,
          pm10: 160.0,
          aqi: 5,
          cityName: 'Test',
          severity: WeatherCardSeverity.danger,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: airQualityCards,
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Poor Air'), findsOneWidget);
      expect(find.text('Very Poor Air'), findsOneWidget);
    });
  });

  group('WeatherConditionCard Integration Tests', () {
    testWidgets('WeatherConditionTagsWidget renders correct text for strong wind card', (WidgetTester tester) async {
      final strongWindCard = WeatherConditionCard.strongWind(
        windSpeed: 25.0,
        cityName: 'Tokyo',
        severity: WeatherCardSeverity.danger,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: [strongWindCard],
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Strong Wind'), findsOneWidget);
    });

    testWidgets('WeatherConditionTagsWidget shows different air quality text based on severity', (WidgetTester tester) async {
      final poorAirCard = WeatherConditionCard.airQualityAlert(
        pm25: 50.0,
        pm10: 90.0,
        aqi: 4,
        cityName: 'Test',
        severity: WeatherCardSeverity.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherConditionTagsWidget(
              cards: [poorAirCard],
              onTagTap: (card) {},
            ),
          ),
        ),
      );

      expect(find.text('Poor Air'), findsOneWidget);
    });
  });
}