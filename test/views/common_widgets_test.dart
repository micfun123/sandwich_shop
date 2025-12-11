import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

void main() {
  group('CartIndicator badge', () {
    testWidgets('badge is hidden when cart is empty',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<Cart>.value(
            value: cart,
            child: const Scaffold(
              appBar: SandwichAppBar(title: 'Test'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsNothing);
      expect(find.bySemanticsLabel('Cart items: 0'), findsOneWidget);
    });

    testWidgets('badge shows count when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<Cart>.value(
            value: cart,
            child: const Scaffold(
              appBar: SandwichAppBar(title: 'Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });
}
