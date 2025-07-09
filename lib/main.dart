import 'dart:async';

import 'package:bhawsar_chemical/business_logic/bloc/add-expense-comment/add_expense_comment_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/area/area_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/auth/auth_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/city/city_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/expense/expense_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/from-area/from_area_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/get-expense/get_expense_by_id_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/medical/medical_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/product/product_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/reminder/reminder_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/report/report_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/state/state_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/to-area/to_area_bloc.dart';
import 'package:bhawsar_chemical/business_logic/cubit/connectivity/internet_cubit.dart';
import 'package:bhawsar_chemical/business_logic/cubit/locale_cubit/locale_cubit.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/repositories/address_repository.dart';
import 'package:bhawsar_chemical/data/repositories/expense_repository.dart';
import 'package:bhawsar_chemical/data/repositories/location_repository.dart';
import 'package:bhawsar_chemical/data/repositories/medical_repository.dart';
import 'package:bhawsar_chemical/data/repositories/order_repository.dart';
import 'package:bhawsar_chemical/data/repositories/product_repository.dart';
import 'package:bhawsar_chemical/data/repositories/reminder_repository.dart';
import 'package:bhawsar_chemical/data/repositories/report_repository.dart';
import 'package:bhawsar_chemical/generated/l10n.dart';
import 'package:bhawsar_chemical/helper/notification_helper.dart';
import 'package:bhawsar_chemical/simple_bloc_observer.dart';
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

import 'business_logic/bloc/client_setting/client_setting_bloc.dart';
import 'business_logic/bloc/comment/comment_bloc.dart';
import 'business_logic/bloc/feedback/feedback_bloc.dart';
import 'business_logic/bloc/order/order_bloc.dart';
import 'data/repositories/comment_repository.dart';
import 'data/repositories/feedback_repository.dart';
import 'helper/app_helper.dart';
import 'src/router/app_router.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    final locationRepository = LocationRepository();
    try {
      final applicationDocumentDir = await path_provider.getApplicationDocumentsDirectory();
      await Hive.initFlutter(applicationDocumentDir.path);
      userBox = await Hive.openBox('userBox');
      switch (task) {
        case taskSendLocation:
          Response res = await locationRepository.sendCurrentLocation().then((value) {
            return value;
          });
          if (res.statusCode == 200) {
            return Future.value(true);
          } else if (res.statusCode == 401) {
            return Future.value(true);
          } else {
            showCatchedError(res.data['message']);
            return Future.value(false);
          }
      }
    } catch (e) {
      return Future.value(false);
    }
    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  try {
    if (message.notification!.title!.toLowerCase().contains("reminder") ||
        message.notification!.title!.toLowerCase().contains("client")) {
      navigationKey.currentState?.pushNamedAndRemoveUntil(RouteList.reminder, (route) => false);
    }
  } catch (e) {
    rethrow;
  }
  if (isDebugMode) {
    Logger().i("onTopLevelBackground: ${message.notification?.title}\n${message.notification?.body}");
  }
}

//* hive section
late Box userBox;

//* internet-connection flag
bool hasConnection = false;

//* localization
var localization = S();

//* Global valueNotifier for update UI when their value update from anywhere in app
ValueNotifier<int> reminderCount = ValueNotifier<int>(0);
ValueNotifier<int> openFeedbackCount = ValueNotifier<int>(0);
ValueNotifier<int> trackStatus = ValueNotifier<int>(0);

//* update user field of work
ValueNotifier<bool> shouldChangeFieldOfWork = ValueNotifier<bool>(true);

//* auth user detail
ValueNotifier<Map<dynamic, dynamic>> userInfo = ValueNotifier<Map<dynamic, dynamic>>({});

//* work manager taskName & taskYag
const taskSendLocation = "sendLocation";
const androidTaskTag = 'AndroidTaskTag';

//* Global navigator key
final GlobalKey<NavigatorState> navigationKey = GlobalKey();

Future<void> main() async {
  await loadInitConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: RepositoryProvider(
        create: (context) => LocationRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc()..add(CheckLoginEvent())),
            BlocProvider(create: (context) => InternetCubit()),
            BlocProvider(create: (context) => LocaleCubit()),
            BlocProvider(create: (context) => CityBloc(AddressRepository())),
            BlocProvider(create: (context) => StateBloc(AddressRepository())),
            BlocProvider(create: (context) => AreaBloc(AddressRepository())),
            BlocProvider(create: (context) => FromAreaBloc(AddressRepository())),
            BlocProvider(create: (context) => ToAreaBloc(AddressRepository())),
            BlocProvider(create: (context) => MedicalBloc(MedicalRepository())),
            BlocProvider(create: (context) => OrderBloc(OrderRepository())),
            BlocProvider(create: (context) => ReminderBloc(ReminderRepository())),
            BlocProvider(create: (context) => ProductBloc(ProductRepository())),
            BlocProvider(create: (context) => ExpenseBloc(ExpenseRepository())),
            BlocProvider(create: (context) => AddExpenseCommentBloc(ExpenseRepository())),
            BlocProvider(create: (context) => ExpenseByIdBloc(ExpenseRepository())),
            BlocProvider(create: (context) => FeedbackBloc(FeedbackRepository())),
            BlocProvider(create: (context) => CommentBloc(CommentRepository())),
            BlocProvider(create: (context) => ReportBloc(ReportRepository())),
            BlocProvider(create: (context) => ClientSettingBloc(MedicalRepository())),
          ],
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      restorationId: 'root',
      child: BlocBuilder<LocaleCubit, LocaleState>(
          buildWhen: (previousState, currentState) => previousState != currentState,
          builder: (context, localeState) {
            return ResponsiveSizer(
              builder: (context, orientation, screenType) {
                return MaterialApp(
                  navigatorKey: navigationKey,
                  locale: localeState.locale,
                  title: 'Bhawsar Chemicals',
                  debugShowCheckedModeBanner: false,
                  initialRoute: RouteList.splash,
                  restorationScopeId: 'root',
                  navigatorObservers: [
                    NavigatorObserver(),
                  ],
                  onGenerateRoute: AppRouter().onGenerateRoute,
                  theme: buildLightTheme(),
                  localizationsDelegates: const [
                    S.delegate,
                    AppLocalizationDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                );
              },
            );
          }),
    );
  }
}

Future<void> loadInitConfig() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    if (isMobile) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      PermissionStatus status = await Permission.notification.status;
      if (!status.isGranted) {
        status = await Permission.notification.request();
      }
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
    }
  } catch (e) {
    showCatchedError(e);
  }

  final applicationDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  //* Clear Upgrader setting
  if (isDebugMode) {
    await Upgrader.clearSavedSettings();
  }

  //* init HIVE
  await Hive.initFlutter(applicationDocumentDir.path);

  Bloc.observer = AppBlocObserver();

  //* Lock portrait mode.
  unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));

  //* register hive adapter and open hive box
  userBox = await Hive.openBox('userBox');
  await updateNotificationCount(await userBox.get('reminderCount') ?? 0);
  await updateFeedbackCount(await userBox.get('openFeedbackCount') ?? 0);
  await changeFieldOfWork(await userBox.get('shouldChangeFieldOfWork') ?? true);
  await updateTrackingStatus(await userBox.get('tracking') ?? 0);
  await updateUserInfo(await userBox.get('userInfo') ?? {});
}
