
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_au/models/product.dart';
import 'package:product_au/services/product_service.dart';
import 'package:product_au/utils/web_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService;
  final SharedPreferences _prefs;

  ProductProvider(
    this._productService,
    this._prefs,
  ) {
    _initializeFavorites();
  }

  List<Product> _products = [];

  final Set<int> _favoriteIds = {};

  static const String _favoritesKey = 'favorite_product_ids';
  static const String _favoritesBackupKey =
      'favorite_product_ids_backup';

  bool _isLoading = false;
  bool _isSearching = false;

  String? _errorMessage;
  String _searchQuery = '';

  Product? _selectedProduct;
  bool _isLoadingDetails = false;
  String? _detailsErrorMessage;

  // ==========================================================
  // GETTERS
  // ==========================================================

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  bool get isSearching => _isSearching;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get isEmpty => !_isLoading && _products.isEmpty;

  bool get hasError => _errorMessage != null;

  Product? get selectedProduct => _selectedProduct;

  bool get isLoadingDetails => _isLoadingDetails;

  String? get detailsErrorMessage => _detailsErrorMessage;

  bool get hasDetailsError => _detailsErrorMessage != null;

  // ==========================================================
  // FAVORITES
  // ==========================================================

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  List<Product> get favoriteProducts {
    return _products
        .where((product) => _favoriteIds.contains(product.id))
        .toList();
  }

  // ==========================================================
  // INITIALIZE FAVORITES
  // ==========================================================

  Future<void> _initializeFavorites() async {
    await _loadFavorites();
  }

  // ==========================================================
  // LOAD SAVED FAVORITES
  // ==========================================================

  Future<void> _loadFavorites() async {
    try {
      // For web, try the direct localStorage approach first
      if (kIsWeb) {
        final webFavorites = await WebStorage.loadFavorites();
        if (webFavorites.isNotEmpty) {
          _favoriteIds.clear();
          _favoriteIds.addAll(webFavorites);
          notifyListeners();
          return;
        }
      }
      
      // First try the primary key.
      List<String>? savedIds =
          _prefs.getStringList(_favoritesKey);

      // If primary key is empty, try backup key.
      if (savedIds == null || savedIds.isEmpty) {
        savedIds =
            _prefs.getStringList(_favoritesBackupKey);
      }

      if (savedIds == null || savedIds.isEmpty) {
        return;
      }

      _favoriteIds.clear();

      for (final id in savedIds) {
        final parsedId = int.tryParse(id);

        if (parsedId != null) {
          _favoriteIds.add(parsedId);
        }
      }

      notifyListeners();
    } catch (e) {
      // Silent error handling - favorites will just be empty
    }
  }

  // ==========================================================
  // TOGGLE FAVORITE
  // ==========================================================

  Future<void> toggleFavorite(int productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    notifyListeners();

    await _saveFavorites();
  }

  // ==========================================================
  // SAVE FAVORITES
  // ==========================================================

  Future<void> _saveFavorites() async {
    try {
      final favoritesList = _favoriteIds
          .map((id) => id.toString())
          .toList();

      // Save primary key.
      await _prefs.setStringList(
        _favoritesKey,
        favoritesList,
      );

      // Save backup key.
      await _prefs.setStringList(
        _favoritesBackupKey,
        favoritesList,
      );

      // Force commit to storage (web-specific)
      await _prefs.commit();
    } catch (e) {
      // Silent error handling
    }
  }


  // ==========================================================
  // LOAD PRODUCTS
  // ==========================================================

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
          'Unable to load products. Please check your internet connection.';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ==========================================================
  // LOAD PRODUCTS ONLY IF NEEDED
  // ==========================================================

  Future<void> loadProductsIfNeeded() async {
    if (_products.isNotEmpty) {
      return;
    }

    await loadProducts();
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Future<void> searchProducts(String query) async {
    final trimmedQuery = query.trim();

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
          await _productService.searchProducts(
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

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refresh() async {
    if (_searchQuery.isEmpty) {
      await loadProducts();
    } else {
      await searchProducts(_searchQuery);
    }
  }

  // ==========================================================
  // PRODUCT DETAILS
  // ==========================================================

  Future<void> getProductDetails(int productId) async {
    _isLoadingDetails = true;
    _detailsErrorMessage = null;
    _selectedProduct = null;

    notifyListeners();

    try {
      _selectedProduct =
          await _productService.getProductById(
        productId,
      );
    } catch (_) {
      _selectedProduct = null;

      _detailsErrorMessage =
          'Unable to load product details. Please check your internet connection.';
    } finally {
      _isLoadingDetails = false;

      notifyListeners();
    }
  }

  // ==========================================================
  // CLEAR PRODUCT DETAILS
  // ==========================================================

  void clearProductDetails() {
    _selectedProduct = null;
    _detailsErrorMessage = null;

    notifyListeners();
  }
}