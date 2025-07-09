part of 'from_area_bloc.dart';

abstract class FromAreaEvent extends Equatable {
  const FromAreaEvent();

  @override
  List<Object?> get props => [];
}

class GetFromAreaListEvent extends FromAreaEvent {
  final int? cityId;
  final String searchKeyword;

  const GetFromAreaListEvent({this.cityId, required this.searchKeyword});

  @override
  List<Object?> get props => [cityId, searchKeyword];
}

class ClearFromAreaEvent extends FromAreaEvent {
  const ClearFromAreaEvent();

  @override
  List<Object> get props => [];
}
