import 'package:bhawsar_chemical/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../router/route_list.dart';
import '../../../../widgets/app_loader_simple.dart';
import '../../../../widgets/app_snackbar_toast.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_text.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart'
    as medical;

import 'medical_info_dialog.dart';

class MedicalCardWidget extends StatelessWidget {
  const MedicalCardWidget(
      {Key? key, required this.medicals, required this.pageTitle})
      : super(key: key);

  final medical.Item medicals;
  final String? pageTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      color: offWhite,
      margin: const EdgeInsets.only(bottom: paddingDefault),
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        tileColor: transparent,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.all(paddingSmall),
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        onTap: () async {
          hideKeyboard();
          if (pageTitle != null) {
            if (pageTitle!.contains('Reminder')) {
              navigationKey.currentState?.popAndPushNamed(
                RouteList.addReminder,
                arguments: medicals,
              );
            } else if (pageTitle!.contains('Order')) {
              if (medicals.type!.toLowerCase() == 'medical' ||
                  medicals.type!.toLowerCase() == 'doctor' ||
                  medicals.type!.toLowerCase() == 'distributor') {
                Navigator.maybePop(context);

                navigationKey.currentState?.pushReplacementNamed(
                  RouteList.addOrder,
                  arguments: medicals,
                );
              } else {
                myToastMsg("Can't  place order for this client!",
                    isError: true);
              }
            }
          } else {
            showMedical(context, medicals);
          }
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                width: 40.sp,
                height: 45.sp,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: greyLight),
                  color: white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedNetworkImage(
                  httpHeaders: {
                    "Referer": "https://mobile.bhawsarayurveda.in/"
                  },
                  imageUrl: "${medicals.image}",
                  imageBuilder: (context, imageProvider) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
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
            const AppSpacerWidth(),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText(
                          '${medicals.name}',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          maxLine: 1,
                        ),
                      ),
                      const AppSpacerWidth(),
                      InkResponse(
                        onTap: () {
                          if (medicals.type!.toLowerCase() == 'medical' ||
                              medicals.type!.toLowerCase() == 'doctor' ||
                              medicals.type!.toLowerCase() == 'distributor') {
                            navigationKey.currentState?.pushReplacementNamed(
                                RouteList.addOrder,
                                arguments: medicals);
                          } else {
                            myToastMsg("Can't place order for this client!",
                                isError: true);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: secondary,
                          radius: 16,
                          child: Icon(
                            Icons.shopping_cart_checkout_sharp,
                            color: textBlack,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        color: primary,
                        size: 18.sp,
                      ),
                      const AppSpacerWidth(),
                      Expanded(
                        child: AppText(
                          '${medicals.address?.trim() == "" ? '-' : medicals.address ?? '-'}-${medicals.area}, ${medicals.city}, ${medicals.state}, ${medicals.zip?.toString().trim() == "" ? '-' : medicals.zip ?? '-'}',
                          maxLine: medicals.profile!.toLowerCase() == 'pending'
                              ? 2
                              : 3,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          makePhoneCall(medicals.mobile!);
                        },
                        child: Icon(
                          Icons.call_outlined,
                          color: primary,
                          size: 18.sp,
                        ),
                      ),
                      const AppSpacerWidth(),
                      Expanded(
                        child: AppText(
                          '${medicals.mobile}',
                          fontSize: 15,
                          maxLine: 1,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: medicals.profile!.toLowerCase() == 'pending'
                        ? true
                        : false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: red,
                          size: 18.sp,
                        ),
                        const AppSpacerWidth(),
                        const Flexible(
                          child: AppText(
                            'Pending',
                            maxLine: 1,
                            color: errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
