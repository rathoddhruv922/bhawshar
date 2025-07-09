import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/medical_model/medical_model.dart';
import 'package:bhawsar_chemical/data/repositories/medical_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'medical_event.dart';
part 'medical_state.dart';

class MedicalBloc extends Bloc<MedicalEvent, MedicalState> {
  final MedicalRepository medicalRepository;
  MedicalBloc(this.medicalRepository) : super(const MedicalState()) {
    on<AddMedicalEvent>(_onAddMedical);
    on<SearchMedicalEvent>(_onSearchMedical,
        transformer: throttleDroppable(const Duration(milliseconds: 700)));

    on<ClearMedicalEvent>(_onClearMedical);
  }

  Future<void> _onClearMedical(
      ClearMedicalEvent event, Emitter<MedicalState> emit) async {
    emit(state.copyWith(
      status: MedicalStatus.initial,
    ));
  }

  Future<void> _onSearchMedical(
      SearchMedicalEvent event, Emitter<MedicalState> emit) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      ApiResult<MedicalModel> apiResult = await medicalRepository
          .getMedicalDetail(event.searchKeyword, type: event.type);
      apiResult.when(success: (MedicalModel data) {
        updateFeedbackCount(data.openFeedback ?? 0);
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: MedicalStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          status: MedicalStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: MedicalStatus.failure,
      ));
    }
  }

  Future<void> _onAddMedical(
      AddMedicalEvent event, Emitter<MedicalState> emit) async {
    emit(state.copyWith(
      status: event.reqType == 'post'
          ? MedicalStatus.adding
          : MedicalStatus.updating,
    ));
    try {
      ApiResult<Response> apiResult = await medicalRepository.addMedicalDetail(
        event.formData,
        event.imgPath,
        reqType: event.reqType,
        clientId: event.clientId,
      );

      await apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            res: event.reqType == 'post' ? data : state.res,
            msg: data.data['message'],
            status: event.reqType == 'post'
                ? MedicalStatus.added
                : MedicalStatus.updated,
          ),
        );
      }, failure: (DioExceptions error) async {
        String errorMsg = DioExceptions.getErrorMSg(error);
        emit(state.copyWith(
          msg: errorMsg == ""
              ? DioExceptions.getErrorMessage(
                  const DioExceptions.internalServerError())
              : errorMsg,
          status: MedicalStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: MedicalStatus.failure,
      ));
    }
  }
}
