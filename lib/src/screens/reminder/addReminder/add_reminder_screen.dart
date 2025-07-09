import 'package:bhawsar_chemical/src/screens/common/common_order_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/reminder/reminder_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../helper/app_helper.dart';
import '../../../../hive/hive_reminder.dart';
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

import 'package:bhawsar_chemical/data/models/medical_model/item.dart'
    as medical;

import '../../common/common_static_reminder_day.dart';
import '../../common/common_time_picker_widget.dart';
import '../../common/common_medical_card_widget.dart';
import '../../common/common_reminder_note_widget.dart';
import '../widget/message_textfield_widget.dart';

class AddReminderScreen extends StatelessWidget {
  final medical.Item medicalInfo;
  final HiveReminder? reminderInfo;
  final dynamic item;
  final int? index;
  const AddReminderScreen(
      {super.key,
      required this.medicalInfo,
      this.reminderInfo,
      this.item,
      this.index});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    String? reqType = 'post';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        AppText(
          localization.reminder_add,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<ReminderBloc, ReminderState>(
          listener: (context, state) async {
            if (state.status == ReminderStatus.adding) {
              showAnimatedDialog(context, const AppDialogLoader());
            } else if (state.status == ReminderStatus.added) {
              Navigator.of(context).pop(); // for close Loader
              mySnackbar(state.msg.toString());
              await Future.delayed(Duration.zero);
              Navigator.of(context).pop(true);
            } else if (state.status == ReminderStatus.failure) {
              await Future.delayed(Duration.zero);
              mySnackbar(state.msg.toString(), isError: true);
            }
          },
          child: Stack(
            children: [
              Container(
                height: 9.h,
                color: secondary,
              ),
              Column(
                children: [
                  GlobalMedicalCard(medicalInfo: medicalInfo),
                  const AppSpacerHeight(height: 3),
                  AddReminderFormWidget(
                    reqType: reqType,
                    index: index,
                    medicalInfo: medicalInfo,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddReminderFormWidget extends StatefulWidget {
  final String? reqType;
  final int? index;
  final medical.Item medicalInfo;
  const AddReminderFormWidget(
      {Key? key, required this.medicalInfo, this.reqType, this.index})
      : super(key: key);

  @override
  State<AddReminderFormWidget> createState() => _AddReminderFormWidgetState();
}

class _AddReminderFormWidgetState extends State<AddReminderFormWidget> {
  static final GlobalKey<FormState> addReminderFormKey = GlobalKey<FormState>();
  DateTime reminderDate = DateTime.now();
  String? reminderDays;

  Map<String, dynamic> formData = {}, medicalInfo = {};
  TextEditingController titleController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isTimeValid = true;
  bool removeStaticDate = false; // used for unselect static date
  String? reminderType = 'At Shop';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: addReminderFormKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(
            paddingDefault,
          ),
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
                  reminderDays =
                      reminderDays = daysBetween(DateTime.now(), value);
                });
              }),
              removeStaticDate: removeStaticDate,
            ),
            const AppSpacerHeight(height: 15),
            CustomDatePicker(
              minDate: DateTime.now(),
              date: reminderDate,
              title: localization.select_reminder_date,
              onChanged: ((DateTime value) {
                setState(() {
                  removeStaticDate = true;
                  reminderDate = value;
                  DateTime temp = DateTime.parse(
                      '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
                  if (temp.compareTo(DateTime.now()).isNegative) {
                    setState(() {
                      isTimeValid = false;
                      reminderDays ??= 'Today,';
                    });
                  } else {
                    isTimeValid = true;
                    reminderDays =
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
                    DateTime temp = DateTime.parse(
                        '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
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
                reminderDays: reminderDays,
                isTimeValid: isTimeValid,
                context: context,
                selectedTime: selectedTime),
            AppSpacerHeight(height: reminderDays == null ? 15 : 0),
            MessageTextFieldWidget(
              msgController: msgController,
              formKey: addReminderFormKey,
            ),
            const AppSpacerHeight(height: 15),
            SizedBox(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AppButtonWithLocation(
                    btnText: localization.save,
                    onBtnClick: () async {
                      hideKeyboard();
                      if (!isTimeValid) {
                        mySnackbar(localization.time_invalid, isError: true);
                      } else if (addReminderFormKey.currentState!.validate()) {
                        int userId = await getUserId();
                        setState(() {
                          medicalInfo = {
                            "id": widget.medicalInfo.id,
                            "name": widget.medicalInfo.name,
                            "img": widget.medicalInfo.image,
                            "mobile": widget.medicalInfo.mobile,
                            "address":
                                '${widget.medicalInfo.address}-${widget.medicalInfo.area}, ${widget.medicalInfo.city}, ${widget.medicalInfo.state}, ${widget.medicalInfo.zip}',
                          };
                          formData = {
                            "user_id": userId,
                            "reminder_id": -1,
                            "reminder_type": reminderType,
                            "client_id": widget.medicalInfo.id,
                            "message": msgController.text.trim(),
                            "date_time":
                                '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}',
                            "reqType": widget.reqType,
                          };
                        });
                        context.read<ReminderBloc>().add(
                              AddReminderEvent(
                                  formData: formData,
                                  reqType: widget.reqType ?? 'post',
                                  medicalInfo: medicalInfo),
                            );
                      }
                    },
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
