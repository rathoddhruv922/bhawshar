import 'package:flutter/material.dart';

import '../../../constants/app_const.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_text.dart';
import 'common_container_widget.dart';

class ClientTypeWidget extends StatelessWidget {
  const ClientTypeWidget(
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
              left: paddingDefault,
              top: paddingDefault,
            ),
            child: AppText(
              localization.client_type,
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: 'Medical',
                        groupValue: type,
                        activeColor: primary,
                        onChanged: (String? value) {
                          onChanged(value);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          onChanged('Medical');
                        },
                        child: const AppText(
                          'Medical',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: 'Warehouse',
                        groupValue: type,
                        activeColor: primary,
                        onChanged: (String? value) {
                          onChanged(value);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          onChanged('Warehouse');
                        },
                        child: const AppText(
                          'Warehouse',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Doctor',
                        groupValue: type,
                        activeColor: primary,
                        onChanged: (String? value) {
                          onChanged(value);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          onChanged('Doctor');
                        },
                        child: const AppText(
                          'Doctor',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: 'Distributor',
                        groupValue: type,
                        activeColor: primary,
                        onChanged: (String? value) {
                          onChanged(value);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          onChanged('Distributor');
                        },
                        child: const AppText(
                          'Distributor',
                          fontSize: 16,
                          maxLine: 1,
                        ),
                      ),
                    ],
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
