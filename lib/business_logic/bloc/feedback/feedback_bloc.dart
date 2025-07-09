import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/feedbacks_model/feedbacks_model.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../data/models/feedback_model/feedback_model.dart';
import '../../../data/repositories/feedback_repository.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository feedbackRepository;
  FeedbackBloc(this.feedbackRepository) : super(const FeedbackState()) {
    on<ClearFeedbackEvent>(_onClearFeedback);
    on<GetFeedbacksEvent>(_onGetFeedbacks,
        transformer: throttleDroppable(throttleDuration));
    on<GetFeedbackEvent>(_onGetFeedback,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteFeedbackEvent>(_onDeleteFeedback,
        transformer: throttleSequentials(throttleDuration));
    on<AddFeedbackEvent>(_onAddFeedback,
        transformer: throttleSequentials(throttleDuration));
    on<ChangeFeedbackStatusEvent>(_onCloseFeedback,
        transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onClearFeedback(
      ClearFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(
        status: FeedbackStatus.initial, msg: localization.loading));
  }

  Future<void> _onGetFeedback(
      GetFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(status: FeedbackStatus.loading));
    try {
      ApiResult<FeedbackModel> apiResult =
          await feedbackRepository.getFeedback(event.id);
      apiResult.when(success: (FeedbackModel data) {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: FeedbackStatus.load,
          ),
        );
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          status: FeedbackStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: FeedbackStatus.failure,
      ));
    }
  }

  Future<void> _onGetFeedbacks(
      GetFeedbacksEvent event, Emitter<FeedbackState> emit) async {
    if (state.hasReachedMax &&
        event.currentPage != 1 &&
        state.status != FeedbackStatus.updated &&
        state.status != FeedbackStatus.deleted &&
        state.status != FeedbackStatus.added) return;
    emit(state.copyWith(status: FeedbackStatus.loading));
    try {
      ApiResult<FeedbacksModel> apiResult = await feedbackRepository
          .getFeedbacks(event.currentPage, event.recordPerPage);
      apiResult.when(success: (FeedbacksModel data) async {
        updateFeedbackCount(data.openFeedback ?? 0);
        FeedbacksModel? feedbackList;
        if (state.res != null &&
            event.currentPage <= data.meta!.lastPage! &&
            event.currentPage != 1) {
          feedbackList = state.res;
          feedbackList?.meta = data.meta;
          feedbackList?.items?.addAll(data.items!);
          feedbackList?.items?.unique();
        } else {
          feedbackList = data;
          feedbackList.items?.unique();
        }
        emit(
          state.copyWith(
            res: feedbackList,
            msg: data.message,
            status: FeedbackStatus.loaded,
            hasReachedMax:
                event.currentPage == data.meta!.lastPage ? true : false,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          status: FeedbackStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: FeedbackStatus.failure,
      ));
    }
  }

  Future<void> _onAddFeedback(
      AddFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(
      status: event.reqType == 'post'
          ? FeedbackStatus.adding
          : FeedbackStatus.updating,
    ));

    try {
      ApiResult<Response> apiResult = await feedbackRepository.addFeedback(
        event.formData,
        reqType: event.reqType,
      );

      await apiResult.when(success: (Response data) async {
        updateFeedbackCount(data.data['open_feedback'] ?? 0);
        emit(
          state.copyWith(
            msg: data.data['message'],
            status: event.reqType == 'post'
                ? FeedbackStatus.added
                : FeedbackStatus.updated,
            hasReachedMax: false,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          // res: event.reqType == 'post' ? 'Error!' : state.res,
          status: FeedbackStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: FeedbackStatus.failure,
      ));
    }
  }

  Future<void> _onDeleteFeedback(
      DeleteFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(
      status: FeedbackStatus.deleting,
    ));
    try {
      ApiResult<Response> apiResult = await feedbackRepository.deleteFeedback(
          event.feedbackId, event.itemIndex);
      apiResult.when(success: (Response data) async {
        FeedbacksModel feedbackList = state.res;
        feedbackList.items?.removeAt(event.itemIndex!);
        emit(state.copyWith(
          res: feedbackList,
          msg: data.data['message'],
          status: FeedbackStatus.deleted,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: FeedbackStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: FeedbackStatus.failure,
      ));
    }
  }

  Future<void> _onCloseFeedback(
      ChangeFeedbackStatusEvent event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(
      status: FeedbackStatus.closing,
      res: state.res,
    ));
    try {
      ApiResult<Response> apiResult = await feedbackRepository.closeFeedback(
          event.feedbackId, event.itemIndex, event.status);
      apiResult.when(success: (Response data) async {
        FeedbacksModel feedbackList = state.res;
        feedbackList.items?.elementAt(event.itemIndex!).status =
            data.data['feedback']['status'];
        emit(state.copyWith(
          res: feedbackList,
          msg: data.data['message'],
          status: FeedbackStatus.closed,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: FeedbackStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: FeedbackStatus.failure,
      ));
    }
  }
}
