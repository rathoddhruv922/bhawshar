import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  const PhoneTextFieldWidget({
    Key? key,
    required this.phoneController,
    this.errorList,
    required this.isRequired,
  }) : super(key: key);

  final TextEditingController phoneController;
  final Map<String, String>? errorList;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: phoneController,
      labelText: localization.phone,
      hintText: localization.phone_enter,
      errorText: errorList != null ? getError('phone', errorList) : null,
      textInputAction: TextInputAction.done,
      keyboardType: isIOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.phone,
      formValidator: (value) {
        return isRequired
            ? FormValidate.requiredField(value!, localization.phone_required)
            : null;
      },
      inputTextFormatter: [
        FilteringTextInputFormatter.allow(RegExp("[0-9+]")),
      ],
    );
  }
}
