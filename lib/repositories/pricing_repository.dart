class PricingRepository {
  final double footlongPrice = 11.00;
  final double sixInchPrice = 7.00;

  int _footlongCount = 0;
  int _sixInchCount = 0;

  int get footlongCount => _footlongCount;
  int get sixInchCount => _sixInchCount;

  double get footlongTotal => _footlongCount * footlongPrice;
  double get sixInchTotal => _sixInchCount * sixInchPrice;

  double get totalPrice => footlongTotal + sixInchTotal;

  void addItem({required bool isSixInch}) {
    if (isSixInch) {
      _sixInchCount++;
    } else {
      _footlongCount++;
    }
  }

  void removeItem({required bool isSixInch}) {
    if (isSixInch) {
      if (_sixInchCount > 0) _sixInchCount--;
    } else {
      if (_footlongCount > 0) _footlongCount--;
    }
  }

  /// Convenience for older code: calculate price for quantity/size
  double calculatePrice({required int quantity, required bool isFootlong}) {
    final double pricePerItem = isFootlong ? footlongPrice : sixInchPrice;
    return quantity * pricePerItem;
  }
}
