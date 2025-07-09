import 'package:bhawsar_chemical/src/screens/drawer/widget/drawer_header_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/drawer_item_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/drawer_logout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../constants/app_const.dart';
import '../../../constants/enums.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: white,
      child: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state.status == AuthStateStatus.loading) {
              showAnimatedDialog(context, const AppDialogLoader());
            } else if (state.status == AuthStateStatus.failure) {
              Navigator.pop(context);
              mySnackbar(state.msg.toString(), isError: true);
            } else if (state.status == AuthStateStatus.unAuthenticated) {
              Navigator.pop(context);
            }
            return;
          },
          child: const Padding(
            padding: EdgeInsets.all(paddingDefault),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                DrawerHeaderWidget(),
                DrawerItemWidget(),
                DrawerLogoutWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
