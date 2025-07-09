import 'package:bhawsar_chemical/data/models/expenses_model/item.dart' as expense;
import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
import 'package:bhawsar_chemical/src/screens/auth/otp_screen.dart';
import 'package:bhawsar_chemical/src/screens/drawer/performance_screen.dart';
import 'package:bhawsar_chemical/src/screens/expense/addComment/add_comment_to_expense_screen.dart';
import 'package:bhawsar_chemical/src/screens/home/about_us_screen.dart';
import 'package:bhawsar_chemical/src/screens/home/contact_us.dart';
import 'package:bhawsar_chemical/src/screens/home/privacy_policy_screen.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/checkout_screen.dart';
import 'package:bhawsar_chemical/src/screens/requestGiftPop/request_gift_history.dart';
import 'package:bhawsar_chemical/src/screens/requestGiftPop/request_gift_pop_screen.dart';
import 'package:bhawsar_chemical/src/screens/requestGiftPop/update_request_gift_pop_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/app_const.dart';
import '../../data/dio/dio_exception.dart';
import '../../hive/hive_expense.dart';
import '../../hive/hive_medical.dart';
import '../../hive/hive_order.dart';
import '../../hive/hive_reminder.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/drawer/add_feedback_screen.dart';
import '../screens/drawer/change_locale_screen.dart';
import '../screens/drawer/change_password_screen.dart';
import '../screens/drawer/drawer_screen.dart';
import '../screens/drawer/feedback_reply_screen.dart';
import '../screens/drawer/feedback_screen.dart';
import '../screens/expense/addExpense/add_expense_screen.dart';
import '../screens/expense/expense_screen.dart';
import '../screens/expense/updateExpense/update_expense_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/medical/add_medical/add_medical_screen.dart';
import '../screens/medical/search_medical/search_medical_screen.dart';
import '../screens/medical/update_medical/update_medical_screen.dart';
import '../screens/order/add_order/add_order_screen.dart';
import '../screens/order/order_screen.dart';
import '../screens/order/update_order/update_order_screen.dart';
import '../screens/order/view_order/view_order_detail_screen.dart';
import '../screens/reminder/addReminder/add_reminder_screen.dart';
import '../screens/reminder/reminder_screen.dart';
import '../screens/reminder/updateReminder/update_reminder_screen.dart';
import '../screens/splashAndOnboard/permission_screen.dart';
import '../screens/splashAndOnboard/splash_screen.dart';
import '../widgets/app_snackbar_toast.dart';
import 'route_list.dart';

class SyncAddMedicalArguments {
  final int index;
  final HiveMedical medicalInfo;

  SyncAddMedicalArguments({required this.index, required this.medicalInfo});
}

class UpdateReminderArguments {
  final medical.Item medicalInfo;
  final dynamic item;

  UpdateReminderArguments({required this.medicalInfo, required this.item});
}

class UpdateExpenseArguments {
  final expense.Item expenseInfo;
  final int id;

  UpdateExpenseArguments({required this.expenseInfo, required this.id});
}

class SyncAddReminderArguments {
  final HiveReminder reminderInfo;
  final int? index;

  SyncAddReminderArguments({required this.reminderInfo, required this.index});
}

class SyncAddOrderArguments {
  final HiveOrder orderInfo;
  final int? index;

  SyncAddOrderArguments({required this.orderInfo, required this.index});
}

class SyncAddExpenseArguments {
  final HiveExpense expenseInfo;
  final int? index;

