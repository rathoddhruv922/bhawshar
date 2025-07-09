import 'dart:async';

import 'package:bhawsar_chemical/data/models/expenses_model/item.dart' as expense;
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

Future<bool?> showExpense(BuildContext context, expense.Item expense) {
  return appInfoDialog(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
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
                  '${expense.type}',
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
              Padding(
                padding: const EdgeInsets.only(bottom: paddingSmall),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      color: primary,
                      size: 18.sp,
                    ),
                    const AppSpacerWidth(),
                    Expanded(
                      child: AppText(
                        '${expense.subType}',
                        maxLine: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.route_outlined,
              //       color: primary,
              //       size: 18.sp,
              //     ),
              //     const AppSpacerWidth(),
              //     Expanded(
              //       child: AppText(
              //         '${expense.fromArea?.name ?? 'N/A'} - ${expense.toArea?.name ?? 'N/A'}',
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
              // const AppSpacerHeight(),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.place_outlined,
              //       color: primary,
              //       size: 18.sp,
              //     ),
              //     const AppSpacerWidth(),
              //     Expanded(
              //       child: AppText(
              //         expense.placesWorked.toString() == ""
              //             ? 'N/A'
              //             : expense.placesWorked.toString(),
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
              // const AppSpacerHeight(),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.travel_explore_outlined,
              //       color: primary,
              //       size: 18.sp,
              //     ),
              //     const AppSpacerWidth(),
              //     Expanded(
              //       child: AppText(
              //         '${expense.distance}',
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
              //const AppSpacerHeight(),
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
                      '${expense.note}',
                      fontSize: 15,
                      maxLine: 50,
                    ),
                  ),
                ],
              ),
              const AppSpacerHeight(),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    child: AppText(
                      '₹',
                      textAlign: TextAlign.center,
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      currencyFormat.format(expense.amount),
                      fontSize: 15,
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
                      getDate(expense.expenseDate, dateFormat: intl.DateFormat.yMMMEd('en_US')),
                      maxLine: 5,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: expense.receipts!.isEmpty ? false : true,
                child: Padding(
                  padding: const EdgeInsets.only(top: paddingSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.attachment,
                        color: primary,
                        size: 18.sp,
                      ),
                      const AppSpacerWidth(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var receipt in expense.receipts!)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PdfViewScreen(url: receipt.url.toString())),
                                      );
                                    },
                                    child: AppText(
                                      receipt.url!.split('/').last.toString(),
                                      maxLine: 1,
                                    ),
                                  ),
                                  const Divider(color: primary),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    isShowButton: false,
  );
}

class PdfViewScreen extends StatelessWidget {
  final String? url;

  PdfViewScreen({super.key, this.url});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String getFileExtension(String url) {
    int dotIndex = url.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < url.length - 1) {
      return url.substring(dotIndex);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.expense_doc_view,
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
      body: SafeArea(
        child: getFileExtension(url!) == '.pdf'
            ? SfPdfViewer.network(
                url!,
                key: _pdfViewerKey,
                headers: {"Referer": "https://mobile.bhawsarayurveda.in/"},
              )
            : Center(
                child: CachedNetworkImage(
                  httpHeaders: {"Referer": "https://mobile.bhawsarayurveda.in/"},
                  imageUrl: url ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    height: 50.h,
                    width: 100.w,
                    margin: EdgeInsets.all(paddingDefault),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const AppLoader(),
                  errorWidget: (context, url, error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Image.asset('assets/ic_launcher.png'),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
