import 'package:bhawsar_chemical/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../constants/app_const.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

class HomeCategoryWidget extends StatelessWidget {
  const HomeCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    S locally = S.of(context);
    List categoryList = [
      {'name': locally.medical_add, 'img': 'assets/svg/add_medical.svg'},
      {'name': locally.medical_search, 'img': 'assets/svg/search_medical.svg'},
      {'name': locally.order_history, 'img': 'assets/svg/add_order.svg'},
      {'name': locally.travel_food_expense, 'img': 'assets/svg/travel.svg'},
      {'name': locally.req_gift, 'img': 'assets/svg/gift.svg'},
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: categoryList.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
          semanticContainer: false,
          shadowColor: greyLight.withOpacity(0.5),
          color: white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingDefault,
          ),
          child: InkWell(
            key: Key(index.toString()),
            onTap: () async {
              switch (index) {
                case 0:
                  navigationKey.currentState
                      ?.restorablePushNamed(RouteList.addMedical);
                  break;
                case 1:
                  navigationKey.currentState
                      ?.restorablePushNamed(RouteList.searchMedical);
                  break;
                case 2:
                  navigationKey.currentState
                      ?.restorablePushNamed(RouteList.order);
                  break;
                case 3:
                  navigationKey.currentState
                      ?.restorablePushNamed(RouteList.expense);
                  break;
                case 4:
                  navigationKey.currentState
                      ?.restorablePushNamed(RouteList.requestGiftPopHistory);
                  break;
                default:
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: paddingLarge, horizontal: paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    categoryList[index]['img'],
                    height: 32.sp,
                  ),
                  const AppSpacerWidth(width: 12),
                  Expanded(
                    child: AppText(
                      categoryList[index]['name'].toString().toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: primary,
                      maxLine: 2,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
