import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  group('Navigation Tests - Core Functionality', () {
    testWidgets('App initializes with correct home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify the app starts with OrderScreen
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.byType(AboutScreen), findsNothing);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('MaterialApp is properly configured with routes', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify MaterialApp exists and is configured
      expect(find.byType(MaterialApp), findsOneWidget);
      
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'Sandwich Shop App');
      expect(app.routes, isNotEmpty);
      expect(app.routes!.containsKey('/about'), isTrue);
    });

    testWidgets('About screen navigation works via app bar icon', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Find and tap the info icon (there may be multiple, use first)
      final infoIcons = find.byIcon(Icons.info_outline);
      expect(infoIcons, findsAtLeastNWidgets(1));
      
      await tester.tap(infoIcons.first);
      await tester.pumpAndSettle();
      
      // Verify navigation to AboutScreen
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Welcome to Sandwich Shop!'), findsOneWidget);
    });

    testWidgets('Navigation back from About screen works', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Navigate to About screen
      await tester.tap(find.byIcon(Icons.info_outline).first);
      await tester.pumpAndSettle();
      expect(find.byType(AboutScreen), findsOneWidget);
      
      // Use Navigator to go back
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      expect(navigator.canPop(), isTrue);
      
      navigator.pop();
      await tester.pumpAndSettle();
      
      // Verify we're back on OrderScreen
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.byType(AboutScreen), findsNothing);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Multiple navigation operations work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      
      // Test multiple navigation cycles
      for (int i = 0; i < 3; i++) {
        // Navigate to About
        await tester.tap(find.byIcon(Icons.info_outline).first);
        await tester.pumpAndSettle();
        expect(find.byType(AboutScreen), findsOneWidget);
        
        // Navigate back
        navigator.pop();
        await tester.pumpAndSettle();
        expect(find.byType(OrderScreen), findsOneWidget);
      }
    });

    testWidgets('Desktop layout shows persistent navigation', (WidgetTester tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify desktop layout shows navigation sidebar
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Fresh sandwiches'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      
      // Navigation items should have correct icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsAtLeastNWidgets(1));
      
      tester.view.reset();
    });

    testWidgets('Mobile layout uses AppShell structure', (WidgetTester tester) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify mobile layout still shows the app content
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
      
      // Navigation structure should exist (might be in drawer)
      // We don't test drawer opening here due to complexity
      
      tester.view.reset();
    });

    testWidgets('Route-based navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Get Navigator from a proper context
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      
      // Test pushNamed with proper context
      navigator.pushNamed('/about');
      await tester.pumpAndSettle();
      
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      
      // Test pop
      navigator.pop();
      await tester.pumpAndSettle();
      
      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets('Navigation preserves app bar structure', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify initial app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
      
      // Navigate to About and verify app bar changes
      await tester.tap(find.byIcon(Icons.info_outline).first);
      await tester.pumpAndSettle();
      
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      
      // Navigate back and verify app bar returns
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('App handles navigation state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      
      // Initial state - can't pop
      expect(navigator.canPop(), isFalse);
      
      // Navigate to About - can pop
      await tester.tap(find.byIcon(Icons.info_outline).first);
      await tester.pumpAndSettle();
      expect(navigator.canPop(), isTrue);
      
      // Navigate back - can't pop again
      navigator.pop();
      await tester.pumpAndSettle();
      expect(navigator.canPop(), isFalse);
    });

    testWidgets('Navigation maintains correct widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify OrderScreen hierarchy
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      
      // Navigate to About
      await tester.tap(find.byIcon(Icons.info_outline).first);
      await tester.pumpAndSettle();
      
      // Verify AboutScreen hierarchy
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      
      // Verify navigation doesn't break widget tree
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });
}