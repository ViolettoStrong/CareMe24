import 'package:careme24/models/user_model.dart';

abstract class SearchState {}

class SearchInit extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<UserModel> users;

  SearchLoaded({
    required this.users,
  });
}
