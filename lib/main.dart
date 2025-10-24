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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const OrderItemDisplay(3, 'Turkey'),
                    color: Colors.amber[600],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const OrderItemDisplay(2, 'Footlong'),
                    color: const Color.fromARGB(255, 0, 17, 255),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const OrderItemDisplay(5, 'Footlong'),
                    color: const Color.fromARGB(255, 66, 97, 10),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: const Color.fromARGB(255, 255, 0, 191),
                    child: const OrderItemDisplay(9, 'Turkey'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const OrderItemDisplay(4, 'Footlong'),
                    color: const Color.fromARGB(255, 255, 0, 0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const OrderItemDisplay(1, 'Footlong'),
                    color: const Color.fromARGB(255, 30, 122, 122),
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

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}
