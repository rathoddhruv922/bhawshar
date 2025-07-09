import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReportTotalItemWidget extends StatelessWidget {
  const ReportTotalItemWidget({
    super.key,
    required this.report,
  });
  final MrDailyReportModel report;

  @override
  Widget build(BuildContext context) {
    List serviceCategoryList = [
      {
        'id': 1,
        'name': localization.order_label,
        'icon': Icons.shopping_cart_outlined,
      },
      {
        'id': 2,
        'name': localization.medical_label,
        'icon': Icons.store_outlined,
      },
      {
        'id': 3,
        'name': localization.reminder_label,
        'icon': Icons.timer_outlined,
      },
      {
        'id': 4,
        'name': localization.expense_label,
        'icon': Icons.currency_rupee_outlined,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: paddingDefault,
      mainAxisSpacing: paddingDefault,
      childAspectRatio: 16 / 9,
      children: List.generate(4, (index) {
        return Container(
          decoration: BoxDecoration(
              color: green.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(08)),
              border: Border.all(color: offWhite)),
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      serviceCategoryList[index]['icon'],
                      color: textBlack.withOpacity(0.4),
                      size: 25.sp,
                    ),
                    AppSpacerWidth(width: paddingDefault),
                    CircleAvatar(
                      backgroundColor: white,
                      child: AppText(
                        index == 0
                            ? (report.activity?.order.toString() ?? '0')
                            : index == 1
                                ? (report.activity?.client.toString() ?? '0')
                                : index == 2
                                    ? (report.activity?.reminder.toString() ??
                                        '0')
                                    : (report.activity?.expense.toString() ??
                                        '0'),
                        color: primary,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 100.w,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(08),
                    bottomRight: Radius.circular(08),
                  ),
                ),
                child: AppText(
                  serviceCategoryList[index]['name'],
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
