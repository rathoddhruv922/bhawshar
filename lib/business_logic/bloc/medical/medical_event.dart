part of 'medical_bloc.dart';

abstract class MedicalEvent extends Equatable {
  const MedicalEvent();

  @override
  List<Object?> get props => [];
}

class SearchMedicalEvent extends MedicalEvent {
  final String searchKeyword;
  final String? type;

  const SearchMedicalEvent({required this.searchKeyword, this.type});

  @override
  List<Object?> get props => [searchKeyword, type];
}

class AddMedicalEvent extends MedicalEvent {
  final Map<String, dynamic> formData;
  final String imgPath, reqType;
  final int clientId;

  const AddMedicalEvent(
      {required this.formData,
      required this.imgPath,
      required this.reqType,
      required this.clientId});

  @override
  List<Object> get props => [formData, imgPath, reqType, clientId];
}

class ClearMedicalEvent extends MedicalEvent {
  const ClearMedicalEvent();

  @override
  List<Object> get props => [];
}
