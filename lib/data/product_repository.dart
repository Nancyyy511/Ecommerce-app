import '../models/category.dart';
import '../models/product.dart';
import 'dummy_data.dart';

/// Local data source boundary; it can be backed by an API in a later phase.
class ProductRepository {
  const ProductRepository();

  List<Product> getProducts() => DummyData.products;

  List<Category> getCategories() => DummyData.categories;

  List<Product> getProductsByCategory(String category, {String? subcategory}) {
    return DummyData.products
        .where(
          (product) =>
              product.category == category &&
              (subcategory == null || product.subcategory == subcategory),
        )
        .toList(growable: false);
  }

  Product? getProductById(String id) {
    for (final product in DummyData.products) {
      if (product.id == id) return product;
    }
    return null;
  }

  List<Product> searchProducts(
    String query, {
    String? category,
    String? subcategory,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return DummyData.products
        .where(
          (product) =>
              (category == null || product.category == category) &&
              (subcategory == null || product.subcategory == subcategory) &&
              (normalizedQuery.isEmpty ||
                  product.name.toLowerCase().contains(normalizedQuery) ||
                  product.category.toLowerCase().contains(normalizedQuery)),
        )
        .toList(growable: false);
  }
}
