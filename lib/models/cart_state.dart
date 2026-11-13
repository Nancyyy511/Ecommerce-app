import 'cart_item.dart';

/// The app-wide cart data, owned by MainLayout and shared with its screens.
class CartState {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(CartItem item) {
    final newItem = item.quantity < 1 ? item.copyWith(quantity: 1) : item;
    final index = _items.indexWhere(
      (existing) => existing.variantKey == newItem.variantKey,
    );
    if (index == -1) {
      _items.add(newItem);
    } else {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + newItem.quantity,
      );
    }
  }

  void setQuantity(String variantKey, int quantity) {
    final index = _items.indexWhere((item) => item.variantKey == variantKey);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: quantity < 1 ? 1 : quantity,
      );
    }
  }

  void remove(String variantKey) {
    _items.removeWhere((item) => item.variantKey == variantKey);
  }
}
