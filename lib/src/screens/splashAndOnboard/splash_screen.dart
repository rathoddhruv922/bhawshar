import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../business_logic/bloc/auth/auth_bloc.dart';
import '../../../constants/enums.dart';
import '../../router/route_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin, RestorationMixin {
  RestorableBool _loginScreenState = RestorableBool(true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  String get restorationId => 'splash_screen_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_loginScreenState, 'splash_screen_state');
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        final initialRoute = await getInitialRoute();
        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
        final didNotificationLaunchApp = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
        if (state.status == AuthStateStatus.authenticated) {
          if (!initialRoute.contains("/password/reset")) {
            Navigator.of(context).restorablePushReplacementNamed(RouteList.home);
            await Future.delayed(Duration.zero);
            if (didNotificationLaunchApp) {
              Navigator.of(context).restorablePushNamed(RouteList.reminder);
            }
          } else if (initialRoute.contains("/password/reset")) {
            Navigator.of(context).restorablePushNamedAndRemoveUntil(RouteList.resetPassword, (route) => false);
          }
        } else if (state.status == AuthStateStatus.unAuthenticated) {
          final isAllPermissionAllowed = await userBox.get('isAllPermissionAllowed');
          if (isAllPermissionAllowed == true && !initialRoute.contains("/password/reset")) {
            Navigator.of(context).restorablePushReplacementNamed(RouteList.login);
          } else if (didNotificationLaunchApp) {
            Navigator.of(context).restorablePushNamed(RouteList.reminder);
          } else if (initialRoute.contains("/password/reset")) {
            Navigator.of(context).restorablePushNamedAndRemoveUntil(RouteList.resetPassword, (route) => false);
          } else if (state.status != AuthStateStatus.loading) {
            Navigator.of(context).restorablePushReplacementNamed(RouteList.permission);
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 200,
                width: 200,
                matchTextDirection: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
