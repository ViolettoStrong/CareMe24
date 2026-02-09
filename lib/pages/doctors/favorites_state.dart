import 'package:careme24/models/favorite_model.dart';

abstract class FavoriteState {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoadedPost extends FavoriteState {
  final Set<String> favoriteProductIds;

  const FavoriteLoadedPost(this.favoriteProductIds);

  @override
  List<Object> get props => [favoriteProductIds];
}

class FavoriteLoadedDelet extends FavoriteState {
  final Set<String> favoriteProductIds;

  const FavoriteLoadedDelet(this.favoriteProductIds);

  @override
  List<Object> get props => [favoriteProductIds];
}

class FavoriteLoadedGet extends FavoriteState {
  final List<ServiceModel2> serviceList;
  final String medCardId;
  FavoriteLoadedGet({required this.serviceList, required this.medCardId});
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}
