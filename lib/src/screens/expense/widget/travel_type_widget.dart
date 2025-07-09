import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

class TravelTypeWidget extends StatelessWidget {
  const TravelTypeWidget({super.key, required this.onChanged, required this.travelType});

  final ValueChanged onChanged;
  final String? travelType;

  @override
  Widget build(BuildContext context) {
    String? tmpType = travelType;
    List<String> vehicleList = ['Car', 'Bike', 'Bus', 'Train', 'Rickshaw', 'Other'];

    return CommonContainer(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
      width: double.infinity,
      height: 45,
      child: InkWell(
        onTap: () async {
          await showModalBottomSheet<String?>(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 100.w,
                        padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                        alignment: Alignment.center,
                        color: greyLight,
                        child: AppText(
                          localization.select_travel_type,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                        itemCount: vehicleList.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              tmpType = vehicleList[index];
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      tmpType?.toLowerCase() == vehicleList[index].toLowerCase()
                                          ? Icons.check_box_rounded
                                          : Icons.check_box_outline_blank_rounded,
                                      color: primary),
                                  const AppSpacerWidth(),
                                  AppText(vehicleList[index]),
                                ],
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: ((context, index) {
                          return const Divider(color: secondary);
                        }),
                      ),
                    ],
                  ),
                );
              });
          if (tmpType == null) {
            return;
          }
          onChanged(tmpType);
        },
        child: Row(
          children: [
            Expanded(
              child: AppText(
                (travelType == null || travelType?.trim() == "") ? localization.select_travel_type : travelType!,
              ),
            ),
            const Icon(
              Icons.expand_circle_down_outlined,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}
