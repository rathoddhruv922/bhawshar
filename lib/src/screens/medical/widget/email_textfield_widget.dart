import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    Key? key,
    required this.emailController,
    this.errorList,
    required this.isRequired,
  }) : super(key: key);

  final TextEditingController emailController;
  final Map<String, String>? errorList;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        textEditingController: emailController,
        hintText: localization.email,
        labelText: localization.email_enter,
        errorText: errorList != null ? getError('email', errorList) : null,
        formValidator: (value) {
          return isRequired
              ? FormValidate.validateEmail(
                  value,
                  value!.trim().isEmpty
                      ? localization.email_required
                      : localization.email_invalid)
              : null;
        });
  }
}
