import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReportProductCountWidget extends StatelessWidget {
  const ReportProductCountWidget({
    super.key,
    required this.report,
  });

  final MrDailyReportModel report;

  @override
  Widget build(BuildContext context) {
    BoxShadow shadow = BoxShadow(
      color: grey.withOpacity(0.8),
      blurRadius: 1,
      spreadRadius: 0.5,
      offset: const Offset(0, 1),
    );

    return Column(
      children: List.generate((report.products?.length ?? 0), (index) {
        return Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.all(Radius.circular(08)),
            border: Border.all(color: offWhite, width: 2),
            boxShadow: [shadow],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100.w,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: offWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(08),
                    topRight: Radius.circular(08),
                  ),
                ),
                child: AppText(
                  report.products?[index].name ?? 'NA',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: List.generate(
                  report.products![index].sizes!.isEmpty ? 1 : report.products![index].sizes!.length,
                  (i) {
                    return Container(
                      color: offWhite,
                      height: 45,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ListTile(
                        minVerticalPadding: 0,
                        minLeadingWidth: 0,
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText(
                              report.products![index].sizes!.isEmpty
                                  ? (report.products?[index].name.toString() ?? 'NA')
                                  : report.products![index].sizes![i].size.toString(),
                              color: textBlack.withOpacity(0.4),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: AppText(
                                "x",
                                textAlign: TextAlign.center,
                                color: grey,
                              ),
                            ),
                            AppText(
                              (report.products![index].sizes!.isEmpty
                                              ? (report.products?[index].totalQty.toString() ?? 'NA')
                                              : report.products![index].sizes![i].totalQty.toString())
                                          .toString() ==
                                      "0"
                                  ? report.products![index].sizes!.isEmpty
                                      ? (report.products?[index].availableQty.toString() ?? 'NA')
                                      : report.products![index].sizes![i].availableQty.toString()
                                  : report.products![index].sizes!.isEmpty
                                      ? (report.products?[index].totalQty.toString() ?? 'NA')
                                      : report.products![index].sizes![i].totalQty.toString(),
                              color: primary,
                              fontWeight: FontWeight.w900,
                            ),
                            (report.products![index].sizes!.isEmpty
                                        ? (report.products?[index].availableQty.toString() ?? 'NA')
                                        : report.products![index].sizes![i].availableQty.toString()) !=
                                    "0"
                                ? Expanded(
                                    child: AppText(
                                      "Available",
                                      color: primary,
                                      fontWeight: FontWeight.w900,
                                      textAlign: TextAlign.right,
                                    ),
                                  )
                                : (report.products![index].sizes!.isEmpty
                                                ? (report.products?[index].totalQty.toString() ?? 'NA')
                                                : report.products![index].sizes![i].totalQty.toString())
                                            .toString() ==
                                        "0"
                                    ? Expanded(
                                        child: AppText(
                                          "Not Interested",
                                          color: grey,
                                          fontWeight: FontWeight.w900,
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    : Expanded(
                                        child: AppText(
                                          "Purchased",
                                          color: orange,
                                          fontWeight: FontWeight.w900,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
