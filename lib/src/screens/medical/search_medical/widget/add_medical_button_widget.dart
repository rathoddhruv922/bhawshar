import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../router/route_list.dart';
import '../../../../widgets/app_text.dart';
import 'dart:math' as math;

class AddMedicalButtonWidget extends StatelessWidget {
  final String redirectTo;
  const AddMedicalButtonWidget({Key? key, required this.redirectTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: green,
      heroTag: "${math.Random().nextDouble()}",
      onPressed: () {
        navigationKey.currentState
            ?.restorablePushNamed(RouteList.addMedical, arguments: redirectTo);
      },
      icon: const Icon(
        Icons.add,
        color: white,
      ),
      label: AppText(
        localization.medical_add,
        color: white,
      ),
    );
  }
}
