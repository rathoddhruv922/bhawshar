import 'package:flutter/material.dart';

import '../../../constants/app_const.dart';
import '../../../helper/app_helper.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';
import 'common_container_widget.dart';

class CommonTimePickerWidget extends StatelessWidget {
  const CommonTimePickerWidget(
      {super.key, required this.selectedTime, required this.onTimeChanged});

  final TimeOfDay selectedTime;
  final ValueChanged onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var pickTime = await showTimePicker(
          context: context,
          initialEntryMode: TimePickerEntryMode.dial,
          initialTime: selectedTime,
        );
        if (pickTime != null) {
          onTimeChanged(
              TimeOfDay(hour: pickTime.hour, minute: pickTime.minute));
        }
      },
      child: CommonContainer(
        width: double.infinity,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
        child: Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: primary,
            ),
            const AppSpacerWidth(),
            Expanded(
              child: AppText('${getTimeToHMSAM(context, selectedTime)}'),
            ),
            const Icon(
              Icons.expand_circle_down_outlined,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}
