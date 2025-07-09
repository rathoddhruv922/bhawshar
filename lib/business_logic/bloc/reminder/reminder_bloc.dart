import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/reminder_model/reminder_model.dart';
import 'package:bhawsar_chemical/data/models/reminders_model/reminders_model.dart';
import 'package:bhawsar_chemical/data/repositories/reminder_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository reminderRepository;

  ReminderBloc(this.reminderRepository) : super(const ReminderState()) {
    on<ClearReminderEvent>(_onClearReminder, transformer: throttleSequentials(throttleDuration));
    on<GetRemindersEvent>(_onGetReminders, transformer: throttleDroppable(throttleDuration));
    on<GetReminderEvent>(_onGetReminder, transformer: throttleSequentials(throttleDuration));
    on<DeleteReminderEvent>(_onDeleteReminder, transformer: throttleDroppable(throttleDuration));
    on<AddReminderEvent>(_onAddReminder, transformer: throttleSequentials(throttleDuration));
    on<ChangeReminderStatusEvent>(_onChangeReminderStatus);
  }

  Future<void> _onClearReminder(ClearReminderEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(status: ReminderStatus.initial, msg: localization.loading));
  }

  Future<void> _onGetReminders(GetRemindersEvent event, Emitter<ReminderState> emit) async {
    if (state.hasReachedMax &&
        event.currentPage != 1 &&
        state.status != ReminderStatus.updated &&
        state.status != ReminderStatus.deleted &&
        state.status != ReminderStatus.added) return;
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      ApiResult<RemindersModel> apiResult = await reminderRepository.getReminders(event.currentPage, event.recordPerPage);
      apiResult.when(success: (RemindersModel data) async {
        updateNotificationCount(data.pending ?? 0);
        updateFeedbackCount(data.openFeedback ?? 0);
        RemindersModel? remindersList;
        if (state.res != null && event.currentPage <= data.meta!.lastPage! && event.currentPage != 1) {
          remindersList = state.res;
          remindersList?.items?[0].past?.addAll(data.items![0].past!);
          remindersList?.meta = data.meta;
        } else {
          if (data.items![0].past!.isEmpty && data.items![0].tomorrow!.isEmpty && data.items![0].today!.isEmpty) {
            remindersList = state.res;
            remindersList?.meta = data.meta;
          } else {
            remindersList = data;
          }
          // remindersList.items?.unique();
        }

        emit(
          state.copyWith(
            res: remindersList,
            msg: data.message,
            hasReachedMax: event.currentPage == data.meta!.lastPage ? true : false,
            status: ReminderStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          status: ReminderStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ReminderStatus.failure,
      ));
    }
  }

  Future<void> _onGetReminder(GetReminderEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(
      status: ReminderStatus.loading,
    ));
    try {
      ApiResult<ReminderModel> apiResult = await reminderRepository.getReminder(event.id);
      apiResult.when(success: (ReminderModel data) {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: ReminderStatus.load,
          ),
        );
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          status: ReminderStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ReminderStatus.failure,
      ));
    }
  }

  Future<void> _onDeleteReminder(DeleteReminderEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(
      status: ReminderStatus.deleting,
    ));
    try {
      ApiResult<Response> apiResult = await reminderRepository.deleteReminder(event.reminderId, event.itemIndex);
      apiResult.when(success: (Response data) {
        RemindersModel reminderList = state.res;
        if (event.type == "today") {
          reminderList.items?[0].today?.removeAt(event.itemIndex!);
          updateNotificationCount(data.data['reminder']['pending']);
        } else if (event.type == "tomorrow") {
          reminderList.items?[0].tomorrow?.removeAt(event.itemIndex!);
        } else {
          reminderList.items?[0].past?.removeAt(event.itemIndex!);
        }

        emit(state.copyWith(
          res: reminderList,
          msg: data.data['message'],
          status: ReminderStatus.deleted,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          msg: DioExceptions.getErrorMSg(error),
          status: ReminderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ReminderStatus.failure,
      ));
    }
  }

  Future<void> _onChangeReminderStatus(ChangeReminderStatusEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(
      status: ReminderStatus.completing,
    ));
    try {
      ApiResult<Response> apiResult =
          await reminderRepository.changeReminderStatus(event.reminderId, event.itemIndex, event.complete);
      apiResult.when(success: (Response data) async {
        RemindersModel reminderList = state.res;
        if (event.type == "today") {
          reminderList.items?[0].today?.elementAt(event.itemIndex!).complete = int.parse(data.data['reminder']['complete']);

          updateNotificationCount(data.data['reminder']['pending']);
        } else if (event.type == "tomorrow") {
          reminderList.items?[0].tomorrow?.elementAt(event.itemIndex!).complete = int.parse(data.data['reminder']['complete']);
        } else {
          reminderList.items?[0].past?.elementAt(event.itemIndex!).complete = int.parse(data.data['reminder']['complete']);
        }

        emit(state.copyWith(
          res: reminderList,
          msg: data.data['message'],
          status: ReminderStatus.completed,
        ));
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          msg: DioExceptions.getErrorMSg(error),
          status: ReminderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ReminderStatus.failure,
      ));
    }
  }

  Future<void> _onAddReminder(AddReminderEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(
      status: event.reqType == 'post' ? ReminderStatus.adding : ReminderStatus.updating,
    ));

    try {
      ApiResult<Response> apiResult = await reminderRepository.addReminderDetail(
        event.formData,
        event.medicalInfo,
        reqType: event.reqType,
      );

      apiResult.when(success: (Response data) {
        emit(state.copyWith(
          msg: data.data['message'],
          status: event.reqType == 'post' ? ReminderStatus.added : ReminderStatus.updated,
        ));
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          // res: event.reqType == 'post' ? 'Error!' : state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: ReminderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ReminderStatus.failure,
      ));
    }
  }
}
