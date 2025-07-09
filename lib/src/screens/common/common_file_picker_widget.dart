// ignore_for_file: depend_on_referenced_packages

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:bhawsar_chemical/data/models/expenses_model/receipt.dart'
    as expense_receipt;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
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
import 'common_container_widget.dart';

class CommonFilePicker extends StatefulWidget {
  const CommonFilePicker({
    super.key,
    required this.paths,
    this.receipts,
    this.title = 'Receipt',
    this.deletedFileId,
    this.onPickedFile,
  });

  final List<PlatformFile>? paths;
  final List<expense_receipt.Receipt?>? receipts;
  final ValueChanged? deletedFileId;
  final String title;

  final ValueChanged? onPickedFile;

  @override
  State<CommonFilePicker> createState() => _CommonFilePickerState();
}

class _CommonFilePickerState extends State<CommonFilePicker>
    with WidgetsBindingObserver {
  final FileType _pickingType = FileType.custom;
  bool _isLoading = false,
      isStoragePermissionAllow = true,
      isCameraPermissionAllow = true,
      _userAborted = false;
  List<PlatformFile>? _paths;
  dynamic pickImageError;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    hideKeyboard();
    checkStoragePermission();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await checkStoragePermission();
    }
  }

  Future<void> checkStoragePermission() async {
    if (isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      await checkPermissions((androidInfo.version.sdkInt <= 32
              ? Permission.storage
              : Permission.photos))
          .then((status) {
        if (status) {
          if (mounted) {
            setState(() {
              isStoragePermissionAllow = status;
            });
          }
        } else {
          myToastMsg(localization.storage_permission_request, isError: true);
          if (mounted) {
            setState(() {
              isStoragePermissionAllow = status;
            });
          }
        }
      });
    } else {
      await checkPermissions(Permission.photos).then((status) {
        if (status) {
          if (mounted) {
            setState(() {
              isStoragePermissionAllow = status;
            });
          }
        } else {
          myToastMsg(localization.storage_permission_request, isError: true);
          if (mounted) {
            setState(() {
              isStoragePermissionAllow = status;
            });
          }
        }
      });
    }
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

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _paths = null;
      _userAborted = false;
    });
  }

  void _pickFiles() async {
    hideKeyboard();
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'jpeg', 'jpg', 'heic', 'png'],
      ))
          ?.files;
      //! don't overwrite old file
      // for (var path in _paths!) {
      //   _paths!.add(path);
      // }

      if (_paths != null) {
        for (int i = _paths!.length - 1; i >= 0; i--) {
          int sizeInBytes = _paths![i].size;
          if (((sizeInBytes / (1024 * 1024)) > 5)) {
            myToastMsg(
              '${_paths![i].name} ${localization.file_size_error}',
              isError: true,
            );
            _paths!.removeAt(i);
            await Future.delayed(Duration.zero);
          }
        }
        widget.onPickedFile!(_paths);
      }
    } on PlatformException catch (e) {
      showCatchedError('Unsupported operation$e');
    } catch (e) {
      showCatchedError('Unsupported operation$e');
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _userAborted = _paths == null;
    });
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    hideKeyboard();
    _resetState();
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      if (pickedFile != null) {
        //? FOR FIXED IMAGE ROTATE
        // if (isIOS) {
        //   final img.Image? capturedImage =
        //       img.decodeImage(await File(pickedFile.path).readAsBytes());
        //   final img.Image orientedImage = img.bakeOrientation(capturedImage!);
        //   await File(pickedFile.path)
        //       .writeAsBytes(img.encodeJpg(orientedImage));
        // }
        //? END ROTATE SECTION
        int size = await pickedFile.length();
        double sizeInMB = size / (1024 * 1024);
        if (sizeInMB < 5) {
          if (!mounted) return;
          try {
            PlatformFile tempFile = PlatformFile(
                path: pickedFile.path, name: pickedFile.name, size: size);
            widget.onPickedFile!([tempFile]);
            _paths?.add(tempFile);
          } catch (e) {
            rethrow;
          }
          if (!mounted) return;
          setState(() {
            pickImageError = null;
            _isLoading = false;
          });
        } else {
          showCatchedError(localization.image_size_error);
          if (!mounted) return;
          setState(() {
            pickImageError = localization.image_size_error;
            _isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (e.toString().contains("denied") == false) {
        if (!mounted) return;
        setState(() {
          pickImageError = e;
          _isLoading = false;
        });
      }
      showCatchedError(e);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _userAborted = _paths == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'file_pick_from_storage',
      child: CommonContainer(
        padding: const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints(minHeight: 10.h),
        child: Column(
          children: [
            Semantics(
              label: 'file_pick_from_storage',
              child: AppText((widget.title == 'Receipt'
                  ? localization.receipt_add
                  : 'Add ${widget.title}')),
            ),
            const AppSpacerHeight(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: 'file_pick_from_storage',
                  child: FloatingActionButton(
                    backgroundColor: greyLight,
                    onPressed: () {
                      _pickFiles();
                    },
                    heroTag: 'storage',
                    tooltip: 'Pick File from Phone',
                    child: const Icon(
                      Icons.file_present,
                      color: primary,
                    ),
                  ),
                ),
                const AppSpacerWidth(
                  width: 20,
                ),
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
              visible: isCameraPermissionAllow && isStoragePermissionAllow
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
                          ? localization.storage_permission_request
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
            const AppSpacerHeight(),
            Semantics(
              label: 'file_pick_from_storage',
              child: Builder(
                builder: (context) => _isLoading
                    ? const AppLoader()
                    : _userAborted &&
                            widget.paths == null &&
                            widget.paths!.isEmpty
                        ? Center(
                            child: AppText(
                              'Please select ${widget.title} if any!',
                            ),
                          )
                        : Column(
                            children: [
                              widget.paths != null && widget.paths!.isNotEmpty
                                  ? ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: widget.paths != null &&
                                              widget.paths!.isNotEmpty
                                          ? widget.paths!.length
                                          : 0,
                                      itemBuilder: (context, int index) {
                                        return ListTile(
                                          dense: true,
                                          title: AppText(
                                            widget.paths![index].name,
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                if (mounted) {
                                                  setState(() {
                                                    widget.paths!
                                                        .removeAt(index);
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.delete_forever_outlined,
                                                  color: errorRed)),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    )
                                  : const SizedBox.shrink(),
                              widget.receipts != null &&
                                      widget.receipts!.isNotEmpty
                                  ? const Divider()
                                  : const SizedBox.shrink(),
                              widget.receipts != null &&
                                      widget.receipts!.isNotEmpty
                                  ? ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: widget.receipts != null &&
                                              widget.receipts!.isNotEmpty
                                          ? widget.receipts!.length
                                          : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          dense: true,
                                          title: AppText(
                                            '${widget.receipts?[index]?.url}',
                                            maxLine: 3,
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              try {
                                                widget.deletedFileId!(int.parse(
                                                    widget.receipts![index]!.id
                                                        .toString()));
                                                if (mounted) {
                                                  setState(() {
                                                    widget.receipts!
                                                        .removeAt(index);
                                                  });
                                                }
                                              } catch (e) {
                                                showCatchedError(
                                                    localization.unknown_error);
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.delete_forever_outlined,
                                                color: errorRed),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
