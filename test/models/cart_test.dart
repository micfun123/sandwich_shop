import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    late OrderRepository orderRepo;
    late PricingRepository pricingRepo;
    late Cart cart;

    setUp(() {
      orderRepo = OrderRepository(maxQuantity: 5);
      pricingRepo = PricingRepository();
      cart = Cart(orderRepository: orderRepo, pricingRepository: pricingRepo);
    });

    test('starts empty with zero totals', () {
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0.0);
      expect(cart.footlongCount, 0);
      expect(cart.sixInchCount, 0);
    });

    test('addItem increments repositories and stores item', () {
      final item = CartItem(isSixInch: false, isToasted: true, breadType: 'wheat', note: 'no onions');
      final added = cart.addItem(item);
      expect(added, isTrue);
      expect(cart.items.length, 1);
      expect(cart.totalQuantity, 1);
      expect(cart.footlongCount, 1);
      expect(cart.totalPrice, pricingRepo.footlongPrice * 1);
    });

    test('cannot add beyond maxQuantity', () {
      // add up to max
      for (var i = 0; i < 5; i++) {
        final added = cart.addItem(CartItem(isSixInch: i % 2 == 0));
        expect(added, isTrue);
      }
      // next add should fail
      final added = cart.addItem(CartItem(isSixInch: true));
      expect(added, isFalse);
      expect(cart.items.length, 5);
      expect(cart.totalQuantity, 5);
    });

    test('removeItem removes matching item and updates repos', () {
      final a = CartItem(isSixInch: true, breadType: 'white');
      final b = CartItem(isSixInch: false, breadType: 'wheat');
      cart.addItem(a);
      cart.addItem(b);

      final removed = cart.removeItem(a);
      expect(removed, isTrue);
      expect(cart.items.length, 1);
      expect(cart.sixInchCount, 0);
      expect(cart.footlongCount, 1);
      expect(cart.totalQuantity, 1);
    });

    test('removeAt removes by index and updates repos', () {
      cart.addItem(CartItem(isSixInch: true));
      cart.addItem(CartItem(isSixInch: true));
      final removed = cart.removeAt(0);
      expect(removed, isNotNull);
      expect(cart.items.length, 1);
      expect(cart.sixInchCount, 1);
      expect(cart.totalQuantity, 1);
    });

    test('clear empties cart and resets repositories', () {
      cart.addItem(CartItem(isSixInch: true));
      cart.addItem(CartItem(isSixInch: false));
      expect(cart.items.length, 2);
      cart.clear();
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0.0);
      expect(cart.footlongCount, 0);
      expect(cart.sixInchCount, 0);
    });
  });
}
