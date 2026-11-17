class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final String image;
  final int quantity;
  final int? category;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.quantity,
    this.category,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
      quantity: json['quantity'],
      category: json['category'],
      categoryName: json['category_name'],
    );
  }
}
