import '../core/constants/app_assets.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/user.dart';

abstract final class DummyData {
  // Asset list indexing is evaluated at runtime, so these collections are final
  // rather than const. Their contents and asset paths remain unchanged.
  static final List<Category> categories = [
    Category(
      name: "Women's Fashion",
      imagePath: AppAssets.categories[0],
      subcategories: [
        'Dresses',
        'Jeans',
        'Skirts',
        'Pijamas',
        'Bags',
        'T-shirts',
        'Footwear',
        'Eyewear',
        'Watches',
      ],
    ),
    Category(
      name: "Men's Fashion",
      imagePath: AppAssets.categories[1],
      subcategories: [
        'T-shirts',
        'Shorts',
        'Jeans',
        'Pants',
        'Footwear',
        'Suits',
        'Watches',
        'Bags',
        'Eyewears',
      ],
    ),
    Category(name: 'Laptops & Electronics', imagePath: AppAssets.categories[2]),
    Category(name: 'Baby & Toys', imagePath: AppAssets.categories[3]),
    Category(name: 'Beauty', imagePath: AppAssets.categories[4]),
    Category(name: 'Headphones', imagePath: AppAssets.categories[5]),
    Category(name: 'Skincare', imagePath: AppAssets.categories[6]),
    Category(name: 'Cameras', imagePath: AppAssets.categories[7]),
  ];

  static final List<Product> products = [
    Product(
      id: 'shoe-1',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[0],
      price: 1200,
      oldPrice: 2000,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'Black',
    ),
    Product(
      id: 'shoe-2',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[1],
      price: 1100,
      oldPrice: 1500,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'Blue',
    ),
    Product(
      id: 'shoe-3',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[2],
      price: 1000,
      oldPrice: 1300,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'Orange',
      colorValue: 0xFFC33115,
    ),
    Product(
      id: 'shoe-4',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[3],
      price: 1500,
      oldPrice: 2000,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'Red',
      colorValue: 0xFFCB171F,
    ),
    Product(
      id: 'shoe-5',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[4],
      price: 1800,
      oldPrice: 2100,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'White',
      colorValue: 0xFFECECEC,
    ),
    Product(
      id: 'shoe-6',
      name: 'Nike Air Jordon',
      imagePath: AppAssets.products[5],
      price: 1900,
      oldPrice: 2500,
      category: "Men's Fashion",
      subcategory: 'Footwear',
      colorName: 'Black',
    ),
    Product(
      id: 'dress-1',
      name: 'Tall Cotton Dress',
      imagePath: AppAssets.women[0],
      price: 600,
      oldPrice: 750,
      category: "Women's Fashion",
      subcategory: 'Dresses',
      colorName: 'Orange',
      colorValue: 0xFFFF9300,
    ),
    Product(
      id: 'watch-1',
      name: "GUESS Women's Gold Watch",
      imagePath: AppAssets.women[8],
      price: 1200,
      oldPrice: 1500,
      category: "Women's Fashion",
      subcategory: 'Watches',
      colorName: 'Gold',
      colorValue: 0xFFFFD9B9,
    ),
    Product(
      id: 'appliance-washer',
      name: 'Front Load Washing Machine',
      price: 12500,
      category: 'Home Appliance',
      subcategory: 'Washing Machines',
    ),
    Product(
      id: 'appliance-cooktop',
      name: 'Stainless Steel Gas Cooktop',
      price: 6800,
      category: 'Home Appliance',
      subcategory: 'Cooktops',
    ),
    Product(
      id: 'appliance-iron',
      name: 'Steam Iron',
      price: 1450,
      category: 'Home Appliance',
      subcategory: 'Irons',
    ),
  ];

  static const User user = User(
    fullName: 'Mohamed Mohamed Nabil',
    email: 'mohamed.N@gmail.com',
    mobileNumber: '01122118855',
    address: '6th October, street 11.....',
  );
}
