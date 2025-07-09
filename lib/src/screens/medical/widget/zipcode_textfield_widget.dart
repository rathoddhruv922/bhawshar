import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class ZipcodeTextFieldWidget extends StatelessWidget {
  const ZipcodeTextFieldWidget({
    Key? key,
    required this.zipCodeController,
    required this.isRequired,
    this.errorList,
  }) : super(key: key);

  final TextEditingController zipCodeController;
  final Map<String, String>? errorList;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: zipCodeController,
      labelText: localization.pin,
      hintText: localization.pin_enter,
      errorText: errorList != null ? getError('zip', errorList) : null,
      keyboardType: defaultTargetPlatform == TargetPlatform.iOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number,
      formValidator: (value) {
        if (!isRequired && value == '') {
          return null;
        } else if (value!.isEmpty) {
          return FormValidate.requiredField(value, localization.pin_required);
        } else {
          return FormValidate.checkLength(value, 6, localization.pin_invalid);
        }
      },
      inputTextFormatter: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
