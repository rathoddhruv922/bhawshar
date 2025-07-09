import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io' as platform;
import '../../constants/app_const.dart';
import '../../helper/app_helper.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';
import '../screens/common/common_container_widget.dart';
import 'app_text.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime date;
  final DateTime? minDate, expiredTime, maxDate;
  final String title;
  final Color bg;
  final Color borderColor;
  final Color textColor;
  final ValueChanged<DateTime> onChanged;
  const CustomDatePicker(
      {Key? key,
      required this.date,
      this.expiredTime,
      this.minDate,
      this.maxDate,
      required this.title,
      this.bg = white,
      this.borderColor = transparent,
      this.textColor = textBlack,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: paddingDefault,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: paddingDefault),
            child: AppText(
              title,
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: primary,
                ),
              ),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  intl.DateFormat('yyyy-MM-dd', 'en_US').format(date),
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.expand_circle_down_outlined,
                      color: primary,
                    ),
                    onPressed: () async {
                      DateTime? newDate = platform.Platform.isIOS
                          ? await showCupertinoDialog<DateTime>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                DateTime? tempPickedDate;
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: offWhite,
                                    ),
                                    height: 25.h,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.8),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(14),
                                                    topRight:
                                                        Radius.circular(14)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CupertinoButton(
                                                child: AppText(
                                                    localization.cancel,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              CupertinoButton(
                                                child: const AppText(
                                                  'Done',
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(tempPickedDate);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date,
                                            minimumDate: minDate ?? DateTime(DateTime.now().year - 500),
                                            maximumDate: maxDate ?? DateTime(DateTime.now().year + 2),
                                            initialDateTime: () {
                                              // Calculate the potential initialDateTime by adding 10 minutes
                                              DateTime potentialInitialDate = date.add(const Duration(minutes: 10));

                                              // Ensure initialDateTime is not after maximumDate
                                              if (potentialInitialDate.isAfter(maxDate ?? DateTime(DateTime.now().year + 2))) {
                                                return maxDate ?? DateTime(DateTime.now().year + 2);
                                              } else {
                                                return potentialInitialDate;
                                              }
                                            }(),
                                            onDateTimeChanged: (DateTime dateTime) {
                                              tempPickedDate = dateTime;
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : await showDatePicker(
                              context: context,
                              initialDate:
                                  date.add(const Duration(minutes: 10)),
                              helpText: title,
                              currentDate: DateTime.now(),
                              firstDate: minDate ??
                                  DateTime(DateTime.now().year - 500),
                              fieldHintText: 'YYYY-MM-DD',
                              errorFormatText: 'Enter Valid date format!',
                              initialDatePickerMode: DatePickerMode.day,
                              lastDate:
                                  maxDate ?? DateTime(DateTime.now().year + 2),
                              fieldLabelText: title,
                            );
                      // Don't change the date if the date picker returns null.
                      if (newDate == null) {
                        return;
                      }
                      onChanged(newDate);
                    },
                  ),
                ),
              ),
            ],
          ),
          expiredTime == null
              ? const SizedBox()
              : Visibility(
                  visible: (date.isBefore(DateTime.now())) ? true : false,
                  child: AppText(
                    "${localization.expire_date} : ${getDate(expiredTime.toString(), dateFormat: intl.DateFormat.yMMMd('en_US'))}",
                    color: errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
