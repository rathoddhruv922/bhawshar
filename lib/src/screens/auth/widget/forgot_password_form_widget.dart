import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_animated_dialog.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_connection_widget.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';
import 'email_textfield_widget.dart';

class ForgotPasswordFormWidget extends StatelessWidget {
  const ForgotPasswordFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();

    return Positioned(
      top: 100.h <= 667 ? 28.5.h : 30.h,
      left: 0,
      right: 0,
      child: CommonContainer(
        width: 100.w,
        margin: const EdgeInsets.symmetric(
          horizontal: paddingExtraLarge,
        ),
        padding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingSmall),
        radius: 33,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: paddingLarge,
            horizontal: paddingExtraSmall,
          ),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const AppSpacerHeight(height: 85),
            CustomAppBar(
              bg: transparent,
              AppText(
                localization.password_forgot,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
              leading: CircleAvatar(
                backgroundColor: greyLight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: getBackArrow(),
                  color: primary,
                ),
              ),
            ),
            const AppSpacerHeight(height: 15),
            AppText(
              localization.send_link_message,
              color: grey,
            ),
            const AppSpacerHeight(height: 15),
            Form(
              key: emailFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: LoginEmailFieldWidget(emailController: emailController),
            ),
            const SizedBox(height: 15),
            ConnectionStatus(
              child: SizedBox(
                width: 100.w,
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.status == AuthStateStatus.sendingMail) {
                      showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
                      await Future.delayed(Duration.zero);
                    } else if (state.status == AuthStateStatus.sended) {
                      Navigator.pop(context);
                      navigationKey.currentState
                          ?.pushReplacementNamed(RouteList.otpScreen, arguments: emailController.text.trim());
                      mySnackbar(state.msg.toString());
                    } else if (state.status == AuthStateStatus.failure) {
                      mySnackbar(state.msg.toString(), isError: true);
                    }
                    return;
                  },
                  child: AppButtonWithLocation(
                    btnText: "Submit",
                    btnFontWeight: FontWeight.bold,
                    onBtnClick: () {
                      hideKeyboard();
                      emailFormKey.currentState!.validate();
                      if (emailFormKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              ForgotPasswordEvent(
                                email: emailController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
