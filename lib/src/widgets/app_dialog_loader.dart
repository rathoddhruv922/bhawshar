import 'package:flutter/material.dart';

import '../../constants/app_const.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';
import 'app_loader_simple.dart';
import 'app_text.dart';

class AppDialogLoader extends StatelessWidget {
  const AppDialogLoader({super.key, this.msg});
  final String? msg;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(paddingLarge),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: PopScope(
        canPop: false,
        child: SizedBox(
          height: 85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 0,
                child: AppText(localization.app_name,
                    color: primary, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Divider(height: 0, thickness: 1, color: primary),
              const SizedBox(height: 10),
              Flexible(
                child: Row(
                  children: [
                    const SizedBox(height: 25, width: 25, child: AppLoader()),
                    const SizedBox(width: 15.0),
                    Expanded(child: AppText(msg ?? S.of(context).loading))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
