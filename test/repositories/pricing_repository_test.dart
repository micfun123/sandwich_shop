import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repository = PricingRepository();

    test('calculatePrice for individual items', () {
      final priceSix = repository.calculatePrice(quantity: 1, isFootlong: false);
      expect(priceSix, 7.00);

      final priceFootThree = repository.calculatePrice(quantity: 3, isFootlong: true);
      expect(priceFootThree, 33.00);

      final priceZero = repository.calculatePrice(quantity: 0, isFootlong: true);
      expect(priceZero, 0.00);
    });

    test('computeTotals returns correct subtotal/tax/total', () {
      final cart = Cart();
      final sFoot = Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: true, breadType: BreadType.white);
      final sSix = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.wheat);

      cart.add(sFoot, quantity: 2); // 2 * 11 = 22
      cart.add(sSix, quantity: 3); // 3 * 7 = 21

      final pricing = repository.computeTotals(cart);

      expect(pricing.subtotal, 43.0);
      // tax is 10% as implemented
      expect(pricing.tax, closeTo(4.3, 0.001));
      expect(pricing.total, closeTo(47.3, 0.001));
    });

    test('computeTotals on empty cart returns zeros', () {
      final cart = Cart();
      final pricing = repository.computeTotals(cart);
      expect(pricing.subtotal, 0.0);
      expect(pricing.tax, 0.0);
      expect(pricing.total, 0.0);
    });
  });
}
