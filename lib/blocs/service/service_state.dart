import 'package:careme24/blocs/service/model_chat.dart';
import 'package:careme24/models/service_model.dart';

abstract class ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceFavoriteLoadedPost extends ServiceState {
  final Set<String> favoriteProductIds;

  ServiceFavoriteLoadedPost(this.favoriteProductIds);

  @override
  List<Object> get props => [favoriteProductIds];
}

class ServiceFavoriteLoadedDelet extends ServiceState {
  final Set<String> favoriteProductIds;

  ServiceFavoriteLoadedDelet(this.favoriteProductIds);

  @override
  List<Object> get props => [favoriteProductIds];
}

class ServiceChatGet extends ServiceState {
  final List<ChatRoom> chatMessage;

  ServiceChatGet(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class ServiceUsersGet extends ServiceState {
  final List<ChatRoom> chatMessage;

  ServiceUsersGet(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class ServiceLoaded extends ServiceState {
  final List<ServiceModel> serviceList;
  final String medCardId;
  ServiceLoaded({required this.serviceList, required this.medCardId});
}
