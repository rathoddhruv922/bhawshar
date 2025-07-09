import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class LoginEmailFieldWidget extends StatelessWidget {
  const LoginEmailFieldWidget({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: emailController,
      prefixIcon: const Icon(
        Icons.email,
        color: primary,
      ),
      isShowShadow: false,
      fillColor: greyLight,
      hintText: localization.email_enter,
      labelText: labelText(localization.email),
      formValidator: (value) {
        return FormValidate.validateEmail(
            value,
            value!.trim().isEmpty
                ? localization.email_required
                : localization.email_invalid);
      },
    );
  }
}
