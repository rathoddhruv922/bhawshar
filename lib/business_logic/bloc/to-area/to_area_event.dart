part of 'to_area_bloc.dart';

abstract class ToAreaEvent extends Equatable {
  const ToAreaEvent();

  @override
  List<Object?> get props => [];
}

class GetToAreaListEvent extends ToAreaEvent {
  final int? cityId;
  final String searchKeyword;

  const GetToAreaListEvent({this.cityId, required this.searchKeyword});

  @override
  List<Object?> get props => [cityId, searchKeyword];
}

class ClearToAreaEvent extends ToAreaEvent {
  const ClearToAreaEvent();

  @override
  List<Object> get props => [];
}
