import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('initial total price is 0.0', () {
      final pricing = PricingRepository();
      expect(pricing.totalPrice, 0.0);
    });
    test('add and remove items update totals per size', () {
        final pricing = PricingRepository();

        pricing.addItem(isSixInch: true);
        pricing.addItem(isSixInch: true);
        pricing.addItem(isSixInch: false);

        // two six-inch (£7 each) and one footlong (£11)
        expect(pricing.sixInchCount, 2);
        expect(pricing.footlongCount, 1);
        expect(pricing.sixInchTotal, equals(7.0 * 2));
        expect(pricing.footlongTotal, equals(11.0 * 1));
        expect(pricing.totalPrice, equals(7.0 * 2 + 11.0 * 1));

        // remove one six-inch
        pricing.removeItem(isSixInch: true);
        expect(pricing.sixInchCount, 1);
        expect(pricing.totalPrice, equals(7.0 * 1 + 11.0 * 1));
      });
  });
}
