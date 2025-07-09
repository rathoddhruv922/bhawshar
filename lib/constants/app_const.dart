import 'dart:io';

import 'package:flutter/foundation.dart';

//const String baseUrl = 'https://bhavsarapi.tp-team.com/api/v1';
//const String baseUrl = 'https://bhawsaruat.tpots.in/api/v1';
const String baseUrl = 'https://api.bhawsarayurveda.in/api/v1';
//! When change baseUrl don't forget to change in Androidmanifest file also.
const String appName = 'Bhawsar Chemicals Sales';
String docLink = baseUrl.contains('bhawsarayurved') ? 'bhawmedia' : baseUrl.split('/').elementAt(2);
String host = baseUrl.split('/').elementAt(2);

//* REST url end point
const String loginUrl = '/login';
const String logoutUrl = '/logout';
const String forgotPasswordUrl = '/user/password/forgot';
const String verifyOtp = '/password/otp/verify';
const String changePasswordUrl = '/user/password/change';
const String resetPasswordUrl = '/user/password/reset';
const String feedbackUrl = '/feedback';
const String getFeedbackUrl = '/feedback/';
const String getFeedbacksUrl = '/feedbacks';
const String deleteFeedbackUrl = '/feedback';
const String closeFeedbackUrl = '/feedback/status';

const String commentUrl = '/comment';

const String getCityUrl = '/cities';
const String getStateUrl = '/states';
const String getAreaUrl = '/areas';

const String getRemindersUrl = '/getuserreminder';
const String getReminderUrl = '/reminder/';
const String addReminderUrl = '/reminder';
const String updateReminderUrl = '/reminder/';
const String deleteReminderUrl = '/reminder';
const String changedReminderStatusUrl = '/reminder/complete';

const String getExpensesUrl = '/expenses';
const String getExpenseUrl = '/expense/';
const String addExpenseUrl = '/expense';
const String addCommentToExpenseUrl = '/expense/comment';
const String updateExpenseUrl = '/expense/';
const String deleteExpenseUrl = '/expense';

const String getOrdersUrl = '/orders';
const String getOrderUrl = '/order/';
const String addOrderUrl = '/order';
const String updateOrderUrl = '/order/';
const String deleteOrderUrl = '/order';
const String cancelOrderUrl = '/order/status';

const String getProductsUrl = '/products';

const String getMedicalUrl = '/clients';
const String addMedicalUrl = '/client';
const String updateMedicalUrl = '/client/';
const String getClientSetting = '/setting/client';

const String getDailyReport = '/app/daily/mr/report';

const String sendLocationUrl = '/location';

//* end
const storeToLocal = 'Connection Not Available! Temporary stored data to local storage!';

//* end
const String privacyPolicyUrl = "https://bhawsarchemicals.com/privacy-policy/";

//* app platform
final bool isIOS = Platform.isIOS;
final bool isAndroid = Platform.isAndroid;
final bool isMobile = Platform.isIOS || Platform.isAndroid;
const bool isDebugMode = kDebugMode;

//* app padding
const double paddingExtraSmall = 5.0;
const double paddingSmall = 10.0;
const double paddingDefault = 12.0;
const double paddingMedium = 15.0;
const double paddingLarge = 20.0;
const double paddingExtraLarge = 25.0;
