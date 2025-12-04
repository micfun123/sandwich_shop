import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  final int maxQuantity;

  const CartScreen({super.key, required this.cart, this.maxQuantity = 10});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  void _showQuantityEditor(Sandwich sandwich, int currentQty) async {
    final TextEditingController controller =
        TextEditingController(text: currentQty.toString());

    final result = await showDialog<int?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit quantity for ${sandwich.name}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter quantity',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.of(context).pop(value);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result == null) return; // cancelled

    int newQty = result;
    if (newQty > widget.maxQuantity) {
      newQty = widget.maxQuantity;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Quantity limited to ${widget.maxQuantity}'),
        duration: const Duration(seconds: 2),
      ));
    }

    setState(() {
      widget.cart.updateQuantity(sandwich, newQty);
    });

    // If the update removed the item, show undo snackbar
    if (newQty <= 0 || widget.cart.getQuantity(sandwich) == 0) {
      _showRemovedSnackbar(sandwich);
    }
  }

  void _showRemovedSnackbar(Sandwich sandwich) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${sandwich.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.cart.restoreLastRemoved();
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Cart total header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Your Cart', style: heading1),
              ),
              const SizedBox(height: 8),
              for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                CartItemRow(
                  sandwich: entry.key,
                  quantity: entry.value,
                  maxQuantity: widget.maxQuantity,
                  onIncrease: () {
                    final current = widget.cart.getQuantity(entry.key);
                    if (current < widget.maxQuantity) {
                      setState(() {
                        widget.cart.updateQuantity(entry.key, current + 1);
                      });
                    }
                  },
                  onDecrease: () {
                    final current = widget.cart.getQuantity(entry.key);
                    if (current > 1) {
                      setState(() {
                        widget.cart.updateQuantity(entry.key, current - 1);
                      });
                    } else {
                      setState(() {
                        widget.cart.removeItem(entry.key);
                      });
                      _showRemovedSnackbar(entry.key);
                    }
                  },
                  onEdit: () => _showQuantityEditor(entry.key, entry.value),
                  onRemove: () {
                    setState(() {
                      widget.cart.removeItem(entry.key);
                    });
                    _showRemovedSnackbar(entry.key);
                  },
                ),
              Builder(builder: (context) {
                final pricing = PricingRepository().computeTotals(widget.cart);
                return Column(
                  children: [
                    Text('Subtotal: £${pricing.subtotal.toStringAsFixed(2)}', style: normalText, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Tax: £${pricing.tax.toStringAsFixed(2)}', style: normalText, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text('Total: £${pricing.total.toStringAsFixed(2)}', style: heading2, textAlign: TextAlign.center),
                  ],
                );
              }),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemRow extends StatelessWidget {
  final Sandwich sandwich;
  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const CartItemRow({
    super.key,
    required this.sandwich,
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Image.asset(
              sandwich.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sandwich.name, style: heading2),
                Text('${sandwich.isFootlong ? 'Footlong' : 'Six-inch'} on ${sandwich.breadType.name}', style: normalText),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDecrease,
                icon: const Icon(Icons.remove),
                tooltip: 'Decrease quantity',
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade200,
                  ),
                  child: Text('$quantity', style: heading2),
                ),
              ),
              IconButton(
                onPressed: quantity >= maxQuantity ? null : onIncrease,
                icon: const Icon(Icons.add),
                tooltip: 'Increase quantity',
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete),
                tooltip: 'Remove item',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
