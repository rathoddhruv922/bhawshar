import 'dart:convert';

import 'package:bhawsar_chemical/business_logic/bloc/auth/auth_bloc.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/src/screens/auth/widget/logo_widget.dart';
import 'package:bhawsar_chemical/src/screens/common/common_container_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_animated_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_button_with_location.dart';
import 'package:bhawsar_chemical/src/widgets/app_connection_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog_loader.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../../generated/l10n.dart';
import '../../widgets/app_snackbar_toast.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    var s = S.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is InternetDisconnected) {
            mySnackbar(s.network_error);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 100.h - 45,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
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
                            "Please check your email and enter the OTP.",
                            color: grey,
                          ),
                          const AppSpacerHeight(height: 15),
                          Form(
                            key: emailFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Pinput(
                              controller: phoneController,
                              hapticFeedbackType: HapticFeedbackType.lightImpact,
                              defaultPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  color: primary,
                                ),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: secondary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ConnectionStatus(
                            child: SizedBox(
                              width: 100.w,
                              child: BlocListener<AuthBloc, AuthState>(
                                listener: (context, state) async {
                                  if (state.status == AuthStateStatus.confirmingOtp) {
                                    showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
                                    await Future.delayed(Duration.zero);
                                  } else if (state.status == AuthStateStatus.confirmed) {
                                    Navigator.pop(context);
                                    var response = jsonDecode(state.msg.toString());
                                    mySnackbar(response["message"]);
                                    if (response["status"] == "success") {
                                      navigationKey.currentState?.pushReplacementNamed(RouteList.resetPassword, arguments: {
                                        "email": response["data"]["email"],
                                        "token": response["data"]["token"],
                                      });
                                    }
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
                                            ConfirmOtpEvent(
                                              otp: phoneController.text.trim(),
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
                  ),
                  AuthLogoWidget(isForgotPwdScreen: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('email', email));
  }
}
