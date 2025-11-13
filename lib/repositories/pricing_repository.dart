class PricingRepository {
    final footlongPrice = 11.00;
    final sixInchPrice = 7.00;
    double _totalPrice = 0.0;

    double get totalPrice => _totalPrice;
    void updatePrice(int quantity, bool isSixInch) {
        double unitPrice = isSixInch ? sixInchPrice : footlongPrice;
        _totalPrice = unitPrice * quantity;
    }
    
}