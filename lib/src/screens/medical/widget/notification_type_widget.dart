import 'package:flutter/material.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

class NotificationTypeWidget extends StatelessWidget {
  const NotificationTypeWidget(
      {super.key, required this.onChanged, required this.type});
  final ValueChanged onChanged;
  final String? type;
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: paddingDefault, top: paddingDefault),
            child: AppText(
              localization.notification_preference,
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: 'WhatsApp',
                      toggleable: true,
                      groupValue: type,
                      activeColor: primary,
                      onChanged: (String? value) {
                        if (value != null) {
                          onChanged(value);
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        onChanged('WhatsApp');
                      },
                      child: const AppText(
                        'WhatsApp',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: 'Email',
                      groupValue: type,
                      activeColor: primary,
                      onChanged: (String? value) {
                        if (value != null) {
                          onChanged(value);
                        }
                      },
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          onChanged('Email');
                        },
                        child: const AppText(
                          'Email',
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: 'Both',
                      groupValue: type,
                      activeColor: primary,
                      onChanged: (String? value) {
                        if (value != null) {
                          onChanged(value);
                        }
                      },
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          onChanged('Both');
                        },
                        child: const AppText(
                          'Both',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
