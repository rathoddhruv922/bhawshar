import 'package:flutter/material.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

class FeedbackModuleTypeWidget extends StatelessWidget {
  const FeedbackModuleTypeWidget(
      {super.key, required this.onChanged, required this.feedbackType});
  final ValueChanged onChanged;
  final String? feedbackType;
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
              localization.feedback_type,
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<String>(
                value: 'Client',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Client');
                  },
                  child: const AppText(
                    'Client',
                    fontSize: 15,
                  ),
                ),
              ),
              Radio<String>(
                value: 'Reminder',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Reminder');
                  },
                  child: const AppText(
                    'Reminder',
                    fontSize: 15,
                  ),
                ),
              ),
              Radio<String>(
                value: 'Expense',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Expense');
                  },
                  child: const AppText(
                    'Expense',
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<String>(
                value: 'Order',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Order');
                  },
                  child: const AppText(
                    'Order',
                    fontSize: 15,
                  ),
                ),
              ),
              Radio<String>(
                value: 'Product',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Product');
                  },
                  child: const AppText(
                    'Product',
                    fontSize: 15,
                  ),
                ),
              ),
              Radio<String>(
                value: 'Other',
                groupValue: feedbackType,
                activeColor: primary,
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onChanged('Other');
                  },
                  child: const AppText(
                    'Other',
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
