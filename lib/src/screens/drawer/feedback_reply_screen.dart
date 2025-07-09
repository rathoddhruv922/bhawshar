// ignore_for_file: depend_on_referenced_packages

import 'package:bhawsar_chemical/src/screens/drawer/widget/comment_message_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../business_logic/bloc/comment/comment_bloc.dart';
import '../../../business_logic/bloc/feedback/feedback_bloc.dart';
import '../../../constants/app_const.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_204_widget.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_loader_simple.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_switcher_widget.dart';
import '../../widgets/app_text.dart';

import 'package:bhawsar_chemical/data/models/feedback_model/feedback.dart'
as feedback;

import 'package:bhawsar_chemical/data/models/feedback_model/comment.dart'
as feedback_comment;

import 'package:bhawsar_chemical/data/models/feedback_model/attachment.dart'
as feedback_attachment;

import '../../widgets/app_text_field.dart';
import 'dart:io' as platform;

class FeedbackReplyScreen extends StatelessWidget {
  final int id;

  const FeedbackReplyScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<FeedbackBloc>().add(
      GetFeedbackEvent(id: id),
    );
    String? reqType = 'put';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.feedback_conversation,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) async {
          if (state.status == FeedbackStatus.updating) {
            showAnimatedDialog(
                navigationKey.currentContext!, const AppDialogLoader());
          } else if (state.status == FeedbackStatus.updated) {
            Navigator.of(context).pop(); // for close Loader
            mySnackbar(state.msg.toString());
            Navigator.of(context).pop(true);
          } else if (state.status == FeedbackStatus.failure) {
            mySnackbar(state.msg.toString(), isError: true);
            await Future.delayed(const Duration(seconds: 1));
          }
          if (state.status == FeedbackStatus.load) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (previous, current) {
          if (previous.status == FeedbackStatus.updating) {
            return false;
          }
          return current.status == FeedbackStatus.load ||
              (current.status == FeedbackStatus.failure && current.res != null);
        },
        builder: (context, state) {
          if (state.status == FeedbackStatus.load) {
            return ViewConversation(reqType: reqType, item: state.res.feedback);
          } else if ((state.status == FeedbackStatus.failure &&
              state.res != null)) {
            return Center(child: AppText(state.msg.toString()));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ViewConversation extends StatefulWidget {
  final String? reqType;
  final int? index;
  final feedback.Feedback? item;

  const ViewConversation({Key? key, this.reqType, this.index, this.item})
      : super(key: key);

  @override
  State<ViewConversation> createState() => ViewConversationState();
}

class ViewConversationState extends State<ViewConversation>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();
  final ScrollController? scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  int? userId, indexOfComment;
  feedback_comment.Comment? replyComment;
  List<feedback_attachment.Attachment>? attachments;
  bool sendingReply = false;
  List<feedback_comment.Comment?> commentList = [];
  bool isCameraPermissionAllow = true,
      isPhotoPermissionAllow = true;
  bool isLoading = false;
  String initialMsg = '';
  dynamic pickImageError;

  final ImagePicker _picker = ImagePicker();
  List<XFile?> pickedFile = [];
  List<XFile?> paths = [];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    updatePermissionStatus();
    WidgetsBinding.instance.addObserver(this);
    init();

    scrollController?.addListener(_scrollListener);

    super.initState();
  }

  init() async {
    userId = await getUserId();
    commentList = widget.item!.comments!;
    if (mounted) {
      setState(() {});
    }
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

  _scrollListener() {
    if (scrollController!.offset >=
        scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {}
  }

  void onSendMessage(String content, int type) {
    hideKeyboard();
    if (content
        .trim()
        .isNotEmpty || pickedFile.isNotEmpty) {
      try {
        initialMsg = content;
        scrollController?.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        commentList = [
          feedback_comment.Comment(
            id: 0,
            message: content,
            user: widget.item?.user,
            commentMessage: replyComment?.message,
            attachments: pickedFile.isNotEmpty
                ? pickedFile
                .map((file) =>
            (feedback_attachment.Attachment(
                id: -1, url: file?.path ?? '')))
                .toList()
                : null,
            dateTime: DateTime.now().toString(),
            userId: userId,
          ),
          ...commentList
        ];
        context.read<CommentBloc>().add(AddCommentEvent(formData: {
          'message': content,
          'feedback_id': widget.item?.id,
          'attachments': pickedFile.isNotEmpty
              ? pickedFile.map((file) => file?.path).toList()
              : null,
          'comment_to': replyComment?.id
        }, index: -1, reqType: 'post'));
      } catch (e) {
        myToastMsg('$e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: secondary,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AppText(
                      '${localization.description}: ${widget.item?.description ?? 'NA'}'),
                ),
                (widget.item?.attachments?.isEmpty ?? true)
                    ? const SizedBox.shrink()
                    : InkWell(
                  onTap: () async {
                    if (widget.item?.attachments?.isNotEmpty ?? false) {
                      final CarouselSliderController controller =
                      CarouselSliderController();
                      await appInfoDialog(
                        context,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                return SizedBox(
                                  height: 50.h,
                                  width: 100.w,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: CarouselSlider(
                                          items: widget.item?.attachments!
                                              .map(
                                                (item) =>
                                            item.id == -1
                                                ? Image.file(
                                              platform.File((item
                                                  .url)
                                                  .toString()),
                                              semanticLabel:
                                              "image",
                                              errorBuilder:
                                                  (context, url,
                                                  error) =>
                                              const Icon(
                                                Icons
                                                    .error_outline,
                                                color: primary,
                                              ),
                                              fit: BoxFit.fill,
                                            )
                                                : CachedNetworkImage(
                                              httpHeaders: {
                                                "Referer":
                                                "https://mobile.bhawsarayurveda.in/"
                                              },
                                              imageUrl:
                                              item.url!,
                                              imageBuilder:
                                                  (context,
                                                  imageProvider) =>
                                                  Container(
                                                    height: 50.h,
                                                    width: 100.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: white,
                                                      borderRadius:
                                                      const BorderRadius
                                                          .all(
                                                        Radius
                                                            .circular(
                                                            4.0),
                                                      ),
                                                      image:
                                                      DecorationImage(
                                                        image:
                                                        imageProvider,
                                                        fit: BoxFit
                                                            .fill,
                                                        filterQuality:
                                                        FilterQuality
                                                            .low,
                                                      ),
                                                    ),
                                                  ),
                                              placeholder: (context,
                                                  url) =>
                                              const AppLoader(),
                                              errorWidget:
                                                  (context, url,
                                                  error) =>
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(
                                                        8.0),
                                                    child: Image.asset(
                                                        'assets/ic_launcher.png'),
                                                  ),
                                            ),
                                          )
                                              .toList(),
                                          carouselController: controller,
                                          options: CarouselOptions(
                                            viewportFraction: 1.0,
                                            aspectRatio: 13 / 16,
                                            enlargeCenterPage: false,
                                            enableInfiniteScroll: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        isDismissible: true,
                        isShowButton: false,
                      );
                    }
                  },
                  child: const Icon(Icons.attachment, color: primary),
                ),
              ],
            ),
          ),
          buildListMessage(),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(paddingExtraSmall),
      child: IntrinsicHeight(
        // width: double.infinity,
        // height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isCameraPermissionAllow && isPhotoPermissionAllow
                  ? false
                  : true,
              child: Center(
                child: InkWell(
                  onTap: () async {
                    openAppSettings();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(paddingSmall),
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
            ),
            if (replyComment != null && !sendingReply)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: greyLight,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      color: primary,
                      width: 4,
                      height: 45,
                    ),
                    const AppSpacerWidth(width: 5),
                    Expanded(
                      child: AppText(
                        replyComment?.message ?? 'NA',
                        maxLine: 1,
                      ),
                    ),
                    const AppSpacerWidth(width: 5),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: primary,
                      ),
                      onPressed: () {
                        replyComment = null;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            if (pickedFile.isNotEmpty && !sendingReply)
              Container(
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
                  itemCount: pickedFile.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return AppSwitcherWidget(
                        animationType: "scale",
                        child: isLoading
                            ? Semantics(
                            label: 'image', child: const AppLoader())
                            : previewImages(pickedFile[index]?.path, index));
                  },
                ),
              ),
            (widget.item?.status?.toLowerCase() == 'disable comment' ||
                widget.item?.status?.toLowerCase() == 'closed' ||
                widget.item?.status?.toLowerCase() == 'resolved')
                ? Flexible(
              child: Card(
                child: ListTile(
                  tileColor: greyLight,
                  title: AppText(
                    widget.item?.status?.toLowerCase() ==
                        'disable comment'
                        ? localization.feedback_disable
                        : widget.item?.status?.toLowerCase() == 'closed'
                        ? localization.feedback_close
                        : localization.feedback_resolved,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    color: widget.item?.status?.toLowerCase() ==
                        'disable comment'
                        ? orange
                        : widget.item?.status?.toLowerCase() == 'closed'
                        ? red
                        : primary,
                  ),
                ),
              ),
            )
                : Flexible(
              child: BlocListener<CommentBloc, CommentState>(
                //* listener
                listener: (context, state) async {
                  if (state.status == CommentStatus.adding ||
                      state.status == CommentStatus.updating) {
                    setState(() {
                      sendingReply = true;
                      textEditingController.clear();
                    });
                  } else if (state.status == CommentStatus.added ||
                      state.status == CommentStatus.updated) {
                    if (state.status == CommentStatus.added) {
                      commentList[0] = feedback_comment.Comment(
                        id: state.res?['id'],
                        message: commentList[0]?.message,
                        user: widget.item?.user,
                        commentMessage: replyComment?.message,
                        attachments: pickedFile.isNotEmpty
                            ? pickedFile
                            .map((file) =>
                        (feedback_attachment.Attachment(
                            id: -1, url: file?.path ?? '')))
                            .toList()
                            : null,
                        dateTime: DateTime.now().toString(),
                        userId: userId,
                      );
                    }
                    setState(() {
                      sendingReply = false;
                      indexOfComment = null;
                      pickedFile = [];
                      paths = [];
                      replyComment = null;
                    });
                    scrollController?.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  } else if (state.status == CommentStatus.failure) {
                    mySnackbar(state.msg.toString(), isError: true);
                    setState(() {
                      commentList.removeAt(0);
                      sendingReply = false;
                      textEditingController =
                          TextEditingController(text: initialMsg);
                    });
                  }
                },
                child: AppTextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  isShowShadow: false,
                  maxLine: 100,
                  prefixIcon: IconButton(
                    onPressed: () async {
                      await onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                    icon: Icon(Icons.photo, color: primary, size: 20.sp),
                    color: white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      onSendMessage(textEditingController.text, 0);
                    },
                    icon: Icon(Icons.send_rounded,
                        color: primary, size: 20.sp),
                  ),
                  fillColor: greyLight,
                  textEditingController: textEditingController,
                  hintText: 'write here...',
                  labelText: localization.comment_add,
                  onFieldSubmit: (value) {
                    onSendMessage(textEditingController.text, 0);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Expanded(
      child: commentList.isNotEmpty
          ? ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: commentList.length,
        shrinkWrap: true,
        reverse: true,
        controller: scrollController,
        itemBuilder: (context, index) {
          feedback_comment.Comment? comment = commentList[index];
          return Dismissible(
            key: UniqueKey(),
            background: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.reply, color: grey),
            ),
            secondaryBackground: const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.reply, color: grey),
            ),
            confirmDismiss: (direction) async {
              if ((widget.item?.status?.toLowerCase() !=
                  'disable comment') &&
                  (widget.item?.status?.toLowerCase() != 'resolved') &&
                  (widget.item?.status?.toLowerCase() != 'closed')) {
                replyComment = comment;
                if (mounted) {
                  setState(() {});
                }
              }
              return false;
            },
            child: CommentMessageWidget(
                index: index,
                indexOfEditComment: indexOfComment ?? 0,
                comment: comment,
                sended: index == (indexOfComment ?? 0) && sendingReply
                    ? true
                    : false,
                commentedByMe: userId == comment?.userId ? true : false),
          );
        },
      )
          : const Center(
        child: NoDataFoundWidget(),
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
                errorBuilder: (context, url, error) =>
                const Icon(
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
                pickedFile.removeAt(index);
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
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
      pickedFile = await _picker.pickMultiImage(
        imageQuality: 50,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      if (pickedFile.isNotEmpty) {
        if (pickedFile.length > 5) {
          myToastMsg(localization.attachment_limit_error, isError: true);
          if (mounted) {
            setState(() {
              pickedFile.clear();
              isLoading = false;
            });
          }
        } else {
          //? FOR FIXED IMAGE ROTATE
          paths.addAll(pickedFile);
          pickedFile.clear();
          Set<String> uniquePaths = {};
          for (XFile? file in paths) {
            uniquePaths.add(file!.path);
          }
          List<XFile> uniqueFiles = [];
          for (String path in uniquePaths) {
            uniqueFiles.add(XFile(path));
          }
          pickedFile.addAll(uniqueFiles);
          for (XFile? pickedPath in pickedFile) {
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
            }
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
}
