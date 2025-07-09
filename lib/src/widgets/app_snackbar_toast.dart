import 'package:bhawsar_chemical/main.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/app_colors.dart';
import 'app_text.dart';

Future<void> mySnackbar(String content,
    {BuildContext? context,
    int duration = 3,
    Color bgColor = primary,
    bool isError = false,
    Color textColor = white}) async {
  final snackBar = isError
      ? SnackBar(
          elevation: 2,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration),
          backgroundColor: greyLight,
          dismissDirection: DismissDirection.down,
          content: AppText(
            content,
            textAlign: TextAlign.center,
            fontSize: 16,
            color: errorRed,
            fontWeight: FontWeight.bold,
            maxLine: 2,
          ),
          // action: SnackBarAction(label: 'Cancel', onPressed: () {}),
        )
      : SnackBar(
          elevation: 2,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration),
          backgroundColor: bgColor,
          dismissDirection: DismissDirection.down,
          content: AppText(
            content,
            textAlign: TextAlign.center,
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
            maxLine: 2,
          ),
          // action: SnackBarAction(label: 'Cancel', onPressed: () {}),
        );

  // show toast message if context &navigationKey.currentContext both are null
  if (context != null) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  } else if (navigationKey.currentContext != null) {
    ScaffoldMessenger.of(navigationKey.currentContext!)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  } else {
    myToastMsg(content);
  }
}

Future myToastMsg(String msg,
    {double fontSize = 14,
    Color bg = primary,
    Color textColor = secondary,
    bool isError = false,
    Toast length = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.SNACKBAR}) async {
  length = isError ? Toast.LENGTH_LONG : length;
  bg = isError ? errorRed : bg;
  textColor = isError ? white : textColor;
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: length,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: bg,
    textColor: textColor,
    fontSize: fontSize,
  );
}
