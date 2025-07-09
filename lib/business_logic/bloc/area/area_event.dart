part of 'area_bloc.dart';

abstract class AreaEvent extends Equatable {
  const AreaEvent();

  @override
  List<Object> get props => [];
}

class GetAreaEvent extends AreaEvent {
  final int cityId;
  final String searchKeyword;
  final bool isAddArea;

  const GetAreaEvent(
      {required this.cityId,
      required this.isAddArea,
      required this.searchKeyword});

  @override
  List<Object> get props => [cityId, searchKeyword, isAddArea];
}

class ClearAreaEvent extends AreaEvent {
  const ClearAreaEvent();

  @override
  List<Object> get props => [];
}
