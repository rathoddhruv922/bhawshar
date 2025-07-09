import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class FeedbackDescriptionTextFieldWidget extends StatelessWidget {
  const FeedbackDescriptionTextFieldWidget({
    Key? key,
    required this.feedbackDescriptionController,
    this.errorList,
  }) : super(key: key);
  final TextEditingController feedbackDescriptionController;
  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: feedbackDescriptionController,
      labelText: localization.description,
      hintText: localization.description_enter,
      errorText: errorList != null ? getError('Description', errorList) : null,
      maxLine: 50,
      textInputAction: TextInputAction.done,
      minLine: 2,
      formValidator: (value) {
        return FormValidate.requiredField(
            value!, localization.description_required);
      },
    );
  }
}
