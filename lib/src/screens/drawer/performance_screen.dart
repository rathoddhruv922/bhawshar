import 'package:bhawsar_chemical/business_logic/bloc/report/report_bloc.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/report_product_count_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/report_tab_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/report_total_item_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_animated_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog_loader.dart';
import 'package:bhawsar_chemical/src/widgets/app_picker.dart';
import 'package:bhawsar_chemical/src/widgets/app_snackbar_toast.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime expenseDate = DateTime.now();

    context.read<ReportBloc>()
      ..add(const ClearReportEvent())
      ..add(GetReportEvent(date: expenseDate));

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: CustomAppBar(
        AppText(
          localization.performance,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(paddingDefault),
        child: SafeArea(
          child: BlocConsumer<ReportBloc, ReportState>(listenWhen: (previous, current) {
            return previous != current;
          }, listener: (context, state) async {
            if (state.status == ReportStatus.loading) {
              showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
            }
            if (state.status == ReportStatus.failure) {
              Navigator.of(context).pop();
              mySnackbar(state.msg.toString(), isError: state.status == ReportStatus.failure ? true : false);
              await Future.delayed(const Duration(seconds: 1));
            }
            if (state.status == ReportStatus.loaded) {
              Navigator.of(context).pop();
            }
          }, buildWhen: (previous, current) {
            return previous != current;
          }, builder: (context, state) {
            if (state.status == ReportStatus.initial) {
              return Center(child: AppText(state.msg.toString()));
            }
            if (state.status == ReportStatus.loaded) {
              MrDailyReportModel report = state.res;
              return report.activity?.order == null
                  ? Center(child: AppText(localization.empty))
                  : ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: paddingExtraSmall),
                          child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return CustomDatePicker(
                                date: expenseDate,
                                minDate: DateTime.now().subtract(const Duration(days: 365)),
                                maxDate: DateTime.now(),
                                borderColor: primary,
                                title: localization.select_date,
                                onChanged: ((value) {
                                  setState(() {
                                    expenseDate = value;
                                  });
                                  context.read<ReportBloc>()
                                    ..add(const ClearReportEvent())
                                    ..add(GetReportEvent(date: expenseDate));
                                }),
                              );
                            },
                          ),
                        ),
                        AppSpacerHeight(),
                        SizedBox(
                          height: 20.h,
                          width: 100.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Card(
                                  elevation: 0.3,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    isThreeLine: true,
                                    leading: CircleAvatar(
                                      backgroundColor: secondary,
                                      child: Icon(
                                        Icons.punch_clock_outlined,
                                        color: primary,
                                      ),
                                    ),
                                    title: AppText(
                                      'First Login',
                                      color: grey,
                                    ),
                                    subtitle: AppText(
                                      report.loginData?.login == null || report.loginData?.login == ""
                                          ? "NA"
                                          : getDateToTime(report.loginData?.login ?? 'NA'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacerHeight(),
                              Flexible(
                                child: Card(
                                  elevation: 0.3,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    isThreeLine: true,
                                    leading: CircleAvatar(
                                      backgroundColor: secondary,
                                      child: Icon(
                                        Icons.timer_sharp,
                                        color: primary,
                                      ),
                                    ),
                                    title: AppText(
                                      'Productive Working Hours',
                                      color: grey,
                                    ),
                                    subtitle: AppText(
                                      report.loginData?.duration ?? 'NA',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacerHeight(),
                        ReportTotalItemWidget(report: report),
                        AppSpacerHeight(height: paddingExtraLarge),
                        (report.products?.isNotEmpty ?? false) ? ReportProductCountWidget(report: report) : SizedBox.fromSize(),
                        AppSpacerHeight(height: (report.products?.isNotEmpty ?? false) ? paddingExtraLarge : 0),
                        ReportTabWidget(report: report, expenseDate: expenseDate),
                      ],
                    );
            }
            return SizedBox();
          }),
        ),
      ),
    );
  }
}
