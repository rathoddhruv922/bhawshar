import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constants/app_const.dart';
import '../../../helper/app_helper.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_loader_simple.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart'
    as medical;
import 'dart:io' as platform;

import 'common_container_widget.dart';

class GlobalMedicalCard extends StatelessWidget {
  const GlobalMedicalCard({
    Key? key,
    this.medicalInfo,
    this.dynamicMedicalInfo,
  }) : super(key: key);

  final medical.Item? medicalInfo;
  final dynamic dynamicMedicalInfo;

  @override
  Widget build(BuildContext context) {
    String? name, img, address;
    try {
      name = medicalInfo != null
          ? '${medicalInfo?.name}'
          : '${dynamicMedicalInfo?.client?.name}';
    } catch (e) {
      showCatchedError(e);
    }
    try {
      address = medicalInfo != null
          ? ' ${medicalInfo?.address}-${medicalInfo?.area}, ${medicalInfo?.city}, ${medicalInfo?.state}, ${medicalInfo?.zip}'
          : '${dynamicMedicalInfo?.client?.address}-${dynamicMedicalInfo?.client?.area}, ${dynamicMedicalInfo?.client?.city}, ${dynamicMedicalInfo?.client?.state}, ${dynamicMedicalInfo?.client?.zip}';
    } catch (e) {
      showCatchedError(e);
    }

    try {
      img = medicalInfo != null
          ? "${medicalInfo?.image}"
          : "${dynamicMedicalInfo?.client?.image}";
    } catch (e) {
      showCatchedError(e);
    }
    return CommonContainer(
      margin: const EdgeInsets.symmetric(horizontal: paddingDefault),
      radius: 8.0,
      border: Border.all(color: greyLight),
      child: ListTile(
        tileColor: white,
        dense: true,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: paddingSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minLeadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 43.sp,
                width: 40.sp,
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  color: white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ((img?.contains('com.app.bhawsarChemical/cache') ==
                                  false &&
                              img?.contains('Containers/Data/Application') ==
                                  false) ||
                          ((img?.contains('com.app.bhawsarChemical/cache') ==
                                  false &&
                              medicalInfo?.image?.contains(
                                      'Containers/Data/Application') ==
                                  false)))
                      ? CachedNetworkImage(
                          httpHeaders: {
                            "Referer": "https://mobile.bhawsarayurveda.in/"
                          },
                          imageUrl: img ?? 'NA',
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
                        )
                      : Image.file(
                          platform.File(
                            medicalInfo != null
                                ? "${medicalInfo?.image}"
                                : "${dynamicMedicalInfo?.client?.image}",
                          ),
                          errorBuilder: (context, url, error) => const Icon(
                            Icons.error_outline,
                            color: primary,
                          ),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                        ),
                ),
              ),
              const AppSpacerWidth(),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: AppText(
                        name ?? 'NA',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        maxLine: 1,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            color: primary,
                            size: 18.sp,
                          ),
                          const AppSpacerWidth(),
                          Expanded(
                            child: AppText(
                              address ?? 'NA',
                              maxLine: 3,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            Icons.call_outlined,
                            color: primary,
                            size: 18.sp,
                          ),
                          const AppSpacerWidth(),
                          Flexible(
                            child: AppText(
                              medicalInfo != null
                                  ? '${medicalInfo?.mobile}'
                                  : '${dynamicMedicalInfo?.client?.mobile}',
                              fontSize: 15,
                              maxLine: 2,
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
      ),
    );
  }
}
