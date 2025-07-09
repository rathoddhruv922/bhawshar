import 'package:bhawsar_chemical/src/screens/reminder/widget/reminder_info_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/reminder/reminder_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../generated/l10n.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

enum ReminderMenu { edit, delete, complete }

class ReminderCard extends StatelessWidget {
  const ReminderCard(
      {Key? key,
      required this.reminder,
      required this.index,
      required this.expired,
      required this.type})
      : super(key: key);

  final dynamic reminder;
  final int index;
  final String type;
  final bool expired;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      color: transparent,
      margin: const EdgeInsets.symmetric(vertical: paddingExtraSmall),
      elevation: reminder.complete == 1 ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        tileColor: reminder.complete == 1 ? grey.withOpacity(0.4) : offWhite,
        dense: true,
        contentPadding: const EdgeInsets.all(paddingSmall),
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () {
          showReminder(context, reminder);
        },
        title: Row(
          children: [
            Container(
              width: 30.sp,
              height: 30.sp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: greyLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                httpHeaders: {"Referer": "https://mobile.bhawsarayurveda.in/"},
                imageUrl: "${reminder.clientImage}",
                imageBuilder: (context, imageProvider) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const AppLoader(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: primary,
                ),
              ),
            ),
            const AppSpacerWidth(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppText(
                            '${reminder.client}',
                            fontWeight: FontWeight.bold,
                            maxLine: 1,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            reminder.reminderType.toString().toLowerCase() ==
                                    'at shop'
                                ? Icons.storefront
                                : Icons.call_outlined,
                            size: 18,
                            color: primary,
                          ),
                        ),
                        PopupMenuButton(
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          onSelected: (ReminderMenu item) async {
                            if (item == ReminderMenu.edit) {
                              if (!expired) {
                                (reminder.complete == 1)
                                    ? null
                                    : navigationKey.currentState
                                        ?.pushNamed(
                                        RouteList.updateReminder,
                                        arguments: reminder.id,
                                      )
                                        .then((value) {
                                        if (value == true) {
                                          context.read<ReminderBloc>()
                                            ..add(const ClearReminderEvent())
                                            ..add(const GetRemindersEvent(
                                                currentPage: 1,
                                                recordPerPage: 20));
                                        }
                                      });
                              }
                            } else if (item == ReminderMenu.delete) {
                              try {
                                appAlertDialog(
                                  context,
                                  AppText(
                                    S.of(context).confirmation,
                                    textAlign: TextAlign.center,
                                    fontSize: 17,
                                  ),
                                  () {
                                    Navigator.of(context).pop();
                                    context.read<ReminderBloc>().add(
                                          DeleteReminderEvent(
                                              reminderId: reminder.id!,
                                              itemIndex: index,
                                              type: type),
                                        );
                                  },
                                  () => Navigator.of(context).pop(),
                                );
                              } catch (e) {
                                showCatchedError(e);
                                rethrow;
                              }
                            } else {
                              try {
                                ((expired ||
                                            reminder.complete == 1 ||
                                            type == 'tomorrow') &&
                                        type != 'today')
                                    ? null
                                    : context.read<ReminderBloc>().add(
                                          ChangeReminderStatusEvent(
                                              reminderId: reminder.id!,
                                              itemIndex: index,
                                              type: type,
                                              complete: reminder.complete),
                                        );
                              } catch (e) {
                                showCatchedError(e);
                                rethrow;
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<ReminderMenu>>[
                            PopupMenuItem(
                              value: ReminderMenu.edit,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.edit,
                                  color: reminder.complete == 1 || expired
                                      ? grey
                                      : textBlack,
                                ),
                                label: AppText(
                                  localization.edit,
                                  color: reminder.complete == 1 || expired
                                      ? grey
                                      : textBlack,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: ReminderMenu.delete,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.delete,
                                  color: textBlack,
                                ),
                                label: AppText(
                                  localization.delete,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: ReminderMenu.complete,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  reminder.complete == 1
                                      ? Icons.cancel_outlined
                                      : Icons.check_circle,
                                  color: ((expired ||
                                              reminder.complete == 1 ||
                                              type == 'tomorrow') &&
                                          type != 'today')
                                      ? grey
                                      : textBlack,
                                ),
                                label: AppText(
                                  reminder.complete == 1
                                      ? localization.incomplete
                                      : localization.complete,
                                  color: ((expired ||
                                              reminder.complete == 1 ||
                                              type == 'tomorrow') &&
                                          type != 'today')
                                      ? grey
                                      : textBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppText(
                          '${reminder.message}',
                          maxLine: 1,
                        ),
                      ),
                      Icon(
                        Icons.timer_outlined,
                        size: 15.sp,
                      ),
                      const AppSpacerWidth(width: 5),
                      AppText(
                        '${getDateToTime(reminder.dateTime)}',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
