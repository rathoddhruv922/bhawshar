import 'dart:io';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bhawsar_chemical/generated/l10n.dart';

import '../../utils/app_colors.dart';
import 'app_animated_dialog.dart';
import 'app_button.dart';
import 'app_spacer.dart';
import 'app_text.dart';

Future<bool?> appAlertDialog(
  BuildContext context,
  Widget title,
  onBtnOneClick,
  onBtnTwoClick, {
  bool isSingleButton = false,
  bool isDismissible = false,
  String? actionBtnOne,
  String? actionBtnTwo,
}) async {
  return await showAnimatedDialog(
      context,
      Platform.isIOS
          ? CupertinoAlertDialog(
              title: title,
              actions: isSingleButton == true
                  ? <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: onBtnOneClick,
                        child: AppText(
                          actionBtnOne ?? S.of(context).yes,
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : <Widget>[
                      CupertinoDialogAction(
                        onPressed: onBtnTwoClick,
                        child: AppText(
                          actionBtnTwo ?? S.of(context).no,
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: false,
                        onPressed: onBtnOneClick,
                        child: AppText(
                          actionBtnOne ?? S.of(context).yes,
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
            )
          : AlertDialog(
              backgroundColor: white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: paddingDefault, vertical: paddingDefault),
              iconPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              content: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title,
                    const AppSpacerHeight(),
                    Row(
                      children: [
                        !isSingleButton
                            ? Expanded(
                                child: AppButton(
                                  onBtnClick: onBtnTwoClick,
                                  btnText: actionBtnTwo ?? S.of(context).no,
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(width: isSingleButton ? 0 : 15),
                        Expanded(
                          child: AppButton(
                            onBtnClick: onBtnOneClick,
                            btnText: actionBtnOne ?? S.of(context).yes,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      isFlip: true,
      dismissible: isDismissible);
}

Future<bool?> appInfoDialog(
  BuildContext context,
  Widget title, {
  onBtnOneClick,
  onBtnTwoClick,
  bool isShowButton = true,
  bool isDismissible = false,
  String? actionBtnOne,
  String? actionBtnTwo,
}) async {
  return await showAnimatedDialog(
    context,
    AlertDialog(
      backgroundColor: white,
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      actionsOverflowButtonSpacing: 0,
      buttonPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: title),
          !isShowButton
              ? const SizedBox.shrink()
              : Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: paddingDefault,
                        right: paddingDefault,
                        bottom: paddingDefault),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onBtnClick: onBtnOneClick,
                            btnText: actionBtnOne ?? S.of(context).yes,
                          ),
                        ),
                        const AppSpacerWidth(),
                        Expanded(
                          child: AppButton(
                            onBtnClick: onBtnTwoClick,
                            btnText: actionBtnTwo ?? S.of(context).no,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    ),
    dismissible: isDismissible,
  );
}
