import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/feedback/feedback_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../generated/l10n.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

import 'package:bhawsar_chemical/data/models/feedbacks_model/item.dart'
    as feedbacks;

enum FeedbackMenu { close, resolved }

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    Key? key,
    required this.feedback,
    required this.index,
  }) : super(key: key);

  final feedbacks.Item feedback;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      color: offWhite,
      margin: const EdgeInsets.only(bottom: paddingDefault),
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        tileColor: transparent,
        dense: true,
        contentPadding: const EdgeInsets.all(paddingSmall),
        minVerticalPadding: paddingExtraSmall,
        minLeadingWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () async {
          await navigationKey.currentState
              ?.pushNamed(RouteList.replyFeedback, arguments: feedback.id)
              .then((value) {
            if (value == true) {
              context.read<FeedbackBloc>()
                ..add(const ClearFeedbackEvent())
                ..add(
                    const GetFeedbacksEvent(currentPage: 1, recordPerPage: 20));
            }
          });
        },
        title: Row(
          children: [
            const AppSpacerWidth(),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              (feedback.type ?? 'NA').toUpperCase(),
                              fontWeight: FontWeight.bold,
                              maxLine: 1,
                            ),
                          ),
                        ),
                        CommonContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          shadowColor: greyLight,
                          color: feedback.status?.toLowerCase() == 'closed'
                              ? grey
                              : feedback.status?.toLowerCase() == 'resolved'
                                  ? primary
                                  : feedback.status?.toLowerCase() == 'pending'
                                      ? orange.withOpacity(0.8)
                                      : feedback.status?.toLowerCase() ==
                                              'disable comment'
                                          ? grey.withOpacity(0.5)
                                          : yellow.withOpacity(0.5),
                          radius: 2,
                          child: AppText(
                            '${feedback.status}',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: feedback.status?.toLowerCase() == 'resolved'
                                ? offWhite
                                : textBlack,
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: primary,
                          ),
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          onSelected: (FeedbackMenu item) async {
                            if (item == FeedbackMenu.close) {
                              try {
                                feedback.status?.toLowerCase() != 'closed'
                                    ? appAlertDialog(
                                        context,
                                        AppText(
                                          S.of(context).confirmation,
                                          textAlign: TextAlign.center,
                                          fontSize: 17,
                                        ),
                                        () {
                                          Navigator.of(context).pop();
                                          context.read<FeedbackBloc>().add(
                                                ChangeFeedbackStatusEvent(
                                                    status: "closed",
                                                    feedbackId: feedback.id!,
                                                    itemIndex: index),
                                              );
                                        },
                                        () => Navigator.of(context).pop(),
                                      )
                                    : null;
                              } catch (e) {
                                showCatchedError(e);
                              }
                            } else {
                              try {
                                (feedback.status?.toLowerCase() != 'closed' &&
                                        feedback.status?.toLowerCase() !=
                                            'resolved')
                                    ? appAlertDialog(
                                        context,
                                        AppText(
                                          S.of(context).confirmation,
                                          textAlign: TextAlign.center,
                                          fontSize: 17,
                                        ),
                                        () {
                                          Navigator.of(context).pop();
                                          context.read<FeedbackBloc>().add(
                                                ChangeFeedbackStatusEvent(
                                                    status: "resolved",
                                                    feedbackId: feedback.id!,
                                                    itemIndex: index),
                                              );
                                        },
                                        () => Navigator.of(context).pop(),
                                      )
                                    : null;
                              } catch (e) {
                                showCatchedError(e);
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<FeedbackMenu>>[
                            PopupMenuItem(
                              value: FeedbackMenu.close,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.cancel,
                                  color:
                                      feedback.status?.toLowerCase() == 'closed'
                                          ? grey
                                          : textBlack,
                                ),
                                label: AppText(localization.close,
                                    color: feedback.status?.toLowerCase() ==
                                            'closed'
                                        ? grey
                                        : textBlack),
                              ),
                            ),
                            PopupMenuItem(
                              value: FeedbackMenu.resolved,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.check_circle,
                                  color: (feedback.status?.toLowerCase() !=
                                              'closed' &&
                                          feedback.status?.toLowerCase() !=
                                              'resolved')
                                      ? textBlack
                                      : grey,
                                ),
                                label: AppText(
                                  localization.resolved,
                                  color: (feedback.status?.toLowerCase() !=
                                              'closed' &&
                                          feedback.status?.toLowerCase() !=
                                              'resolved')
                                      ? textBlack
                                      : grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const AppSpacerHeight(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonContainer(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 0.5), // changes position of shadow
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.message_outlined,
                          size: 15.sp,
                          color: primary,
                        ),
                      ),
                      const AppSpacerWidth(),
                      Expanded(
                        child: AppText(
                          '${feedback.description}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
