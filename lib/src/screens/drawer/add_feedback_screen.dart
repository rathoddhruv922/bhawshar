import 'package:bhawsar_chemical/src/screens/drawer/widget/feedback_description_textfield_widget.dart';
import 'package:bhawsar_chemical/src/screens/drawer/widget/feedback_module_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../business_logic/bloc/feedback/feedback_bloc.dart';
import '../../../constants/app_const.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_button_with_location.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_spacer.dart';
import '../../widgets/app_text.dart';
import '../common/common_multi_image_picker_widget.dart';

class AddFeedbackScreen extends StatelessWidget {
  const AddFeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    String? reqType = 'post';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        AppText(
          localization.feedback_add,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) async {
          if (state.status == FeedbackStatus.adding) {
            showAnimatedDialog(
                navigationKey.currentContext!, const AppDialogLoader());
          } else if (state.status == FeedbackStatus.added) {
            Navigator.of(context).pop(); // for close Loader
            mySnackbar(state.msg.toString());
            Navigator.of(context).pop(true);
          } else if (state.status == FeedbackStatus.failure) {
            mySnackbar(state.msg.toString(), isError: true);
            await Future.delayed(const Duration(seconds: 1));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(paddingDefault),
          child: AddFeedbackFormWidget(
            reqType: reqType,
          ),
        ),
      ),
    );
  }
}

class AddFeedbackFormWidget extends StatelessWidget {
  final String? reqType;

  const AddFeedbackFormWidget({Key? key, this.reqType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();

    Map<String, dynamic> formData = {};
    TextEditingController feedbackDescriptionController =
        TextEditingController();

    String feedbackType = 'Client';
    List<XFile>? paths = [];

    return SafeArea(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                FeedbackModuleTypeWidget(
                  feedbackType: feedbackType,
                  onChanged: ((value) {
                    setState(() {
                      feedbackType = value;
                    });
                  }),
                ),
              ],
            );
          }),
          const AppSpacerHeight(height: 15),
          Form(
            key: messageFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: FeedbackDescriptionTextFieldWidget(
                feedbackDescriptionController: feedbackDescriptionController),
          ),
          const AppSpacerHeight(height: 15),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CommonMultiImagePicker(
                paths: paths,
                onPickedImage: ((value) {
                  setState(() {
                    paths.addAll(value);
                    Set<String> uniquePaths = {};
                    for (XFile file in paths) {
                      uniquePaths.add(file.path);
                    }
                    List<XFile> uniqueFiles = [];
                    for (String path in uniquePaths) {
                      uniqueFiles.add(XFile(path));
                    }
                    paths.clear();
                    paths.addAll(uniqueFiles);
                  });
                }),
              );
            },
          ),
          const AppSpacerHeight(height: 15),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                child: AppButtonWithLocation(
                  btnText: localization.save,
                  onBtnClick: () async {
                    messageFormKey.currentState!.validate();
                    hideKeyboard();
                    if (messageFormKey.currentState!.validate()) {
                      if (paths.isNotEmpty && (paths.length > 5)) {
                        myToastMsg(localization.attachment_limit_error,
                            isError: true);
                      } else {
                        try {
                          setState(() {
                            formData = paths.isNotEmpty
                                ? {
                                    "feedback_id": -1,
                                    "description": feedbackDescriptionController
                                        .text
                                        .trim(),
                                    "reqType": reqType,
                                    "type": feedbackType,
                                    "attachments": paths.isNotEmpty
                                        ? paths.map((e) => e.path).toList()
                                        : null,
                                  }
                                : {
                                    "feedback_id": -1,
                                    "description": feedbackDescriptionController
                                        .text
                                        .trim()
                                        .toString(),
                                    "reqType": reqType,
                                    "type": feedbackType,
                                  };
                          });
                          context.read<FeedbackBloc>().add(AddFeedbackEvent(
                              formData: formData, reqType: reqType ?? 'post'));
                        } catch (e) {
                          showCatchedError(e);
                        }
                      }
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
