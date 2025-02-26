class Product {
  final int id;
  final String title;
  final double price; // 9.99
  final String description;
  final String image;
  final Map<String, dynamic> rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
      rating: json['rating'],
    );
  }
}
