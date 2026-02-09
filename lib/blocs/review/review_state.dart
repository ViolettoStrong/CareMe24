import 'package:careme24/models/reviews_model.dart';

abstract class ReviewState {
  const ReviewState();

  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String message;
  const ReviewSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  ReviewLoaded(this.reviews);
}

class ReviewSuccessAverage extends ReviewState {
  final double average_rating;
  const ReviewSuccessAverage(this.average_rating);

  @override
  List<Object> get props => [average_rating];
}

class ReviewFailure extends ReviewState {
  final String error;
  const ReviewFailure(this.error);

  @override
  List<Object> get props => [error];
}
