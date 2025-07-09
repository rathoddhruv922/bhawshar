import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhawsar_chemical/main.dart';

import '../../../generated/l10n.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(SelectedLocale(Locale(userBox.get('locale') ?? 'en')));

  Future setLocale(Locale locale) async {
    await userBox.put('locale', locale.languageCode);
    localization = S.of(navigationKey.currentContext!);
    emit(SelectedLocale(locale));
  }
}
