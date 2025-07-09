import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text_field.dart';

class LoginPasswordFieldWidget extends StatelessWidget {
  const LoginPasswordFieldWidget({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: AppTextField(
          textEditingController: passwordController,
          prefixIcon: const Icon(
            Icons.lock,
            color: primary,
          ),
          isShowShadow: false,
          fillColor: greyLight,
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
          hintText: localization.password_enter,
          labelText: labelText(localization.password),
          isPasswordField: true,
          obscureText: obscureText,
          formValidator: (value) {
            if (value == null || value.trim().isEmpty) {
              return localization.password_required;
            }
            return null;
          },
        ),
      );
    });
  }
}
