import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text_field.dart';

class OldPasswordFieldWidget extends StatelessWidget {
  const OldPasswordFieldWidget({
    Key? key,
    required this.oldPwdController,
  }) : super(key: key);

  final TextEditingController oldPwdController;

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: AppTextField(
          textEditingController: oldPwdController,
          prefixIcon: const Icon(
            Icons.lock,
            color: primary,
          ),
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
          hintText: localization.password_old,
          labelText: localization.password_enter_old,
          isPasswordField: true,
          obscureText: obscureText,
          formValidator: (value) {
            if (value == null || value.trim().isEmpty) {
              return localization.password_old_required;
            }
            return null;
          },
        ),
      );
    });
  }
}
