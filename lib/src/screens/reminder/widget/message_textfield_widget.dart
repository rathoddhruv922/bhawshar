import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class MessageTextFieldWidget extends StatelessWidget {
  const MessageTextFieldWidget({
    Key? key,
    required this.msgController,
    required this.formKey,
    this.errorList,
  }) : super(key: key);

  final TextEditingController msgController;
  final Map<String, String>? errorList;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: msgController,
      labelText: localization.message,
      hintText: localization.message_enter,
      maxLine: 10,
      minLine: 2,
      onChanged: (value) {
        formKey.currentState?.validate();
      },
      errorText: errorList != null ? getError('message', errorList) : null,
      textInputAction: TextInputAction.done,
      formValidator: (value) {
        return FormValidate.requiredField(
            value!, localization.message_required);
      },
    );
  }
}
