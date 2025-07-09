import 'package:bhawsar_chemical/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../src/widgets/app_dialog.dart';
import '../src/widgets/app_text.dart';

Future<bool> onWillPop(BuildContext context) async {
  bool? exitResult = await appAlertDialog(
    context,
    AppText(
      S.of(context).exit_app,
      textAlign: TextAlign.center,
      fontSize: 17,
    ),
    () => Navigator.of(context).pop(true),
    () => Navigator.of(context).pop(false),
  );
  return exitResult ?? false;
}
