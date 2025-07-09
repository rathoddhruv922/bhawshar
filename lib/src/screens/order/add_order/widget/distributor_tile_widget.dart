import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../business_logic/bloc/medical/medical_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_text.dart';
import 'distributor_list_widget.dart';
import 'distributors_search_widget.dart';

class DistributorTile extends StatelessWidget {
  final String? distributorType;
  final dynamic distributorInfo;

  final TextEditingController distributorController;
  final ValueChanged onDistributorChanged;

  const DistributorTile({
    super.key,
    required this.onDistributorChanged,
    required this.distributorType,
    required this.distributorInfo,
    required this.distributorController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: paddingDefault + 5,
      ),
      child: ExpansionPanelList.radio(
        animationDuration: const Duration(milliseconds: 600),
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: ((panelIndex, isExpanded) {
          distributorController.clear();
          context.read<MedicalBloc>().add(const ClearMedicalEvent());
        }),
        children: [0].map<ExpansionPanelRadio>((int headerItem) {
          return ExpansionPanelRadio(
            value: headerItem,
            backgroundColor: secondary,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                minVerticalPadding: 0,
                dense: true,
                key: Key(headerItem.toString()),
                tileColor: transparent,
                title: AppText(
                  distributorType?.toLowerCase() == 'distributor'
                      ? localization.distributor_select
                      : localization.warehouse_select,
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            body: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: paddingDefault),
              tileColor: white,
              dense: true,
              horizontalTitleGap: 0,
              isThreeLine: true,
              title: DistributorSearchWidget(
                distributorController: distributorController,
                type: distributorType,
              ),
              subtitle: DistributorListWidget(
                type: distributorType,
                distributorInfo: distributorInfo,
                distributorController: distributorController,
                onChanged: (selectedDistributorInfo) {
                  if (selectedDistributorInfo != null) {
                    onDistributorChanged(selectedDistributorInfo);
                  }
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
