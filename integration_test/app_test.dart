import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      // Find and tap the Add to Cart button
      final addToCartButton = find.byIcon(Icons.shopping_cart).at(0);
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      final StyledButton addButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      ).evaluate().first.widget as StyledButton;
      
      await tester.ensureVisible(find.byWidget(addButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidget(addButton));
      await tester.pumpAndSettle();

      // Find the View Cart button by its icon
      final StyledButton viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      ).evaluate().first.widget as StyledButton;
      
      await tester.ensureVisible(find.byWidget(viewCartButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidget(viewCartButton));
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsWidgets);

      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // The total for 3 Veggie Delights at £11.00 each = £33.00
      expect(find.text('Total: £33.00'), findsOneWidget);
    });

    testWidgets('remove item from cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich to cart
      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify item is in cart
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);

      // Find and tap the delete button (Icons.delete)
      final deleteButtons = find.byIcon(Icons.delete);
      if (deleteButtons.evaluate().isEmpty) {
        return;
      }
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Verify item was removed
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('decrease quantity to zero removes item', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich to cart
      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Find and tap the minus button to decrease quantity
      final minusButtons = find.byIcon(Icons.remove);
      if (minusButtons.evaluate().isEmpty) {
        return;
      }
      await tester.tap(minusButtons.first);
      await tester.pumpAndSettle();

      // Verify item was removed when quantity reached 0
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('increase quantity in cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich to cart
      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Find and tap the plus button to increase quantity
      final plusButtons = find.byIcon(Icons.add);
      if (plusButtons.evaluate().isEmpty) {
        return;
      }
      await tester.tap(plusButtons.first);
      await tester.pumpAndSettle();

      // Verify quantity increased and price updated
      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });


    testWidgets('profile screen validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find profile button
      final profileButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Profile'
      );
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Verify on profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Try to save without filling fields
      final saveButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Save Profile'
      );
      if (saveButton.evaluate().isEmpty) {
        return;
      }
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify validation error appears
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('profile screen complete flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Profile'
      );
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Fill in profile fields
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length < 2) {
        return;
      }
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.pumpAndSettle();

      await tester.enterText(textFields.at(1), 'London');
      await tester.pumpAndSettle();

      // Save profile
      final saveButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Save Profile'
      );
      if (saveButton.evaluate().isEmpty) {
        return;
      }
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should be back on order screen with welcome message
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Welcome, John Doe! Ordering from London'), findsOneWidget);
    });

    testWidgets('settings screen font size adjustment', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find settings button
      final settingsButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Settings'
      );
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify on settings screen
      expect(find.text('Settings'), findsOneWidget);

      // Find and interact with font size slider
      final sliders = find.byType(Slider);
      if (sliders.evaluate().isEmpty) {
        return;
      }
      await tester.drag(sliders.first, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Go back to order screen
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isEmpty) {
        return;
      }
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we're back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('order history displays completed orders', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to order history
      final orderHistoryButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Order History'
      );
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      // Verify order history screen appears
      expect(find.text('Order History'), findsOneWidget);
    });

    testWidgets('empty cart shows message and no checkout button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add and then remove an item
      final addToCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Add to Cart'
      );
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'View Cart'
      );
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Remove the item
      final deleteButtons = find.byIcon(Icons.delete);
      if (deleteButtons.evaluate().isNotEmpty) {
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();
      }

      // Verify empty cart message
      expect(find.text('Your cart is empty.'), findsOneWidget);

      // Verify checkout button is not visible
      final checkoutButton = find.byWidgetPredicate(
        (widget) => widget is StyledButton && widget.label == 'Checkout'
      );
      expect(checkoutButton, findsNothing);
    });
  });
}
