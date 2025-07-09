import 'package:flutter/material.dart';

import '../../../constants/app_const.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_text.dart';

class ReminderNotesWidget extends StatelessWidget {
  const ReminderNotesWidget({
    Key? key,
    required this.reminderDays,
    required this.context,
    this.isTimeValid = true,
    required this.selectedTime,
  }) : super(key: key);

  final String? reminderDays;
  final bool isTimeValid;
  final BuildContext context;
  final TimeOfDay selectedTime;

  @override
  Widget build(BuildContext context) {
    return !isTimeValid
        ? Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: AppText(
              localization.time_invalid,
              color: errorRed,
              fontWeight: FontWeight.bold,
            ),
          )
        : Visibility(
            visible: (reminderDays != null) ? true : false,
            child: Container(
              margin: const EdgeInsets.all(paddingSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    '$reminderDays',
                    color: orange,
                    fontWeight: FontWeight.bold,
                  ),
                  const AppText(
                    '\tat',
                  ),
                  AppText(
                    '\t${getTimeToHMSAM(context, selectedTime)}',
                    color: orange,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          );
  }
}
