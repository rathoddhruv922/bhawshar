import 'package:bhawsar_chemical/src/screens/drawer/widget/confirm_password_textfield_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/new_password_textfield_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/old_password_textfield_widget.dart';
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

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController oldPwdController = TextEditingController();
    TextEditingController newPwdController = TextEditingController();
    TextEditingController confirmPwdController = TextEditingController();
    final GlobalKey<FormState> oldPwdFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> newPwdFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> confirmPwdFormKey = GlobalKey<FormState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        AppText(
          localization.password_change,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
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
                key: oldPwdFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: OldPasswordFieldWidget(
                  oldPwdController: oldPwdController,
                ),
              ),
              const SizedBox(height: 15),
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
                      showAnimatedDialog(navigationKey.currentContext!,
                          const AppDialogLoader());
                    } else if (state.status == AuthStateStatus.updated) {
                      Navigator.pop(context);
                      await Workmanager().cancelAll();
                      String? locale = await userBox.get('locale');
                      await userBox.clear();
                      await changeFieldOfWork(true);
                      await userBox.put('isAllPermissionAllowed', true);
                      await userBox.put('locale', locale);
                      mySnackbar(state.msg.toString());
                      navigationKey.currentState
                          ?.restorablePushNamedAndRemoveUntil(
                              RouteList.login, (route) => false);
                    } else if (state.status == AuthStateStatus.failure) {
                      Navigator.pop(context);
                      mySnackbar(state.msg.toString(), isError: true);
                    }
                    return;
                  },
                  child: AppButtonWithLocation(
                    btnText: localization.password_change,
                    btnFontWeight: FontWeight.bold,
                    onBtnClick: () async {
                      hideKeyboard();
                      oldPwdFormKey.currentState!.validate();
                      newPwdFormKey.currentState!.validate();
                      confirmPwdFormKey.currentState!.validate();
                      if (oldPwdFormKey.currentState!.validate() &&
                          newPwdFormKey.currentState!.validate() &&
                          confirmPwdFormKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              ChangePasswordEvent(
                                oldPassword: oldPwdController.text.trim(),
                                newPassword: newPwdController.text.trim(),
                                confirmPassword:
                                    confirmPwdController.text.trim(),
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
                            child: AppText(localization.network_error,
                                textAlign: TextAlign.center, color: errorRed),
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
