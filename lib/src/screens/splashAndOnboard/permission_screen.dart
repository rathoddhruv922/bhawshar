import 'package:bhawsar_chemical/src/widgets/app_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_snackbar_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../router/route_list.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  PermissionScreenState createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final int numPages = isAndroid ? 5 : 4;
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  bool showSettingBtn = false;
  String btnText = "Allow";
  bool isAllAllowed = false;
  bool isAcceptPolicy = false;
  List<String> titles = isAndroid
      ? [
          "Need Accept \nPrivacy Policy",
          "Need\nLocation Permission",
          "Need\nLocation Permission",
          "Need\nCamera Permission",
          "Need Photo\nAnd Media Permission",
          "You're\nAll Set"
        ]
      : [
          "Need Accept \nPrivacy Policy",
          "Need\nLocation Permission",
          "Need\nCamera Permission",
          "Need Photo\nAnd Media Permission",
          "You're\nAll Set",
        ];
  static const String permissionErrorSubtitle = "You have to allow the permission to continue";
  static const String permissionSubtitle = "Press Allow to grant permission";
  String? title;

  String subtitle = permissionSubtitle;

  late List<Permission> permissions = [];

  @override
  void initState() {
    getPermissionList();
    title = isAllAllowed == true ? titles[numPages] : titles[currentPage];
    WidgetsBinding.instance.addObserver(this);
    checkExistingPermission().then((value) {
      for (int p = 0; p < value.length; p++) {
        if (value[p][1] == PermissionStatus.granted && value[p][0] == permissions[p] && p == currentPage) {
          if ((currentPage < (numPages - 1))) {
            if (mounted) {
              setState(() {
                currentPage = p + 1;
                moveNextPage();
              });
            }
          }
        }
        if (value[p][1] == PermissionStatus.permanentlyDenied) {
          setState(() {
            btnText = "Go to setting";
          });
        }
      }
    });
    super.initState();
  }

  void getPermissionList() async {
    late final AndroidDeviceInfo androidInfo;
    if (isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }

    permissions = isAndroid
        ? [
            Permission.location,
            Permission.location,
            Permission.locationAlways,
            Permission.locationWhenInUse,
            Permission.camera,
            androidInfo.version.sdkInt <= 32 ? Permission.storage : Permission.photos,
          ]
        : [
            Permission.location,
            Permission.location,
            Permission.camera,
            Permission.storage,
          ];
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // this is when permissions are changed in app settings outside of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkExistingPermission().then((value) {
        for (int p = 0; p < value.length; p++) {
          if (value[p][1] == PermissionStatus.granted && value[p][0] == permissions[p] && p == currentPage) {
            if (mounted) {
              setState(() {
                if (isAcceptPolicy) {
                  currentPage = p + 1;
                  moveNextPage();
                }
              });
            }
          }
          if (value[p][1] == PermissionStatus.permanentlyDenied) {
            setState(() {
              btnText = "Go to setting";
            });
          }
        }
      });
    }
  }

  List existingPermissionStatus = [];

  Future checkExistingPermission() async {
    setState(() {
      existingPermissionStatus.clear();
    });
    for (int p = 0; p < permissions.length; p++) {
      PermissionStatus status = await permissions[p].status;
      setState(() {
        existingPermissionStatus.insert(p, ([permissions[p], status]));
      });
    }
    await Future.delayed(Duration.zero);
    return existingPermissionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          color: secondary,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: isAndroid
                        ? [
                            PageViewPrivacyPolicyWidget(
                              title: title!,
                              isAcceptPolicy: isAcceptPolicy,
                              onChanged: (value) {
                                setState(() {
                                  isAcceptPolicy = value!;
                                });
                              },
                            ),
                            PageViewWidget(icon: Icons.pin_drop_outlined, title: title!, subTitle: subtitle),
                            PageViewWidget(
                                icon: Icons.pin_drop_outlined,
                                title: title!,
                                subTitle: "Press Allow to grant permission.Please select Allow all the time option"),
                            PageViewWidget(icon: Icons.camera_outlined, title: title!, subTitle: subtitle),
                            PageViewWidget(
                                icon: isAllAllowed == true ? Icons.thumb_up_outlined : Icons.folder_open,
                                title: title!,
                                subTitle: subtitle),
                          ]
                        : [
                            PageViewPrivacyPolicyWidget(
                              title: title!,
                              isAcceptPolicy: isAcceptPolicy,
                              onChanged: (value) {
                                setState(() {
                                  isAcceptPolicy = value!;
                                });
                              },
                            ),
                            PageViewWidget(
                                icon: Icons.pin_drop_outlined,
                                title: title!,
                                subTitle:
                                    isAndroid ? subtitle : "Press Allow to grant permission.Please select Always Allow option"),
                            PageViewWidget(icon: Icons.camera_outlined, title: title!, subTitle: subtitle),
                            PageViewWidget(
                                icon: isAllAllowed == true ? Icons.thumb_up_outlined : Icons.folder_open,
                                title: title!,
                                subTitle: subtitle),
                          ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                const AppSpacerHeight(height: 40),
                Row(
                  children: <Widget>[
                    const AppSpacerWidth(width: 40),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (isAcceptPolicy) {
                              if (currentPage > 0) {
                                if (showSettingBtn) {
                                  await openAppSettings();
                                } else {
                                  await askPermission();
                                }
                              } else {
                                setState(() {
                                  currentPage = currentPage + 1;
                                  moveNextPage();
                                });
                              }
                            } else {
                              setState(() {
                                currentPage = 0;
                                moveNextPage();
                              });
                              mySnackbar("Please accept Privacy policy");
                            }
                          },
                          child: SizedBox(
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AppText(btnText, color: primary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const AppSpacerWidth(width: 40),
                  ],
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openSetting() async {}

  List<Widget> _buildPageIndicator() {
    return List.generate(
      numPages,
      (index) => IndicatorWidget(isActive: index == currentPage),
    );
  }

  askPermission() async {
    bool? res;
    if (currentPage == 2) {
      res = await appAlertDialog(
          context,
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                "$appName App, Collects location data for live tracking of users for attendance purposes even when the app is closed or not in use.",
                maxLine: 10,
              ),
            ],
          ),
          actionBtnOne: "Accept",
          actionBtnTwo: "Deny",
          () => Navigator.of(context).pop(true),
          () => Navigator.of(context).pop(false));
      if (res == true) {
        if (await permissions[currentPage].status.isGranted) {
          currentPage = currentPage + 1;
          moveNextPage();
        } else if (await userBox.get('isAllPermissionAllowed') == false || await userBox.get('isAllPermissionAllowed') == null) {
          PermissionStatus status = await permissions[currentPage].request();
          await handlePermissionStatus(status);
        }
      } else {
        myToastMsg("You have to Accept the permission policy to continue", isError: true);
      }
    } else {
      try {
        if (await userBox.get('isAllPermissionAllowed') == true) {
          navigationKey.currentState!.restorablePushReplacementNamed(RouteList.login);
          return;
        }
        if (await permissions[currentPage].status.isGranted) {
          PermissionStatus status = await permissions[currentPage].request();
          currentPage = currentPage + 1;
          await handlePermissionStatus(status);
          //  moveNextPage();
        } else if (await userBox.get('isAllPermissionAllowed') == false || await userBox.get('isAllPermissionAllowed') == null) {
          PermissionStatus status = await permissions[currentPage].request();
          await handlePermissionStatus(status);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void moveNextPage() async {
    if (mounted) {
      setState(() {
        showSettingBtn = false;
        btnText = "Allow";
        subtitle = permissionSubtitle;
        title = isAllAllowed == true ? titles[numPages] : titles[currentPage];
      });
    }
    if (currentPage < numPages) {
      pageController.jumpToPage(currentPage);
    } else {
      await userBox.put('isAllPermissionAllowed', true);
      if (mounted) {
        setState(() {
          currentPage = (numPages - 1);
          isAllAllowed = true;
          btnText = "Finish";
          subtitle = "Press Finish to continue.";
          title = isAllAllowed == true ? titles[numPages] : titles[currentPage];
        });
      }
    }
  }

  Future<void> handlePermissionStatus(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        moveNextPage();
        break;
      case PermissionStatus.denied:
        if (mounted) {
          setState(() {
            subtitle = permissionErrorSubtitle;
          });
        }
        break;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        if (mounted) {
          setState(() {
            btnText = "Go to setting";
            subtitle = permissionErrorSubtitle;
            showSettingBtn = true;
          });
        }
        break;
      case PermissionStatus.provisional:
        moveNextPage();
        break;
    }
  }

  Future<bool> isPermissionAllowed(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: paddingExtraSmall),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? primary : grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({super.key, required this.icon, required this.title, required this.subTitle});

  final IconData icon;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Center(
          child: CircleAvatar(backgroundColor: offWhite, radius: 100, child: Icon(icon, size: 50.sp, color: textBlack)),
        ),
        const AppSpacerHeight(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: AppText(title, fontSize: 22, color: primary),
        ),
        const AppSpacerHeight(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: AppText(
            isAndroid
                ? (subTitle.contains("all the time") ? subTitle.split(".").first : subTitle)
                : (subTitle.contains("Always Allow") ? subTitle.split(".").first : subTitle),
            maxLine: 2,
            fontSize: 18,
          ),
        ),
        (isAndroid ? subTitle.contains("all the time") : subTitle.contains("Always Allow"))
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: AppText(
                  subTitle.split(".").elementAt(1),
                  maxLine: 2,
                  color: red,
                  fontSize: 18,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class PageViewPrivacyPolicyWidget extends StatefulWidget {
  PageViewPrivacyPolicyWidget({
    Key? key,
    required this.title,
    this.onChanged,
    required this.isAcceptPolicy,
  }) : super(key: key);

  final ValueChanged<bool?>? onChanged;
  final String title;
  bool isAcceptPolicy;

  @override
  State<PageViewPrivacyPolicyWidget> createState() => _PageViewPrivacyPolicyWidgetState();
}

class _PageViewPrivacyPolicyWidgetState extends State<PageViewPrivacyPolicyWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Center(
          child: CircleAvatar(
            backgroundColor: offWhite,
            radius: 100,
            child: Icon(
              Icons.policy_outlined,
              size: 50.sp,
              color: textBlack,
            ),
          ),
        ),
        const AppSpacerHeight(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: AppText(widget.title, fontSize: 22, color: primary),
        ),
        const AppSpacerHeight(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.isAcceptPolicy,
                checkColor: primary,
                onChanged: (value) {
                  widget.isAcceptPolicy = value ?? false;
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    navigationKey.currentState?.restorablePushNamed(RouteList.privacyPolicy);
                    //navigationKey.currentState?.pushNamed(RouteList.privacyPolicy);
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "You have to accept the ",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16.sp),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16.sp,
                              color: Colors.red,
                              decorationThickness: 1.5,
                              decorationColor: Colors.red,
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: " to continue",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
