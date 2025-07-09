import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';

class AddCityTextFieldWidget extends StatelessWidget {
  const AddCityTextFieldWidget({
    Key? key,
    required this.cityController,
    this.onSearchChanged,
    this.errorList,
    this.onAddCity,
  }) : super(key: key);

  final TextEditingController cityController;
  final dynamic onSearchChanged;
  final ValueChanged? onAddCity;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: cityController,
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
            onAddCity!(false);
          }),
      labelText: localization.city_add,
      hintText: localization.city_enter,
      errorText: errorList != null ? getError('city', errorList) : null,
      onChanged: (value) {
        if (value != '') {
          onSearchChanged();
        }
      },
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.city_required);
      },
    );
  }
}
