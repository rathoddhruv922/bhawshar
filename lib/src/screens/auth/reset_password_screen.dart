// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:workmanager/workmanager.dart';

import '../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../../constants/app_const.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../router/route_list.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_button_with_location.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_switcher_widget.dart';
import '../../widgets/app_text.dart';
import '../drawer/widget/confirm_password_textfield_widget.dart';
import '../drawer/widget/new_password_textfield_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({super.key, required this.email, required this.token});

  @override
  Widget build(BuildContext context) {
    TextEditingController newPwdController = TextEditingController();
    TextEditingController confirmPwdController = TextEditingController();
    final GlobalKey<FormState> newPwdFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> confirmPwdFormKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        AppText(
          'Reset Password',
          color: primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppSpacerHeight(),
              Form(
                key: newPwdFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: NewPasswordFieldWidget(
                  newPwdController: newPwdController,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: confirmPwdFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ConfirmPasswordFieldWidget(
                  newPwdController: newPwdController,
                  confirmPwdController: confirmPwdController,
                ),
              ),
              const AppSpacerHeight(height: paddingExtraLarge),
              SizedBox(
                width: 100.w,
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.status == AuthStateStatus.updating) {
                      showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
                    } else if (state.status == AuthStateStatus.updated) {
                      Navigator.pop(context);
                      await Workmanager().cancelAll();
                      String? locale = await userBox.get('locale');
                      await userBox.clear();
                      await changeFieldOfWork(true);
                      await userBox.put('isAllPermissionAllowed', true);
                      await userBox.put('locale', locale);
                      mySnackbar(state.msg.toString());
                      navigationKey.currentState?.restorablePushNamedAndRemoveUntil(RouteList.login, (route) => false);
                    } else if (state.status == AuthStateStatus.failure) {
                      mySnackbar(state.msg.toString(), isError: true);
                      var token = await userBox.get('authToken');
                      if (token != null) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: AppButtonWithLocation(
                    btnText: "Reset Password",
                    btnFontWeight: FontWeight.bold,
                    onBtnClick: () async {
                      hideKeyboard();
                      //dynamic initialRoute = await getInitialRoute();
                      newPwdFormKey.currentState!.validate();
                      confirmPwdFormKey.currentState!.validate();
                      if (newPwdFormKey.currentState!.validate() && confirmPwdFormKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              ResetPasswordEvent(
                                token: token,
                                email: email,
                                newPassword: newPwdController.text.trim(),
                                confirmPassword: confirmPwdController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                ),
              ),
              BlocBuilder<InternetCubit, InternetState>(
                builder: (context, state) {
                  return AppSwitcherWidget(
                    animationType: 'scale',
                    child: state is InternetConnected
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: AppText(
                              localization.network_error,
                              textAlign: TextAlign.center,
                              color: errorRed,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
