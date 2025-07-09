import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class AddressTextFieldWidget extends StatelessWidget {
  const AddressTextFieldWidget({
    Key? key,
    required this.buildingNameController,
    this.errorList,
    required this.isRequired,
  }) : super(key: key);

  final TextEditingController buildingNameController;
  final Map<String, String>? errorList;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: buildingNameController,
      labelText: localization.address,
      maxLine: 5,
      minLine: 2,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      hintText: localization.address_enter,
      errorText: errorList != null ? getError('address', errorList) : null,
      formValidator: (value) {
        return isRequired
            ? FormValidate.requiredField(value!, localization.address_required)
            : null;
      },
    );
  }
}
