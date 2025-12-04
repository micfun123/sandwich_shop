import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Subtotal: £0.00'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white'), findsOneWidget);
      expect(find.text('2'), findsWidgets);
      // subtotal 2 * 11 = 22
      expect(find.text('Subtotal: £22.00'), findsOneWidget);
      // total with 10% tax = 24.20
      expect(find.text('Total: £24.20'), findsOneWidget);
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white'), findsOneWidget);
      expect(find.text('Six-inch on wheat'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
      expect(find.text('3'), findsWidgets);
      // subtotal 11 + 21 = 32
      expect(find.text('Subtotal: £32.00'), findsOneWidget);
      expect(find.text('Total: £35.20'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final Finder backButtonFinder =
          find.widgetWithText(StyledButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final StyledButton backButton =
          tester.widget<StyledButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final appBarImagesFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Image),
      );
      expect(appBarImagesFinder, findsOneWidget);

      final Image logoImage = tester.widget(appBarImagesFinder);
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('displays correct pricing for different sandwich types',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('3'), findsWidgets);
      // subtotal 3 * 11 = 33
      expect(find.text('Subtotal: £33.00'), findsOneWidget);
      expect(find.text('Total: £36.30'), findsOneWidget);
    });
  });
}
