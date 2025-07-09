import 'dart:async';

import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/repositories/location_repository.dart';
import 'package:bhawsar_chemical/src/screens/auth/login_screen.dart';
import 'package:bhawsar_chemical/src/widgets/app_animated_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/utils/location_singleton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../../constants/enums.dart';
import '../../../generated/l10n.dart';
import '../../router/route_list.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_text.dart';
import '../drawer/drawer_screen.dart';
import 'widget/widgets.dart';

class ShowUpgradeAlert extends StatelessWidget {
  final Widget child;

  const ShowUpgradeAlert({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return isIOS
        ? child
        : UpgradeAlert(
            navigatorKey: navigationKey,
            upgrader: Upgrader(
              debugDisplayAlways: false,
              countryCode: "IN",
              debugLogging: false,
              durationUntilAlertAgain: Duration.zero,
              messages: UpgraderMessages(code: userBox.get('locale') ?? 'en'),
            ),
            child: child,
          );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStateStatus.unAuthenticated) {
          await Future.delayed(Duration.zero);
          await Workmanager().cancelAll();
          await updateTrackingStatus(0);
          String? locale = await userBox.get('locale');
          await userBox.clear();
          await changeFieldOfWork(true);
          await userBox.put('isAllPermissionAllowed', true);
          await userBox.put('locale', locale);
          navigationKey.currentState?.restorablePushNamedAndRemoveUntil(RouteList.login, (route) => false);
        }
      },
      //* show app update available popup
      child: ShowUpgradeAlert(
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            ValueListenableBuilder<Map>(
              valueListenable: userInfo,
              builder: (BuildContext context, value, widget) {
                return AppText(
                  '${greeting(context)}, ${value['name'].toString().toCapitalized()}',
                  fontWeight: FontWeight.bold,
                  color: primary,
                );
              },
            ),
            isCenterTile: false,
            leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.menu,
                  color: primary,
                  size: 23.sp,
                ),
                onPressed: () async {
                  scaffoldKey.currentState!.openDrawer();
                }),
            action: [
              ValueListenableBuilder<Map>(
                valueListenable: userInfo,
                builder: (BuildContext context, user, widget) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isIOS
                          ? SizedBox.shrink()
                          : ValueListenableBuilder<int>(
                              valueListenable: trackStatus,
                              builder: (BuildContext context, trackingStatus, widget) {
                                bool val = trackingStatus == 1 ? true : false;
                                final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return const Icon(
                                        Icons.check,
                                        color: white,
                                      );
                                    }
                                    return const Icon(Icons.close);
                                  },
                                );

                                return Theme(
                                  data: ThemeData(useMaterial3: true),
                                  child: SizedBox(
                                    height: 40,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Switch(
                                        thumbIcon: thumbIcon,
                                        activeColor: primary,
                                        thumbColor: WidgetStatePropertyAll<Color>(val ? primary : grey),
                                        value: val,
                                        onChanged: (bool value) {
                                          setState(() {
                                            val = value;
                                          });
                                          showLanguageSelectionDialog(context, trackingStatus, shouldChangeFieldOfWork.value);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      AppSpacerWidth(),
                      InkWell(
                        onTap: isIOS
                            ? () async {
                                showLanguageSelectionDialog(context, 0, shouldChangeFieldOfWork.value);
                              }
                            : null,
                        child: AppText(
                          user['field_of_work'].toString() == 'WFH' ? 'WFH' : 'MKT',
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              navigationKey.currentState?.pushNamed(RouteList.reminder).then((value) {
                                if (value == true) {}
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/svg/reminder.svg',
                              height: 20.sp,
                            ),
                          ),
                          Positioned(
                            // draw a red marble
                            top: 0.0,
                            right: 10.0,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              height: 25,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: red),
                              child: FittedBox(
                                child: ValueListenableBuilder(
                                  valueListenable: reminderCount,
                                  builder: (context, value, widget) {
                                    return AppText(
                                      '${reminderCount.value}',
                                      color: secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          drawer: const DrawerScreen(),
          drawerEnableOpenDragGesture: true,
          body: BlocListener<InternetCubit, InternetState>(
            listener: (context, state) {
              if (state is InternetDisconnected) {
                mySnackbar(S.of(context).network_error, isError: true);
              }
            },
            child: const HomeCategoryWidget(),
          ),
        ),
      ),
    );
  }
}

void showLanguageSelectionDialog(BuildContext context, int value, shouldShowChangeAlert) async {
  if (shouldShowChangeAlert && await userInfo.value['field_of_work'] != 'MKT') {
    final result = await showAnimatedDialog(
      context,
      FieldOfWorkSelection(),
      dismissible: true,
    );

    if (result != null) {
      await changeFieldOfWork(false);
      if (value == 0 && isAndroid) {
        LocationState().myBool = 1;
        startStopActionLocationApi();
        await Workmanager().initialize(callbackDispatcher, isInDebugMode: isDebugMode);
        //* WORK MANAGER FOR TRACKING LOCATION WHEN APP IS ON BACKGROUND
        await Workmanager().registerPeriodicTask(
          taskSendLocation,
          taskSendLocation,
          tag: androidTaskTag,
          frequency: const Duration(minutes: 15),
          initialDelay: const Duration(seconds: 1),
          existingWorkPolicy: ExistingWorkPolicy.append,
        );
        await updateTrackingStatus(1);
        //* END WORK MANAGER
      } else {
        isAndroid
            ? appAlertDialog(
                context,
                AppText(
                  S.of(context).confirmation,
                  textAlign: TextAlign.center,
                  fontSize: 17,
                ),
                () async {
                  Navigator.of(context).pop();
                  LocationState().myBool = 0;
                  await updateTrackingStatus(0);
                  await Workmanager().cancelAll();
                  startStopActionLocationApi();
                },
                () => Navigator.of(context).pop(),
              )
            : null;
      }
    }
  } else {
    if (value == 0 && isAndroid) {
      LocationState().myBool = 1;
      startStopActionLocationApi();
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: isDebugMode);
      //* WORK MANAGER FOR TRACKING LOCATION WHEN APP IS ON BACKGROUND
      await Workmanager().registerPeriodicTask(
        taskSendLocation,
        taskSendLocation,
        tag: androidTaskTag,
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 1),
        existingWorkPolicy: ExistingWorkPolicy.append,
      );
      await updateTrackingStatus(1);
      //* END WORK MANAGER
    } else {
      isAndroid
          ? appAlertDialog(
              context,
              AppText(
                S.of(context).confirmation,
                textAlign: TextAlign.center,
                fontSize: 17,
              ),
              () async {
                Navigator.of(context).pop();
                LocationState().myBool = 0;
                await updateTrackingStatus(0);
                await Workmanager().cancelAll();
                startStopActionLocationApi();
              },
              () => Navigator.of(context).pop(),
            )
          : null;
    }
  }
}

void startStopActionLocationApi() async {
  final locationRepository = LocationRepository();
  try {
    Response res = await locationRepository.sendCurrentLocation().then((value) {
      return value;
    });
    if (res.statusCode != 200) {
      if (res.data['message'] != null) {
        showCatchedError(res.data['message']);
      }
    }
  } on DioException catch (e) {
    LocationState().myBool = -1;
    if (e.response?.statusCode == 401) {
      await updateTrackingStatus(0);
      navigationKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  } catch (e) {
    String error = DioExceptions.getErrorMSg(await DioExceptions.getDioException(e));
    if (error.toString().contains('re-login') == true) {
      //! Force disabled tracking because token is expired
      await updateTrackingStatus(0);
      LocationState().myBool = -1;
    }
  }
}
