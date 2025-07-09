import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';

class AddAreaTextFieldWidget extends StatelessWidget {
  const AddAreaTextFieldWidget({
    Key? key,
    required this.areaController,
    this.onSearchChanged,
    this.errorList,
    this.onAddArea,
  }) : super(key: key);

  final TextEditingController areaController;
  final dynamic onSearchChanged;
  final ValueChanged? onAddArea;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: areaController,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(
        Icons.search,
        color: primary,
      ),
      suffixIcon: TextButton.icon(
          icon: const Icon(Icons.cancel, color: primary),
          label: AppText(
            localization.cancel,
          ),
          onPressed: () async {
            onAddArea!(false);
          }),
      labelText: localization.area_add,
      hintText: localization.area_enter,
      errorText: errorList != null ? getError('area', errorList) : null,
      onChanged: (value) {
        if (value != '') {
          onSearchChanged();
        }
      },
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.area_required);
      },
    );
  }
}
