import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class MobileTextFieldWidget extends StatelessWidget {
  const MobileTextFieldWidget({
    Key? key,
    required this.mobileController,
    required this.isRequired,
    this.errorList,
    this.removeCallBack,
    this.index,
  }) : super(key: key);

  final TextEditingController mobileController;
  final Map<String, String>? errorList;
  final void Function()? removeCallBack;
  final int? index;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: mobileController,
      labelText: localization.mobile,
      hintText: localization.mobile_enter,
      errorText: errorList != null ? getError('mobile', errorList) : null,
      keyboardType: isIOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number,
      inputTextFormatter: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      suffixIcon: index != 0
          ? IconButton(
              icon: Icon(Icons.close),
              onPressed: removeCallBack,
            )
          : null,
      formValidator: (value) {
        if (!isRequired && value == '') {
          return null;
        } else if (value!.isEmpty) {
          return FormValidate.requiredField(
              value, localization.mobile_required);
        } else {
          return FormValidate.checkLength(
              value, 10, localization.mobile_invalid);
        }
      },
    );
  }
}
