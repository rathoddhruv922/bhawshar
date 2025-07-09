import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';
import '../../../../utils/form_validator.dart';

class AddStateTextFieldWidget extends StatelessWidget {
  const AddStateTextFieldWidget({
    Key? key,
    required this.stateController,
    this.onSearchChanged,
    this.errorList,
    this.onCancelState,
  }) : super(key: key);

  final TextEditingController stateController;
  final dynamic onSearchChanged;
  final ValueChanged? onCancelState;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: stateController,
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
            onCancelState!(false);
          }),
      labelText: labelText('Add new state'),
      hintText: localization.state_enter,
      errorText: errorList != null ? getError('state', errorList) : null,
      onChanged: (value) {
        if (value != '') {
          onSearchChanged();
        }
      },
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.state_required);
      },
    );
  }
}
