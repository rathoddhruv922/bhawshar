import 'package:flutter/material.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../widgets/app_text_field.dart';

class OrderNotesTextFieldWidget extends StatelessWidget {
  const OrderNotesTextFieldWidget({
    Key? key,
    required this.orderNotesController,
    this.errorList,
  }) : super(key: key);

  final TextEditingController orderNotesController;
  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: orderNotesController,
      labelText: localization.special_note,
      hintText: localization.special_note_enter,
      maxLine: 10,
      minLine: 2,
      errorText: errorList != null ? getError('notes', errorList) : null,
      textInputAction: TextInputAction.done,
    );
  }
}
