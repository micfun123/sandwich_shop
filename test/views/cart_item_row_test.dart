import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

/// Host widget to hold mutable quantity state for testing callbacks.
class _Host extends StatefulWidget {
  final Sandwich sandwich;
  final int initialQty;
  final int maxQuantity;

  const _Host({required this.sandwich, required this.initialQty, required this.maxQuantity});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CartItemRow(
          sandwich: widget.sandwich,
          quantity: qty,
          maxQuantity: widget.maxQuantity,
          onIncrease: () => setState(() => qty++),
          onDecrease: () => setState(() => qty = qty > 0 ? qty - 1 : 0),
          onEdit: () {},
          onRemove: () => setState(() => qty = 0),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('CartItemRow increases and disables + at maxQuantity', (WidgetTester tester) async {
    final sandwich = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.white);

    await tester.pumpWidget(_Host(sandwich: sandwich, initialQty: 1, maxQuantity: 2));

    // initial quantity displayed
    expect(find.text('1'), findsOneWidget);

    // tap increase
    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);

    // at maxQuantity the increase button should be disabled (null)
    final increaseButtons = tester.widgetList<IconButton>(find.widgetWithIcon(IconButton, Icons.add));
    // There should be at least one IconButton and it should be disabled when at max
    expect(increaseButtons.isNotEmpty, isTrue);
    // The enabled state is represented by onPressed != null
    final first = increaseButtons.first;
    expect(first.onPressed, isNull);
  });

  testWidgets('CartItemRow decrease and remove sets quantity to zero', (WidgetTester tester) async {
    final sandwich = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.wheat);

    await tester.pumpWidget(_Host(sandwich: sandwich, initialQty: 1, maxQuantity: 5));

    // tap decrease (should go to 0)
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
  });
}
