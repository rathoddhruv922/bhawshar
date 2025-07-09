import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';

class StateTextFieldWidget extends StatelessWidget {
  const StateTextFieldWidget({
    Key? key,
    required this.stateController,
    this.onSearchChanged,
    this.errorList,
    this.onAddState,
    required this.globalAreaAccess,
    this.isAddState = false,
    this.isStateFound = false,
  }) : super(key: key);

  final TextEditingController stateController;
  final dynamic onSearchChanged;
  final ValueChanged? onAddState;
  final bool isStateFound, isAddState, globalAreaAccess;

  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: stateController,
      prefixIcon: Icon(
        Icons.search,
        color:
            (isAddState && !isStateFound && globalAreaAccess) ? grey : primary,
      ),
      fillColor: (isAddState && !isStateFound && globalAreaAccess)
          ? greyLight.withOpacity(0.1)
          : null,
      readOnly: (isAddState && !isStateFound && globalAreaAccess),
      suffixIcon: AppSwitcherWidget(
        durationInMiliSec: 800,
        animationType: 'slide',
        child: (isStateFound || !globalAreaAccess)
            ? const SizedBox.shrink()
            : TextButton.icon(
                icon: const Icon(Icons.add, color: primary),
                label: AppText(localization.add),
                onPressed: () async {
                  isAddState ? null : onAddState!(true);
                }),
      ),
      labelText: localization.state,
      hintText: localization.state_enter,
      errorText: errorList != null ? getError('state', errorList) : null,
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
        return FormValidate.requiredField(value!, localization.state_required);
      },
    );
  }
}
