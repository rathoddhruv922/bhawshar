import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class ShopNameTextFieldWidget extends StatelessWidget {
  const ShopNameTextFieldWidget({
    Key? key,
    required this.nameController,
    required this.isRequired,
    this.errorList,
  }) : super(key: key);

  final TextEditingController nameController;
  final Map<String, String>? errorList;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: nameController,
      labelText: localization.name,
      textInputAction: TextInputAction.next,
      hintText: localization.name_enter,
      errorText: errorList != null ? getError('name', errorList) : null,
      formValidator: (value) {
        return isRequired
            ? FormValidate.requiredField(value!, localization.name_required)
            : null;
      },
    );
  }
}
