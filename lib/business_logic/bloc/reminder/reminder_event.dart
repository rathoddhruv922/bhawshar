part of 'reminder_bloc.dart';

class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

class DeleteReminderEvent extends ReminderEvent {
  final int? reminderId, itemIndex;
  final String type;

  const DeleteReminderEvent(
      {required this.reminderId, required this.type, required this.itemIndex});

  @override
  List<Object?> get props => [reminderId, itemIndex, type];
}

class ChangeReminderStatusEvent extends ReminderEvent {
  final int? reminderId, itemIndex, complete;
  final String type;

  const ChangeReminderStatusEvent(
      {required this.reminderId,
      required this.itemIndex,
      required this.type,
      required this.complete});

  @override
  List<Object?> get props => [reminderId, itemIndex, complete, type];
}

class GetRemindersEvent extends ReminderEvent {
  final int currentPage, recordPerPage;
  const GetRemindersEvent(
      {required this.currentPage, required this.recordPerPage});

  @override
  List<Object> get props => [currentPage, recordPerPage];
}

class GetReminderEvent extends ReminderEvent {
  final int id;

  const GetReminderEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddReminderEvent extends ReminderEvent {
  final Map<String, dynamic> formData, medicalInfo;
  final String reqType;

  const AddReminderEvent(
      {required this.formData,
      required this.medicalInfo,
      required this.reqType});

  @override
  List<Object> get props => [formData, medicalInfo, reqType];
}

class ClearReminderEvent extends ReminderEvent {
  const ClearReminderEvent();

  @override
  List<Object> get props => [];
}
