import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../router/route_list.dart';
import '../../../../widgets/app_dialog.dart';
import '../../../../widgets/app_loader_simple.dart';
import '../../../../widgets/app_snackbar_toast.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_text.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart'
    as medical;

Future<bool?> showMedical(BuildContext context, medical.Item medical) async {
  var userId = await getUserId();
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
                  medical.name.toString().toUpperCase(),
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
                  width: 75.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: greyLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    httpHeaders: {
                      "Referer": "https://mobile.bhawsarayurveda.in/"
                    },
                    imageUrl: "${medical.image}",
                    imageBuilder: (context, imageProvider) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
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
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      '${medical.type}',
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
                    Icons.pin_drop_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      '${medical.address?.trim() == "" ? '-' : medical.address ?? '-'}-${medical.area}, ${medical.city}, ${medical.state}, ${medical.zip?.toString().trim() == "" ? '-' : medical.zip ?? '-'}',
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
                    Icons.inventory_2_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      medical.panGst?.trim() == ""
                          ? 'NA'
                          : medical.panGst ?? 'NA',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const AppSpacerHeight(),
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: primary,
                    size: 18.sp,
                  ),
                  const AppSpacerWidth(),
                  Expanded(
                    child: AppText(
                      '${medical.email}',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const AppSpacerHeight(),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      makePhoneCall(medical.mobile!);
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
                      '${medical.mobile}',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible:
                    medical.profile!.toLowerCase() == 'pending' ? true : false,
                child: const AppSpacerHeight(),
              ),
              Visibility(
                visible:
                    medical.profile!.toLowerCase() == 'pending' ? true : false,
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
                    Flexible(
                      child: AppText(
                        localization.pending,
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
    onBtnOneClick: userId != medical.createdBy
        ? null
        : () {
            Navigator.of(context).pop();

            navigationKey.currentState
                ?.pushNamed(RouteList.updateMedical, arguments: medical);
          },
    onBtnTwoClick: () {
      if (medical.type!.toLowerCase() == 'medical' ||
          medical.type!.toLowerCase() == 'doctor' ||
          medical.type!.toLowerCase() == 'distributor') {
        Navigator.of(context).pop();

        navigationKey.currentState
            ?.pushReplacementNamed(RouteList.addOrder, arguments: medical);
      } else {
        myToastMsg("Can't place order for this client!", isError: true);
      }
    },
    actionBtnOne: localization.edit,
    actionBtnTwo: localization.order_now,
  );
}
