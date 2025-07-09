part of 'report_bloc.dart';

class ReportState extends Equatable {
  const ReportState({this.status = ReportStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final ReportStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  ReportState copyWith({dynamic res, String? msg, ReportStatus? status}) {
    return ReportState(res: res, msg: msg, status: status ?? this.status);
  }
}
