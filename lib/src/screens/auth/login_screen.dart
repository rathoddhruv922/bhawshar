import 'package:bhawsar_chemical/business_logic/cubit/connectivity/internet_cubit.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/auth/widget/login_form_widget.dart';
import 'package:bhawsar_chemical/src/screens/auth/widget/logo_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_snackbar_toast.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocListener<InternetCubit, InternetState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is InternetDisconnected) {
            mySnackbar(localization.network_error);
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: ShowUpgradeAlert(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AuthFormWidget(),
                  AuthLogoWidget(),
                  kDebugMode
                      ? Positioned(
                          bottom: 0,
                          child: SafeArea(
                            child: AppText(
                              host.contains('uat')
                                  ? 'UAT Server'
                                  : host.contains('tp-team')
                                      ? 'Staging Server'
                                      : 'Live Server',
                              color: red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