  SyncAddExpenseArguments({required this.expenseInfo, required this.index});
}

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        //? AUTH / SPLASH / PERMISSION ROUTE
        case RouteList.permission:
          return appRoute(const PermissionScreen(), type: 'direction', direction: AxisDirection.up);

        case RouteList.resetPassword:
          final args = routeSettings.arguments as Map<String, dynamic>;
          return appRoute(
            ResetPasswordScreen(
              email: args["email"] ?? "",
              token: args["token"] ?? "",
            ),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.splash:
          return appRoute(const SplashScreen(), type: 'direction', direction: AxisDirection.left);

        case RouteList.login:
          return appRoute(
            const LoginScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.forgotPassword:
          return appRoute(
            ForgotScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        //? END AUTH / SPLASH / PERMISSION ROUTE

        //? REQUEST GIFT / POP ROUTE
        case RouteList.requestGiftPop:
          return appRoute(
            const RequestGiftPop(),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.updateRequestGiftPop:
          return appRoute(
            UpdateRequestGiftPop(orderId: routeSettings.arguments as int),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.requestGiftPopHistory:
          return appRoute(
            const RequestGiftPopHistoryScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        //? END REQ. GIFT / POP

        // ? REMINDER ROUTE
        case RouteList.reminder:
          return appRoute(
            const ReminderScreen(),
            direction: AxisDirection.left,
          );
        case RouteList.addReminder:
          return appRoute(
            AddReminderScreen(
              medicalInfo: routeSettings.arguments as medical.Item,
            ),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.updateReminder:
          return appRoute(
            UpdateReminderScreen(
              id: routeSettings.arguments as int,
            ),
            type: 'direction',
            direction: AxisDirection.up,
          );
        //? END REMINDER ROUTE

        //? HOME ROUTE
        case RouteList.home:
          return appRoute(
            HomeScreen(),
            type: 'direction',
            direction: AxisDirection.left,
          );
        //? END HOME AND SYNC ROUTE

        // ? DRAWER ROUTE
        case RouteList.drawer:
          return appRoute(const DrawerScreen());

        case RouteList.changeLocale:
          return appRoute(const ChangeLocale());

        case RouteList.changePassword:
          return appRoute(const ChangePasswordScreen());

        case RouteList.feedback:
          return appRoute(
            const FeedbackScreen(),
            type: 'direction',
            direction: AxisDirection.left,
          );

        case RouteList.addFeedback:
          return appRoute(
            const AddFeedbackScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.aboutUs:
          return appRoute(
            AboutUsScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.privacyPolicy:
          return appRoute(
            PrivacyPolicyScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.contactUs:
          return appRoute(
            ContactUsScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.replyFeedback:
          return appRoute(
            FeedbackReplyScreen(
              id: routeSettings.arguments as int,
            ),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.performance:
          return appRoute(
            const PerformanceScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        // ? END DRAWER ROUTE

        // ? MEDICAL ROUTE
        case RouteList.addMedical:
          String? redirectTo = routeSettings.arguments as String? ?? 'none';
          return appRoute(
            AddMedicalScreen(redirectTo: redirectTo),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.updateMedical:
          return appRoute(
            UpdateMedicalScreen(item: routeSettings.arguments as medical.Item?),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.searchMedical:
          return appRoute(
            SearchMedicalScreen(
              pageTitle: routeSettings.arguments as dynamic,
            ),
          );
        // ? END MEDICAL ROUTE

        //? EXPENSE ROUTE
        case RouteList.expense:
          return appRoute(const ExpenseScreen());
        case RouteList.addExpense:
          return appRoute(
            const AddExpenseScreen(),
            type: 'direction',
            direction: AxisDirection.up,
          );
        case RouteList.updateExpense:
          UpdateExpenseArguments argument = routeSettings.arguments as UpdateExpenseArguments;
          return appRoute(
            UpdateExpenseScreen(
              id: argument.id,
              expenseInfo: argument.expenseInfo,
            ),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.addComment:
          return appRoute(
            AddCommentToExpenseScreen(expenseId: routeSettings.arguments as int),
          );
        //? END EXPENSE ROUTE

        //? ORDER ROUTE
        case RouteList.order:
          return appRoute(
            const OrderScreen(),
          );
        case RouteList.otpScreen:
          String argument = routeSettings.arguments as String;
          return appRoute(
            OtpScreen(
              email: argument,
            ),
          );
        case RouteList.viewOrder:
          return appRoute(
            OrderDetailScreen(orderId: routeSettings.arguments as int),
          );
        case RouteList.addOrder:
          return appRoute(
            AddOrderScreen(medicalInfo: routeSettings.arguments as medical.Item),
            type: 'direction',
            direction: AxisDirection.up,
          );

        case RouteList.checkout:
          final args = routeSettings.arguments as Map<String, dynamic>;
          return appRoute(
            CheckoutScreen(
              orderId: args["orderID"],
              popItems: args["popItems"],
              distributorType: args["distributorType"],
              giftItems: args["giftItems"],
              isAddReminder: args["isAddReminder"],
              isTimeValid: args["isTimeValid"],
              medicalInfo: args["medicalInfo"],
              msg: args["msg"],
              nonProductive: args["nonProductive"],
              notInterested: args["notInterested"],
              orderNotes: args["orderNotes"],
              orderType: args["orderType"],
              productItems: args["productItems"],
              sampleItems: args["sampleItems"],
              distributorInfo: args["distributorInfo"],
            ),
          );

        // case RouteList.productive:
        //   final args = routeSettings.arguments as Map<String, dynamic>;
        //   return appRoute(
        //     ProductiveCall(
        //       medicalInfo: args["medicalInfo"] as medical.Item,
        //       orderType: args["orderType"] as String,
        //     ),
        //     type: 'direction',
        //     direction: AxisDirection.up,
        //   );

        // case RouteList.nonProductive:
        //   final args = routeSettings.arguments as Map<String, dynamic>;
        //   return appRoute(
        //     NonProductiveScreen(
        //       medicalInfo: args["medicalInfo"] as medical.Item,
        //       orderType: args["orderType"] as String,
        //     ),
        //     type: 'direction',
        //     direction: AxisDirection.up,
        //   );

        case RouteList.updateOrder:
          return appRoute(
            UpdateOrderScreen(orderId: routeSettings.arguments as int),
            type: 'direction',
            direction: AxisDirection.up,
          );
        //? END ORDER ROUTE

        default:
          return null;
      }
    } catch (e) {
      if (isDebugMode) {
        myToastMsg('Please check RouteName or RouteArgument!');
      } else {
        myToastMsg(DioExceptions.getErrorMessage(const DioExceptions.unexpectedError()));
      }
      rethrow;
    }
  }
}

Route appRoute(Widget page, {Curve curved = Curves.easeIn, AxisDirection direction = AxisDirection.up, String type = 'fadeIn'}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
    transitionsBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curved);
      return type != 'fadeIn'
          ? SlideTransition(
              position: Tween<Offset>(begin: getBeginOffset(direction), end: Offset.zero).animate(curvedAnimation), child: child)
          : FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
              child: child,
            );
    },
  );
}

//? used for page Transition effect
getBeginOffset(AxisDirection direction) {
  switch (direction) {
    case AxisDirection.up:
      return const Offset(0.0, 1.0);
    case AxisDirection.down:
      return const Offset(0.0, -1.0);
    case AxisDirection.left:
      return const Offset(1.0, 0.0);
    case AxisDirection.right:
      return const Offset(-1.0, 0.0);
  }
}
