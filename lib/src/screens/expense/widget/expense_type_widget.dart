import 'package:flutter/material.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

class ExpenseTypeWidget extends StatelessWidget {
  const ExpenseTypeWidget(
      {super.key, required this.onChanged, required this.expenseType});
  final ValueChanged onChanged;
  final String? expenseType;
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: paddingDefault, top: paddingDefault),
            child: AppText(
              localization.select_expense_type,
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Travel',
                groupValue: expenseType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              InkWell(
                onTap: () {
                  onChanged('Travel');
                },
                child: const AppText(
                  'Travel',
                  fontSize: 16,
                ),
              ),
              Radio<String>(
                value: 'Miscellaneous',
                groupValue: expenseType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              InkWell(
                onTap: () {
                  onChanged('Miscellaneous');
                },
                child: const AppText(
                  'Miscellaneous',
                  fontSize: 16,
                ),
              ),
              Radio<String>(
                value: 'DA',
                groupValue: expenseType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              InkWell(
                onTap: () {
                  onChanged('DA');
                },
                child: const AppText(
                  'DA',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
