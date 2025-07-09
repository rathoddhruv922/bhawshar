// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_const.dart';
import '../generated/l10n.dart';
import '../main.dart';
import '../src/widgets/app_snackbar_toast.dart';

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

//* calculate total amount [OrderModule]
String getTotalAmount(List<Map<dynamic, dynamic>>? items) {
  num total = 0;
  try {
    for (int t = 0; t < (items!.length); t++) {
      double amount = 0;
      String price = "0.00";

      if (items[t]["add_item"] == true) {
        price = currencyFormat
            .format(items[t]['price'].toString().contains('-1') == true ? 0 : num.parse(items[t]['price'].toString()))
            .toString(); // check -1 when mr has no right to view price
        if (price != "0.00") {
          amount = double.parse(price);
        }
        total = total + (amount * (int.parse(items[t]['qty'].toString())));
      } else if (items[t]["add_item"] == null) {
        price = currencyFormat
            .format(items[t]['price'].toString().contains('-1') == true ? 0 : num.parse(items[t]['price'].toString()))
            .toString(); // check -1 when mr has no right to view price
        if (price != "0.00") {
          amount = double.parse(price);
        }
        total = total + (amount * (int.parse(items[t]['qty'].toString())));
      }
    }
  } catch (e) {
    showCatchedError(e);
  }
  return '₹ ${currencyFormat.format(total)}';
}

//* Validate input like 10,20,30 ... [OrderModule]
bool schemeQtyValidate(BuildContext ctx, controller, int? isSchemeApply) {
  if (isSchemeApply == 1) {
    if (controller.text.length >= 2) {
      if ((int.parse(controller.text) % 10 == 0) == true) {
        hideKeyboard();
        return true;
      } else {
        myToastMsg(S.of(ctx).scheme_qty_error, isError: true);
        controller.clear();
        return false;
      }
    } else {
      myToastMsg(S.of(ctx).scheme_qty_error, isError: true);
      return false;
    }
  }
  return true;
}

Future<File?> getLocalFile(String? filename) async {
  File file = File('$filename');
  return file;
}

XFile? getLocalXfile(String? filename) {
  XFile xfile = XFile('$filename');
  return xfile;
}

Icon getBackArrow() {
  if (isAndroid) {
    return const Icon(Icons.arrow_back);
  }
  if (isIOS) {
    return const Icon(Icons.arrow_back_ios_new);
  }
  return const Icon(Icons.arrow_back);
}

String greeting(context) {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return S.of(context).gm;
  }
  if (hour < 17) {
    return S.of(context).ga;
  }
  return S.of(context).ge;
}

//* return required field message
//return type: String
// @param String filedName,
String requiredMsg(String fieldName) {
  return '${fieldName.toCapitalized()} is required';
}

//* return invalid message
//return type: String
// @param String filedName,
// @param String errorMsg (optional)
String invalidMsg(String fieldName, {String errorMsg = ''}) {
  return errorMsg == '' ? '$fieldName is invalid!' : errorMsg;
}

//* return hint message
//return type: String
// @param String filedName,
String hintMsg(String fieldName) {
  return 'Enter ${fieldName.toLowerCase()}';
}

//* return field name in capitalized
//return type: String
// @param String filedName,
String labelText(String fieldName) {
  return fieldName.toCapitalized();
}

//* open URL in Browser
// @param String url,
void launchInBrowser(String url) async {
  if (await canLaunchUrl(
    Uri.parse(url),
  )) {
    List<String> pathSegments = Uri.parse(url).pathSegments;
    String filename = pathSegments.last;
    if ((filename.isNotEmpty && filename.contains('.pdf') && isAndroid)) {
      var googleDocsUrl = 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeQueryComponent(url)}';
      final Uri uri = Uri.parse(googleDocsUrl);
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
        webViewConfiguration: const WebViewConfiguration(
          headers: {
            "Content-Type": "application/pdf",
            // "Content-Disposition": "inline",
            "Referer": "https://mobile.bhawsarayurveda.in/"
          },
        ),
      );
    } else {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.platformDefault,
        webViewConfiguration: const WebViewConfiguration(
          headers: {"Referer": "https://mobile.bhawsarayurveda.in/"},
        ),
      );
    }
  } else {
    showCatchedError("Could not launch $url");
    throw 'Could not launch $url';
  }
}

