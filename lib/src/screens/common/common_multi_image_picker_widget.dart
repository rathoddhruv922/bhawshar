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

import 'common_container_widget.dart';

class CommonMultiImagePicker extends StatefulWidget {
  const CommonMultiImagePicker({
    super.key,
    required this.paths,
    this.onPickedImage,
  });

  final List<XFile?> paths;
  final ValueChanged? onPickedImage;

  @override
  State<CommonMultiImagePicker> createState() => _CommonMultiImagePickerState();
}

class _CommonMultiImagePickerState extends State<CommonMultiImagePicker>
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
      final List<XFile?> pickedImages = await _picker.pickMultiImage(
        imageQuality: 50,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      if (pickedImages.isNotEmpty) {
        //? FOR FIXED IMAGE ROTATE
        for (XFile? pickedPath in pickedImages) {
          if (pickedPath != null) {
            // if (isIOS) {
            //   final img.Image? capturedImage =
            //       img.decodeImage(await File(pickedPath.path).readAsBytes());
            //   final img.Image orientedImage =
            //       img.bakeOrientation(capturedImage!);
            //   await File(pickedPath.path)
            //       .writeAsBytes(img.encodeJpg(orientedImage));
            // }
            //? END ROTATE SECTION
            int size = await pickedPath.length();
            double sizeInMB = size / (1024 * 1024);
            if (sizeInMB < 5) {
              if (widget.onPickedImage != null) {
                widget.onPickedImage!(pickedImages);
              }
              if (mounted) {
                setState(() {
                  pickImageError = null;
                });
              }
            } else {
              showCatchedError(localization.image_size_error);
              if (mounted) {
                setState(() {
                  pickImageError = localization.image_size_error;
                });
              }
            }
          }
        }
      }
    } catch (e) {
      if (e.toString().contains("denied") == false) {
        if (mounted) {
          setState(() {
            pickImageError = e;
          });
        }
      }
      showCatchedError(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(localization.attachment_add),
          const AppSpacerHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'image_pick_from_gallery',
                child: FloatingActionButton(
                  backgroundColor: greyLight,
                  onPressed: () async {
                    await onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  heroTag: 'image_gallery',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(
                    Icons.photo,
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
          Flexible(
            child: AppSwitcherWidget(
              animationType: "scale",
              child: isLoading
                  ? Semantics(label: 'image', child: const AppLoader())
                  : (widget.paths.isEmpty)
                      ? const SizedBox()
                      : Container(
                          height: 100,
                          padding: const EdgeInsets.only(
                            left: paddingExtraSmall,
                            top: paddingExtraSmall,
                            bottom: paddingExtraSmall,
                          ),
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: greyLight,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListView.builder(
                            itemCount: widget.paths.length,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return AppSwitcherWidget(
                                  animationType: "scale",
                                  child: isLoading
                                      ? Semantics(
                                          label: 'image',
                                          child: const AppLoader())
                                      : previewImages(
                                          widget.paths[index]?.path, index));
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget previewImages(String? imgPath, int index) {
    return Semantics(
      label: 'image',
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            constraints: BoxConstraints.tightFor(width: 45.sp, height: 45.sp),
            decoration: BoxDecoration(
              border: Border.all(color: grey, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(right: paddingExtraSmall),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(
                platform.File((imgPath).toString()),
                semanticLabel: "image",
                errorBuilder: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: primary,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: paddingExtraSmall),
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
                //Todo: code for remove picked image
                widget.paths.removeAt(index);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
