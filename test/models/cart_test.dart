import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    test('addItem increments order quantity and pricing counts', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      final item = CartItem(isSixInch: true, breadType: 'white', note: 'note');
      final added = cart.addItem(item);

      expect(added, isTrue);
      expect(order.quantity, 1);
      expect(pricing.sixInchCount, 1);
      expect(pricing.footlongCount, 0);
      expect(cart.items.length, 1);
      expect(cart.totalQuantity, 1);
    });

    test('addItem returns false when max quantity reached', () {
      final order = OrderRepository(maxQuantity: 1);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      final itemA = CartItem(isSixInch: true);
      final itemB = CartItem(isSixInch: false);

      expect(cart.addItem(itemA), isTrue);
      expect(order.quantity, 1);
      expect(cart.addItem(itemB), isFalse);
      // counts should remain unchanged from the single successful add
      expect(pricing.sixInchCount, 1);
      expect(pricing.footlongCount, 0);
      expect(order.quantity, 1);
      expect(cart.items.length, 1);
    });

    test('removeItem removes a matching item and updates repos', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      final item = CartItem(isSixInch: false, breadType: 'wholemeal');
      expect(cart.addItem(item), isTrue);
      expect(order.quantity, 1);
      expect(pricing.footlongCount, 1);

      final removed = cart.removeItem(item);
      expect(removed, isTrue);
      expect(order.quantity, 0);
      expect(pricing.footlongCount, 0);
      expect(cart.items.length, 0);
    });

    test('removeItem returns false if item not found', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      final itemA = CartItem(isSixInch: false);
      final itemB = CartItem(isSixInch: true);

      expect(cart.addItem(itemA), isTrue);
      expect(cart.removeItem(itemB), isFalse);
      expect(cart.items.length, 1);
      expect(order.quantity, 1);
    });

    test('removeAt removes by index and returns removed item', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      final a = CartItem(isSixInch: true, breadType: 'white');
      final b = CartItem(isSixInch: false, breadType: 'wheat');

      expect(cart.addItem(a), isTrue);
      expect(cart.addItem(b), isTrue);
      expect(order.quantity, 2);
      expect(pricing.sixInchCount, 1);
      expect(pricing.footlongCount, 1);

      final removed = cart.removeAt(0);
      expect(removed, isNotNull);
      expect(order.quantity, 1);
      // if we removed the first (six-inch) item, sixInchCount should decrement
      expect(pricing.sixInchCount + pricing.footlongCount, 1);
      expect(cart.items.length, 1);
    });

    test('removeAt returns null for invalid index', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      expect(cart.removeAt(0), isNull);
      expect(cart.removeAt(-1), isNull);
    });

    test('clear removes all and resets quantities', () {
      final order = OrderRepository(maxQuantity: 10);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      for (int i = 0; i < 3; i++) {
        cart.addItem(CartItem(isSixInch: i % 2 == 0));
      }
      expect(cart.items.length, 3);
      expect(order.quantity, 3);

      cart.clear();
      expect(cart.items.length, 0);
      expect(order.quantity, 0);
      expect(pricing.footlongCount + pricing.sixInchCount, 0);
    });

    test('items list is unmodifiable', () {
      final order = OrderRepository(maxQuantity: 5);
      final pricing = PricingRepository();
      final cart = Cart(orderRepository: order, pricingRepository: pricing);

      cart.addItem(CartItem(isSixInch: true));
      expect(() => cart.items.add(CartItem(isSixInch: false)), throwsUnsupportedError);
    });
  });
}
