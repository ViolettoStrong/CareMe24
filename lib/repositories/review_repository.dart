import 'package:careme24/api/api.dart';
import 'package:careme24/models/reviews_model.dart';

class ReviewRepository {
  static Future<List<Review>> getReviewRepository(String serviceId) async {
    return await Api.getReviews(serviceId);
  }

  static Future<dynamic> postReviewRepository(Map<String, dynamic> data) async {
    return await Api.postReviews(data);
  }

  static Future<Map<String, dynamic>> deleteReviewRepository(String id) async {
    return await Api.deleteReviews(id);
  }

  static Future<Map<String, dynamic>> getAverageRetingRepository(
      String id) async {
    return await Api.getAverageRating(id);
  }
}
