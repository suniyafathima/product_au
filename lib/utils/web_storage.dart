import 'package:shared_preferences/shared_preferences.dart';

class WebStorage {
  static const String favoritesKey = 'flutter_favorites_v2';

  /// Save favorites
  static Future<void> saveFavorites(Set<int> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final favoritesList =
          favoriteIds.map((id) => id.toString()).toList();

      await prefs.setStringList(
        favoritesKey,
        favoritesList,
      );
    } catch (e) {
      print('WebStorage: Error saving favorites: $e');
    }
  }

  /// Load favorites
  static Future<Set<int>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final favoritesList =
          prefs.getStringList(favoritesKey);

      if (favoritesList == null || favoritesList.isEmpty) {
        return {};
      }

      final Set<int> favoriteIds = {};

      for (final item in favoritesList) {
        final parsedId = int.tryParse(item);

        if (parsedId != null) {
          favoriteIds.add(parsedId);
        }
      }

      return favoriteIds;
    } catch (e) {
      print('WebStorage: Error loading favorites: $e');
      return {};
    }
  }

  /// Check whether storage is available
  static Future<bool> get isWeb async {
    return true;
  }
}
