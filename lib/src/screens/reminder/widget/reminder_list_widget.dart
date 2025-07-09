import 'package:bhawsar_chemical/src/screens/reminder/widget/reminder_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/bloc/reminder/reminder_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../data/models/reminders_model/reminders_model.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_text.dart';

class ReminderList extends StatefulWidget {
  final RemindersModel reminderList;
  final bool hasReachedMax;
  const ReminderList(
      {Key? key, required this.reminderList, required this.hasReachedMax})
      : super(key: key);

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  final ScrollController _pastScrollController = ScrollController();

  @override
  void initState() {
    _pastScrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pastScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ReminderBloc>().add(GetRemindersEvent(
          currentPage: widget.reminderList.meta!.currentPage! + 1,
          recordPerPage: 20));
    }
  }

  bool get _isBottom {
    final maxScroll = _pastScrollController.position.maxScrollExtent;
    final currentScroll = _pastScrollController.offset;
    return currentScroll >= (maxScroll * 0.90);
  }

  @override
  Widget build(BuildContext context) {
    return
        // CustomRefreshIndicator(
        //   onRefresh: () async {
        //     context.read<ReminderBloc>()
        //       ..add(const ClearReminderEvent())
        //       ..add(const GetRemindersEvent(currentPage: 1, recordPerPage: 20));
        //   },
        //   builder: (
        //     BuildContext context,
        //     Widget child,
        //     IndicatorController controller,
        //   ) {
        //     return RefreshIndi(context, controller, child, 50);
        //   },
        //   child:
        ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _pastScrollController,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.reminderList.items?[0].today?.length ?? 0,
          itemBuilder: (buildContext, t) {
            return Column(
              children: [
                Visibility(
                  visible: t == 0 ? true : false,
                  child: Chip(label: AppText(localization.today)),
                ),
                ReminderCard(
                    reminder: widget.reminderList.items![0].today![t],
                    index: t,
                    type: "today",
                    expired: isExpired(
                      DateTime.parse(
                          widget.reminderList.items![0].today![t].dateTime!),
                    )),
              ],
            );
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.reminderList.items?[0].tomorrow?.length ?? 0,
          itemBuilder: (buildContext, t) {
            return Column(
              children: [
                Visibility(
                  visible: t == 0 ? true : false,
                  child: Chip(label: AppText(localization.tomorrow)),
                ),
                ReminderCard(
                    reminder: widget.reminderList.items![0].tomorrow![t],
                    index: t,
                    type: "tomorrow",
                    expired: isExpired(
                      DateTime.parse(
                          widget.reminderList.items![0].tomorrow![t].dateTime!),
                    )),
              ],
            );
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: (widget.reminderList.items?[0].past!.length)! + 1,
          itemBuilder: (buildContext, index) {
            if (widget.reminderList.items![0].today!.isEmpty &&
                widget.reminderList.items![0].tomorrow!.isEmpty &&
                widget.reminderList.items![0].past!.isEmpty) {
              return Center(
                child: AppText(localization.empty),
              );
            } else if (index >=
                int.parse(
                    (widget.reminderList.items?[0].past!.length).toString())) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                child: widget.hasReachedMax
                    ? Center(
                        child: AppText(localization.no_more_data),
                      )
                    : const AppLoader(),
              );
            } else {
              return Column(
                children: [
                  Visibility(
                    visible: index == 0 ? true : false,
                    child: Chip(label: AppText(localization.past_three_month)),
                  ),
                  ReminderCard(
                      reminder: widget.reminderList.items![0].past![index],
                      index: index,
                      type: "past",
                      expired: isExpired(
                        DateTime.parse(widget
                            .reminderList.items![0].past![index].dateTime!),
                      ))
                ],
              );
            }
          },
        ),
      ],
      // ),
    );
  }
}
