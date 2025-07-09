import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/repositories/comment_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';

part 'comment_event.dart';
part 'comment_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  CommentBloc(this.commentRepository) : super(const CommentState()) {
    on<ClearCommentEvent>(_onClearComment,
        transformer: throttleSequentials(throttleDuration));
    on<AddCommentEvent>(_onAddComment,
        transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onClearComment(
      ClearCommentEvent event, Emitter<CommentState> emit) async {
    emit(state.copyWith(
        status: CommentStatus.initial, msg: localization.loading));
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<CommentState> emit) async {
    emit(state.copyWith(
      status: event.reqType == 'post'
          ? CommentStatus.adding
          : CommentStatus.updating,
    ));

    try {
      ApiResult<Response> apiResult = await commentRepository.addComment(
        event.formData,
        reqType: event.reqType,
      );

      await apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            res: data.data['comment'],
            msg: data.data['message'],
            status: event.reqType == 'post'
                ? CommentStatus.added
                : CommentStatus.updated,
            hasReachedMax: false,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          // res: event.reqType == 'post' ? 'Error!' : state.res,
          status: CommentStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: CommentStatus.failure,
      ));
    }
  }
}
