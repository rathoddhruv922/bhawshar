import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/city_model/city_model.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final AddressRepository addressRepository;
  CityBloc(this.addressRepository) : super(const CityState()) {
    on<GetCityEvent>(_onGetCities,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearCityEvent>(_onClearCities);
  }
  Future<void> _onGetCities(GetCityEvent event, Emitter<CityState> emit) async {
    emit(state.copyWith(
      status: CityStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<CityModel> apiResult = await addressRepository.getCityDetail(
          event.stateId, event.searchKeyword, event.isAddCity);
      apiResult.when(success: (CityModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: CityStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: CityStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: CityStatus.failure,
      ));
    }
  }

  Future<void> _onClearCities(
      ClearCityEvent event, Emitter<CityState> emit) async {
    emit(state.copyWith(
      status: CityStatus.initial,
    ));
  }
}
