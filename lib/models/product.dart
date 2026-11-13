class Product {
  const Product({
    required this.id,
    required this.name,
    this.imagePath,
    required this.price,
    required this.category,
    required this.subcategory,
    this.oldPrice,
    this.galleryImagePaths = const [],
    this.rating = 4.8,
    this.reviewCount = 7500,
    this.soldCount = 3230,
    this.description =
        'A quality product selected for the Route collection, made from carefully chosen materials for comfort, reliable performance, and everyday use.',
    this.colorName = 'Black',
    this.colorValue = 0xFF292525,
  });

  final String id;
  final String name;
  final String? imagePath;
  final double price;
  final double? oldPrice;

  /// Additional images for this product, when the catalog has them.
  final List<String> galleryImagePaths;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final String description;
  final String category;
  final String subcategory;
  final String colorName;
  final int colorValue;
}
