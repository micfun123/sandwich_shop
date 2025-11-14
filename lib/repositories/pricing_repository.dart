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

    /// Utility used by tests or admin flows to set counts directly.
    void setCounts({required int footlong, required int sixInch}) {
        _footlongCount = footlong >= 0 ? footlong : 0;
        _sixInchCount = sixInch >= 0 ? sixInch : 0;
    }
}