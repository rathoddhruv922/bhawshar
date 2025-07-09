import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../widgets/app_text.dart';
import 'common_container_widget.dart';

//* This widget is used in order and reminder module

class OrderTypeWidget extends StatelessWidget {
  const OrderTypeWidget(
      {super.key, required this.onChanged, required this.type});
  final ValueChanged onChanged;
  final String? type;
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      color: white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<String>(
            value: 'At Shop',
            groupValue: type,
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
                onChanged('At Shop');
              },
              child: const AppText(
                'At Shop',
                fontSize: 15,
              ),
            ),
          ),
          Radio<String>(
            value: 'On Phone',
            groupValue: type,
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
                onChanged('On Phone');
              },
              child: const AppText(
                'On Phone',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
