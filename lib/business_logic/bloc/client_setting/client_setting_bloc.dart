import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/client_setting_model/client_setting_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../data/repositories/medical_repository.dart';
import '../../../helper/app_helper.dart';

part 'client_setting_event.dart';
part 'client_setting_state.dart';

class ClientSettingBloc extends Bloc<ClientSettingEvent, ClientSettingState> {
  final MedicalRepository medicalRepository;
  ClientSettingBloc(this.medicalRepository)
      : super(const ClientSettingState()) {
    on<GetClientSettingEvent>(_onGetClientSetting,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearSettingEvent>(_onClearSetting);
  }
  Future<void> _onGetClientSetting(
      GetClientSettingEvent event, Emitter<ClientSettingState> emit) async {
    emit(state.copyWith(
      status: ClientSettingStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<ClientSettingModel> apiResult =
          await medicalRepository.getClientSettings();
      apiResult.when(success: (ClientSettingModel data) async {
        updateFeedbackCount(data.settings?.openFeedback ?? 0);
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: ClientSettingStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: ClientSettingStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: ClientSettingStatus.failure,
      ));
    }
  }

  Future<void> _onClearSetting(
      ClearSettingEvent event, Emitter<ClientSettingState> emit) async {
    emit(state.copyWith(
      status: ClientSettingStatus.initial,
    ));
  }
}
