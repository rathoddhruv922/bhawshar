import 'dart:async';

import 'package:bhawsar_chemical/business_logic/cubit/connectivity/internet_cubit.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:geolocator/geolocator.dart' as status;
import '../../constants/app_const.dart';
import '../../helper/app_helper.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';
import 'app_snackbar_toast.dart';
import 'app_switcher_widget.dart';
import 'app_text.dart';

class AppButtonWithLocation extends StatefulWidget {
  final String btnText;
  final Color? btnColor;

  final Color? btnTextColor;
  final double? btnFontSize;
  final double? btnHeight;
  final double? btnWidth;
  final double? btnRadius;
  final FontWeight? btnFontWeight;
  final Function()? onBtnClick;
  const AppButtonWithLocation(
      {Key? key,
      required this.btnText,
      this.btnColor,
      this.btnTextColor,
      this.btnFontSize,
      this.btnHeight,
      this.btnWidth,
      this.btnRadius,
      this.btnFontWeight,
      required this.onBtnClick})
      : super(key: key);

  @override
  State<AppButtonWithLocation> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButtonWithLocation>
    with WidgetsBindingObserver {
  bool isLocationEnabled = false;
  bool appLocationStatus = false;
  bool deviceLocationStatus = false;
  late StreamSubscription<status.ServiceStatus> serviceStatusStream;
  @override
  void initState() {
    _updateStatus();
    WidgetsBinding.instance.addObserver(this);
    serviceStatusStream = Geolocator.getServiceStatusStream()
        .listen((status.ServiceStatus locationStatus) {
      if (locationStatus == status.ServiceStatus.disabled) {
        setState(() {
          deviceLocationStatus = false;
        });
      } else {
        setState(() {
          deviceLocationStatus = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    serviceStatusStream.cancel();
    super.dispose();
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocationServiceStatus().then((status) {
        if (mounted) {
          setState(() {
            appLocationStatus = status;
          });
        }
      });
    }
  }

  void _updateStatus() async {
    await getLocationServiceStatus().then((value) {
      if (value == false) {
        myToastMsg(
          localization.location_permission_request,
          isError: true,
        );
      }
      if (mounted) {
        setState(() {
          appLocationStatus = value;
        });
      }
    });

    Geolocator.isLocationServiceEnabled().then((value) {
      if (value == false) {
        myToastMsg(
          localization.location_enabled,
          isError: true,
        );
      }
      if (mounted) {
        setState(() {
          deviceLocationStatus = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state is InternetConnected
                        ? widget.btnColor ?? primary
                        : grey,
                    disabledForegroundColor: greyLight,
                    minimumSize:
                        Size(widget.btnWidth ?? 88.sp, widget.btnHeight ?? 47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.btnRadius ?? 33)),
                    ),
                  ),
                  onPressed: (state is InternetConnected &&
                          appLocationStatus &&
                          deviceLocationStatus)
                      ? widget.onBtnClick
                      : null,
                  child: AppText(
                    widget.btnText,
                    fontSize: widget.btnFontSize ?? 17.sp,
                    color: (state is InternetConnected &&
                            appLocationStatus &&
                            deviceLocationStatus)
                        ? widget.btnTextColor ?? secondary
                        : grey,
                    fontWeight: widget.btnFontWeight ?? FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: appLocationStatus && deviceLocationStatus ? false : true,
              child: InkWell(
                onTap: () async {
                  deviceLocationStatus
                      ? await Geolocator.openAppSettings()
                      : await Geolocator.openLocationSettings();
                },
                child: AppSwitcherWidget(
                  animationType: 'slide',
                  child: appLocationStatus && deviceLocationStatus
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: paddingSmall),
                          child: AppText(
                            deviceLocationStatus
                                ? '${localization.app_location_permission_request}. Click here...'
                                : '${localization.location_permission_request}. Click here...',
                            textAlign: TextAlign.center,
                            color: errorRed,
                            isUnderline: true,
                          ),
                        ),
                ),
              ),
            ),
            const AppSpacerHeight(
              height: 5,
            ),
            AppSwitcherWidget(
              animationType: "slide",
              child: state is InternetDisconnected
                  ? AppText(localization.network_error,
                      textAlign: TextAlign.center, color: errorRed)
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
