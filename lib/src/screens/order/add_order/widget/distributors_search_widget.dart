import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../business_logic/bloc/medical/medical_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_text_field.dart';

class DistributorSearchWidget extends StatelessWidget {
  const DistributorSearchWidget({
    super.key,
    required this.type,
    required this.distributorController,
  });
  final String? type;
  final TextEditingController distributorController;
  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    String? lastInputValue = '';

    onDistributorSearchChanged() {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (distributorController.text.trim() != '') {
          BlocProvider.of<MedicalBloc>(context).add(
            SearchMedicalEvent(
                searchKeyword: distributorController.text.toString(),
                type: type),
          );
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.only(top: paddingDefault),
      child: AppTextField(
          textEditingController: distributorController,
          fillColor: greyLight,
          isShowShadow: false,
          prefixIcon: const Icon(
            Icons.search,
            color: primary,
          ),
          suffixIcon: TextButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            onPressed: () {
              distributorController.clear();
              context.read<MedicalBloc>().add(const ClearMedicalEvent());
            },
            child: AppText(
              localization.clear,
              fontWeight: FontWeight.bold,
            ),
          ),
          hintText: type?.toLowerCase() == 'distributor'
              ? localization.distributor_search
              : localization.warehouse_search,
          labelText: type?.toLowerCase() == 'distributor'
              ? localization.distributor_search
              : localization.warehouse_search,
          textInputAction: TextInputAction.search,
          onFieldSubmit: (value) async {},
          onChanged: (value) async {
            if (value != '') {
              if (lastInputValue != value) {
                lastInputValue = value;
                onDistributorSearchChanged();
              }
            }
          }),
    );
  }
}
