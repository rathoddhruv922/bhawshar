import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FieldOfWorkSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map>(
      valueListenable: userInfo,
      builder: (BuildContext context, user, widget) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: paddingDefault,
                  top: paddingDefault,
                ),
                child: AppText(
                  localization.select_field_of_work,
                  fontSize: 16,
                  color: grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Radio<String>(
                      value: 'MKT',
                      groupValue: user['field_of_work'],
                      activeColor: primary,
                      onChanged: (String? value) async {
                        if (value != null) {
                          await updateUserFieldOfWork('field_of_work', value);
                          Navigator.of(context)
                              .pop(true); // true means work from market
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        await updateUserFieldOfWork('field_of_work', 'MKT');
                        Navigator.of(context)
                            .pop(true); // true means work from market
                      },
                      child: const AppText(
                        'Market',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Radio<String>(
                      value: 'WFH',
                      groupValue: user['field_of_work'].toString(),
                      activeColor: primary,
                      onChanged: (String? value) async {
                        if (value != null) {
                          await updateUserFieldOfWork('field_of_work', value);
                          Navigator.of(context)
                              .pop(false); // false means work from home
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        await updateUserFieldOfWork('field_of_work', 'WFH');
                        Navigator.of(context)
                            .pop(false); // false means work from home
                      },
                      child: const AppText(
                        'Work From Home',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
