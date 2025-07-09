import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List drawerCategoryList = [
      {
        'name': localization.language_change,
        'img': 'assets/svg/translate_icon.svg',
        'routeName': RouteList.changeLocale,
      },
      {
        'name': localization.password_change,
        'img': 'assets/svg/lock_icon.svg',
        'routeName': RouteList.changePassword,
      },
      {
        'name': localization.feedback,
        'img': 'assets/svg/feedback_icon.svg',
        'routeName': RouteList.feedback,
      },
      {
        'name': localization.performance,
        'img': 'assets/svg/performance.svg',
        'routeName': RouteList.performance,
      },
      {
        'name': localization.privacy_policy,
        'img': 'assets/svg/privacy_policy.svg',
        'routeName': RouteList.privacyPolicy,
      },
      {
        'name': localization.about_us,
        'img': 'assets/svg/about.svg',
        'routeName': RouteList.aboutUs,
      },
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: drawerCategoryList.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SvgPicture.asset(
              drawerCategoryList[i]['img'],
              colorFilter: const ColorFilter.mode(primary, BlendMode.srcATop),
              height: 20.sp,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: AppText(
                  drawerCategoryList[i]['name'],
                ),
              ),
              const AppSpacerWidth(),
              drawerCategoryList[i]['name'] == localization.feedback
                  ? ValueListenableBuilder(
                      valueListenable: openFeedbackCount,
                      builder: (context, value, widget) {
                        return Container(
                          padding: const EdgeInsets.all(5.0),
                          height: 30,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: red),
                          child: FittedBox(
                            child: AppText(
                              '${openFeedbackCount.value}',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: white,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink()
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: primary,
          ),
          onTap: () async {
            Navigator.pop(context);
            navigationKey.currentState?.restorablePushNamed(drawerCategoryList[i]['routeName']);
          },
        );
      },
    );
  }
}
