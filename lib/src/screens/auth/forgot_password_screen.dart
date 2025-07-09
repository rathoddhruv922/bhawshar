import 'package:bhawsar_chemical/src/screens/auth/widget/forgot_password_form_widget.dart';
import 'package:bhawsar_chemical/src/screens/auth/widget/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../../generated/l10n.dart';
import '../../widgets/app_snackbar_toast.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({Key? key}) : super(key: key);

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
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  ForgotPasswordFormWidget(),
                  AuthLogoWidget(isForgotPwdScreen: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
