import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/area_model/area_model.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/app_helper.dart';

part 'area_event.dart';
part 'area_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final AddressRepository addressRepository;
  AreaBloc(this.addressRepository) : super(const AreaState()) {
    on<GetAreaEvent>(_onGetAreas,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearAreaEvent>(_onClearAreas,
        transformer: throttleSequentials(throttleDuration));
  }
  Future<void> _onGetAreas(GetAreaEvent event, Emitter<AreaState> emit) async {
    emit(state.copyWith(
      status: AreaStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<AreaModel> apiResult = await addressRepository.getAreaDetail(
          event.cityId, event.searchKeyword, event.isAddArea);
      apiResult.when(success: (AreaModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: AreaStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: AreaStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: AreaStatus.failure,
      ));
    }
  }

  Future<void> _onClearAreas(
      ClearAreaEvent event, Emitter<AreaState> emit) async {
    emit(state.copyWith(
      status: AreaStatus.initial,
    ));
  }
}
