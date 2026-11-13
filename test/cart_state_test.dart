import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/cart_state.dart';

void main() {
  test(
    'cart merges matching variants and keeps different variants separate',
    () {
      final cart = CartState();
      const black = CartItem(
        productId: 'shoe-1',
        quantity: 1,
        size: '40',
        colorName: 'Black',
        colorValue: 0xFF302C2C,
      );

      cart.add(black);
      cart.add(black);
      cart.add(
        const CartItem(
          productId: 'shoe-1',
          quantity: 1,
          size: '41',
          colorName: 'Black',
          colorValue: 0xFF302C2C,
        ),
      );
      cart.add(
        const CartItem(
          productId: 'shoe-1',
          quantity: 1,
          size: '40',
          colorName: 'Orange',
          colorValue: 0xFFC33115,
        ),
      );

      expect(cart.items, hasLength(3));
      expect(cart.items.first.quantity, 2);
      expect(cart.items.map((item) => item.variantKey).toSet(), hasLength(3));
    },
  );

  test('cart quantity never drops below one and items can be removed', () {
    final cart = CartState();
    const item = CartItem(
      productId: 'shoe-1',
      quantity: 2,
      size: '40',
      colorName: 'Black',
    );
    cart.add(item);

    cart.setQuantity(item.variantKey, 0);
    expect(cart.items.single.quantity, 1);

    cart.remove(item.variantKey);
    expect(cart.items, isEmpty);

    cart.add(item.copyWith(quantity: 0));
    expect(cart.items.single.quantity, 1);
  });
}
