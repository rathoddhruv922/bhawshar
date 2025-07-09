import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/data/repositories/report_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'report_event.dart';
part 'report_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc(this.reportRepository) : super(const ReportState()) {
    on<GetReportEvent>(_onGetReport, transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<ClearReportEvent>(_onClearReport, transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onGetReport(GetReportEvent event, Emitter<ReportState> emit) async {
    emit(state.copyWith(
      status: ReportStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<MrDailyReportModel> apiResult = await reportRepository.getReport(event.date);
      apiResult.when(success: (MrDailyReportModel data) async {
        emit(
          state.copyWith(
            res: data,
            status: ReportStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: ReportStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: ReportStatus.failure,
      ));
    }
  }

  Future<void> _onClearReport(ClearReportEvent event, Emitter<ReportState> emit) async {
    emit(state.copyWith(
      status: ReportStatus.initial,
    ));
  }
}
