import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/area_model/area_model.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/app_helper.dart';

part 'from_area_event.dart';
part 'from_area_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class FromAreaBloc extends Bloc<FromAreaEvent, FromAreaState> {
  final AddressRepository addressRepository;
  FromAreaBloc(this.addressRepository) : super(const FromAreaState()) {
    on<GetFromAreaListEvent>(_onGetFromAreas,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearFromAreaEvent>(_onClearFromAreas,
        transformer: throttleSequentials(throttleDuration));
  }
  Future<void> _onGetFromAreas(
      GetFromAreaListEvent event, Emitter<FromAreaState> emit) async {
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

  Future<void> _onClearFromAreas(
      ClearFromAreaEvent event, Emitter<FromAreaState> emit) async {
    emit(state.copyWith(
      status: AreaStatus.initial,
    ));
  }
}
