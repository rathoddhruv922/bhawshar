import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../constants/app_const.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

class CommentBubbleWidget extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final String comment;
  final String? replyComment;
  final bool commentedByMe;
  final Color? textColor;
  const CommentBubbleWidget(
      {super.key,
      required this.comment,
      this.replyComment,
      required this.margin,
      required this.commentedByMe,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(paddingSmall),
      margin: margin,
      constraints: BoxConstraints.loose(Size(80.w, double.infinity)),
      decoration: BoxDecoration(
        color: commentedByMe ? secondary : greyLight,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(10.0),
          topLeft: const Radius.circular(10.0),
          bottomRight: Radius.circular(commentedByMe ? 0.0 : 10.0),
          bottomLeft: Radius.circular(commentedByMe ? 10.0 : 0.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          replyComment != null
              ? Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: paddingSmall),
                    constraints:
                        BoxConstraints.loose(Size(80.w, double.infinity)),
                    decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                        ),
                        const AppSpacerWidth(width: 5),
                        Flexible(
                          child: AppText(
                            replyComment ?? 'NA',
                            color: textColor,
                            maxLine: 1,
                          ),
                        ),
                        const AppSpacerWidth(width: 5),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          AppText(
            comment,
            color: textColor,
            maxLine: 200,
          ),
        ],
      ),
    );
  }
}
