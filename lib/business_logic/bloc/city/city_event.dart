part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class GetCityEvent extends CityEvent {
  final int stateId;
  final String searchKeyword;
  final bool isAddCity;

  const GetCityEvent(
      {required this.stateId,
      required this.isAddCity,
      required this.searchKeyword});

  @override
  List<Object> get props => [stateId, searchKeyword, isAddCity];
}

class ClearCityEvent extends CityEvent {
  const ClearCityEvent();

  @override
  List<Object> get props => [];
}
