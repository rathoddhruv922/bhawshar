import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';
import 'common_container_widget.dart';

class CommonStaticReminderDay extends StatefulWidget {
  final ValueChanged onDayChanged;
  final bool removeStaticDate;

  const CommonStaticReminderDay({
    super.key,
    required this.onDayChanged,
    this.removeStaticDate = false,
  });

  @override
  State<CommonStaticReminderDay> createState() =>
      _CommonStaticReminderDayState();
}

class _CommonStaticReminderDayState extends State<CommonStaticReminderDay> {
  int selectedDate = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                widget
                    .onDayChanged(DateTime.now().add(const Duration(days: 7)));
                selectedDate = 1;
              });
            },
            child: CommonContainer(
              width: double.infinity,
              color: ((!widget.removeStaticDate) && selectedDate == 1)
                  ? secondary
                  : white,
              height: 45,
              child: Center(
                child: AppText(
                  '1 - Week',
                  fontWeight: ((!widget.removeStaticDate) && selectedDate == 1)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        const AppSpacerWidth(),
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedDate = 2;
                widget
                    .onDayChanged(DateTime.now().add(const Duration(days: 15)));
              });
            },
            child: CommonContainer(
              width: double.infinity,
              color: ((!widget.removeStaticDate) && selectedDate == 2)
                  ? secondary
                  : white,
              height: 45,
              child: Center(
                child: AppText(
                  '15 - Day',
                  fontWeight: ((!widget.removeStaticDate) && selectedDate == 2)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        const AppSpacerWidth(),
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedDate = 3;
                widget
                    .onDayChanged(DateTime.now().add(const Duration(days: 30)));
              });
            },
            child: CommonContainer(
              width: double.infinity,
              color: ((!widget.removeStaticDate) && selectedDate == 3)
                  ? secondary
                  : white,
              height: 45,
              child: Center(
                child: AppText(
                  '1 - Month',
                  fontWeight: ((!widget.removeStaticDate) && selectedDate == 3)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
