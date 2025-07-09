import 'dart:async';

import 'package:bhawsar_chemical/data/models/client_setting_model/client_setting_model.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
import 'package:bhawsar_chemical/src/screens/medical/widget/gst_pan_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/area/area_bloc.dart';
import '../../../../business_logic/bloc/city/city_bloc.dart';
import '../../../../business_logic/bloc/client_setting/client_setting_bloc.dart';
import '../../../../business_logic/bloc/medical/medical_bloc.dart';
import '../../../../business_logic/bloc/state/state_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_animated_dialog.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_client_type_widget.dart';
import '../../common/common_container_widget.dart';
import '../../common/common_image_picker_widget.dart';
import '../widget/add_area_textfield_widget.dart';
import '../widget/add_city_textfield_widget.dart';
import '../widget/add_state_textfield_widget.dart';
import '../widget/area_textfield_widget.dart';
import '../widget/building_name_textfield_widget.dart';
import '../widget/city_textfield_widget.dart';
import '../widget/email_textfield_widget.dart';
import '../widget/gst_textfield_widget.dart';
import '../widget/mobile_textfield_widget.dart';
import '../widget/notification_type_widget.dart';
import '../widget/phone_textfield_widget.dart';
import '../widget/shop_name_textfield_widget.dart';
import '../widget/state_textfield_widget.dart';
import '../widget/zipcode_textfield_widget.dart';

class AddMedicalScreen extends StatefulWidget {
  final String redirectTo;

  const AddMedicalScreen({super.key, this.redirectTo = 'none'});

  @override
  State<AddMedicalScreen> createState() => _AddMedicalScreenState();
}

