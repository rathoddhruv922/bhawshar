import 'package:bhawsar_chemical/data/models/reminder_model/reminder.dart' as client;
import 'package:bhawsar_chemical/src/screens/common/common_order_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/reminder/reminder_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_animated_dialog.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_picker.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_medical_card_widget.dart';
import '../../common/common_reminder_note_widget.dart';
import '../../common/common_static_reminder_day.dart';
import '../../common/common_time_picker_widget.dart';
import '../widget/message_textfield_widget.dart';

class UpdateReminderScreen extends StatelessWidget {
  final int id;

  const UpdateReminderScreen({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<ReminderBloc>().add(
          GetReminderEvent(id: id),
        );
    String? reqType = 'put';
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: offWhite,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          const AppText(
            'Update Reminder',
            color: primary,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: getBackArrow(),
            color: primary,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<ReminderBloc, ReminderState>(
            listener: (context, state) async {
              if (state.status == ReminderStatus.updating) {
                showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
              }
              if (state.status == ReminderStatus.failure) {
                mySnackbar(state.msg.toString(), isError: true);
                await Future.delayed(Duration.zero);
              }
              if (state.status == ReminderStatus.updated) {
                Navigator.of(context).pop(); // for close Loader
                mySnackbar(state.msg.toString());
                Navigator.of(context).pop(false);
              }
              if (state.status == ReminderStatus.load) {
                Navigator.of(context).pop();
              }
            },
            buildWhen: (previous, current) {
              if (previous.status == ReminderStatus.updating) {
                return false;
              }
              return current.status == ReminderStatus.load || (current.status == ReminderStatus.failure && current.res != null);
            },
            builder: (context, state) {
              if (state.status == ReminderStatus.load) {
                return Stack(
                  children: [
                    Container(
                      height: 9.h,
                      color: secondary,
                    ),
                    Column(
                      children: [
                        GlobalMedicalCard(dynamicMedicalInfo: state.res.reminder),
                        const AppSpacerHeight(height: 3),
                        UpdateReminderFormsWidget(
                          reqType: reqType,
                          item: state.res.reminder,
                        ),
                      ],
                    )
                  ],
                );
              } else if ((state.status == ReminderStatus.failure && state.res != null)) {
                return Center(child: AppText(state.msg.toString()));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class UpdateReminderFormsWidget extends StatefulWidget {
  final String? reqType;
  final int? index;
  final client.Reminder? item;

  const UpdateReminderFormsWidget({super.key, required this.item, this.reqType, this.index});

  @override
  State<UpdateReminderFormsWidget> createState() => _UpdateReminderFormsWidgetState();
}

class _UpdateReminderFormsWidgetState extends State<UpdateReminderFormsWidget> {
  static final GlobalKey<FormState> updateReminderFormKey = GlobalKey<FormState>();
  late DateTime reminderDate;
  String? reminderDays;
  late TimeOfDay selectedTime;
  bool isTimeValid = true;
  bool removeStaticDate = false; // used for unselect static date

  Map<String, dynamic> formData = {}, medicalInfo = {};
  String? reminderType = 'At Shop';
  late TextEditingController titleController, msgController;

  @override
  void initState() {
    try {
      selectedTime = getTimeOfFromDateTime(widget.item!.dateTime!);
      reminderDate = DateTime.parse((widget.item?.dateTime).toString());
      msgController = TextEditingController(text: widget.item?.message.toString());
      reminderType = widget.item?.reminderType;
    } catch (e) {
      Navigator.of(context).pop(false);
      showCatchedError(e);
      rethrow;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: updateReminderFormKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(paddingDefault),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return OrderTypeWidget(
                  type: reminderType,
                  onChanged: ((value) {
                    setState(() {
                      reminderType = value;
                    });
                  }),
                );
              },
            ),
            const AppSpacerHeight(height: 15),
            CommonStaticReminderDay(
              onDayChanged: ((value) {
                setState(() {
                  removeStaticDate = false;
                  isTimeValid = true;
                  reminderDate = value;
                  reminderDays = daysBetween(DateTime.now(), value);
                });
              }),
              removeStaticDate: removeStaticDate,
            ),
            const AppSpacerHeight(height: 15),
            CustomDatePicker(
              minDate: reminderDate,
              date: reminderDate,
              title: localization.select_reminder_date,
              onChanged: ((DateTime value) {
                setState(() {
                  removeStaticDate = true;
                  reminderDate = value;
                  DateTime temp = DateTime.parse('${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
                  if (temp.compareTo(DateTime.now()).isNegative) {
                    setState(() {
                      isTimeValid = false;
                      reminderDays ??= 'Today,';
                    });
                  } else {
                    isTimeValid = true;
                    reminderDays = daysBetween(DateTime.now(), value);
                  }
                });
              }),
            ),
            const AppSpacerHeight(height: 15),
            CommonTimePickerWidget(
                selectedTime: selectedTime,
                onTimeChanged: (value) {
                  setState(() {
                    selectedTime = value;
                    DateTime temp = DateTime.parse('${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
                    if (temp.compareTo(DateTime.now()).isNegative) {
                      setState(() {
                        isTimeValid = false;
                        reminderDays ??= 'Today,';
                      });
                    } else {
                      isTimeValid = true;
                      reminderDays = daysBetween(DateTime.now(), reminderDate);
                    }
                  });
                }),
            ReminderNotesWidget(
                reminderDays: reminderDays, context: context, isTimeValid: isTimeValid, selectedTime: selectedTime),
            AppSpacerHeight(height: reminderDays == null ? 15 : 0),
            MessageTextFieldWidget(
              msgController: msgController,
              formKey: updateReminderFormKey,
            ),
            const AppSpacerHeight(height: 15),
            SizedBox(
              child: AppButtonWithLocation(
                btnText: localization.save,
                onBtnClick: () async {
                  if (!isTimeValid) {
                    mySnackbar(localization.time_invalid, isError: true);
                  } else if (updateReminderFormKey.currentState!.validate()) {
                    int userId = await getUserId();
                    setState(() {
                      medicalInfo = {
                        "_method": "PUT",
                        "id": widget.item?.client?.id,
                        "name": widget.item?.client?.name,
                        "img": widget.item?.client?.image,
                        "mobile": widget.item?.client?.mobile,
                        "address":
                            '${widget.item?.client?.address}-${widget.item?.client?.area}, ${widget.item?.client?.city}, ${widget.item?.client?.state}, ${widget.item?.client?.zip}',
                      };
                      formData = {
                        "_method": "PUT",
                        "user_id": userId,
                        "reminder_id": widget.item?.id,
                        "reminder_type": reminderType,
                        "client_id": widget.item?.client?.id,
                        "message": msgController.text.trim(),
                        "date_time": '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}',
                        "reqType": widget.reqType,
                      };
                    });

                    context.read<ReminderBloc>().add(
                          AddReminderEvent(formData: formData, reqType: widget.reqType!, medicalInfo: medicalInfo),
                        );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
