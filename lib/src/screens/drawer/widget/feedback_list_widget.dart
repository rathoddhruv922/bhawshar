import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/bloc/feedback/feedback_bloc.dart';
import '../../../../data/models/feedbacks_model/feedbacks_model.dart';
import '../../../../main.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_text.dart';
import 'feedback_card_widget.dart';

class FeedbackListWidget extends StatefulWidget {
  final FeedbacksModel feedbackList;
  final bool hasReachedMax;

  const FeedbackListWidget(
      {Key? key, required this.feedbackList, required this.hasReachedMax})
      : super(key: key);

  @override
  State<FeedbackListWidget> createState() => _FeedbackListWidgetState();
}

class _FeedbackListWidgetState extends State<FeedbackListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FeedbackBloc>().add(GetFeedbacksEvent(
          currentPage: widget.feedbackList.meta!.currentPage! + 1,
          recordPerPage: 20));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.90);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.feedbackList.items!.length + 1,
      itemBuilder: (buildContext, index) {
        if (index >= widget.feedbackList.items!.length) {
          return widget.hasReachedMax
              ? Center(
                  child: AppText(localization.no_more_data),
                )
              : const AppLoader();
        } else {
          return FeedbackCard(
              feedback: widget.feedbackList.items![index], index: index);
        }
      },
    );
  }
}
