// ignore_for_file: unused_element, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../constants/app_const.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_loader_simple.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_switcher_widget.dart';
import '../../widgets/app_text.dart';
import 'dart:io' as platform;
import 'package:cached_network_image/cached_network_image.dart';

import 'common_container_widget.dart';

class CommonImagePicker extends StatefulWidget {
  const CommonImagePicker(
      {super.key,
      required this.imageFile,
      this.onPickedImage,
      this.networkImageUrl});

  final XFile? imageFile;
  final String? networkImageUrl;
  final ValueChanged? onPickedImage;

  @override
  State<CommonImagePicker> createState() => _CommonImagePickerState();
}

class _CommonImagePickerState extends State<CommonImagePicker>
    with WidgetsBindingObserver {
  bool isCameraPermissionAllow = true, isPhotoPermissionAllow = true;
  bool isLoading = false;
  dynamic pickImageError;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    hideKeyboard();
    updatePermissionStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await updatePermissionStatus();
    }
  }

  Future<void> updatePermissionStatus() async {
    await checkPermissions(Permission.camera).then((status) {
      if (status) {
        if (mounted) {
          setState(() {
            isCameraPermissionAllow = status;
          });
        }
      } else {
        myToastMsg(localization.camera_permission_request, isError: true);
        if (mounted) {
          setState(() {
            isCameraPermissionAllow = status;
          });
        }
      }
    });
    if (isIOS) {
      await checkPermissions(Permission.photos).then((status) {
        if (status) {
          if (mounted) {
            setState(() {
              isPhotoPermissionAllow = status;
            });
          }
        } else {
          myToastMsg(localization.photo_permission_request, isError: true);
          if (mounted) {
            setState(() {
              isPhotoPermissionAllow = status;
            });
          }
        }
      });
    }
  }

  // CHECK PERMISSION
  Future<bool> checkPermissions(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      return false;
    } else {
      return false;
    }
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    hideKeyboard();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      if (pickedFile != null) {
        int size = await pickedFile.length();
        double sizeInMB = size / (1024 * 1024);
        if (sizeInMB < 5) {
          if (widget.onPickedImage != null) {
            widget.onPickedImage!(pickedFile);
          }
          if (mounted) {
            setState(() {
              pickImageError = null;
              isLoading = false;
            });
          }
        } else {
          showCatchedError(localization.image_size_error);
          if (mounted) {
            setState(() {
              pickImageError = localization.image_size_error;
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (e.toString().contains("denied") == false) {
        if (mounted) {
          setState(() {
            pickImageError = e;
            isLoading = false;
          });
        }
      }
      showCatchedError(e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget previewImages() {
    return Semantics(
      label: 'image',
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            constraints: BoxConstraints.tightFor(width: 60.sp, height: 45.sp),
            decoration: BoxDecoration(
              border: Border.all(color: grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ((widget.networkImageUrl == null ||
                          widget.networkImageUrl == "") &&
                      widget.imageFile != null &&
                      widget.imageFile?.path != 'NA')
                  ? Image.file(
                      platform.File((widget.imageFile?.path).toString()),
                      semanticLabel: "image",
                      errorBuilder: (context, url, error) => const Icon(
                        Icons.error_outline,
                        color: primary,
                      ),
                      fit: BoxFit.fitWidth,
                    )
                  : CachedNetworkImage(
                      httpHeaders: {
                        "Referer":
                            "https://mobile.bhawsarayurveda.in/" //used for accessing AWS server storage image
                      },
                      imageUrl: "${widget.networkImageUrl}",
                      placeholder: (context, url) => const AppLoader(),
                      errorWidget: (context, url, error) => Container(
                        width: 45.sp,
                        height: 43.sp,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.error_outline,
                          color: primary,
                        ),
                      ),
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.medium,
                    ),
            ),
          ),
          widget.networkImageUrl?.contains("default.jpeg") == true
              ? const SizedBox.shrink()
              : Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  height: 30,
                  decoration: const BoxDecoration(
                    color: offWhite,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.delete_forever_outlined,
                        size: 18.sp, color: errorRed),
                    onPressed: () {
                      widget.onPickedImage!(true);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          AppText(localization.photo_add),
          const AppSpacerHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'image_pick_from_camera',
                child: FloatingActionButton(
                  backgroundColor: greyLight,
                  onPressed: () async {
                    await onImageButtonPressed(ImageSource.camera,
                        context: context);
                  },
                  heroTag: 'image_camera',
                  tooltip: 'Take a Photo',
                  child: const Icon(
                    Icons.camera_alt,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isCameraPermissionAllow && isPhotoPermissionAllow
                ? false
                : true,
            child: InkWell(
              onTap: () async {
                openAppSettings();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: paddingSmall),
                child: AppText(
                    textAlign: TextAlign.center,
                    color: errorRed,
                    isUnderline: true,
                    isCameraPermissionAllow
                        ? localization.photo_permission_request
                        : localization.camera_permission_request),
              ),
            ),
          ),
          const AppSpacerHeight(),
          Center(
            child: AppSwitcherWidget(
                child: pickImageError != null
                    ? AppText(
                        '$pickImageError',
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox()),
          ),
          Center(
            child: AppSwitcherWidget(
                animationType: "scale",
                child: isLoading
                    ? Semantics(label: 'image', child: const AppLoader())
                    : (((widget.imageFile == null ||
                                widget.imageFile?.path == 'NA') &&
                            widget.networkImageUrl == null))
                        ? (pickImageError == null)
                            ? AppText(
                                localization.photo_upload,
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox()
                        : previewImages()),
          ),
        ],
      ),
    );
  }
}
