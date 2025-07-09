// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bhawsar Chemical`
  String get app_name {
    return Intl.message(
      'Bhawsar Chemical',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Need Location Permission`
  String get location_permission {
    return Intl.message(
      'Need Location Permission',
      name: 'location_permission',
      desc: '',
      args: [],
    );
  }

  /// `Need Camera Permission`
  String get camera_permission {
    return Intl.message(
      'Need Camera Permission',
      name: 'camera_permission',
      desc: '',
      args: [],
    );
  }

  /// `Need Storage Permission`
  String get storage_permission {
    return Intl.message(
      'Need Storage Permission',
      name: 'storage_permission',
      desc: '',
      args: [],
    );
  }

  /// `Need Photo And Media Permission`
  String get photo_media_permission {
    return Intl.message(
      'Need Photo And Media Permission',
      name: 'photo_media_permission',
      desc: '',
      args: [],
    );
  }

  /// `Press Allow to grant a permission`
  String get grant_permission {
    return Intl.message(
      'Press Allow to grant a permission',
      name: 'grant_permission',
      desc: '',
      args: [],
    );
  }

  /// `You have to allow the permission to continue`
  String get force_grant_permission {
    return Intl.message(
      'You have to allow the permission to continue',
      name: 'force_grant_permission',
      desc: '',
      args: [],
    );
  }

  /// `Press Allow to grant permission.Please select Always Allow option`
  String get location_always_permission_ios {
    return Intl.message(
      'Press Allow to grant permission.Please select Always Allow option',
      name: 'location_always_permission_ios',
      desc: '',
      args: [],
    );
  }

  /// `Press Allow to grant permission.Please select Allow all the time option`
  String get location_always_permission_android {
    return Intl.message(
      'Press Allow to grant permission.Please select Allow all the time option',
      name: 'location_always_permission_android',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get button_allow {
    return Intl.message(
      'Allow',
      name: 'button_allow',
      desc: '',
      args: [],
    );
  }

  /// `You’re All set`
  String get setup_complete {
    return Intl.message(
      'You’re All set',
      name: 'setup_complete',
      desc: '',
      args: [],
    );
  }

  /// `Press Finish to Continue`
  String get finished {
    return Intl.message(
      'Press Finish to Continue',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get button_finish {
    return Intl.message(
      'Finish',
      name: 'button_finish',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get login_account {
    return Intl.message(
      'Login to your account',
      name: 'login_account',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get email_enter {
    return Intl.message(
      'Enter email',
      name: 'email_enter',
      desc: '',
      args: [],
    );
  }

  /// `Email is invalid`
  String get email_invalid {
    return Intl.message(
      'Email is invalid',
      name: 'email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get email_required {
    return Intl.message(
      'Email is required',
      name: 'email_required',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get password_enter {
    return Intl.message(
      'Enter password',
      name: 'password_enter',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get password_required {
    return Intl.message(
      'Password is required',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get password_forgot_ask {
    return Intl.message(
      'Forgot password?',
      name: 'password_forgot_ask',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get password_forgot {
    return Intl.message(
      'Forgot Password',
      name: 'password_forgot',
      desc: '',
      args: [],
    );
  }

  /// `Send Link`
  String get send_link {
    return Intl.message(
      'Send Link',
      name: 'send_link',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address to receive a verification link`
  String get send_link_message {
    return Intl.message(
      'Please enter your email address to receive a verification link',
      name: 'send_link_message',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get password_change {
    return Intl.message(
      'Change Password',
      name: 'password_change',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get password_old {
    return Intl.message(
      'Old Password',
      name: 'password_old',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get password_new {
    return Intl.message(
      'New Password',
      name: 'password_new',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get password_confirm {
    return Intl.message(
      'Confirm Password',
      name: 'password_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Enter old password`
  String get password_enter_old {
    return Intl.message(
      'Enter old password',
      name: 'password_enter_old',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get password_enter_new {
    return Intl.message(
      'Enter new password',
      name: 'password_enter_new',
      desc: '',
      args: [],
    );
  }

  /// `Enter confirm password`
  String get password_enter_confirm {
    return Intl.message(
      'Enter confirm password',
      name: 'password_enter_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Old password is required`
  String get password_old_required {
    return Intl.message(
      'Old password is required',
      name: 'password_old_required',
      desc: '',
      args: [],
    );
  }

  /// `New password is required`
  String get password_new_required {
    return Intl.message(
      'New password is required',
      name: 'password_new_required',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get password_confirm_required {
    return Intl.message(
      'Confirm password is required',
      name: 'password_confirm_required',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password not match`
  String get password_not_match {
    return Intl.message(
      'Confirm password not match',
      name: 'password_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get gm {
    return Intl.message(
      'Morning',
      name: 'gm',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon`
  String get ga {
    return Intl.message(
      'Afternoon',
      name: 'ga',
      desc: '',
      args: [],
    );
  }

  /// `Evening`
  String get ge {
    return Intl.message(
      'Evening',
      name: 'ge',
      desc: '',
      args: [],
    );
  }

  /// `ADD MEDICAL`
  String get medical_add {
    return Intl.message(
      'ADD MEDICAL',
      name: 'medical_add',
      desc: '',
      args: [],
    );
  }

  /// `Add Medical`
  String get medical_add_s {
    return Intl.message(
      'Add Medical',
      name: 'medical_add_s',
      desc: '',
      args: [],
    );
  }

  /// `SEARCH MEDICAL`
  String get medical_search {
    return Intl.message(
      'SEARCH MEDICAL',
      name: 'medical_search',
      desc: '',
      args: [],
    );
  }

  /// `Search Medical`
  String get medical_search_s {
    return Intl.message(
      'Search Medical',
      name: 'medical_search_s',
      desc: '',
      args: [],
    );
  }

  /// `ORDER HISTORY`
  String get order_history {
    return Intl.message(
      'ORDER HISTORY',
      name: 'order_history',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get order_history_s {
    return Intl.message(
      'Order History',
      name: 'order_history_s',
      desc: '',
      args: [],
    );
  }

  /// `TRAVEL & FOOD EXPENSES`
  String get travel_food_expense {
    return Intl.message(
      'TRAVEL & FOOD EXPENSES',
      name: 'travel_food_expense',
      desc: '',
      args: [],
    );
  }

  /// `Travel & Food Expense`
  String get travel_food_expense_s {
    return Intl.message(
      'Travel & Food Expense',
      name: 'travel_food_expense_s',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get language_change {
    return Intl.message(
      'Change Language',
      name: 'language_change',
      desc: '',
      args: [],
    );
  }

  /// `Please select application language`
  String get language_select {
    return Intl.message(
      'Please select application language',
      name: 'language_select',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Update Medical`
  String get medical_update {
    return Intl.message(
      'Update Medical',
      name: 'medical_update',
      desc: '',
      args: [],
    );
  }

  /// `Select client type`
  String get client_type {
    return Intl.message(
      'Select client type',
      name: 'client_type',
      desc: '',
      args: [],
    );
  }

  /// `Medical`
  String get medical {
    return Intl.message(
      'Medical',
      name: 'medical',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse`
  String get warehouse {
    return Intl.message(
      'Warehouse',
      name: 'warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get doctor {
    return Intl.message(
      'Doctor',
      name: 'doctor',
      desc: '',
      args: [],
    );
  }

  /// `Distributor`
  String get distributor {
    return Intl.message(
      'Distributor',
      name: 'distributor',
      desc: '',
      args: [],
    );
  }

  /// `Select notification preference`
  String get notification_preference {
    return Intl.message(
      'Select notification preference',
      name: 'notification_preference',
      desc: '',
      args: [],
    );
  }

  /// `Whatsapp`
  String get whatsapp {
    return Intl.message(
      'Whatsapp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Both`
  String get both {
    return Intl.message(
      'Both',
      name: 'both',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get name_enter {
    return Intl.message(
      'Enter Name',
      name: 'name_enter',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get name_required {
    return Intl.message(
      'Name is required',
      name: 'name_required',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobile {
    return Intl.message(
      'Mobile number',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Enter mobile number`
  String get mobile_enter {
    return Intl.message(
      'Enter mobile number',
      name: 'mobile_enter',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number is required`
  String get mobile_required {
    return Intl.message(
      'Mobile number is required',
      name: 'mobile_required',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number should contain exactly 10 digits`
  String get mobile_invalid {
    return Intl.message(
      'Mobile number should contain exactly 10 digits',
      name: 'mobile_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Enter address`
  String get address_enter {
    return Intl.message(
      'Enter address',
      name: 'address_enter',
      desc: '',
      args: [],
    );
  }

  /// `Address is required`
  String get address_required {
    return Intl.message(
      'Address is required',
      name: 'address_required',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message(
      'Area',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Enter area`
  String get area_enter {
    return Intl.message(
      'Enter area',
      name: 'area_enter',
      desc: '',
      args: [],
    );
  }

  /// `Area is required`
  String get area_required {
    return Intl.message(
      'Area is required',
      name: 'area_required',
      desc: '',
      args: [],
    );
  }

  /// `From Area`
  String get from_area {
    return Intl.message(
      'From Area',
      name: 'from_area',
      desc: '',
      args: [],
    );
  }

  /// `Enter from area`
  String get from_area_enter {
    return Intl.message(
      'Enter from area',
      name: 'from_area_enter',
      desc: '',
      args: [],
    );
  }

  /// `From area is required`
  String get from_area_required {
    return Intl.message(
      'From area is required',
      name: 'from_area_required',
      desc: '',
      args: [],
    );
  }

  /// `To Area`
  String get to_area {
    return Intl.message(
      'To Area',
      name: 'to_area',
      desc: '',
      args: [],
    );
  }

  /// `Enter to area`
  String get to_area_enter {
    return Intl.message(
      'Enter to area',
      name: 'to_area_enter',
      desc: '',
      args: [],
    );
  }

  /// `To area is required`
  String get to_area_required {
    return Intl.message(
      'To area is required',
      name: 'to_area_required',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Add new city`
  String get city_add {
    return Intl.message(
      'Add new city',
      name: 'city_add',
      desc: '',
      args: [],
    );
  }

  /// `Add new area`
  String get area_add {
    return Intl.message(
      'Add new area',
      name: 'area_add',
      desc: '',
      args: [],
    );
  }

  /// `Enter city`
  String get city_enter {
    return Intl.message(
      'Enter city',
      name: 'city_enter',
      desc: '',
      args: [],
    );
  }

  /// `City is required`
  String get city_required {
    return Intl.message(
      'City is required',
      name: 'city_required',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Enter state`
  String get state_enter {
    return Intl.message(
      'Enter state',
      name: 'state_enter',
      desc: '',
      args: [],
    );
  }

  /// `State is required`
  String get state_required {
    return Intl.message(
      'State is required',
      name: 'state_required',
      desc: '',
      args: [],
    );
  }

  /// `Pincode`
  String get pin {
    return Intl.message(
      'Pincode',
      name: 'pin',
      desc: '',
      args: [],
    );
  }

  /// `Enter pincode`
  String get pin_enter {
    return Intl.message(
      'Enter pincode',
      name: 'pin_enter',
      desc: '',
      args: [],
    );
  }

  /// `Pincode is required`
  String get pin_required {
    return Intl.message(
      'Pincode is required',
      name: 'pin_required',
      desc: '',
      args: [],
    );
  }

  /// `Pincode should contain exactly 6 digits`
  String get pin_invalid {
    return Intl.message(
      'Pincode should contain exactly 6 digits',
      name: 'pin_invalid',
      desc: '',
      args: [],
    );
  }

  /// `GST number`
  String get GST {
    return Intl.message(
      'GST number',
      name: 'GST',
      desc: '',
      args: [],
    );
  }

  /// `Enter GST number`
  String get GST_enter {
    return Intl.message(
      'Enter GST number',
      name: 'GST_enter',
      desc: '',
      args: [],
    );
  }

  /// `GST number is required`
  String get GST_required {
    return Intl.message(
      'GST number is required',
      name: 'GST_required',
      desc: '',
      args: [],
    );
  }

  /// `GST number should be exactly 15 alphanumeric`
  String get GST_invalid {
    return Intl.message(
      'GST number should be exactly 15 alphanumeric',
      name: 'GST_invalid',
      desc: '',
      args: [],
    );
  }

  /// `PAN number`
  String get PAN {
    return Intl.message(
      'PAN number',
      name: 'PAN',
      desc: '',
      args: [],
    );
  }

  /// `Enter PAN number`
  String get PAN_enter {
    return Intl.message(
      'Enter PAN number',
      name: 'PAN_enter',
      desc: '',
      args: [],
    );
  }

  /// `PAN number is required`
  String get PAN_required {
    return Intl.message(
      'PAN number is required',
      name: 'PAN_required',
      desc: '',
      args: [],
    );
  }

  /// `PAN number should be exactly 10 alphanumeric`
  String get PAN_invalid {
    return Intl.message(
      'PAN number should be exactly 10 alphanumeric',
      name: 'PAN_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Phone / landline number`
  String get phone {
    return Intl.message(
      'Phone / landline number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone / landline number`
  String get phone_enter {
    return Intl.message(
      'Enter phone / landline number',
      name: 'phone_enter',
      desc: '',
      args: [],
    );
  }

  /// `Phone / landline number is required`
  String get phone_required {
    return Intl.message(
      'Phone / landline number is required',
      name: 'phone_required',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get photo_add {
    return Intl.message(
      'Add Photo',
      name: 'photo_add',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a photo of medical board.`
  String get photo_upload {
    return Intl.message(
      'Please upload a photo of medical board.',
      name: 'photo_upload',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Search medical by Name, Email, Mobile, GST`
  String get medical_search_filter {
    return Intl.message(
      'Search medical by Name, Email, Mobile, GST',
      name: 'medical_search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get order_now {
    return Intl.message(
      'Order Now',
      name: 'order_now',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get add_expense {
    return Intl.message(
      'Add Expense',
      name: 'add_expense',
      desc: '',
      args: [],
    );
  }

  /// `Update Expense`
  String get update_expense {
    return Intl.message(
      'Update Expense',
      name: 'update_expense',
      desc: '',
      args: [],
    );
  }

  /// `Select expense type`
  String get select_expense_type {
    return Intl.message(
      'Select expense type',
      name: 'select_expense_type',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get food {
    return Intl.message(
      'Food',
      name: 'food',
      desc: '',
      args: [],
    );
  }

  /// `Car`
  String get car {
    return Intl.message(
      'Car',
      name: 'car',
      desc: '',
      args: [],
    );
  }

  /// `Bus`
  String get bus {
    return Intl.message(
      'Bus',
      name: 'bus',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get bike {
    return Intl.message(
      'Bike',
      name: 'bike',
      desc: '',
      args: [],
    );
  }

  /// `Train`
  String get train {
    return Intl.message(
      'Train',
      name: 'train',
      desc: '',
      args: [],
    );
  }

  /// `Rickshaw`
  String get rickshaw {
    return Intl.message(
      'Rickshaw',
      name: 'rickshaw',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get travel {
    return Intl.message(
      'Travel',
      name: 'travel',
      desc: '',
      args: [],
    );
  }

  /// `Select travel type`
  String get select_travel_type {
    return Intl.message(
      'Select travel type',
      name: 'select_travel_type',
      desc: '',
      args: [],
    );
  }

  /// `Select miscellaneous type`
  String get select_misc_type {
    return Intl.message(
      'Select miscellaneous type',
      name: 'select_misc_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Expense Date`
  String get select_expense_date {
    return Intl.message(
      'Select Expense Date',
      name: 'select_expense_date',
      desc: '',
      args: [],
    );
  }

  /// `Select Daily Allowance type`
  String get select_da_type {
    return Intl.message(
      'Select Daily Allowance type',
      name: 'select_da_type',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get description_enter {
    return Intl.message(
      'Enter description',
      name: 'description_enter',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get description_required {
    return Intl.message(
      'Description is required',
      name: 'description_required',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Enter note`
  String get note_enter {
    return Intl.message(
      'Enter note',
      name: 'note_enter',
      desc: '',
      args: [],
    );
  }

  /// `Note is required`
  String get note_required {
    return Intl.message(
      'Note is required',
      name: 'note_required',
      desc: '',
      args: [],
    );
  }

  /// `Add receipt`
  String get receipt_add {
    return Intl.message(
      'Add receipt',
      name: 'receipt_add',
      desc: '',
      args: [],
    );
  }

  /// `You cannot edit expense that are more than 14 days old`
  String get expense_edit_warning {
    return Intl.message(
      'You cannot edit expense that are more than 14 days old',
      name: 'expense_edit_warning',
      desc: '',
      args: [],
    );
  }

  /// `DA`
  String get DA {
    return Intl.message(
      'DA',
      name: 'DA',
      desc: '',
      args: [],
    );
  }

  /// `My Reminder`
  String get my_reminder {
    return Intl.message(
      'My Reminder',
      name: 'my_reminder',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Past 3 month`
  String get past_three_month {
    return Intl.message(
      'Past 3 month',
      name: 'past_three_month',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incomplete {
    return Intl.message(
      'Incomplete',
      name: 'incomplete',
      desc: '',
      args: [],
    );
  }

  /// `Add Reminder`
  String get reminder_add {
    return Intl.message(
      'Add Reminder',
      name: 'reminder_add',
      desc: '',
      args: [],
    );
  }

  /// `Update Reminder`
  String get reminder_update {
    return Intl.message(
      'Update Reminder',
      name: 'reminder_update',
      desc: '',
      args: [],
    );
  }

  /// `Select Reminder Date`
  String get select_reminder_date {
    return Intl.message(
      'Select Reminder Date',
      name: 'select_reminder_date',
      desc: '',
      args: [],
    );
  }

  /// `Selected time must be future time`
  String get time_invalid {
    return Intl.message(
      'Selected time must be future time',
      name: 'time_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Enter message`
  String get message_enter {
    return Intl.message(
      'Enter message',
      name: 'message_enter',
      desc: '',
      args: [],
    );
  }

  /// `Message is required`
  String get message_required {
    return Intl.message(
      'Message is required',
      name: 'message_required',
      desc: '',
      args: [],
    );
  }

  /// `My Feedback's`
  String get my_feedback {
    return Intl.message(
      'My Feedback\'s',
      name: 'my_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Add Feedback`
  String get feedback_add {
    return Intl.message(
      'Add Feedback',
      name: 'feedback_add',
      desc: '',
      args: [],
    );
  }

  /// `Please select type`
  String get feedback_type {
    return Intl.message(
      'Please select type',
      name: 'feedback_type',
      desc: '',
      args: [],
    );
  }

  /// `Feedback has been closed`
  String get feedback_close {
    return Intl.message(
      'Feedback has been closed',
      name: 'feedback_close',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get resolved {
    return Intl.message(
      'Resolved',
      name: 'resolved',
      desc: '',
      args: [],
    );
  }

  /// `Feedback is resolved`
  String get feedback_resolved {
    return Intl.message(
      'Feedback is resolved',
      name: 'feedback_resolved',
      desc: '',
      args: [],
    );
  }

  /// `Comment are disable for this feedback`
  String get feedback_disable {
    return Intl.message(
      'Comment are disable for this feedback',
      name: 'feedback_disable',
      desc: '',
      args: [],
    );
  }

  /// `Feedback Conversation`
  String get feedback_conversation {
    return Intl.message(
      'Feedback Conversation',
      name: 'feedback_conversation',
      desc: '',
      args: [],
    );
  }

  /// `You can't edit this comment`
  String get feedback_edit_error {
    return Intl.message(
      'You can\'t edit this comment',
      name: 'feedback_edit_error',
      desc: '',
      args: [],
    );
  }

  /// `Add comment`
  String get comment_add {
    return Intl.message(
      'Add comment',
      name: 'comment_add',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get amount_enter {
    return Intl.message(
      'Enter amount',
      name: 'amount_enter',
      desc: '',
      args: [],
    );
  }

  /// `Amount is required`
  String get amount_required {
    return Intl.message(
      'Amount is required',
      name: 'amount_required',
      desc: '',
      args: [],
    );
  }

  /// `Place worked`
  String get place {
    return Intl.message(
      'Place worked',
      name: 'place',
      desc: '',
      args: [],
    );
  }

  /// `Enter the place you work`
  String get place_enter {
    return Intl.message(
      'Enter the place you work',
      name: 'place_enter',
      desc: '',
      args: [],
    );
  }

  /// `Worked place is required`
  String get place_required {
    return Intl.message(
      'Worked place is required',
      name: 'place_required',
      desc: '',
      args: [],
    );
  }

  /// `Travelled distance`
  String get distance {
    return Intl.message(
      'Travelled distance',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Enter the distance you travelled`
  String get distance_enter {
    return Intl.message(
      'Enter the distance you travelled',
      name: 'distance_enter',
      desc: '',
      args: [],
    );
  }

  /// `Travelled distance is required`
  String get distance_required {
    return Intl.message(
      'Travelled distance is required',
      name: 'distance_required',
      desc: '',
      args: [],
    );
  }

  /// `Add Attachments`
  String get attachment_add {
    return Intl.message(
      'Add Attachments',
      name: 'attachment_add',
      desc: '',
      args: [],
    );
  }

  /// `Add Order`
  String get order_add {
    return Intl.message(
      'Add Order',
      name: 'order_add',
      desc: '',
      args: [],
    );
  }

  /// `Update Order`
  String get order_update {
    return Intl.message(
      'Update Order',
      name: 'order_update',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get Message {
    return Intl.message(
      'Message',
      name: 'Message',
      desc: '',
      args: [],
    );
  }

  /// `Order Type`
  String get order_type {
    return Intl.message(
      'Order Type',
      name: 'order_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Distributor`
  String get distributor_select {
    return Intl.message(
      'Select Distributor',
      name: 'distributor_select',
      desc: '',
      args: [],
    );
  }

  /// `Please select distributor`
  String get distributor_required {
    return Intl.message(
      'Please select distributor',
      name: 'distributor_required',
      desc: '',
      args: [],
    );
  }

  /// `Search Distributor...`
  String get distributor_search {
    return Intl.message(
      'Search Distributor...',
      name: 'distributor_search',
      desc: '',
      args: [],
    );
  }

  /// `Select Warehouse`
  String get warehouse_select {
    return Intl.message(
      'Select Warehouse',
      name: 'warehouse_select',
      desc: '',
      args: [],
    );
  }

  /// `Please select warehouse`
  String get warehouse_required {
    return Intl.message(
      'Please select warehouse',
      name: 'warehouse_required',
      desc: '',
      args: [],
    );
  }

  /// `Search Warehouse...`
  String get warehouse_search {
    return Intl.message(
      'Search Warehouse...',
      name: 'warehouse_search',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product_add {
    return Intl.message(
      'Product',
      name: 'product_add',
      desc: '',
      args: [],
    );
  }

  /// `Search Product`
  String get product_search {
    return Intl.message(
      'Search Product',
      name: 'product_search',
      desc: '',
      args: [],
    );
  }

  /// `Search product by name, type etc..`
  String get product_search_filter {
    return Intl.message(
      'Search product by name, type etc..',
      name: 'product_search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Enter quantity`
  String get quantity_enter {
    return Intl.message(
      'Enter quantity',
      name: 'quantity_enter',
      desc: '',
      args: [],
    );
  }

  /// `Please enter quantity`
  String get quantity_required {
    return Intl.message(
      'Please enter quantity',
      name: 'quantity_required',
      desc: '',
      args: [],
    );
  }

  /// `Quantity value is invalid`
  String get quantity_invalid {
    return Intl.message(
      'Quantity value is invalid',
      name: 'quantity_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Scheme Applied : `
  String get scheme_apply {
    return Intl.message(
      'Scheme Applied : ',
      name: 'scheme_apply',
      desc: '',
      args: [],
    );
  }

  /// `Scheme Available : `
  String get scheme_available {
    return Intl.message(
      'Scheme Available : ',
      name: 'scheme_available',
      desc: '',
      args: [],
    );
  }

  /// `Shipped Qty: `
  String get shipped_qty {
    return Intl.message(
      'Shipped Qty: ',
      name: 'shipped_qty',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Please choose another size option`
  String get size_invalid {
    return Intl.message(
      'Please choose another size option',
      name: 'size_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please select size`
  String get size_select {
    return Intl.message(
      'Please select size',
      name: 'size_select',
      desc: '',
      args: [],
    );
  }

  /// `Remove from order list`
  String get product_remove {
    return Intl.message(
      'Remove from order list',
      name: 'product_remove',
      desc: '',
      args: [],
    );
  }

  /// `Add Gift Articles`
  String get gift_add {
    return Intl.message(
      'Add Gift Articles',
      name: 'gift_add',
      desc: '',
      args: [],
    );
  }

  /// `Search Gift Articles`
  String get gift_search {
    return Intl.message(
      'Search Gift Articles',
      name: 'gift_search',
      desc: '',
      args: [],
    );
  }

  /// `Search Gift Articles by name, type etc..`
  String get gift_search_filter {
    return Intl.message(
      'Search Gift Articles by name, type etc..',
      name: 'gift_search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Add Pop Materials`
  String get pop_add {
    return Intl.message(
      'Add Pop Materials',
      name: 'pop_add',
      desc: '',
      args: [],
    );
  }

  /// `Search Pop Materials`
  String get pop_search {
    return Intl.message(
      'Search Pop Materials',
      name: 'pop_search',
      desc: '',
      args: [],
    );
  }

  /// `Search Pop Materials by name, type etc..`
  String get pop_search_filter {
    return Intl.message(
      'Search Pop Materials by name, type etc..',
      name: 'pop_search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Add Free Sample`
  String get sample_add {
    return Intl.message(
      'Add Free Sample',
      name: 'sample_add',
      desc: '',
      args: [],
    );
  }

  /// `Search Free Sample`
  String get sample_search {
    return Intl.message(
      'Search Free Sample',
      name: 'sample_search',
      desc: '',
      args: [],
    );
  }

  /// `Search Free Sample by name, type etc..`
  String get sample_search_filter {
    return Intl.message(
      'Search Free Sample by name, type etc..',
      name: 'sample_search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Special Note`
  String get special_note {
    return Intl.message(
      'Special Note',
      name: 'special_note',
      desc: '',
      args: [],
    );
  }

  /// `Need to cancel the order before deleting`
  String get delete_order_warning {
    return Intl.message(
      'Need to cancel the order before deleting',
      name: 'delete_order_warning',
      desc: '',
      args: [],
    );
  }

  /// `Cannot perform any action because an order is`
  String get change_order_status_warning {
    return Intl.message(
      'Cannot perform any action because an order is',
      name: 'change_order_status_warning',
      desc: '',
      args: [],
    );
  }

  /// `Reminder is Completed/Deleted`
  String get reminder_edit_warning {
    return Intl.message(
      'Reminder is Completed/Deleted',
      name: 'reminder_edit_warning',
      desc: '',
      args: [],
    );
  }

  /// `You cannot edit this order as it contains in-active product`
  String get product_inactive_warning {
    return Intl.message(
      'You cannot edit this order as it contains in-active product',
      name: 'product_inactive_warning',
      desc: '',
      args: [],
    );
  }

  /// `Reminder not added`
  String get reminder_not_added {
    return Intl.message(
      'Reminder not added',
      name: 'reminder_not_added',
      desc: '',
      args: [],
    );
  }

  /// `Enter special notes`
  String get special_note_enter {
    return Intl.message(
      'Enter special notes',
      name: 'special_note_enter',
      desc: '',
      args: [],
    );
  }

  /// `Order summary`
  String get order_summary {
    return Intl.message(
      'Order summary',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `Expire Date`
  String get expire_date {
    return Intl.message(
      'Expire Date',
      name: 'expire_date',
      desc: '',
      args: [],
    );
  }

  /// `Unable to process the data`
  String get unable_process {
    return Intl.message(
      'Unable to process the data',
      name: 'unable_process',
      desc: '',
      args: [],
    );
  }

  /// `The authenticated user is not allowed to access the specified API endpoint`
  String get error_403 {
    return Intl.message(
      'The authenticated user is not allowed to access the specified API endpoint',
      name: 'error_403',
      desc: '',
      args: [],
    );
  }

  /// `Order Detail`
  String get order_detail {
    return Intl.message(
      'Order Detail',
      name: 'order_detail',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get product {
    return Intl.message(
      'Products',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Gift Articles`
  String get gift {
    return Intl.message(
      'Gift Articles',
      name: 'gift',
      desc: '',
      args: [],
    );
  }

  /// `Pop Materials`
  String get pop {
    return Intl.message(
      'Pop Materials',
      name: 'pop',
      desc: '',
      args: [],
    );
  }

  /// `Free Sample`
  String get sample {
    return Intl.message(
      'Free Sample',
      name: 'sample',
      desc: '',
      args: [],
    );
  }

  /// `To Pay`
  String get pay {
    return Intl.message(
      'To Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Punch Order`
  String get punch_order {
    return Intl.message(
      'Punch Order',
      name: 'punch_order',
      desc: '',
      args: [],
    );
  }

  /// `Please check your device network connection`
  String get network_error {
    return Intl.message(
      'Please check your device network connection',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get confirmation {
    return Intl.message(
      'Are you sure?',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `No more data to load`
  String get no_more_data {
    return Intl.message(
      'No more data to load',
      name: 'no_more_data',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get loading {
    return Intl.message(
      'Please wait...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Make sure location service are enabled`
  String get location_enabled {
    return Intl.message(
      'Make sure location service are enabled',
      name: 'location_enabled',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get empty {
    return Intl.message(
      'No data found',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Sync Data`
  String get sync_data {
    return Intl.message(
      'Sync Data',
      name: 'sync_data',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong! Try again after sometimes`
  String get unknown_error {
    return Intl.message(
      'Something went wrong! Try again after sometimes',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than Five MB`
  String get image_size_error {
    return Intl.message(
      'Image size must be less than Five MB',
      name: 'image_size_error',
      desc: '',
      args: [],
    );
  }

  /// `Please give Photo permission`
  String get photo_permission_request {
    return Intl.message(
      'Please give Photo permission',
      name: 'photo_permission_request',
      desc: '',
      args: [],
    );
  }

  /// `Please give Storage permission`
  String get storage_permission_request {
    return Intl.message(
      'Please give Storage permission',
      name: 'storage_permission_request',
      desc: '',
      args: [],
    );
  }

  /// `Please give Camera permission`
  String get camera_permission_request {
    return Intl.message(
      'Please give Camera permission',
      name: 'camera_permission_request',
      desc: '',
      args: [],
    );
  }

  /// `Please enable device location`
  String get location_permission_request {
    return Intl.message(
      'Please enable device location',
      name: 'location_permission_request',
      desc: '',
      args: [],
    );
  }

  /// `Please give location permission`
  String get app_location_permission_request {
    return Intl.message(
      'Please give location permission',
      name: 'app_location_permission_request',
      desc: '',
      args: [],
    );
  }

  /// `File size is greater than five mb`
  String get file_size_error {
    return Intl.message(
      'File size is greater than five mb',
      name: 'file_size_error',
      desc: '',
      args: [],
    );
  }

  /// `You cannot upload more than five receipt`
  String get receipt_limit_error {
    return Intl.message(
      'You cannot upload more than five receipt',
      name: 'receipt_limit_error',
      desc: '',
      args: [],
    );
  }

  /// `You cannot upload more than five attachment`
  String get attachment_limit_error {
    return Intl.message(
      'You cannot upload more than five attachment',
      name: 'attachment_limit_error',
      desc: '',
      args: [],
    );
  }

  /// `Please select subtype`
  String get select_subtype {
    return Intl.message(
      'Please select subtype',
      name: 'select_subtype',
      desc: '',
      args: [],
    );
  }

  /// `Type a comment...`
  String get type_comment {
    return Intl.message(
      'Type a comment...',
      name: 'type_comment',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your comment`
  String get comment_required {
    return Intl.message(
      'Please enter your comment',
      name: 'comment_required',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh`
  String get refresh {
    return Intl.message(
      'Pull down to refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Please select the field of work`
  String get select_field_of_work {
    return Intl.message(
      'Please select the field of work',
      name: 'select_field_of_work',
      desc: '',
      args: [],
    );
  }

  /// `Invalid input. Please enter 10, 20, 30, 40, etc.`
  String get scheme_qty_error {
    return Intl.message(
      'Invalid input. Please enter 10, 20, 30, 40, etc.',
      name: 'scheme_qty_error',
      desc: '',
      args: [],
    );
  }

  /// `Request Gift/Pop Materials`
  String get req_gift {
    return Intl.message(
      'Request Gift/Pop Materials',
      name: 'req_gift',
      desc: '',
      args: [],
    );
  }

  /// `Select product type`
  String get select_req_item {
    return Intl.message(
      'Select product type',
      name: 'select_req_item',
      desc: '',
      args: [],
    );
  }

  /// `Gift Request History`
  String get req_gift_history {
    return Intl.message(
      'Gift Request History',
      name: 'req_gift_history',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit the app?`
  String get exit_app {
    return Intl.message(
      'Do you want to exit the app?',
      name: 'exit_app',
      desc: '',
      args: [],
    );
  }

  /// `Non productive call`
  String get non_productive_call {
    return Intl.message(
      'Non productive call',
      name: 'non_productive_call',
      desc: '',
      args: [],
    );
  }

  /// `Special notes is required`
  String get special_note_required {
    return Intl.message(
      'Special notes is required',
      name: 'special_note_required',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid state`
  String get state_invalid {
    return Intl.message(
      'Please select a valid state',
      name: 'state_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid city`
  String get city_invalid {
    return Intl.message(
      'Please select a valid city',
      name: 'city_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid area`
  String get area_invalid {
    return Intl.message(
      'Please select a valid area',
      name: 'area_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Expense document viewer`
  String get expense_doc_view {
    return Intl.message(
      'Expense document viewer',
      name: 'expense_doc_view',
      desc: '',
      args: [],
    );
  }

  /// `Performance`
  String get performance {
    return Intl.message(
      'Performance',
      name: 'performance',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get select_date {
    return Intl.message(
      'Select Date',
      name: 'select_date',
      desc: '',
      args: [],
    );
  }

  /// `Location request timed out`
  String get location_time_out {
    return Intl.message(
      'Location request timed out',
      name: 'location_time_out',
      desc: '',
      args: [],
    );
  }

  /// `Productive`
  String get productive {
    return Intl.message(
      'Productive',
      name: 'productive',
      desc: '',
      args: [],
    );
  }

  /// `Productive call`
  String get productive_call {
    return Intl.message(
      'Productive call',
      name: 'productive_call',
      desc: '',
      args: [],
    );
  }

  /// `Non-Productive`
  String get non_productive {
    return Intl.message(
      'Non-Productive',
      name: 'non_productive',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get order_label {
    return Intl.message(
      'Orders',
      name: 'order_label',
      desc: '',
      args: [],
    );
  }

  /// `Medicals`
  String get medical_label {
    return Intl.message(
      'Medicals',
      name: 'medical_label',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expense_label {
    return Intl.message(
      'Expenses',
      name: 'expense_label',
      desc: '',
      args: [],
    );
  }

  /// `Reminders`
  String get reminder_label {
    return Intl.message(
      'Reminders',
      name: 'reminder_label',
      desc: '',
      args: [],
    );
  }

  /// `Not interested in any product`
  String get not_interested_in_any_product {
    return Intl.message(
      'Not interested in any product',
      name: 'not_interested_in_any_product',
      desc: '',
      args: [],
    );
  }

  /// `Please select product`
  String get please_select_product {
    return Intl.message(
      'Please select product',
      name: 'please_select_product',
      desc: '',
      args: [],
    );
  }

  /// `Quantity is missing`
  String get quantity_is_missing {
    return Intl.message(
      'Quantity is missing',
      name: 'quantity_is_missing',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Add item`
  String get add_item {
    return Intl.message(
      'Add item',
      name: 'add_item',
      desc: '',
      args: [],
    );
  }

  /// `Not Interested`
  String get not_interested {
    return Intl.message(
      'Not Interested',
      name: 'not_interested',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Reason`
  String get please_select_reason {
    return Intl.message(
      'Please Select Reason',
      name: 'please_select_reason',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about_us {
    return Intl.message(
      'About Us',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'messages'),
      Locale.fromSubtags(languageCode: 'mr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
