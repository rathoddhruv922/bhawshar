import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class ConfirmPasswordFieldWidget extends StatelessWidget {
  const ConfirmPasswordFieldWidget({
    Key? key,
    required this.newPwdController,
    required this.confirmPwdController,
  }) : super(key: key);

  final TextEditingController confirmPwdController, newPwdController;

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: AppTextField(
          textEditingController: confirmPwdController,
          prefixIcon: const Icon(
            Icons.lock,
            color: primary,
          ),
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: primary,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
          hintText: localization.password_confirm,
          labelText: localization.password_enter_confirm,
          isPasswordField: true,
          obscureText: obscureText,
          formValidator: (value) {
            return FormValidate.matchPassword(
              newPwdController.text.trim(),
              value ?? "",
            );
          },
        ),
      );
    });
  }
}
