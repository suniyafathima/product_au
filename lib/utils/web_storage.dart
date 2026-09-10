// Web-specific storage solution for favorites persistence
import 'dart:html' as html;
import 'dart:convert';

class WebStorage {
  static const String favoritesKey = 'flutter_favorites_v2';
  
  static bool get isWeb {
    try {
      return html.window != null;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> saveFavorites(Set<int> favoriteIds) async {
    if (!isWeb) return;
    
    try {
      final List<String> favoritesList = favoriteIds.map((id) => id.toString()).toList();
      final String jsonString = jsonEncode(favoritesList);
      
      html.window.localStorage[favoritesKey] = jsonString;
    } catch (e) {
      // Silent error handling
    }
  }
  
  static Future<Set<int>> loadFavorites() async {
    if (!isWeb) return {};
    
    try {
      final String? jsonString = html.window.localStorage[favoritesKey];
      
      if (jsonString == null || jsonString.isEmpty) {
        return {};
      }
      
      final List<dynamic> favoritesList = jsonDecode(jsonString);
      final Set<int> favoriteIds = {};
      
      for (final item in favoritesList) {
        final parsedId = int.tryParse(item.toString());
        if (parsedId != null) {
          favoriteIds.add(parsedId);
        }
      }
      
      return favoriteIds;
    } catch (e) {
      return {};
    }
  }
}

