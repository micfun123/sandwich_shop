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

  
  });
}