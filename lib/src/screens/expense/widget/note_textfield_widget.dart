import 'package:flutter/material.dart';

import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/form_validator.dart';
import '../../../widgets/app_text_field.dart';

class NoteTextFieldWidget extends StatelessWidget {
  const NoteTextFieldWidget({
    Key? key,
    required this.expenseNoteController,
    this.errorList,
  }) : super(key: key);
  final TextEditingController expenseNoteController;
  final Map<String, String>? errorList;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      textEditingController: expenseNoteController,
      labelText: localization.note,
      hintText: localization.note_enter,
      errorText: errorList != null ? getError('note', errorList) : null,
      maxLine: 5,
      textInputAction: TextInputAction.done,
      minLine: 2,
      formValidator: (value) {
        return FormValidate.requiredField(value!, localization.note_required);
      },
    );
  }
}
