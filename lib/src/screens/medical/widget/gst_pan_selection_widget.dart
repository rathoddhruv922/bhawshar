import 'package:bhawsar_chemical/src/screens/common/common_container_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';

//* This widget is used in order and reminder module

class GSTorPANselectionWidget extends StatelessWidget {
  const GSTorPANselectionWidget(
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
            value: 'GST',
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
                onChanged('GST');
              },
              child: const AppText(
                'GST',
                fontSize: 15,
              ),
            ),
          ),
          Radio<String>(
            value: 'PAN',
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
                onChanged('PAN');
              },
              child: const AppText(
                'PAN',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
