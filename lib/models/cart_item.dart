class CartItem {
  const CartItem({
    required this.productId,
    required this.quantity,
    this.size,
    this.colorName,
    this.colorValue,
  });

  final String productId;
  final int quantity;
  final String? size;
  final String? colorName;
  final int? colorValue;

  String get variantKey =>
      '$productId|${size ?? ''}|${colorName ?? ''}|${colorValue ?? ''}';

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    quantity: quantity ?? this.quantity,
    size: size,
    colorName: colorName,
    colorValue: colorValue,
  );
}
