import 'dart:async';

import 'package:bhawsar_chemical/generated/l10n.dart';
import 'package:bhawsar_chemical/src/screens/medical/search_medical/widget/add_medical_button_widget.dart';
import 'package:bhawsar_chemical/src/screens/medical/search_medical/widget/medical_card_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/bloc/medical/medical_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../data/models/medical_model/medical_model.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_204_widget.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_connection_widget.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_text_field.dart';
import '../../common/common_reload_widget.dart';

class SearchMedicalScreen extends StatelessWidget {
  final String? pageTitle;

  const SearchMedicalScreen({Key? key, this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<MedicalBloc>().add(const ClearMedicalEvent());
    final TextEditingController searchMedicalController = TextEditingController();
    Timer? debounce;
    String? lastInputValue;

    onSearchChanged() {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (searchMedicalController.text.trim() != '') {
          context.read<MedicalBloc>().add(SearchMedicalEvent(
              searchKeyword: searchMedicalController.text.toString(),
              type: (pageTitle == null || pageTitle == "" || pageTitle?.contains('Reminder') == true)
                  ? ""
                  : "Medical,Doctor,Distributor"));
        }
      });
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          pageTitle?.contains('Order') == true
              ? localization.order_now
              : pageTitle?.contains('Reminder') == true
                  ? localization.reminder_add
                  : localization.medical_search,
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
      floatingActionButton: AddMedicalButtonWidget(
          redirectTo: pageTitle?.contains('Order') == true
              ? 'order'
              : pageTitle?.contains('Reminder') == true
                  ? 'reminder'
                  : 'none'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(paddingMedium),
          child: Column(
            children: [
              AppTextField(
                isShowShadow: false,
                textEditingController: searchMedicalController,
                fillColor: greyLight,
                prefixIcon: const Icon(
                  Icons.search,
                  color: primary,
                ),
                hintText: localization.medical_search_filter,
                labelText: localization.medical_search,
                textInputAction: TextInputAction.search,
                onFieldSubmit: (value) {
                  if (value != null && value.trim() != '') {
                    if (lastInputValue != value) {
                      lastInputValue = value;
                      onSearchChanged();
                    }
                  }
                },
                onChanged: (value) {
                  if (value.trim() != '') {
                    if (lastInputValue != value) {
                      lastInputValue = value;
                      onSearchChanged();
                    }
                  }
                },
              ),
              const SizedBox(
                height: paddingDefault,
              ),
              Expanded(
                child: ConnectionStatus(
                  isShowAnimation: true,
                  child: BlocConsumer<MedicalBloc, MedicalState>(
                    listenWhen: (previous, current) {
                      if ((previous.status == MedicalStatus.adding && current.status != MedicalStatus.added) ||
                          (previous.status == MedicalStatus.updating && current.status != MedicalStatus.updated)) {
                        return false;
                      }
                      return true;
                    },
                    listener: (context, state) async {
                      if (state.status == MedicalStatus.failure) {
                        // Navigator.of(context).pop();
                        mySnackbar(state.msg.toString());
                        await Future.delayed(Duration.zero);
                      } else if (state.status == MedicalStatus.loading) {
                        // showAnimatedDialog(context, const AppDialogLoader());
                      } else if (state.status == MedicalStatus.loaded) {
                        // Navigator.of(context).pop();
                      } else if (state.status == MedicalStatus.updated || state.status == MedicalStatus.added) {
                        lastInputValue = "";
                        context.read<MedicalBloc>().add(const ClearMedicalEvent());
                      }
                    },
                    buildWhen: (previous, current) {
                      if (previous.status == MedicalStatus.adding || previous.status == MedicalStatus.updating) {
                        return false;
                      } else if (current.status == MedicalStatus.failure ||
                          current.status == MedicalStatus.initial ||
                          current.status == MedicalStatus.loading ||
                          current.status == MedicalStatus.loaded) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state.status == MedicalStatus.loading) {
                        return Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(height: 25, width: 25, child: AppLoader()),
                                const SizedBox(width: 10.0),
                                Flexible(child: AppText(S.of(context).loading)),
                                const SizedBox(width: 10.0),
                              ],
                            ));
                      } else {
                        return AppSwitcherWidget(
                            animationType: 'slide',
                            direction: AxisDirection.left,
                            child: state.status == MedicalStatus.initial
                                ? Center(
                                    child: AppText("${localization.medical_search_filter}..."),
                                  )
                                : state.status == MedicalStatus.initial
                                    ? Center(
                                        child: AppText(localization.medical_search_filter),
                                      )
                                    : state.status == MedicalStatus.failure
                                        ? state.msg == "No data found"
                                            ? const NoDataFoundWidget()
                                            : CommonReloadWidget(
                                                message: state.msg,
                                                reload: state.msg.toString() == localization.network_error
                                                    ? (context.read<MedicalBloc>()..add(const ClearMedicalEvent()))
                                                    : null)
                                        : state.status == MedicalStatus.loaded || state.status == MedicalStatus.updated
                                            ? MedicalList(
                                                state: state.res,
                                                pageTitle: pageTitle,
                                              )
                                            : const SizedBox());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicalList extends StatelessWidget {
  final MedicalModel state;
  final String? pageTitle;

  const MedicalList({
    Key? key,
    required this.state,
    this.pageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: state.items?.length ?? 0,
      itemBuilder: (buildContext, index) {
        return MedicalCardWidget(
          medicals: state.items![index],
          pageTitle: pageTitle,
        );
      },
    );
  }
}
