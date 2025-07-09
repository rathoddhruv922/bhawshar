part of 'medical_bloc.dart';

class MedicalState extends Equatable {
  const MedicalState({this.status = MedicalStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final MedicalStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  MedicalState copyWith({dynamic res, String? msg, MedicalStatus? status}) {
    return MedicalState(
      res: status == MedicalStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
    );
  }
}
