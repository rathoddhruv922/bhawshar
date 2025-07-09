import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';

import '../../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

class DrawerLogoutWidget extends StatelessWidget {
  const DrawerLogoutWidget({Key? key}) : super(key: key);

  Future<String?> getVersion() async {
    // Perform asynchronous operation to get the app version
    return await getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<InternetCubit, InternetState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButtonWithLocation(
                    btnText: S.of(context).logout,
                    btnWidth: 60.w,
                    btnTextColor: state is InternetConnected ? secondary : grey,
                    onBtnClick: state is InternetConnected
                        ? () {
                            appAlertDialog(
                              context,
                              AppText(
                                S.of(context).confirmation,
                                textAlign: TextAlign.center,
                                fontSize: 17,
                              ),
                              () async {
                                Navigator.of(context).pop();
                                context.read<AuthBloc>().add(LogOutEvent());
                                // Position location = await determinePosition();
                                // String? fieldOfWork =
                                //     await userInfo.value['field_of_work'] ??
                                //         'MKT';
                                // fieldOfWork ??= 'MKT';
                                // Map<String, dynamic>? locationData = {
                                //   "lat": location.latitude,
                                //   "lng": location.longitude,
                                //   "field_of_work":
                                //       ((fieldOfWork == 'WFH') ? 'WFH' : 'MKT'),
                                // };
                                // locationData.forEach((key, value) async {
                                //   await Future.delayed(Duration.zero);
                                // });
                                // print(location);
                                // Navigator.of(context).pop();
                              },
                              () => Navigator.of(context).pop(),
                            );
                          }
                        : null,
                  ),
                  const AppSpacerHeight(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('Version '),
                      FutureBuilder<String?>(
                        future: getVersion(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While waiting for the version, show a loading indicator
                            return AppLoader();
                          } else if (snapshot.hasError) {
                            // If an error occurred while getting the version, show an error message
                            return AppText('Error: ${snapshot.error}');
                          } else {
                            // Version retrieved successfully, display it using AppText
                            final appVersion = snapshot.data;
                            return AppText(
                              appVersion ?? '',
                              fontWeight: FontWeight.bold,
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
