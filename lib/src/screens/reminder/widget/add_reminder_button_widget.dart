import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_text.dart';

import 'dart:math' as math;

class AddReminderWidget extends StatelessWidget {
  const AddReminderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: green,
      heroTag: "${math.Random().nextDouble()}",
      onPressed: () async {
        navigationKey.currentState?.restorablePushNamed(RouteList.searchMedical,
            arguments: 'Add Reminder');
      },
      icon: const Icon(
        Icons.add,
        color: white,
      ),
      label: AppText(
        localization.reminder_add,
        color: white,
      ),
    );
  }
}
