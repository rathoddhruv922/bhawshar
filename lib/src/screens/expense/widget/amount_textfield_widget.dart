import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class AmountTextFieldWidget extends StatelessWidget {
  const AmountTextFieldWidget({
    Key? key,
    required this.expenseAmountController,
    this.errorList,
  }) : super(key: key);

  final TextEditingController expenseAmountController;
  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: expenseAmountController,
      labelText: localization.amount,
      hintText: localization.amount_enter,
      keyboardType: defaultTargetPlatform == TargetPlatform.iOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number,
      inputTextFormatter: [
        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
      ],
      errorText: errorList != null ? getError('amount', errorList) : null,
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.amount_required);
      },
    );
  }
}
