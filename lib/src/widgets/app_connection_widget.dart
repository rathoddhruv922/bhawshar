//disable This widget is return network error if any else return child widget
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/connectivity/internet_cubit.dart';
import '../../main.dart';
import 'app_no_internet_widget.dart';
import 'app_switcher_widget.dart';
import 'app_text.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key, this.child, this.isShowAnimation = false});
  final Widget? child;
  final bool? isShowAnimation;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        return AppSwitcherWidget(
          animationType: 'scale',
          child: state is InternetDisconnected
              ? !isShowAnimation!
                  ? Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: AppText(localization.network_error,
                          textAlign: TextAlign.center))
                  : const NoInternetWidget()
              : child ?? const SizedBox(),
        );
      },
    );
  }
}
