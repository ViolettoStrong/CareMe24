abstract class ChangeBalanceState {
  @override
  List<Object> get props => [];
}

class ChangeBalanceInitial extends ChangeBalanceState {}

class ChangeBalanceLoading extends ChangeBalanceState {}

class ChangeBalanceSuccess extends ChangeBalanceState {
  final String message;

  ChangeBalanceSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ChangeBalanceError extends ChangeBalanceState {
  final String error;

  ChangeBalanceError(this.error);

  @override
  List<Object> get props => [error];
}
