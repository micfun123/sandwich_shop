import 'package:sandwich_shop/models/cart.dart';

class Pricing {
  final double subtotal;
  final double tax;
  final double total;

  Pricing({required this.subtotal, required this.tax, required this.total});
}

class PricingRepository {
  /// Price per sandwich: footlong and six-inch
  double calculatePrice({required int quantity, required bool isFootlong}) {
    double price = isFootlong ? 11.00 : 7.00;
    return quantity * price;
  }

  /// Compute subtotal/tax/total for the given cart.
  /// Uses a flat tax rate (10%) — adjust if needed.
  Pricing computeTotals(Cart cart) {
    double subtotal = 0.0;
    for (final entry in cart.items.entries) {
      subtotal += calculatePrice(
        quantity: entry.value,
        isFootlong: entry.key.isFootlong,
      );
    }
    const taxRate = 0.10;
    double tax = subtotal * taxRate;
    double total = subtotal + tax;
    return Pricing(subtotal: subtotal, tax: tax, total: total);
  }
}