//* make a phone call
//@param String mobileNo,
void makePhoneCall(String mobileNo) async {
  if (await canLaunchUrl(
    Uri(
      path: mobileNo,
      scheme: 'tel',
    ),
  )) {
    await launchUrl(
        Uri(
          path: mobileNo,
          scheme: 'tel',
        ),
        mode: LaunchMode.platformDefault);
  } else {
    showCatchedError("Could not make a call");
    throw 'Could not launch $mobileNo';
  }
}

//* return a String (Today, Tomorrow, After 14 days)
//@param DateTime from,
//@param DateTime to,
String daysBetween(DateTime from, DateTime to) {
  try {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays > 0
        ? to.difference(from).inDays > 1
            ? 'After ${to.difference(from).inDays} days,'
            : "Tomorrow,"
        : 'Today,';
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* update tracking flag
Future<void> updateTrackingStatus(int value) async {
  trackStatus.value = value;
  await userBox.put('tracking', value);
}

//* update notification count
Future<void> updateNotificationCount(dynamic count) async {
  try {
    int pendingReminder = int.parse(count.toString());
    reminderCount.value = pendingReminder;
    await userBox.put('reminderCount', pendingReminder);
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* update open feedback count
Future<void> updateFeedbackCount(dynamic count) async {
  try {
    int openFeedback = int.parse(count.toString());
    await userBox.put('openFeedbackCount', openFeedback);
    openFeedbackCount.value = openFeedback;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* update user field of work status ( for showing dialog once while logged in)
Future<void> changeFieldOfWork(dynamic shouldUpdate) async {
  try {
    await userBox.put('shouldChangeFieldOfWork', shouldUpdate);
    shouldChangeFieldOfWork.value = shouldUpdate;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* update userInfo object (HIVE)
Future<void> updateUserInfo(Map<dynamic, dynamic> user) async {
  try {
    userInfo.value = user;
    await userBox.put('userInfo', userInfo.value);
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* update userInfo/single value object (HIVE)
Future<void> updateUserFieldOfWork(String key, newValue) async {
  try {
    Map<dynamic, dynamic> updatedUser = {...userInfo.value};
    updatedUser[key] = newValue;
    userInfo.value = updatedUser;
    await userBox.put('userInfo', userInfo.value);
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* return location service status
Future<bool> getLocationServiceStatus() async {
  late bool locationServiceEnabled = false;
  try {
    LocationPermission? permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      locationServiceEnabled = false;
    } else if (permission == LocationPermission.deniedForever) {
      locationServiceEnabled = false;
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      locationServiceEnabled = true;
    }
    return locationServiceEnabled;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* get formatted date
String getDate(String? date, {intl.DateFormat? dateFormat}) {
  try {
    DateTime parseDate = intl.DateFormat('yyyy-MM-dd', 'en_US').parse(date!);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = dateFormat ?? intl.DateFormat('yyyy-MM-dd', 'en_US');
    String outputDate = outputFormat.format(
      inputDate,
    );
    return outputDate;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* get formatted amount
var currencyFormat = intl.NumberFormat.currency(
  locale: 'HI',
  name: '',
  symbol: '',
);

//* get userId
getUserId() async {
  try {
    var user = await userBox.get('userInfo');
    return user['id'];
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* get fcm token
getFcmToken() async {
  try {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken().then((value) => value);
    return fcmToken;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* remove duplicate element from array
extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

//* return time is expired or not
bool isExpired(DateTime dateToCheck) {
  final beforeMonth = DateTime.now().subtract(const Duration(days: 30));
  return beforeMonth.isAfter(dateToCheck);
}

//* get initial route info
Future getInitialRoute() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initialLink;
  final String initialRoute = WidgetsFlutterBinding.ensureInitialized().platformDispatcher.defaultRouteName;
  if (initialRoute != "") {
    final Uri initialUri = Uri.parse(initialRoute);
    initialLink = initialUri.toString();
  }
  return initialLink;
}

//* get device info
getDeviceInfo() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceFormData;
    if (isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceFormData = {"device_model": androidInfo.model, "device_id": androidInfo.id};
      return deviceFormData;
    } else if (isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceFormData = {"device_model": iosInfo.model, "device_id": iosInfo.identifierForVendor};
      return deviceFormData;
    }
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* get current location
// late location_data.LocationData locationData;

Future<Position> determinePosition(bool isCheckPermission) async {
  if (isCheckPermission) {
    bool locationServiceEnabled = await getLocationServiceStatus();
    try {
      if (!locationServiceEnabled) {
        return Future.error('Location services are disabled');
      }
      LocationPermission? permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
          return Future.error(
            'Location permissions are permanently denied, we cannot request permissions',
          );
        }
      }

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(
              seconds: 5,
            )),
      );
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
        forceAndroidLocationManager: false,
      );
    } catch (e) {
      rethrow;
    }
  } else {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
        forceAndroidLocationManager: false,
      );
    } catch (e) {
      rethrow;
    }
  }
}

getLocations() async {
  // locationData = await location_data.Location.instance.getLocation();
  // await location_data.Location.instance.enableBackgroundMode(enable: true);
  // location_data.Location.instance.onLocationChanged.listen(
  //   (location_data.LocationData currentLocation) {
  //     locationData = currentLocation;
  //     debugPrint(locationData.toString());
  //   },
  // );
}

//* show Log msg in debug mode & toast error
showCatchedError(dynamic error) {
  if (isDebugMode) {
    Logger().i(error.toString());
  }
  myToastMsg(error.toString(), isError: true);
}

//* Sync Data Error List
String? getError(String? errorKey, errorList) {
  String? errorMsg;
  try {
    errorList.forEach((key, value) {
      if (key == errorKey) {
        errorMsg = value;
      }
    });
    return errorMsg;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* for bloc usage
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> throttleReplace<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> throttleSequentials<E>(Duration duration) {
  return (events, mapper) {
    return sequential<E>().call(events.throttle(duration), mapper);
  };
}

//* String to Capitalized & String to TitleCase
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

//* Get time to hours:minute:second AM/PM from TimeOfDay
getTimeToHMSAM(BuildContext context, TimeOfDay time, {bool isShowAmPm = true}) {
  try {
    final localizations = MaterialLocalizations.of(navigationKey.currentContext!);
    final formattedTimeOfDay = localizations.formatTimeOfDay(time);

    var timeToHMSAM = isShowAmPm ? formattedTimeOfDay : intl.DateFormat('hh:mm:ss');
    return timeToHMSAM;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* Get date to time
getDateToTime(String dateTime, {bool isShowAmPm = true}) {
  try {
    String formattedTime = isShowAmPm
        ? intl.DateFormat.jms('en_US').format(DateTime.parse(dateTime))
        : intl.DateFormat.Hms('en_US').format(DateTime.parse(dateTime));
    return formattedTime;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* Get TimeOf from DateTime()
getTimeOfFromDateTime(String dateTime) {
  try {
    return TimeOfDay(
      hour: DateTime.parse(dateTime).hour,
      minute: DateTime.parse(dateTime).minute,
    );
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* Get time to hours:minute:second from TimeOfDay
getHMS(TimeOfDay time) {
  try {
    String timeToHMS = '${time.toString().substring(10, 15)}:00';
    return timeToHMS;
  } catch (e) {
    showCatchedError(e);
    rethrow;
  }
}

//* Get package info. object
getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (kDebugMode) {
    print("App. version: ${packageInfo.version}");
    print("App. version code: ${packageInfo.buildNumber}");
  }
  String code = packageInfo.version;
  return code;
}
