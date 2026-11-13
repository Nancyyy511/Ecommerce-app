class Category {
  const Category({
    required this.name,
    required this.imagePath,
    this.subcategories = const [],
  });

  final String name;
  final String imagePath;
  final List<String> subcategories;
}
