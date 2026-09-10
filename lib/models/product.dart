class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final List<String> tags;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.tags,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      id: json['id'] ?? 0,

      title: json['title'] ?? '',

      description: json['description'] ?? '',

      price: (json['price'] as num?)?.toDouble() ?? 0.0,

      discountPercentage:
          (json['discountPercentage'] as num?)
                  ?.toDouble() ??
              0.0,

      rating:
          (json['rating'] as num?)?.toDouble() ?? 0.0,

      stock: json['stock'] ?? 0,

      brand: json['brand'] ?? 'Unknown',

      category: json['category'] ?? '',

      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],

      thumbnail: json['thumbnail'] ?? '',

      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
    );
  }
}
