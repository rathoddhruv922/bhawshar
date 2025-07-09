import 'package:bhawsar_chemical/src/screens/drawer/widget/feedback_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/bloc/feedback/feedback_bloc.dart';
import '../../../constants/app_const.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../router/route_list.dart';
import '../../widgets/app_204_widget.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_connection_widget.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_text.dart';
import '../common/common_reload_widget.dart';
import 'dart:math' as math;

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<FeedbackBloc>()
      ..add(const ClearFeedbackEvent())
      ..add(const GetFeedbacksEvent(currentPage: 1, recordPerPage: 20));

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.my_feedback,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: green,
        heroTag: "${math.Random().nextDouble()}",
        onPressed: () {
          navigationKey.currentState
              ?.restorablePushNamed(RouteList.addFeedback);
        },
        icon: const Icon(
          Icons.add,
          color: white,
        ),
        label: AppText(
          localization.feedback_add,
          color: white,
        ),
      ),
      body: SafeArea(
        child: ConnectionStatus(
          isShowAnimation: true,
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: BlocConsumer<FeedbackBloc, FeedbackState>(
              listenWhen: (previous, current) {
                if ((previous.status == FeedbackStatus.updating ||
                        previous.status == FeedbackStatus.adding) &&
                    current.status == FeedbackStatus.load) {
                  return false;
                }
                return true;
              },
              listener: (context, state) async {
                if (state.status == FeedbackStatus.added) {
                  context.read<FeedbackBloc>().add(
                        const GetFeedbacksEvent(
                            currentPage: 1, recordPerPage: 20),
                      );
                }
                if (state.status == FeedbackStatus.loading ||
                    state.status == FeedbackStatus.deleting ||
                    state.status == FeedbackStatus.closing) {
                  showAnimatedDialog(
                      navigationKey.currentContext!, const AppDialogLoader());
                }
                if (state.status == FeedbackStatus.deleted ||
                    state.status == FeedbackStatus.closed ||
                    state.status == FeedbackStatus.failure) {
                  Navigator.of(context).pop();
                  mySnackbar(state.msg.toString(),
                      isError: state.status == FeedbackStatus.failure
                          ? true
                          : false);
                  await Future.delayed(const Duration(seconds: 1));
                }
                if (state.status == FeedbackStatus.loaded) {
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (previous, current) {
                if (previous.status == FeedbackStatus.adding ||
                    previous.status == FeedbackStatus.updating) {
                  return false;
                } else if (current.status == FeedbackStatus.deleted ||
                    current.status == FeedbackStatus.loaded ||
                    current.status == FeedbackStatus.closed ||
                    current.status == FeedbackStatus.initial ||
                    (current.res == null &&
                        current.status == FeedbackStatus.failure)) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state.status == FeedbackStatus.initial) {
                  return Center(child: AppText(state.msg.toString()));
                }
                if (state.res == null &&
                    state.status == FeedbackStatus.failure) {
                  return CommonReloadWidget(
                      message: state.msg,
                      reload: state.msg.toString() == localization.network_error
                          ? (context.read<FeedbackBloc>()
                            ..add(const ClearFeedbackEvent())
                            ..add(const GetFeedbacksEvent(
                                currentPage: 1, recordPerPage: 20)))
                          : null);
                }
                if (state.status == FeedbackStatus.loaded ||
                    state.status == FeedbackStatus.deleted ||
                    state.status == FeedbackStatus.closed) {
                  return state.res.items?.length == 0
                      ? const Center(
                          child: NoDataFoundWidget(),
                        )
                      : FeedbackListWidget(
                          hasReachedMax: state.hasReachedMax,
                          feedbackList: state.res);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
