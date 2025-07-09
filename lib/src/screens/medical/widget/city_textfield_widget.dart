import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';

class CityTextFieldWidget extends StatelessWidget {
  const CityTextFieldWidget({
    Key? key,
    required this.cityController,
    this.onSearchChanged,
    this.errorList,
    this.onAddCity,
    required this.globalAreaAccess,
    this.isAddCity = false,
    this.isCityFound = false,
  }) : super(key: key);

  final TextEditingController cityController;
  final dynamic onSearchChanged;
  final ValueChanged? onAddCity;
  final bool isCityFound, isAddCity, globalAreaAccess;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: cityController,
      prefixIcon: Icon(
        Icons.search,
        color: (isAddCity && !isCityFound && globalAreaAccess) ? grey : primary,
      ),
      fillColor: (isAddCity && !isCityFound && globalAreaAccess)
          ? greyLight.withOpacity(0.1)
          : null,
      readOnly: (isAddCity && !isCityFound && globalAreaAccess),
      suffixIcon: AppSwitcherWidget(
        durationInMiliSec: 800,
        animationType: 'slide',
        child: (isCityFound || !globalAreaAccess)
            ? const SizedBox.shrink()
            : TextButton.icon(
                icon: const Icon(Icons.add, color: primary),
                label: AppText(localization.add),
                onPressed: () async {
                  isAddCity ? null : onAddCity!(true);
                }),
      ),
      labelText: localization.city,
      hintText: localization.city_enter,
      errorText: errorList != null ? getError('city', errorList) : null,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        if (value != '') {
          onSearchChanged();
        }
      },
      onFieldSubmit: (value) {
        if (value != null && value.trim() != '') {
          onSearchChanged();
        }
      },
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.city_required);
      },
    );
  }
}
