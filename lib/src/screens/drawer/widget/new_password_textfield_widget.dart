import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text_field.dart';

class NewPasswordFieldWidget extends StatelessWidget {
  const NewPasswordFieldWidget({
    Key? key,
    required this.newPwdController,
  }) : super(key: key);

  final TextEditingController newPwdController;

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: AppTextField(
          textEditingController: newPwdController,
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
          hintText: localization.password_new,
          labelText: localization.password_enter_new,
          isPasswordField: true,
          obscureText: obscureText,
          formValidator: (value) {
            if (value == null || value.trim().isEmpty) {
              return localization.password_new_required;
            }
            return null;
          },
        ),
      );
    });
  }
}
