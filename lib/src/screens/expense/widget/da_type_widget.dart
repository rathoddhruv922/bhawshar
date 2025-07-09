import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

class DATypeWidget extends StatelessWidget {
  const DATypeWidget(
      {super.key, required this.onChanged, required this.daType});
  final ValueChanged onChanged;
  final String? daType;
  @override
  Widget build(BuildContext context) {
    String? tmpDAType = daType;
    List<String> daList = [
      'HQ',
      'XHQ',
      'Loadge',
      'Food',
    ];

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
                        padding:
                            const EdgeInsets.symmetric(vertical: paddingSmall),
                        alignment: Alignment.center,
                        color: greyLight,
                        child: AppText(
                          localization.select_da_type,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: paddingDefault),
                        itemCount: daList.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              tmpDAType = daList[index];
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingDefault),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      tmpDAType?.toLowerCase() ==
                                              daList[index].toLowerCase()
                                          ? Icons.check_box_rounded
                                          : Icons
                                              .check_box_outline_blank_rounded,
                                      color: primary),
                                  const AppSpacerWidth(),
                                  AppText(daList[index]),
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
          if (tmpDAType == null) {
            return;
          }
          onChanged(tmpDAType);
        },
        child: Row(
          children: [
            Expanded(
                child: AppText((daType == null || daType?.trim() == "")
                    ? localization.select_da_type
                    : daType!)),
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
