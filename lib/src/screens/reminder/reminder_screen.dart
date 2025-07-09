import 'package:bhawsar_chemical/src/screens/reminder/widget/add_reminder_button_widget.dart';
import 'package:bhawsar_chemical/src/screens/reminder/widget/reminder_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../business_logic/bloc/reminder/reminder_bloc.dart';
import '../../../constants/enums.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_connection_widget.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_text.dart';
import '../common/common_reload_widget.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    context.read<ReminderBloc>()
      ..add(const ClearReminderEvent())
      ..add(const GetRemindersEvent(currentPage: 1, recordPerPage: 20));
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: CustomAppBar(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: AppText(
                  localization.my_reminder,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  backgroundColor: primary,
                  label: ValueListenableBuilder(
                    valueListenable: reminderCount,
                    builder: (context, value, widget) {
                      return AppText(
                        '${localization.pending} : ${reminderCount.value}',
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      floatingActionButton: const AddReminderWidget(),
      body: SafeArea(
        child: ConnectionStatus(
          isShowAnimation: true,
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: BlocConsumer<ReminderBloc, ReminderState>(
              listenWhen: (previous, current) {
                if ((previous.status == ReminderStatus.updating ||
                        previous.status == ReminderStatus.adding) &&
                    current.status == ReminderStatus.load) {
                  return false;
                }
                return true;
              },
              listener: (context, state) async {
                if (state.status == ReminderStatus.added ||
                    state.status == ReminderStatus.updated ||
                    state.status == ReminderStatus.deleted) {
                  await Future.delayed(Duration.zero);
                  context.read<ReminderBloc>().add(
                        const GetRemindersEvent(
                            currentPage: 1, recordPerPage: 20),
                      );
                }
                if (state.status == ReminderStatus.loading ||
                    state.status == ReminderStatus.completing ||
                    state.status == ReminderStatus.deleting) {
                  showAnimatedDialog(context, const AppDialogLoader());
                }
                if (state.status == ReminderStatus.deleted ||
                    state.status == ReminderStatus.completed ||
                    state.status == ReminderStatus.failure) {
                  Navigator.of(context).pop();
                  mySnackbar(state.msg.toString(),
                      isError: state.status == ReminderStatus.failure
                          ? true
                          : false);
                  await Future.delayed(Duration.zero);
                }
                if (state.status == ReminderStatus.loaded) {
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (previous, current) {
                if (previous.status == ReminderStatus.adding ||
                    previous.status == ReminderStatus.updating) {
                  return false;
                } else if (current.status == ReminderStatus.deleted ||
                    current.status == ReminderStatus.loaded ||
                    current.status == ReminderStatus.initial ||
                    current.status == ReminderStatus.completed ||
                    current.res == null &&
                        current.status == ReminderStatus.failure) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state.status == ReminderStatus.initial) {
                  return Center(child: AppText(state.msg.toString()));
                } else if (state.res == null &&
                    state.status == ReminderStatus.failure) {
                  return CommonReloadWidget(
                      message: state.msg,
                      reload: state.msg.toString() == localization.network_error
                          ? (context.read<ReminderBloc>()
                            ..add(const ClearReminderEvent())
                            ..add(const GetRemindersEvent(
                                currentPage: 1, recordPerPage: 20)))
                          : null);
                } else if (state.status == ReminderStatus.loaded ||
                    state.status == ReminderStatus.completed ||
                    state.status == ReminderStatus.deleted) {
                  return (state.res == null ||
                          state.res?.items?.length == 0 ||
                          (state.res?.items![0].today!.isEmpty &&
                              state.res?.items![0].tomorrow!.isEmpty &&
                              state.res?.items![0].past!.isEmpty))
                      ? Center(child: AppText(localization.empty))
                      : ReminderList(
                          reminderList: state.res,
                          hasReachedMax: state.hasReachedMax);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
