import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Simple in-memory cart model.
///
/// Note: this class intentionally keeps the same simple design used by the
/// app (a map keyed by `Sandwich`). It adds helper methods used by the UI:
/// - `updateQuantity` to set an exact quantity (or remove when <= 0)
/// - `removeItem` to remove an item entirely (and record it for undo)
/// - `restoreLastRemoved` to restore the most recently removed item
class Cart {
  final Map<Sandwich, int> _items = {};

  // undo buffer for last removed item (sandwich + quantity)
  MapEntry<Sandwich, int>? _lastRemoved;

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  /// Returns the last removed item (if any) and its quantity.
  MapEntry<Sandwich, int>? get lastRemoved => _lastRemoved;

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
  }

  /// Decrease quantity by [quantity]. If the resulting quantity is <= 0 the
  /// item is removed entirely. This method does not populate the undo buffer
  /// (it is meant for incremental decreases).
  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  /// Remove the item entirely and record it in the undo buffer so the UI can
  /// offer an "Undo" action.
  void removeItem(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      final qty = _items[sandwich]!;
      _items.remove(sandwich);
      _lastRemoved = MapEntry(sandwich, qty);
    }
  }

  /// Restore the last removed item (if any) back into the cart and clear the
  /// undo buffer.
  void restoreLastRemoved() {
    if (_lastRemoved != null) {
      _items[_lastRemoved!.key] = _lastRemoved!.value;
      _lastRemoved = null;
    }
  }

  /// Set the exact quantity for a sandwich. If [newQuantity] <= 0 the item
  /// is removed and placed into the undo buffer (same behavior as
  /// [removeItem]). This method overwrites any existing quantity.
  void updateQuantity(Sandwich sandwich, int newQuantity) {
    if (newQuantity <= 0) {
      // treat as removal
      if (_items.containsKey(sandwich)) {
        final qty = _items[sandwich]!;
        _items.remove(sandwich);
        _lastRemoved = MapEntry(sandwich, qty);
      }
    } else {
      _items[sandwich] = newQuantity;
    }
  }

  void clear() {
    _items.clear();
    _lastRemoved = null;
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}
