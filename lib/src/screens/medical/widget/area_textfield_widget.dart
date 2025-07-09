import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';

import '../../../widgets/app_text_field.dart';
import '../../../../utils/form_validator.dart';

class AreaTextFieldWidget extends StatelessWidget {
  const AreaTextFieldWidget({
    Key? key,
    required this.areaController,
    this.onSearchChanged,
    this.errorList,
    this.onAddArea,
    required this.globalAreaAccess,
    this.isAddArea = false,
    this.isAreaFound = false,
  }) : super(key: key);

  final TextEditingController areaController;
  final dynamic onSearchChanged;
  final ValueChanged? onAddArea;
  final bool isAreaFound, isAddArea, globalAreaAccess;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: areaController,
      prefixIcon: Icon(
        Icons.search,
        color: (isAddArea && !isAreaFound && globalAreaAccess) ? grey : primary,
      ),
      fillColor: (isAddArea && !isAreaFound && globalAreaAccess)
          ? greyLight.withOpacity(0.1)
          : null,
      readOnly: (isAddArea && !isAreaFound && globalAreaAccess),
      suffixIcon: AppSwitcherWidget(
        durationInMiliSec: 800,
        animationType: 'slide',
        child: (isAreaFound || !globalAreaAccess)
            ? const SizedBox.shrink()
            : TextButton.icon(
                icon: const Icon(Icons.add, color: primary),
                label: AppText(localization.add),
                onPressed: () async {
                  isAddArea ? null : onAddArea!(true);
                }),
      ),
      labelText: localization.area,
      hintText: localization.area_enter,
      errorText: errorList != null ? getError('area', errorList) : null,
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
        return FormValidate.requiredField(value!, localization.area_required);
      },
    );
  }
}
