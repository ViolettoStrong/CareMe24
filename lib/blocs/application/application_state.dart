abstract class ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationCompleted extends ApplicationState {
  final bool isAuthorized;
  final bool error;

  ApplicationCompleted({
    required this.isAuthorized,
    required this.error,
  });
}
