import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../constants/app_const.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

Future<bool?> showReminder(BuildContext context, dynamic reminder) {
  return appInfoDialog(
    context,
    Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: greyLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppText(
                  reminder.client.toString().toUpperCase(),
                  fontWeight: FontWeight.bold,
                  maxLine: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(paddingDefault),
          child: Column(
            children: [
              FittedBox(
                child: Container(
                  height: 50.sp,
                  width: 70.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: greyLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    httpHeaders: {
                      "Referer": "https://mobile.bhawsarayurveda.in/"
                    },
                    imageUrl: "${reminder.clientImage}",
                    imageBuilder: (context, imageProvider) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyLight),
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
              ),
              const Divider(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      reminder.reminderType.toString(),
                      maxLine: 5,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const AppSpacerHeight(),
              Row(
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      '${reminder.message}',
                      fontSize: 15,
                      maxLine: 10,
                    ),
                  ),
                ],
              ),
              const AppSpacerHeight(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      reminder.dateTime.toString(),
                      maxLine: 5,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    isShowButton: false,
  );
}
