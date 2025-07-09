part of 'feedback_bloc.dart';

class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class GetFeedbacksEvent extends FeedbackEvent {
  final int currentPage, recordPerPage;
  const GetFeedbacksEvent(
      {required this.currentPage, required this.recordPerPage});

  @override
  List<Object> get props => [currentPage, recordPerPage];
}

class GetFeedbackEvent extends FeedbackEvent {
  final int id;

  const GetFeedbackEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddFeedbackEvent extends FeedbackEvent {
  final Map<String, dynamic> formData;
  final String reqType;

  const AddFeedbackEvent({required this.formData, required this.reqType});

  @override
  List<Object> get props => [formData, reqType];
}

class DeleteFeedbackEvent extends FeedbackEvent {
  final int? feedbackId, itemIndex;

  const DeleteFeedbackEvent(
      {required this.feedbackId, required this.itemIndex});

  @override
  List<Object?> get props => [feedbackId, itemIndex];
}

class ChangeFeedbackStatusEvent extends FeedbackEvent {
  final int? feedbackId, itemIndex;
  final String status;

  const ChangeFeedbackStatusEvent(
      {required this.feedbackId,
      required this.itemIndex,
      required this.status});

  @override
  List<Object?> get props => [feedbackId, itemIndex, status];
}

class ClearFeedbackEvent extends FeedbackEvent {
  const ClearFeedbackEvent();

  @override
  List<Object> get props => [];
}
