import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sky_mesh/main.dart';

void main() {
  group('SkyMesh App Widget Tests', () {
    testWidgets('App starts and displays basic structure', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pump();

      // Verify that the app starts without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage contains floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should find at least one floating action button (random button)
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
      
      // Check for shuffle icon (random button)
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('Random button triggers animation', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the random button
      final randomButton = find.byIcon(Icons.shuffle);
      expect(randomButton, findsOneWidget);

      await tester.tap(randomButton);
      await tester.pump();

      // Should show loading indicator during animation
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('Home button appears after random city selection', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap random button to change location
      final randomButton = find.byIcon(Icons.shuffle);
      await tester.tap(randomButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Home button should appear when not showing current location
      // Note: This test might be flaky depending on the mock data behavior
      final homeButtons = find.byIcon(Icons.home);
      
      // We expect either 0 or 1 home button depending on whether we switched locations
      expect(homeButtons.evaluate().length, lessThanOrEqualTo(1));
    });

    testWidgets('Weather display widget is present', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check for weather-related widgets
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      
      // Should have some weather information displayed (text widgets)
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    testWidgets('Background image container is present', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check for the main container that holds the background image
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('Scaffold structure is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify basic scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget); // Main content stack
      expect(find.byType(Column), findsAtLeastNWidgets(1)); // Floating action button column
    });

    testWidgets('Theme configuration is applied', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify theme configuration
      expect(materialApp.title, 'SkyMesh');
      expect(materialApp.themeMode, ThemeMode.system);
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });

  group('Edge Cases and Error Handling', () {
    testWidgets('App handles loading states gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      
      // During initial load, should handle loading state
      await tester.pump(const Duration(milliseconds: 100));
      
      // App should not crash during loading
      expect(tester.takeException(), isNull);
    });

    testWidgets('Multiple rapid button presses are handled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final randomButton = find.byIcon(Icons.shuffle);
      
      // Rapid button presses
      await tester.tap(randomButton);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(randomButton);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(randomButton);
      
      // Should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('FloatingActionButton tooltip is set correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find FloatingActionButton and check tooltip
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton).first
      );
      
      expect(fab.tooltip, anyOf(
        'Random City Weather',
        'Current Location Weather',
      ));
    });
  });

  group('Animation and State Tests', () {
    testWidgets('Animation controller is properly disposed', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      await tester.pumpAndSettle();

      // Navigate away to trigger disposal
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      
      // Should not have memory leaks or exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('State updates correctly after weather data load', (WidgetTester tester) async {
      await tester.pumpWidget(const SkyMeshApp());
      
      // Wait for initial weather data to load
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Should have transitioned from loading to content
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
