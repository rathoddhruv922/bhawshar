import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/area_model/area_model.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/app_helper.dart';

part 'to_area_event.dart';
part 'to_area_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ToAreaBloc extends Bloc<ToAreaEvent, ToAreaState> {
  final AddressRepository addressRepository;
  ToAreaBloc(this.addressRepository) : super(const ToAreaState()) {
    on<GetToAreaListEvent>(_onGetToAreas,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearToAreaEvent>(_onClearToAreas,
        transformer: throttleSequentials(throttleDuration));
  }
  Future<void> _onGetToAreas(
      GetToAreaListEvent event, Emitter<ToAreaState> emit) async {
    emit(state.copyWith(
      status: AreaStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<AreaModel> apiResult = await addressRepository.getGlobalAreas(
          event.cityId, event.searchKeyword);
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

  Future<void> _onClearToAreas(
      ClearToAreaEvent event, Emitter<ToAreaState> emit) async {
    emit(state.copyWith(
      status: AreaStatus.initial,
    ));
  }
}
