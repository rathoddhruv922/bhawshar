import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubit/locale_cubit/locale_cubit.dart';
import '../../../constants/app_const.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';
import '../common/common_container_widget.dart';

class ChangeLocale extends StatelessWidget {
  const ChangeLocale({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        AppText(
          localization.language_change,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(localization.language_select),
            const AppSpacerHeight(height: 15),
            CommonContainer(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BlocConsumer<LocaleCubit, LocaleState>(
                buildWhen: (previousState, currentState) =>
                    previousState != currentState,
                listener: (ctx, state) {
                  if (state is SelectedLocale) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (_, localeState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Radio<String>(
                          value: 'en',
                          groupValue: localeState.locale.languageCode,
                          activeColor: primary,
                          onChanged: (String? value) {
                            if (value != null) {
                              BlocProvider.of<LocaleCubit>(context)
                                  .setLocale(const Locale('en'));
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<LocaleCubit>(context)
                                .setLocale(const Locale('en'));
                          },
                          child: const AppText(
                            'English',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Radio<String>(
                          value: 'hi',
                          groupValue: localeState.locale.languageCode,
                          activeColor: primary,
                          onChanged: (String? value) {
                            if (value != null) {
                              BlocProvider.of<LocaleCubit>(context)
                                  .setLocale(const Locale('hi'));
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<LocaleCubit>(context)
                                .setLocale(const Locale('hi'));
                          },
                          child: const AppText(
                            'हिन्दी',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Radio<String>(
                          value: 'mr',
                          groupValue: localeState.locale.languageCode,
                          activeColor: primary,
                          onChanged: (String? value) {
                            if (value != null) {
                              final blocA =
                                  BlocProvider.of<LocaleCubit>(context);
                              blocA.setLocale(const Locale('mr'));
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<LocaleCubit>(context)
                                .setLocale(const Locale('mr'));
                          },
                          child: const AppText(
                            'मराठी',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
