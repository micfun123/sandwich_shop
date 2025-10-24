import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const OrderItemDisplay(5, 'Footlong'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => print('Add button pressed!'),
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () => print('Remove button pressed!'),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              'Footlong',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => print('Add button pressed!'),
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => print('Remove button pressed!'),
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
