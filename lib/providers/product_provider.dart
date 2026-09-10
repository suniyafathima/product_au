
import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  ProductProvider(this._productService);

  // ------------------------------------------------------------
  // PRODUCTS
  // ------------------------------------------------------------

  List<Product> _products = [];

  final Set<int> _favoriteIds = {};

  bool _isLoading = false;

  bool _isSearching = false;

  String? _errorMessage;

  String _searchQuery = '';

  // ------------------------------------------------------------
  // PRODUCT DETAILS
  // ------------------------------------------------------------

  Product? _selectedProduct;

  bool _isLoadingDetails = false;

  String? _detailsErrorMessage;

  // ------------------------------------------------------------
  // GETTERS
  // ------------------------------------------------------------

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  bool get isSearching => _isSearching;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get isEmpty =>
      !_isLoading && _products.isEmpty;

  bool get hasError =>
      _errorMessage != null;

  // ------------------------------------------------------------
  // PRODUCT DETAILS GETTERS
  // ------------------------------------------------------------

  Product? get selectedProduct =>
      _selectedProduct;

  bool get isLoadingDetails =>
      _isLoadingDetails;

  String? get detailsErrorMessage =>
      _detailsErrorMessage;

  bool get hasDetailsError =>
      _detailsErrorMessage != null;

  // ------------------------------------------------------------
  // FAVORITES
  // ------------------------------------------------------------

  List<Product> get favoriteProducts {
    return _products
        .where(
          (product) =>
              _favoriteIds.contains(product.id),
        )
        .toList();
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    notifyListeners();
  }

  // ------------------------------------------------------------
  // LOAD PRODUCTS
  // ------------------------------------------------------------

  Future<void> loadProducts() async {
    _isLoading = true;

    _errorMessage = null;

    _searchQuery = '';

    notifyListeners();

    try {
      _products =
          await _productService.getProducts();
    } catch (_) {
      _products = [];

      _errorMessage =
          'Unable to load products. '
          'Please check your internet connection.';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------

  Future<void> searchProducts(
    String query,
  ) async {
    final trimmedQuery =
        query.trim();

    if (trimmedQuery.isEmpty) {
      await loadProducts();
      return;
    }

    _searchQuery = trimmedQuery;

    _isSearching = true;

    _errorMessage = null;

    notifyListeners();

    try {
      _products =
          await _productService
              .searchProducts(
        trimmedQuery,
      );
    } catch (_) {
      _products = [];

      _errorMessage =
          'Search failed. Please try again.';
    } finally {
      _isSearching = false;

      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // REFRESH
  // ------------------------------------------------------------

  Future<void> refresh() async {
    if (_searchQuery.isEmpty) {
      await loadProducts();
    } else {
      await searchProducts(
        _searchQuery,
      );
    }
  }

  // ------------------------------------------------------------
  // GET PRODUCT DETAILS
  // ------------------------------------------------------------

  Future<void> getProductDetails(
    int productId,
  ) async {
    _isLoadingDetails = true;

    _detailsErrorMessage = null;

    _selectedProduct = null;

    notifyListeners();

    try {
      _selectedProduct =
          await _productService
              .getProductById(productId);
    } catch (_) {
      _selectedProduct = null;

      _detailsErrorMessage =
          'Unable to load product details. '
          'Please check your internet connection.';
    } finally {
      _isLoadingDetails = false;

      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // CLEAR PRODUCT DETAILS
  // ------------------------------------------------------------

  void clearProductDetails() {
    _selectedProduct = null;

    _detailsErrorMessage = null;

    notifyListeners();
  }
}