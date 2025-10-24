import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
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
  int _sixinchQuantity = 0;
  bool _isSixInch = false;


  void _increaseQuantity() {
    if (_isSixInch) {
      if (_sixinchQuantity < widget.maxQuantity) {
        setState(() => _sixinchQuantity++);
      }
    } else {
      if (_quantity < widget.maxQuantity) {
        setState(() => _quantity++);
      }
    }
  }

  void _decreaseQuantity() {
    if (_isSixInch) {
      if (_sixinchQuantity > 0) {
        setState(() => _sixinchQuantity--);
      }
    } else {
      if (_quantity > 0) {
        setState(() => _quantity--);
      }
    }
  }

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
              _isSixInch ? _sixinchQuantity : _quantity,
              _isSixInch ? '6-inch' : 'Footlong',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isSixInch ? _sixinchQuantity < widget.maxQuantity ? _increaseQuantity : null : _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  child: const Text('+ Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton(
                    onPressed: _isSixInch ? _sixinchQuantity > 0 ? _decreaseQuantity : null : _quantity > 0 ? _decreaseQuantity : null,
                  child: const Text('- Remove'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            Slider(
              value: _isSixInch ? 1 : 0,
              onChanged: (double value) {
                setState(() {
                  _isSixInch = value == 1;
                });
              },
              divisions: 1,
              label: _isSixInch ? '6-inch' : 'Footlong',
              min: 0,
              max: 1,
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
