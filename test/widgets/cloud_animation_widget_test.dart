import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/widgets/cloud_animation_widget.dart';

void main() {
  group('CloudAnimationWidget Tests', () {
    testWidgets('CloudAnimationWidget renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 800,
              currentWeather: 'cloudy',
            ),
          ),
        ),
      );

      expect(find.byType(CloudAnimationWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('CloudAnimationWidget updates with different weather', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 800,
              currentWeather: 'sunny',
            ),
          ),
        ),
      );

      expect(find.byType(CloudAnimationWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Update weather
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 800,
              currentWeather: 'rainy',
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('CloudAnimationWidget animates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 800,
              currentWeather: 'cloudy',
            ),
          ),
        ),
      );

      // Let animation start
      await tester.pump();
      
      // Progress animation
      await tester.pump(const Duration(seconds: 1));
      
      // Check that no exceptions occurred during animation
      expect(tester.takeException(), isNull);
    });

    testWidgets('CloudAnimationWidget handles different screen heights', (WidgetTester tester) async {
      // Test with small screen
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 400,
              currentWeather: 'cloudy',
            ),
          ),
        ),
      );

      expect(find.byType(CloudAnimationWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Test with large screen
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 1200,
              currentWeather: 'cloudy',
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('CloudAnimationWidget disposes animation controller properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CloudAnimationWidget(
              screenHeight: 800,
              currentWeather: 'cloudy',
            ),
          ),
        ),
      );

      await tester.pump();

      // Replace with different widget to trigger disposal
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        ),
      );

      // Should not have memory leaks or exceptions
      expect(tester.takeException(), isNull);
    });
  });

  group('WeatherBasedCloudAnimation Tests', () {
    testWidgets('WeatherBasedCloudAnimation renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherBasedCloudAnimation(
              weather: 'sunny',
            ),
          ),
        ),
      );

      expect(find.byType(WeatherBasedCloudAnimation), findsOneWidget);
      expect(find.byType(CloudAnimationWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('WeatherBasedCloudAnimation adapts to screen size', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherBasedCloudAnimation(
              weather: 'cloudy',
            ),
          ),
        ),
      );

      expect(find.byType(WeatherBasedCloudAnimation), findsOneWidget);
      expect(tester.takeException(), isNull);

      addTearDown(tester.binding.setSurfaceSize);
    });
  });

  group('SimpleCloudAnimation Tests', () {
    testWidgets('SimpleCloudAnimation renders with default settings', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SimpleCloudAnimation(),
          ),
        ),
      );

      expect(find.byType(SimpleCloudAnimation), findsOneWidget);
      expect(find.byType(CloudAnimationWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('CloudData Tests', () {
    test('CloudData constructor works correctly', () {
      final cloudData = CloudData(
        imagePath: 'test/path.png',
        initialX: -100.0,
        y: 50.0,
        speed: 1.0,
        scale: 1.2,
        opacity: 0.8,
        verticalOffset: 5.0,
        windPhase: 1.57,
      );

      expect(cloudData.imagePath, 'test/path.png');
      expect(cloudData.initialX, -100.0);
      expect(cloudData.y, 50.0);
      expect(cloudData.speed, 1.0);
      expect(cloudData.scale, 1.2);
      expect(cloudData.opacity, 0.8);
      expect(cloudData.verticalOffset, 5.0);
      expect(cloudData.windPhase, 1.57);
    });

    test('CloudData defaults work correctly', () {
      final cloudData = CloudData(
        imagePath: 'test/path.png',
        initialX: -100.0,
        y: 50.0,
        speed: 1.0,
        scale: 1.2,
        opacity: 0.8,
      );

      expect(cloudData.verticalOffset, 0.0);
      expect(cloudData.windPhase, 0.0);
    });
  });
}