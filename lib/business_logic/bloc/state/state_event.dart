part of 'state_bloc.dart';

abstract class StateEvent extends Equatable {
  const StateEvent();

  @override
  List<Object> get props => [];
}

class GetStateEvent extends StateEvent {
  final String searchKeyword;

  final bool isAddState;
  const GetStateEvent({required this.searchKeyword, required this.isAddState});

  @override
  List<Object> get props => [searchKeyword, isAddState];
}

class ClearStateEvent extends StateEvent {
  const ClearStateEvent();

  @override
  List<Object> get props => [];
}
