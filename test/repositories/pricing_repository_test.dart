import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('initial total price is 0.0', () {
      final pricing = PricingRepository();
      expect(pricing.totalPrice, 0.0);
    });

    test('calculates total for six-inch sandwiches', () {
      final pricing = PricingRepository();
      pricing.updatePrice(3, true); // six-inch
      expect(pricing.totalPrice, equals(7.0 * 3));
    });

    test('calculates total for footlong sandwiches', () {
      final pricing = PricingRepository();
      pricing.updatePrice(2, false); // footlong
      expect(pricing.totalPrice, equals(11.0 * 2));
    });
  });
}
