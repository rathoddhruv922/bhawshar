import 'package:bhawsar_chemical/src/screens/auth/widget/password_textfield_widget.dart';
import 'package:flutter/foundation.dart';
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
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';
import 'email_textfield_widget.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({super.key});

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> with RestorationMixin {
  RestorableBool _loginScreenState = RestorableBool(true);
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> pwdFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  String get restorationId => 'login_screen_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_loginScreenState, 'login_screen_state_key');
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // emailController =
      //     TextEditingController(text: 'shashikantchaudhari272@gmail.com');
      // passwordController = TextEditingController(text: 'Bhawsar@123');

      emailController = TextEditingController(text: 'pankaj.patel@tpots.co');
      passwordController = TextEditingController(text: 'qwerty');
    }
    return Positioned(
      top: 100.h <= 667 ? 25.h : 30.h,
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
            AppText(
              localization.login,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
            const AppSpacerHeight(height: 10),
            AppText(
              localization.login_account,
              color: grey,
            ),
            const AppSpacerHeight(height: 30),
            Form(
              key: emailFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: LoginEmailFieldWidget(emailController: emailController),
            ),
            const SizedBox(height: 15),
            Form(
              key: pwdFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: LoginPasswordFieldWidget(
                passwordController: passwordController,
              ),
            ),
            const AppSpacerHeight(),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  navigationKey.currentState!.restorablePushNamed(RouteList.forgotPassword);
                },
                child: AppText(localization.password_forgot_ask),
              ),
            ),
            const AppSpacerHeight(),
            SizedBox(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (previous, current) => previous != current,
                    listener: (context, state) async {
                      if (state.status == AuthStateStatus.loading) {
                        showAnimatedDialog(context, const AppDialogLoader());
                        await Future.delayed(Duration.zero);
                      } else if (state.status == AuthStateStatus.authenticated) {
                        Navigator.pop(context);
                        await Future.delayed(Duration.zero);
                        navigationKey.currentState!.restorablePushReplacementNamed(RouteList.home);
                        return;
                      } else if (state.status == AuthStateStatus.unAuthenticated ||
                          (state.status == AuthStateStatus.failure && state.status != AuthStateStatus.updating)) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        mySnackbar(state.msg.toString(), isError: true);
                      }
                      return;
                    },
                    child: AppButtonWithLocation(
                      btnText: localization.login,
                      btnFontWeight: FontWeight.bold,
                      btnTextColor: secondary,
                      onBtnClick: () {
                        hideKeyboard();
                        emailFormKey.currentState!.validate();
                        pwdFormKey.currentState!.validate();
                        if (emailFormKey.currentState!.validate() && pwdFormKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                LoginEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
