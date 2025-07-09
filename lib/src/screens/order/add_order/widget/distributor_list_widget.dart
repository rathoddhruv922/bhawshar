import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../business_logic/bloc/medical/medical_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../constants/enums.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_loader_simple.dart';
import '../../../../widgets/app_separator_widget.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_switcher_widget.dart';
import '../../../../widgets/app_text.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart'
    as medical;

class DistributorListWidget extends StatelessWidget {
  final TextEditingController distributorController;
  final ValueChanged onChanged;
  final String? type;
  final dynamic distributorInfo;

  const DistributorListWidget({
    super.key,
    required this.type,
    required this.distributorInfo,
    required this.distributorController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    context.read<MedicalBloc>().add(const ClearMedicalEvent());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingExtraSmall),
      child: Stack(
        children: [
          Visibility(
            visible: distributorInfo != null ? true : false,
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MySeparator(),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: paddingSmall),
                    minLeadingWidth: 0,
                    dense: true,
                    tileColor: offWhite,
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppText(
                            '${distributorInfo?.name}',
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.pin_drop, color: primary),
                        const AppSpacerWidth(),
                        Flexible(
                          child: AppText(
                            '${distributorInfo?.area}, ${distributorInfo?.city}, ${distributorInfo?.state} ',
                            fontSize: 16,
                            maxLine: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<MedicalBloc, MedicalState>(
            builder: (BuildContext context, state) {
              return AppSwitcherWidget(
                animationType: 'slide',
                direction: AxisDirection.left,
                child: state.status == MedicalStatus.initial
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: paddingSmall,
                          bottom: paddingSmall,
                        ),
                        child: Center(
                          child: AppText(
                              textAlign: TextAlign.center,
                              '${type?.toLowerCase() == 'distributor' ? localization.distributor_search : localization.warehouse_search}..'),
                        ),
                      )
                    : state.status == MedicalStatus.loading
                        ? const Padding(
                            padding: EdgeInsets.only(
                              top: paddingSmall,
                              bottom: paddingSmall,
                            ),
                            child: AppLoader(),
                          )
                        : state.status == MedicalStatus.failure
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: paddingDefault,
                                  bottom: paddingSmall,
                                ),
                                child: Center(
                                  child: AppText(
                                    state.msg.toString(),
                                  ),
                                ),
                              )
                            : state.status == MedicalStatus.loaded
                                ? Container(
                                    color: white,
                                    constraints:
                                        BoxConstraints(maxHeight: 50.h),
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: ListView.separated(
                                        itemCount: int.parse(
                                            (state.res.items?.length)
                                                .toString()),
                                        padding: EdgeInsets.zero,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const Divider();
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List<medical.Item>? items =
                                              state.res.items;
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: paddingSmall),
                                            minLeadingWidth: 0,
                                            dense: true,
                                            tileColor: transparent,
                                            minVerticalPadding: 0,
                                            horizontalTitleGap: 0,
                                            onTap: (() {
                                              hideKeyboard();
                                              onChanged(items?[index]);
                                              context.read<MedicalBloc>().add(
                                                  const ClearMedicalEvent());
                                            }),
                                            title: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: AppText(
                                                    '${items?[index].name}',
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.pin_drop,
                                                    color: primary),
                                                const AppSpacerWidth(),
                                                Flexible(
                                                  child: AppText(
                                                    '${items?[index].area}, ${items?[index].city}, ${items?[index].state}',
                                                    fontSize: 17,
                                                    maxLine: 5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
