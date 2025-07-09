import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../helper/app_formatter.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class GSTTextFieldWidget extends StatelessWidget {
  const GSTTextFieldWidget({
    Key? key,
    required this.gstController,
    this.errorList,
    required this.gstType,
    required this.isRequired,
  }) : super(key: key);

  final TextEditingController gstController;
  final Map<String, String>? errorList;
  final String? gstType;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return gstType == 'GST'
        ? AppTextField(
            textEditingController: gstController,
            labelText: localization.GST,
            hintText: localization.GST_enter,
            errorText: errorList != null ? getError('gst', errorList) : null,
            inputTextFormatter: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp("[0-9A-Za-z]")),
            ],
            formValidator: (value) {
              if (!isRequired && value == '') {
                return null;
              } else if (value!.isEmpty) {
                return FormValidate.requiredField(
                    value, localization.GST_required);
              } else {
                return FormValidate.checkLength(
                    value, 15, localization.GST_invalid);
              }
            },
          )
        : AppTextField(
            textEditingController: gstController,
            labelText: localization.PAN,
            hintText: localization.PAN_enter,
            errorText: errorList != null ? getError('gst', errorList) : null,
            inputTextFormatter: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp("[0-9A-Za-z]")),
            ],
            formValidator: (value) {
              if (!isRequired && value == '') {
                return null;
              } else if (value!.isEmpty) {
                return FormValidate.requiredField(
                    value, localization.PAN_required);
              } else {
                return FormValidate.checkLength(
                    value, 10, localization.PAN_invalid);
              }
            },
          );
  }
}
