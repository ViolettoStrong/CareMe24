import 'package:careme24/api/api.dart';
import 'package:careme24/models/favorite_model.dart';

class FavoritesResponse {
  static Future<List<ServiceModel2>> getFavoritesRepository() async {
    return await Api.getFavorites();
  }

  static Future<dynamic> postFavoritesRepository(String id) async {
    return await Api.postFavorites(id);
  }

  static Future<Map<String, dynamic>> deleteFavoriteRepository(
      String id) async {
    return await Api.deleteFavorite(id);
  }
}
