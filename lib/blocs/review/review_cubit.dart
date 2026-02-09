import 'package:bloc/bloc.dart';
import 'package:careme24/models/reviews_model.dart';
import 'package:careme24/repositories/review_repository.dart';

import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  Future<void> submitReview(String text, int rating, String serviceId) async {
    emit(ReviewLoading());
    try {
      final data = {
        "text": text.trim(),
        "rating": rating,
        "service_id": serviceId.trim(),
      };

      final response = await ReviewRepository.postReviewRepository(data);

      if (response != null) {
        emit(const ReviewSuccess("Review submitted successfully!"));

        getReview(serviceId);
      } else {
        emit(const ReviewFailure("Failed to submit review"));
      }
    } catch (e) {
      emit(ReviewFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> getAverage(
    String id,
  ) async {
    emit(ReviewLoading());
    try {
      final response = await ReviewRepository.getAverageRetingRepository(id);

      if (response['average_rating'] != null && response.isNotEmpty) {
        emit(ReviewSuccessAverage(response['average_rating']));
      } else {
        emit(const ReviewFailure("Failed to submit review"));
      }
    } catch (e) {
      emit(ReviewFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> getReview(
    String serviceId,
  ) async {
    emit(ReviewLoading());
    try {
      final List<Review> reviews =
          await ReviewRepository.getReviewRepository(serviceId);

      if (reviews.isNotEmpty) {
        emit(ReviewLoaded(reviews));
      } else {
        emit(const ReviewFailure("Failed to submit review"));
      }
    } catch (e) {
      emit(ReviewFailure("Error: ${e.toString()}"));
    }
  }
}
