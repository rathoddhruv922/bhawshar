import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/report_productive_non_productive_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReportTabWidget extends StatefulWidget {
  const ReportTabWidget({
    super.key,
    required this.report,
    required this.expenseDate,
  });

  final MrDailyReportModel report;
  final DateTime expenseDate;

  @override
  State<ReportTabWidget> createState() => _ReportTabWidgetState();
}

class _ReportTabWidgetState extends State<ReportTabWidget> {
  int activeTab = 0;
  BoxShadow shadow = BoxShadow(
    color: grey.withOpacity(0.8),
    blurRadius: 1,
    spreadRadius: 0.5,
    offset: const Offset(0, 1),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 120.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    activeTab = 0;
                    setState(() {});
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          activeTab == 0 ? primary.withOpacity(0.1) : offWhite,
                      border: Border(
                        bottom: BorderSide(
                          color: activeTab == 0 ? primary : transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          localization.productive,
                          fontWeight: activeTab == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            child: AppText(
                              widget.report.productive?.length.toString() ??
                                  '0',
                              fontWeight: activeTab == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacerWidth(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    activeTab = 1;
                    setState(() {});
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeTab == 1 ? red.withOpacity(0.1) : offWhite,
                      border: Border(
                        bottom: BorderSide(
                          color: activeTab == 1 ? red : transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          localization.non_productive,
                          fontWeight: activeTab == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            child: AppText(
                              widget.report.nonproductive?.length.toString() ??
                                  '0',
                              fontWeight: activeTab == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacerHeight(height: 8.0),
        ProNonProList(
            activeTab: activeTab,
            report: widget.report,
            shadow: shadow,
            expenseDate: widget.expenseDate),
      ],
    );
  }
}
