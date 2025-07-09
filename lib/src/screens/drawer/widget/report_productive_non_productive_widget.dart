import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/common/common_container_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_switcher_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart' as intl;

class ProNonProList extends StatelessWidget {
  const ProNonProList({
    super.key,
    required this.activeTab,
    required this.report,
    required this.shadow,
    required this.expenseDate,
  });

  final int activeTab;
  final MrDailyReportModel report;
  final BoxShadow shadow;
  final DateTime expenseDate;

  @override
  Widget build(BuildContext context) {
    return (activeTab == 0 && (report.productive?.isEmpty ?? true))
        ? AppText(localization.empty)
        : (activeTab == 1 && (report.nonproductive?.isEmpty ?? true))
            ? AppText(localization.empty)
            : ListView.separated(
                itemCount: activeTab == 0
                    ? (report.productive?.length ?? 0)
                    : (report.nonproductive?.length ?? 0),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return AppSpacerHeight();
                },
                itemBuilder: (BuildContext context, int index) {
                  String status = (activeTab == 0
                      ? (report.productive?[index].status ?? 'NA')
                      : (report.nonproductive?[index].status ?? 'NA'));
                  return AppSwitcherWidget(
                    // animationType: 'slide',
                    child: Card(
                      semanticContainer: false,
                      color: offWhite,
                      margin: EdgeInsets.zero,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        tileColor: transparent,
                        dense: true,
                        contentPadding: const EdgeInsets.all(paddingSmall),
                        minVerticalPadding: paddingExtraSmall,
                        minLeadingWidth: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onTap: () {},
                        title: Row(
                          children: [
                            const AppSpacerWidth(),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppText(
                                        (activeTab == 0
                                            ? (report.productive?[index]
                                                    .client ??
                                                'NA')
                                            : (report.nonproductive?[index]
                                                    .client ??
                                                'NA')),
                                        fontWeight: FontWeight.bold,
                                        maxLine: 1,
                                      ),
                                      CommonContainer(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        shadowColor: greyLight,
                                        color: status.toLowerCase() == 'new'
                                            ? yellow.withOpacity(0.5)
                                            : status.toLowerCase() == 'cancel'
                                                ? grey.withOpacity(0.5)
                                                : status.toLowerCase() ==
                                                        'processing'
                                                    ? secondary
                                                    : status.toLowerCase() ==
                                                            'shipped'
                                                        ? orange
                                                            .withOpacity(0.8)
                                                        : status.toLowerCase() ==
                                                                'delivered'
                                                            ? primary
                                                                .withOpacity(
                                                                    0.6)
                                                            : status.toLowerCase() ==
                                                                    'hold'
                                                                ? red
                                                                    .withOpacity(
                                                                        0.5)
                                                                : status.toLowerCase() ==
                                                                        'complete'
                                                                    ? primary
                                                                    : yellow
                                                                        .withOpacity(
                                                                            0.5),
                                        radius: 2,
                                        child: AppText(status.toCapitalized(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: (status.toLowerCase() ==
                                                    'complete')
                                                ? offWhite
                                                : textBlack),
                                      ),
                                    ],
                                  ),
                                  activeTab == 0
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: AppText(
                                            (report.productive?[index]
                                                    .distributor ??
                                                'NA'),
                                            textAlign: TextAlign.left,
                                            maxLine: 1,
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.sticky_note_2_outlined),
                                      AppSpacerWidth(),
                                      Flexible(
                                        child: AppText(
                                          (activeTab == 0
                                              ? (report.productive?[index]
                                                      .notes ??
                                                  'NA')
                                              : (report.nonproductive?[index]
                                                      .notes ??
                                                  'NA')),
                                          maxLine: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const AppSpacerHeight(),
                                  Row(
                                    children: [
                                      CommonContainer(
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                            color: white,
                                            boxShadow: [shadow],
                                            shape: BoxShape.circle),
                                        child: activeTab == 0
                                            ? ((report.productive?[index]
                                                            .type ??
                                                        'NA') ==
                                                    'On Phone'
                                                ? Icon(
                                                    Icons
                                                        .phone_android_outlined,
                                                    color: primary,
                                                    size: 12.sp,
                                                  )
                                                : Icon(
                                                    Icons.store_outlined,
                                                    color: primary,
                                                  ))
                                            : ((report.nonproductive?[index]
                                                            .type ??
                                                        'NA') ==
                                                    'On Phone'
                                                ? Icon(
                                                    Icons
                                                        .phone_android_outlined,
                                                    color: primary,
                                                  )
                                                : Icon(
                                                    Icons.store_outlined,
                                                    color: primary,
                                                  )),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.calendar_month,
                                        size: 15.sp,
                                        color: primary,
                                      ),
                                      const AppSpacerWidth(width: 5),
                                      AppText(
                                        getDate(expenseDate.toString(),
                                            dateFormat:
                                                intl.DateFormat.yMMMd('en_US')),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      const AppSpacerWidth(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
  }
}
