import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Represents a single sandwich added to the cart.
class CartItem {
  final bool isSixInch;
  final bool isToasted;
  final String breadType;
  final String note;
  final DateTime addedAt;

  CartItem({
    required this.isSixInch,
    this.isToasted = false,
    this.breadType = 'white',
    this.note = '',
  }) : addedAt = DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'isSixInch': isSixInch,
      'isToasted': isToasted,
      'breadType': breadType,
      'note': note,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

/// Simple cart that keeps the list of items and uses the provided
/// repositories to keep quantity and pricing in sync.
class Cart {
  final OrderRepository _orderRepository;
  final PricingRepository _pricingRepository;
  final List<CartItem> _items = [];

  Cart({
    required OrderRepository orderRepository,
    required PricingRepository pricingRepository,
  })  : _orderRepository = orderRepository,
        _pricingRepository = pricingRepository;

  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of items in the cart (delegates to OrderRepository).
  int get totalQuantity => _orderRepository.quantity;

  /// Total price (delegates to PricingRepository).
  double get totalPrice => _pricingRepository.totalPrice;

  int get footlongCount => _pricingRepository.footlongCount;
  int get sixInchCount => _pricingRepository.sixInchCount;

  /// Attempts to add an item. Returns true if added, false if the
  /// order repository disallows more items (maxQuantity reached).
  bool addItem(CartItem item) {
    if (!_orderRepository.canIncrement) return false;
    _items.add(item);
    _orderRepository.increment();
    _pricingRepository.addItem(isSixInch: item.isSixInch);
    return true;
  }

  /// Attempts to remove the first matching item; returns true when removed.
  bool removeItem(CartItem item) {
    final index = _items.indexWhere((i) => _sameItem(i, item));
    if (index == -1) return false;
    final removed = _items.removeAt(index);
    if (_orderRepository.canDecrement) {
      _orderRepository.decrement();
    }
    _pricingRepository.removeItem(isSixInch: removed.isSixInch);
    return true;
  }

  /// Remove item by index.
  CartItem? removeAt(int index) {
    if (index < 0 || index >= _items.length) return null;
    final removed = _items.removeAt(index);
    if (_orderRepository.canDecrement) {
      _orderRepository.decrement();
    }
    _pricingRepository.removeItem(isSixInch: removed.isSixInch);
    return removed;
  }

  /// Clears the cart and resets the repositories to match an empty cart.
  void clear() {
    // remove items one-by-one so repositories stay in sync
    while (_items.isNotEmpty) {
      final removed = _items.removeLast();
      if (_orderRepository.canDecrement) {
        _orderRepository.decrement();
      }
      _pricingRepository.removeItem(isSixInch: removed.isSixInch);
    }
  }

  bool _sameItem(CartItem a, CartItem b) {
    return a.isSixInch == b.isSixInch &&
        a.isToasted == b.isToasted &&
        a.breadType == b.breadType &&
        a.note == b.note &&
        a.addedAt == b.addedAt;
  }
}