class _AddMedicalScreenState extends State<AddMedicalScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  XFile? imageFile;
  Map<String, dynamic>? formData;
  final GlobalKey<FormState> gstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> zipFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stateFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> cityFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> areaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addStateFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addCityFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addAreaFormKey = GlobalKey<FormState>();

  String? type = 'Medical', reqType = 'post', notificationPreference = 'WhatsApp', panGSTType = 'GST';

  //! Multiple mobile number
  List<TextEditingController> mobileController = [TextEditingController()];
  List<GlobalKey<FormState>> mobileFormKey = [GlobalKey<FormState>()];
  int mobileTextFieldCount = 1;
  bool mobileFieldValid = true;

  String collectFieldValues() {
    List<String> values = [];
    for (var controller in mobileController) {
      values.add(controller.text);
    }
    return values.join(',');
  }

  //! end multiple mobile number

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController addStateController = TextEditingController();
  TextEditingController addCityController = TextEditingController();
  TextEditingController addAreaController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  bool isMediaDelete = false;
  late bool showNonProductive;

  //! custom state, city, area

  int? cityId, stateId, areaId;
  bool isStateFound = true,
      isCityFound = true,
      isAreaFound = true,
      isAddState = false,
      isAddCity = false,
      isAddArea = false,
      nonProductive = false;
  String? lastSearchKeyword;
  Timer? debounce;

  onStateSearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (stateController.text.trim() != "" && lastSearchKeyword != stateController.text.trim()) {
        lastSearchKeyword = stateController.text.trim();
        BlocProvider.of<StateBloc>(context).add(GetStateEvent(searchKeyword: stateController.text.trim(), isAddState: false));
      } else {
        stateId = null;
      }
    });
  }

  onAddStateSearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (addStateController.text.trim() != "" && lastSearchKeyword != addStateController.text) {
        lastSearchKeyword = addStateController.text.trim();
        BlocProvider.of<StateBloc>(context).add(GetStateEvent(searchKeyword: addStateController.text.trim(), isAddState: true));
      }
    });
  }

  onCitySearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (cityController.text.trim() != "" && lastSearchKeyword != cityController.text.trim()) {
        lastSearchKeyword = cityController.text.trim();
        BlocProvider.of<CityBloc>(context)
            .add(GetCityEvent(stateId: stateId ?? -1, searchKeyword: cityController.text.trim(), isAddCity: false));
      } else {
        cityId = null;
      }
    });
  }

  onAddCitySearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (addCityController.text.trim() != "" && lastSearchKeyword != addCityController.text) {
        lastSearchKeyword = addCityController.text.trim();
        BlocProvider.of<CityBloc>(context)
            .add(GetCityEvent(stateId: stateId ?? -1, searchKeyword: addCityController.text.trim(), isAddCity: true));
      }
    });
  }

  onAreaSearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (areaController.text.trim() != "" && lastSearchKeyword != areaController.text.trim()) {
        lastSearchKeyword = areaController.text.trim();
        BlocProvider.of<AreaBloc>(context)
            .add(GetAreaEvent(cityId: cityId ?? -1, searchKeyword: areaController.text.trim(), isAddArea: false));
      } else {
        areaId = null;
      }
    });
  }

  onAddAreaSearchChanged() async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (addAreaController.text.trim() != "" && lastSearchKeyword != addAreaController.text) {
        lastSearchKeyword = addAreaController.text.trim();
        BlocProvider.of<AreaBloc>(context)
            .add(GetAreaEvent(cityId: cityId ?? -1, searchKeyword: addAreaController.text.trim(), isAddArea: true));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ClientSettingBloc>()
      ..add(const ClearSettingEvent())
      ..add(const GetClientSettingEvent());
    context.read<StateBloc>().add(const ClearStateEvent());
    context.read<CityBloc>().add(const ClearCityEvent());
    context.read<AreaBloc>().add(const ClearAreaEvent());
    showNonProductive = (widget.redirectTo == 'order' || widget.redirectTo == 'reminder') ? false : true;
  }

  void toggleNonProductiveVisibility(type) {
    setState(() {
      showNonProductive =
          (type.toString().toLowerCase() == 'warehouse' || widget.redirectTo == 'order' || widget.redirectTo == 'reminder')
              ? false
              : true;
    });
  }

  //! end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      appBar: CustomAppBar(
        AppText(
          localization.medical_add,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(paddingMedium),
        child: BlocConsumer<ClientSettingBloc, ClientSettingState>(listener: (context, state) {
          if (state.status == ClientSettingStatus.loading) {
            showAnimatedDialog(context, const AppDialogLoader());
          } else if (state.status == ClientSettingStatus.loaded) {
            Navigator.of(context).pop();
          } else if (state.status == ClientSettingStatus.failure) {
            Navigator.of(context).pop();
            mySnackbar(state.msg.toString(), isError: true);
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state.status != ClientSettingStatus.loaded) {
            return Center(child: AppText(localization.loading));
          } else {
            ClientSettingModel? setting = state.res;
            return BlocListener<MedicalBloc, MedicalState>(
              listener: (context, state) async {
                if (state.status == MedicalStatus.adding || state.status == MedicalStatus.loading) {
                  ((widget.redirectTo == 'order' || widget.redirectTo == 'reminder') && state.status != MedicalStatus.adding)
                      ? null
                      : showAnimatedDialog(context, const AppDialogLoader());
                } else if (state.status == MedicalStatus.added) {
                  Navigator.of(context).pop();
                  mySnackbar(state.msg.toString());
                  if (widget.redirectTo == 'none') {
                    Navigator.of(context).pop(true);
                  }
                  if ((widget.redirectTo == 'order' || widget.redirectTo == 'reminder')) {
                    Navigator.of(context).pop();
                    try {
                      medical.Item item = medical.Item(
                        name: nameController.text,
                        email: emailController.text,
                        image: imageFile?.path,
                        address: addController.text,
                        area: areaController.text,
                        city: cityController.text,
                        id: state.res.data['client']['id'],
                        state: stateController.text,
                        zip: int.parse(zipCodeController.text.toString() == "" ? "0" : zipCodeController.text.toString()),
                        mobile: collectFieldValues(),
                        panGst: gstController.text.toString(),
                        type: type,
                      );
                      if (widget.redirectTo == 'order') {
                        if (item.type!.toLowerCase() == 'medical' ||
                            item.type!.toLowerCase() == 'doctor' ||
                            item.type!.toLowerCase() == 'distributor') {
                          Future.delayed(const Duration(milliseconds: 500)).then((value) {
                            navigationKey.currentState!.pushReplacementNamed(RouteList.addOrder, arguments: item);
                          });
                        } else {
                          myToastMsg("Can't  place order for this client!", isError: true);
                        }
                      } else if (widget.redirectTo == 'reminder') {
                        Future.delayed(const Duration(milliseconds: 500)).then((value) {
                          navigationKey.currentState?.pushReplacementNamed(RouteList.addReminder, arguments: item);
                        });
                      }
                    } catch (e) {
                      showCatchedError(e.toString());
                      Navigator.of(context).pop(null);
                    }
                  }
                } else if (state.status == MedicalStatus.failure) {
                  Navigator.of(context).pop();
                  mySnackbar(state.msg.toString(), isError: true);
                  await Future.delayed(Duration.zero);
                }
              },
              child: Column(
                children: [
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return ClientTypeWidget(
                      type: type,
                      onChanged: ((value) {
                        toggleNonProductiveVisibility(value);
                        setState(() {
                          type = value;
                        });
                      }),
                    );
                  }),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return NotificationTypeWidget(
                      type: notificationPreference,
                      onChanged: ((value) {
                        setState(() {
                          notificationPreference = value;
                        });
                      }),
                    );
                  }),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: nameFormKey,
                    autovalidateMode:
                        (setting?.settings?.name == true) ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: ShopNameTextFieldWidget(
                      nameController: nameController,
                      isRequired: setting?.settings?.name ?? true,
                    ),
                  ),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: emailFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: EmailTextFieldWidget(
                      emailController: emailController,
                      isRequired: setting?.settings?.email ?? false,
                    ),
                  ),
                  const AppSpacerHeight(height: 8),
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    void addTextField() {
                      setState(() {
                        mobileTextFieldCount++;
                        mobileController.add(TextEditingController());
                        mobileFormKey.add(GlobalKey<FormState>());
                      });
                    }

                    void removeTextField(int index) {
                      setState(() {
                        if (index > 0) {
                          mobileController[index].dispose(); // Dispose the controller
                          mobileController.removeAt(index); // Remove the controller from the list
                          mobileFormKey.removeAt(index);
                          mobileTextFieldCount--; // Decrease the count of text fields
                        } else {
                          myToastMsg('You can\'t delete.', isError: true);
                        }
                      });
                    }

                    return Row(
                      children: [
                        // Existing text fields
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0; i < mobileTextFieldCount; i++)
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Form(
                                      key: mobileFormKey[i],
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: MobileTextFieldWidget(
                                        mobileController: mobileController[i],
                                        index: i,
                                        isRequired: setting?.settings?.mobile ?? false,
                                        removeCallBack: () {
                                          removeTextField(i);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        mobileTextFieldCount < 3
                            ? IconButton.filled(
                                padding: EdgeInsets.zero,
                                onPressed: addTextField,
                                icon: Icon(Icons.add),
                              )
                            : SizedBox.shrink(),
                      ],
                    );
                  }),
                  const AppSpacerHeight(height: 8.0),
                  Form(
                    key: addFormKey,
                    autovalidateMode:
                        (setting?.settings?.address == true) ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: AddressTextFieldWidget(
                      buildingNameController: addController,
                      isRequired: setting?.settings?.address ?? false,
                    ),
                  ),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Form(
                            key: stateFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: StateTextFieldWidget(
                              globalAreaAccess: setting?.settings?.globalAreaAccess ?? false,
                              isStateFound: isStateFound,
                              stateController: stateController,
                              isAddState: isAddState,
                              onAddState: (value) {
                                setState(() {
                                  lastSearchKeyword = "";
                                  stateController.clear();
                                  addStateController.clear();
                                  if (value == true) {
                                    isAddState = true;
                                    stateController.text = "Other";
                                    stateId = null;
                                  } else {
                                    isAddState = false;
                                  }
                                });
                                context.read<StateBloc>().add(const ClearStateEvent());
                              },
                              onSearchChanged: onStateSearchChanged,
                            ),
                          ),
                          AppSwitcherWidget(
                            animationType: 'slide',
                            child: isAddState
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Form(
                                      key: addStateFormKey,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: AddStateTextFieldWidget(
                                        stateController: addStateController,
                                        onCancelState: (value) {
                                          setState(() {
                                            lastSearchKeyword = "";
                                            stateController.clear();
                                            addStateController.clear();
                                            if (value == true) {
                                              isAddState = true;
                                            } else {
                                              isAddState = false;
                                            }
                                          });
                                          context.read<StateBloc>().add(const ClearStateEvent());
                                        },
                                        onSearchChanged: onAddStateSearchChanged,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          BlocConsumer<StateBloc, StateState>(
                            listener: (context, state) async {
                              if (state.status == StateStatus.failure) {
                                setState(() {
                                  if (!isAddState) {
                                    isStateFound = false;
                                  }
                                });
                              }
                              if (state.status == StateStatus.loaded) {
                                setState(() {
                                  if (!isAddState) {
                                    isStateFound = true;
                                  }
                                });
                              }
                            },
                            builder: (context, state) {
                              if (isAddState) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: (state.status == StateStatus.loading ||
                                              state.status == StateStatus.loaded ||
                                              (state.status == StateStatus.failure && (state.msg?.contains("No data") == false)))
                                          ? 10
                                          : 0.0),
                                  child: AppSwitcherWidget(
                                      child: state.status == StateStatus.failure && (state.msg?.contains("No data") == false)
                                          ? Row(children: [AppText(state.msg ?? 'NA')])
                                          : state.status == StateStatus.loading
                                              ? const Row(
                                                  children: [AppLoader(), AppSpacerWidth(), AppText("Checking availability")])
                                              : state.status == StateStatus.loaded
                                                  ? Row(
                                                      children: [
                                                        const Icon(Icons.cancel_outlined, color: red),
                                                        const AppSpacerWidth(width: 5),
                                                        AppText('${state.res.items?[0].name.toString()} is already added.'),
                                                        const AppSpacerWidth(width: 5),
                                                        Flexible(
                                                          child: AppButton(
                                                            btnHeight: 30,
                                                            btnFontSize: 15,
                                                            btnText: "Select",
                                                            onBtnClick: () {
                                                              hideKeyboard();
                                                              setState(() {
                                                                lastSearchKeyword = "";
                                                                isAddState = false;
                                                                isStateFound = true;
                                                                addStateController.clear();
                                                              });
                                                              if (state.res.items != null) {
                                                                stateId = state.res.items?[0].id;
                                                                stateController.text = (state.res.items?[0].name).toString();
                                                              }
                                                              state.res.items?.clear();
                                                              context.read<StateBloc>().add(const ClearStateEvent());
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()),
                                );
                              } else {
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  child: state.status == StateStatus.loading
                                      ? const Padding(padding: EdgeInsets.only(top: paddingSmall), child: AppLoader())
                                      : state.status == StateStatus.failure
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: paddingSmall),
                                              child: Center(child: AppText(state.msg.toString())))
                                          : state.status == StateStatus.loaded
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.res.items?.length ?? 0,
                                                    itemBuilder: (buildContext, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          hideKeyboard();
                                                          stateId = state.res.items?[index].id;
                                                          stateController.text = (state.res.items?[index].name).toString();
                                                          state.res.items?.clear();
                                                          context.read<StateBloc>().add(const ClearStateEvent());
                                                        },
                                                        child: Container(
                                                          width: 94.w,
                                                          decoration: BoxDecoration(
                                                            color: secondary.withOpacity(0.5),
                                                            border: const Border(
                                                              bottom: BorderSide(color: grey),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: AppText('${state.res.items?[index].name.toString()}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Form(
                            key: cityFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: CityTextFieldWidget(
                              globalAreaAccess: setting?.settings?.globalAreaAccess ?? false,
                              isCityFound: isCityFound,
                              cityController: cityController,
                              isAddCity: isAddCity,
                              onAddCity: (value) {
                                setState(() {
                                  lastSearchKeyword = "";
                                  cityController.clear();
                                  addCityController.clear();
                                  if (value == true) {
                                    isAddCity = true;
                                    cityController.text = "Other";
                                    cityId = null;
                                  } else {
                                    isAddCity = false;
                                  }
                                });
                                context.read<CityBloc>().add(const ClearCityEvent());
                              },
                              onSearchChanged: onCitySearchChanged,
                            ),
                          ),
                          AppSwitcherWidget(
                            animationType: 'slide',
                            child: isAddCity
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Form(
                                      key: addCityFormKey,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: AddCityTextFieldWidget(
                                        cityController: addCityController,
                                        onAddCity: (value) {
                                          setState(() {
                                            lastSearchKeyword = "";
                                            cityController.clear();
                                            addCityController.clear();
                                            if (value == true) {
                                              isAddCity = true;
                                            } else {
                                              isAddCity = false;
                                            }
                                          });
                                          context.read<CityBloc>().add(const ClearCityEvent());
                                        },
                                        onSearchChanged: onAddCitySearchChanged,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          BlocConsumer<CityBloc, CityState>(
                            listener: (context, state) async {
                              if (state.status == CityStatus.failure) {
                                setState(() {
                                  if (!isAddCity) {
                                    isCityFound = false;
                                  }
                                });
                              }
                              if (state.status == CityStatus.loaded) {
                                setState(() {
                                  if (!isAddCity) {
                                    isCityFound = true;
                                  }
                                });
                              }
                            },
                            builder: (context, state) {
                              if (isAddCity) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: (state.status == CityStatus.loading ||
                                              state.status == CityStatus.loaded ||
                                              (state.status == CityStatus.failure && (state.msg?.contains("No data") == false)))
                                          ? 10
                                          : 0.0),
                                  child: AppSwitcherWidget(
                                      child: state.status == CityStatus.failure && (state.msg?.contains("No data") == false)
                                          ? Row(children: [AppText(state.msg ?? 'NA')])
                                          : state.status == CityStatus.loading
                                              ? const Row(
                                                  children: [AppLoader(), AppSpacerWidth(), AppText("Checking availability")])
                                              : state.status == CityStatus.loaded
                                                  ? Row(
                                                      children: [
                                                        const Icon(Icons.cancel_outlined, color: red),
                                                        const AppSpacerWidth(width: 5),
                                                        AppText('${state.res.items?[0].name.toString()} is already added.'),
                                                        const AppSpacerWidth(width: 5),
                                                        Flexible(
                                                          child: AppButton(
                                                            btnHeight: 30,
                                                            btnFontWeight: FontWeight.normal,
                                                            btnText: "Select",
                                                            onBtnClick: () {
                                                              hideKeyboard();
                                                              setState(() {
                                                                lastSearchKeyword = "";
                                                                isAddCity = false;
                                                                isCityFound = true;
                                                                addCityController.clear();
                                                              });
                                                              if (state.res.items != null) {
                                                                cityId = state.res.items?[0].id;
                                                                cityController.text = (state.res.items?[0].name).toString();
                                                              }
                                                              state.res.items?.clear();
                                                              context.read<CityBloc>().add(const ClearCityEvent());
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()),
                                );
                              } else {
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  child: state.status == CityStatus.loading
                                      ? const Padding(padding: EdgeInsets.only(top: paddingSmall), child: AppLoader())
                                      : state.status == CityStatus.failure
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: paddingSmall),
                                              child: Center(child: AppText(state.msg.toString())))
                                          : state.status == CityStatus.loaded
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.res.items?.length ?? 0,
                                                    itemBuilder: (buildContext, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          hideKeyboard();
                                                          cityId = state.res.items?[index].id;
                                                          cityController.text = (state.res.items?[index].name).toString();
                                                          state.res.items?.clear();
                                                          context.read<CityBloc>().add(const ClearCityEvent());
                                                        },
                                                        child: Container(
                                                          width: 94.w,
                                                          decoration: BoxDecoration(
                                                            color: secondary.withOpacity(0.5),
                                                            border: const Border(
                                                              bottom: BorderSide(color: grey),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: AppText('${state.res.items?[index].name.toString()}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Form(
                            key: areaFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: AreaTextFieldWidget(
                              globalAreaAccess: setting?.settings?.globalAreaAccess ?? false,
                              isAreaFound: isAreaFound,
                              areaController: areaController,
                              isAddArea: isAddArea,
                              onAddArea: (value) {
                                setState(() {
                                  lastSearchKeyword = "";
                                  areaController.clear();
                                  addAreaController.clear();
                                  if (value == true) {
                                    isAddArea = true;
                                    areaController.text = "Other";
                                    areaId = null;
                                  } else {
                                    isAddArea = false;
                                  }
                                });
                                context.read<AreaBloc>().add(const ClearAreaEvent());
                              },
                              onSearchChanged: onAreaSearchChanged,
                            ),
                          ),
                          AppSwitcherWidget(
                            animationType: 'slide',
                            child: isAddArea
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Form(
                                      key: addAreaFormKey,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: AddAreaTextFieldWidget(
                                        areaController: addAreaController,
                                        onAddArea: (value) {
                                          setState(() {
                                            lastSearchKeyword = "";
                                            areaController.clear();
                                            addAreaController.clear();
                                            if (value == true) {
                                              isAddArea = true;
                                            } else {
                                              isAddArea = false;
                                            }
                                          });
                                          context.read<AreaBloc>().add(const ClearAreaEvent());
                                        },
                                        onSearchChanged: onAddAreaSearchChanged,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          BlocConsumer<AreaBloc, AreaState>(
                            listener: (context, state) async {
                              if (state.status == AreaStatus.failure) {
                                setState(() {
                                  if (!isAddArea) {
                                    isAreaFound = false;
                                  }
                                });
                              }
                              if (state.status == AreaStatus.loaded) {
                                setState(() {
                                  if (!isAddArea) {
                                    isAreaFound = true;
                                  }
                                });
                              }
                            },
                            builder: (context, state) {
                              if (isAddArea) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: (state.status == AreaStatus.loading ||
                                              state.status == AreaStatus.loaded ||
                                              (state.status == AreaStatus.failure && (state.msg?.contains("No data") == false)))
                                          ? 10
                                          : 0.0),
                                  child: AppSwitcherWidget(
                                      child: state.status == AreaStatus.failure && (state.msg?.contains("No data") == false)
                                          ? Row(children: [AppText(state.msg ?? 'NA')])
                                          : state.status == AreaStatus.loading
                                              ? const Row(
                                                  children: [AppLoader(), AppSpacerWidth(), AppText("Checking availability")])
                                              : state.status == AreaStatus.loaded
                                                  ? Row(
                                                      children: [
                                                        const Icon(Icons.cancel_outlined, color: red),
                                                        const AppSpacerWidth(width: 5),
                                                        AppText('${state.res.items?[0].name.toString()} is already added.'),
                                                        const AppSpacerWidth(width: 5),
                                                        Flexible(
                                                          child: AppButton(
                                                            btnHeight: 30,
                                                            btnFontWeight: FontWeight.normal,
                                                            btnText: "Select",
                                                            onBtnClick: () {
                                                              hideKeyboard();
                                                              setState(() {
                                                                lastSearchKeyword = "";
                                                                isAddArea = false;
                                                                isAreaFound = true;
                                                                addAreaController.clear();
                                                              });
                                                              if (state.res.items != null) {
                                                                areaId = state.res.items?[0].id;
                                                                areaController.text = (state.res.items?[0].name).toString();
                                                              }
                                                              state.res.items?.clear();
                                                              context.read<AreaBloc>().add(const ClearAreaEvent());
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()),
                                );
                              } else {
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  child: state.status == AreaStatus.loading
                                      ? const Padding(padding: EdgeInsets.only(top: paddingSmall), child: AppLoader())
                                      : state.status == AreaStatus.failure
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: paddingSmall),
                                              child: Center(child: AppText(state.msg.toString())))
                                          : state.status == AreaStatus.loaded
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.res.items?.length ?? 0,
                                                    itemBuilder: (buildContext, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          hideKeyboard();
                                                          areaId = state.res.items?[index].id;
                                                          areaController.text = (state.res.items?[index].name).toString();
                                                          state.res.items?.clear();
                                                          context.read<AreaBloc>().add(const ClearAreaEvent());
                                                        },
                                                        child: Container(
                                                          width: 94.w,
                                                          decoration: BoxDecoration(
                                                            color: secondary.withOpacity(0.5),
                                                            border: const Border(
                                                              bottom: BorderSide(color: grey),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: AppText('${state.res.items?[index].name.toString()}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: zipFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ZipcodeTextFieldWidget(
                      zipCodeController: zipCodeController,
                      isRequired: setting?.settings?.zip ?? false,
                    ),
                  ),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          GSTorPANselectionWidget(
                            type: panGSTType,
                            onChanged: ((value) {
                              setState(() {
                                panGSTType = value;
                              });
                            }),
                          ),
                          const AppSpacerHeight(height: 15),
                          Form(
                            key: gstFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: GSTTextFieldWidget(
                              gstController: gstController,
                              isRequired: setting?.settings?.panGst ?? false,
                              gstType: panGSTType,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: phoneFormKey,
                    autovalidateMode:
                        (setting?.settings?.phone == true) ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: PhoneTextFieldWidget(phoneController: phoneController, isRequired: setting?.settings?.phone ?? false),
                  ),
                  const AppSpacerHeight(height: 15),
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return CommonImagePicker(
                      imageFile: imageFile,
                      onPickedImage: ((value) {
                        value == true
                            ? setState(() {
                                imageFile = null;
                                isMediaDelete = value;
                              })
                            : setState(() {
                                imageFile = value;
                                isMediaDelete = false;
                              });
                      }),
                    );
                  }),
                  const AppSpacerHeight(height: 15),
                  if (showNonProductive)
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CommonContainer(
                          width: double.infinity,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: paddingLarge),
                            tileColor: white,
                            dense: true,
                            title: AppText(
                              localization.non_productive_call,
                              color: red,
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                              nonProductive = !nonProductive;
                              setState(() {});
                            },
                            trailing: Icon(
                              nonProductive ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                              color: nonProductive ? red : grey,
                            ),
                          ),
                        );
                      },
                    ),
                  const AppSpacerHeight(height: 15),
                  SafeArea(
                    top: false,
                    child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return AppButtonWithLocation(
                        btnText: localization.save,
                        onBtnClick: () {
                          hideKeyboard();
                          if ((setting?.settings?.mobile ?? true)) {
                            for (var key in mobileFormKey) {
                              if (!key.currentState!.validate() && (setting?.settings?.mobile ?? false)) {
                                setState(() {
                                  mobileFieldValid = false;
                                });
                              } else {
                                setState(() {
                                  mobileFieldValid = true;
                                });
                              }
                            }
                          }
                          nameFormKey.currentState!.validate();
                          emailFormKey.currentState!.validate();
                          addFormKey.currentState!.validate();
                          stateFormKey.currentState!.validate();
                          addStateFormKey.currentState?.validate();
                          cityFormKey.currentState!.validate();
                          addCityFormKey.currentState?.validate();
                          areaFormKey.currentState!.validate();
                          addAreaFormKey.currentState?.validate();
                          zipFormKey.currentState!.validate();
                          gstFormKey.currentState!.validate();
                          phoneFormKey.currentState!.validate();
                          if (nameFormKey.currentState!.validate() &&
                              emailFormKey.currentState!.validate() &&
                              addFormKey.currentState!.validate() &&
                              stateFormKey.currentState!.validate() &&
                              (addStateFormKey.currentState?.validate() ?? true) &&
                              cityFormKey.currentState!.validate() &&
                              (addCityFormKey.currentState?.validate() ?? true) &&
                              areaFormKey.currentState!.validate() &&
                              (addAreaFormKey.currentState?.validate() ?? true) &&
                              zipFormKey.currentState!.validate() &&
                              gstFormKey.currentState!.validate() &&
                              phoneFormKey.currentState!.validate() &&
                              mobileFieldValid) {
                            setState(
                              () {
                                formData = {
                                  "delete_media": isMediaDelete ? 1 : 0,
                                  "name": nameController.text,
                                  "non_productive": nonProductive ? 1 : 0,
                                  "email": emailController.text,
                                  "address": addController.text,
                                  "zip": zipCodeController.text,
                                  "notification": notificationPreference,
                                  "area": areaId ?? areaController.text,
                                  "city": cityId ?? cityController.text,
                                  "state": stateId ?? stateController.text,
                                  "area_name": areaController.text,
                                  "city_name": cityController.text,
                                  "state_name": stateController.text,
                                  "other_area": addAreaController.text,
                                  "other_city": addCityController.text,
                                  "other_state": addStateController.text,
                                  "phone": phoneController.text,
                                  "mobile": collectFieldValues(),
                                  "pan_gst": gstController.text.toString(),
                                  "type": type,
                                  "pan_gst_type": panGSTType,
                                };
                                if (stateId == null && addStateController.text.trim() == "") {
                                  mySnackbar(localization.state_invalid, isError: true);
                                } else if (cityId == null && addCityController.text.trim() == "") {
                                  mySnackbar(localization.city_invalid, isError: true);
                                } else if (areaId == null && addAreaController.text.trim() == "") {
                                  mySnackbar(localization.area_invalid, isError: true);
                                } else {
                                  context.read<MedicalBloc>().add(
                                        AddMedicalEvent(
                                          formData: formData!,
                                          imgPath: imageFile?.path ?? 'NA',
                                          reqType: reqType!,
                                          clientId: -1,
                                        ),
                                      );
                                }
                              },
                            );
                          }
                        },
                        btnFontWeight: FontWeight.bold,
                      );
                    }),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
