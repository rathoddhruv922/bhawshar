import 'dart:async';

import 'package:bhawsar_chemical/business_logic/bloc/order/order_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/product/product_bloc.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/order_model/order_model.dart';
import 'package:bhawsar_chemical/data/models/product_model/product_model.dart' as product;
import 'package:bhawsar_chemical/generated/l10n.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/screens/requestGiftPop/widgets/request_item_type_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_animated_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_button.dart';
import 'package:bhawsar_chemical/src/widgets/app_button_with_location.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog_loader.dart';
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';
import 'package:bhawsar_chemical/src/widgets/app_separator_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_snackbar_toast.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_switcher_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/src/widgets/app_text_field.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateRequestGiftPop extends StatefulWidget {
  final int orderId;

  const UpdateRequestGiftPop({super.key, required this.orderId});

  @override
  State<UpdateRequestGiftPop> createState() => _UpdateRequestGiftPopState();
}

class _UpdateRequestGiftPopState extends State<UpdateRequestGiftPop> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? debounce;
  final TextEditingController searchProductController = TextEditingController();
  List<int> existingProductIds = [];
  String? lastInputValue = '';
  bool isLoading = true;

  String reqItemType = 'Gift Article';
  List<Map<dynamic, dynamic>> productItems = [];

  onSearchChanged(requestItem) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 700), () {
      if (searchProductController.text.trim() != '') {
        BlocProvider.of<ProductBloc>(context).add(
          SearchProductEvent(
            searchKeyword: searchProductController.text.toString(),
            type: requestItem == 'Gift Article' ? 'gift article' : 'pop material',
            existingProductIds: existingProductIds,
          ),
        );
      }
    });
  }

  List<TextEditingController> generalController = [];
  product.ProductModel? products;
  OrderModel? order;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderEvent(orderId: widget.orderId));
  }

  @override
  void dispose() {
    for (var controller in generalController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<bool?> editQuantity(name, qty, index) {
    TextEditingController editQty = TextEditingController(text: qty.toString());
    return appInfoDialog(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: greyLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppSpacerWidth(),
                Expanded(
                  child: AppText(
                    name.toUpperCase(),
                    fontWeight: FontWeight.bold,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(paddingDefault),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    autofocus: true,
                    key: Key(index.toString()),
                    controller: editQty,
                    style: Theme.of(context).textTheme.titleMedium!.merge(
                          const TextStyle(
                            color: textBlack,
                          ),
                        ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          hideKeyboard();
                          if (editQty.text.trim() == '') {
                            myToastMsg(localization.quantity_enter, bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                          } else if (editQty.text.trim() != '' && int.parse(editQty.text) <= 0) {
                            myToastMsg(localization.quantity_invalid, bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                          } else {
                            productItems[index]['qty'] = editQty.text;
                            Navigator.of(context).pop(true);
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                      alignLabelWithHint: true,
                      labelText: localization.quantity,
                      hintText: localization.quantity_enter,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
                      errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(height: 0, color: errorRed),
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
      isShowButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        AppText(
          localization.req_gift,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingDefault),
        child: BlocListener<OrderBloc, OrderState>(
          listenWhen: ((previous, current) {
            if (previous.status == OrderStatus.updating) {
              return false;
            }
            return true;
          }),
          listener: (context, state) async {
            if (state.status == OrderStatus.load) {
              setState(() {
                try {
                  order = state.res;
                } catch (e) {
                  showCatchedError(e);
                }
                try {
                  order?.order?.items?.forEach((element) {
                    productItems.add({
                      "type": element.product?.type,
                      "id": element.product?.id,
                      "name": element.product?.name,
                      "qty": element.quantity
                    });
                    existingProductIds.add(element.product?.id ?? -1);
                  });
                } catch (e) {
                  showCatchedError(e);
                }
              });
              Navigator.of(context).pop();
              setState(() {
                isLoading = false;
              });
            }
            if (state.status == OrderStatus.failure) {
              mySnackbar(state.msg.toString(), isError: true);
              await Future.delayed(Duration.zero);
              Navigator.of(context).pop();
            }
          },
          child: isLoading
              ? const SizedBox()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RequestItemTypeWidget(
                      type: reqItemType,
                      onChanged: ((value) {
                        setState(() {
                          reqItemType = value;
                        });
                      }),
                    ),
                    AppSpacerHeight(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                      tileColor: white,
                      dense: true,
                      horizontalTitleGap: 0,
                      isThreeLine: true,
                      title: Padding(
                        padding: const EdgeInsets.only(top: paddingDefault),
                        child: AppTextField(
                          textEditingController: searchProductController,
                          fillColor: greyLight,
                          isShowShadow: false,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: primary,
                          ),
                          suffixIcon: TextButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            onPressed: () {
                              searchProductController.clear();
                              context.read<ProductBloc>().add(const ClearProductEvent());
                            },
                            child: AppText(
                              localization.clear,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          hintText: reqItemType == 'Gift Article' ? localization.gift_search : localization.pop_search,
                          labelText: reqItemType == 'Gift Article' ? localization.gift_search : localization.pop_search,
                          onTap: () async {
                            context.read<ProductBloc>().add(const ClearProductEvent());
                            await Future.delayed(Duration.zero);

                            BlocProvider.of<ProductBloc>(context).add(GetProductsEvent(
                              type: reqItemType == 'Gift Article' ? 'gift article' : 'pop material',
                              existingProductIds: existingProductIds,
                            ));
                          },
                          onFieldSubmit: (value) async {
                            if (value != '') {
                              BlocProvider.of<ProductBloc>(context).add(
                                SearchProductEvent(
                                  searchKeyword: searchProductController.text.toString(),
                                  type: reqItemType == 'Gift Article' ? 'gift article' : 'pop material',
                                  existingProductIds: existingProductIds,
                                ),
                              );
                            }
                          },
                          onChanged: (value) async {
                            if (value != '') {
                              if (lastInputValue != value) {
                                lastInputValue = value;
                                onSearchChanged(reqItemType);
                              }
                            }
                          },
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 35.0,
                              ),
                              child: ListView.separated(
                                  itemCount: productItems.length,
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (BuildContext context, int index) {
                                    return MySeparator();
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              await editQuantity(productItems[index]['name'], productItems[index]['qty'], index)
                                                  .then((value) => setState(() {}));
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete_forever),
                                            onPressed: () {
                                              appAlertDialog(
                                                  context,
                                                  AppText(
                                                    S.of(context).confirmation,
                                                    textAlign: TextAlign.center,
                                                    fontSize: 17,
                                                  ), () {
                                                Navigator.of(context).pop(true);
                                                try {
                                                  existingProductIds.removeWhere(
                                                    (element) {
                                                      return element == productItems[index]['id'];
                                                    },
                                                  );
                                                  productItems.remove(productItems[index]);
                                                  setState(() {});
                                                } catch (e) {
                                                  showCatchedError(e);
                                                  mySnackbar(
                                                      DioExceptions.getErrorMessage(const DioExceptions.unexpectedError()));
                                                }
                                              }, () {
                                                Navigator.of(context).pop(false);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      title: AppText(
                                        productItems[index]['type'].toString().toTitleCase(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          AppText(
                                            productItems[index]['name'].toString().toTitleCase(),
                                          ),
                                          AppText(
                                            ' x ${productItems[index]['qty']}',
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state.status == ProductStatus.loaded) {
                                  products = state.res;
                                  for (int i = 0; i < ((products?.items?.length) ?? 0); i++) {
                                    generalController.add(TextEditingController());
                                  }
                                }
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  direction: AxisDirection.left,
                                  child: state.status == ProductStatus.initial
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5.0,
                                          ),
                                          child: Center(
                                            child: AppText(
                                                textAlign: TextAlign.center,
                                                reqItemType == 'Gift Article'
                                                    ? localization.gift_search_filter
                                                    : localization.pop_search_filter),
                                          ),
                                        )
                                      : state.status == ProductStatus.loading
                                          ? const AppLoader()
                                          : state.status == ProductStatus.failure
                                              ? Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 5.0,
                                                  ),
                                                  child: Center(
                                                    child: AppText(
                                                      state.msg.toString(),
                                                    ),
                                                  ),
                                                )
                                              : state.status == ProductStatus.loaded
                                                  ? Container(
                                                      color: white,
                                                      constraints: BoxConstraints(maxHeight: 80.h),
                                                      child: ListView.separated(
                                                          itemCount: products?.items?.length ?? 0,
                                                          padding: EdgeInsets.zero,
                                                          physics: const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          separatorBuilder: (BuildContext context, int index) {
                                                            return const Divider();
                                                          },
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: paddingSmall, horizontal: paddingSmall),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Flexible(
                                                                    child: AppText(
                                                                      '${products?.items?[index].name}',
                                                                      fontSize: 17,
                                                                      maxLine: 3,
                                                                    ),
                                                                  ),
                                                                  const AppSpacerHeight(),
                                                                  Flexible(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: SizedBox(
                                                                            width: 25.w,
                                                                            child: TextField(
                                                                              controller: generalController[index],
                                                                              key: Key(index.toString()),
                                                                              style:
                                                                                  Theme.of(context).textTheme.titleMedium!.merge(
                                                                                        const TextStyle(
                                                                                          color: textBlack,
                                                                                        ),
                                                                                      ),
                                                                              textInputAction: TextInputAction.done,
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: <TextInputFormatter>[
                                                                                FilteringTextInputFormatter.allow(
                                                                                    RegExp("[0-9]")),
                                                                              ],
                                                                              decoration: InputDecoration(
                                                                                alignLabelWithHint: true,
                                                                                labelText: localization.quantity,
                                                                                hintText: localization.quantity_enter,
                                                                                contentPadding: const EdgeInsets.symmetric(
                                                                                    vertical: 5.0, horizontal: 5),
                                                                                isDense: true,
                                                                                floatingLabelBehavior:
                                                                                    FloatingLabelBehavior.never,
                                                                                border: OutlineInputBorder(
                                                                                  borderSide:
                                                                                      BorderSide(color: Colors.grey.shade300),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide:
                                                                                      BorderSide(color: Colors.grey.shade300),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide:
                                                                                      BorderSide(color: Colors.grey.shade300),
                                                                                ),
                                                                                hintStyle: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall!
                                                                                    .copyWith(fontSize: 14),
                                                                                errorStyle: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall!
                                                                                    .copyWith(height: 0, color: errorRed),
                                                                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const AppSpacerWidth(),
                                                                        Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: AppButton(
                                                                            btnColor: greyLight,
                                                                            btnTextColor: textBlack,
                                                                            btnFontWeight: FontWeight.normal,
                                                                            btnHeight: 35,
                                                                            btnText: localization.add,
                                                                            onBtnClick: () async {
                                                                              hideKeyboard();
                                                                              if (generalController[index].text.trim() == '') {
                                                                                myToastMsg(localization.quantity_enter,
                                                                                    bg: yellow,
                                                                                    textColor: black,
                                                                                    gravity: ToastGravity.CENTER);
                                                                              } else if (generalController[index].text.trim() !=
                                                                                      '' &&
                                                                                  int.parse(generalController[index].text) <= 0) {
                                                                                myToastMsg(localization.quantity_invalid,
                                                                                    bg: yellow,
                                                                                    textColor: black,
                                                                                    gravity: ToastGravity.CENTER);
                                                                              } else {
                                                                                productItems.add({
                                                                                  "type": products?.items?[index].type,
                                                                                  "id": products?.items?[index].id,
                                                                                  "name": products?.items?[index].name,
                                                                                  "qty": generalController[index].text
                                                                                });
                                                                                existingProductIds
                                                                                    .add(products?.items?[index].id ?? -1);
                                                                                searchProductController.clear();
                                                                                context
                                                                                    .read<ProductBloc>()
                                                                                    .add(const ClearProductEvent());
                                                                                lastInputValue = "";
                                                                                generalController = [];
                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  : const SizedBox.shrink(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    productItems.isEmpty
                        ? SizedBox.shrink()
                        : BlocListener<OrderBloc, OrderState>(
                            listener: (context, state) async {
                              if (state.status == OrderStatus.failure) {
                                mySnackbar(state.msg.toString(), isError: true);
                              }
                              if (state.status == OrderStatus.updating) {
                                showAnimatedDialog(context, const AppDialogLoader());
                              }
                              if (state.status == OrderStatus.updated) {
                                Navigator.of(context).pop(true);
                                mySnackbar(state.msg.toString());
                                if (Navigator.of(context).canPop() == true) {
                                  Navigator.of(context).pop(true);
                                }
                              }
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                                child: AppButtonWithLocation(
                                  btnText: localization.punch_order,
                                  onBtnClick: () async {
                                    hideKeyboard();
                                    List<Map<String, dynamic>> items = [];
                                    for (var product in productItems) {
                                      items.add({"product_id": product['id'], "quantity": product['qty']});
                                    }
                                    Map<String, dynamic> formData = {
                                      "_method": "PUT",
                                      "order": {
                                        "order_id": order?.order?.id,
                                        "client_id": order?.order?.client?.id,
                                        "distributor": order?.order?.distributor?.id,
                                        "type": "MR",
                                        "items": items
                                      }
                                    };
                                    context.read<OrderBloc>().add(
                                          AddOrderEvent(
                                            formData: formData,
                                            reqType: 'put',
                                          ),
                                        );
                                  },
                                ),
                              ),
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
