part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class GetReportEvent extends ReportEvent {
  final DateTime date;

  const GetReportEvent({required this.date});

  @override
  List<Object> get props => [date];
}

class ClearReportEvent extends ReportEvent {
  const ClearReportEvent();

  @override
  List<Object> get props => [];
}
