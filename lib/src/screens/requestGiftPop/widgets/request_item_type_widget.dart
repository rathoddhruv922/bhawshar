import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/common/common_container_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RequestItemTypeWidget extends StatelessWidget {
  const RequestItemTypeWidget(
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
              localization.select_req_item,
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
                      value: 'Gift Article',
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
                        onChanged('Gift Article');
                      },
                      child: const AppText(
                        'Gift Article',
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
                      value: 'Pop Material',
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
                          onChanged('Pop Material');
                        },
                        child: const AppText(
                          'Pop Material',
                          fontSize: 16,
                        ),
                      ),
                    )
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
