
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const String baseUrl =
      'https://dummyjson.com';

  // ------------------------------------------------------------
  // GET ALL PRODUCTS
  // ------------------------------------------------------------

  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load products',
      );
    }

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    final List products =
        data['products'] ?? [];

    return products
        .map(
          (item) => Product.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ------------------------------------------------------------
  // SEARCH PRODUCTS
  // ------------------------------------------------------------

  Future<List<Product>> searchProducts(
    String query,
  ) async {
    if (query.trim().isEmpty) {
      return getProducts();
    }

    final uri = Uri.parse(
      '$baseUrl/products/search',
    ).replace(
      queryParameters: {
        'q': query.trim(),
      },
    );

    final response =
        await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to search products',
      );
    }

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    final List products =
        data['products'] ?? [];

    return products
        .map(
          (item) => Product.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ------------------------------------------------------------
  // GET PRODUCT DETAILS
  // ------------------------------------------------------------

  Future<Product> getProductById(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load product details',
      );
    }

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    return Product.fromJson(data);
  }
}
