import 'package:flutter/material.dart';

import 'package:bhawsar_chemical/data/models/feedback_model/comment.dart'
    as feedback_comment;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utils/app_colors.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import 'comment_attachments_widget.dart';
import 'comment_bubble_widget.dart';

import 'package:intl/intl.dart' as intl;

class CommentMessageWidget extends StatelessWidget {
  final int index, indexOfEditComment;

  final feedback_comment.Comment? comment;
  final bool commentedByMe, sended;

  const CommentMessageWidget(
      {super.key,
      required this.index,
      required this.indexOfEditComment,
      required this.comment,
      required this.sended,
      required this.commentedByMe});

  @override
  Widget build(BuildContext context) {
    if (comment!.id != null) {
      return Column(
        crossAxisAlignment:
            commentedByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (comment!.message != null && comment!.message != "")
            Row(
              mainAxisAlignment: commentedByMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                (sended &&
                        (index == indexOfEditComment || index == 0) &&
                        (comment?.attachments == null))
                    ? const AppLoader()
                    : const SizedBox.shrink(),
                sended ? const AppSpacerWidth() : const SizedBox.shrink(),
                Flexible(
                  child: CommentBubbleWidget(
                    comment: comment?.message ?? 'NA',
                    replyComment: comment?.commentMessage,
                    textColor: textBlack,
                    commentedByMe: commentedByMe ? true : false,
                    margin: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          (comment?.attachments != null && comment!.attachments!.isNotEmpty)
              ? Row(
                  mainAxisAlignment: commentedByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    (sended && (index == indexOfEditComment || index == 0))
                        ? const AppLoader()
                        : const SizedBox.shrink(),
                    sended ? const AppSpacerWidth() : const SizedBox.shrink(),
                    CommentAttachmentWidget(
                      attachments: comment!.attachments!,
                      commentedByMe: commentedByMe,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          Container(
            margin: EdgeInsets.only(
                right: commentedByMe ? 0 : 50.sp,
                left: commentedByMe ? 50.sp : 0.0,
                top: 6.sp,
                bottom: 6.sp),
            child: AppText(
              intl.DateFormat.yMEd('en_US')
                  .format(DateTime.parse((comment?.dateTime).toString())),
              textTheme: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontStyle: FontStyle.italic,
                    color: grey,
                    fontSize: 11,
                  ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
