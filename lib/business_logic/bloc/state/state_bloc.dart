import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/state_model/state_model.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'state_event.dart';
part 'state_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class StateBloc extends Bloc<StateEvent, StateState> {
  final AddressRepository addressRepository;
  StateBloc(this.addressRepository) : super(const StateState()) {
    on<GetStateEvent>(_onGetStates,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearStateEvent>(_onClearStates,
        transformer: throttleSequentials(throttleDuration));
  }
  Future<void> _onGetStates(
      GetStateEvent event, Emitter<StateState> emit) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<StateModel> apiResult = await addressRepository.getStateDetail(
          event.searchKeyword, event.isAddState);
      apiResult.when(success: (StateModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: StateStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: StateStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: StateStatus.failure,
      ));
    }
  }

  Future<void> _onClearStates(
      ClearStateEvent event, Emitter<StateState> emit) async {
    emit(state.copyWith(
      status: StateStatus.initial,
    ));
  }
}
