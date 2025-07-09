import 'package:bhawsar_chemical/data/models/product_model/item.dart' as product;
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/inner_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../data/models/product_model/product_model.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_snackbar_toast.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_text.dart';

class SearchItemListWidget extends StatefulWidget {
  final ProductModel state;
  final List<Map<dynamic, dynamic>> productItems, giftItems, popItems, sampleItems;
  final ValueChanged onChanged;
  final bool nonProductive;
  final int id;

  const SearchItemListWidget({
    super.key,
    required this.state,
    required this.id,
    required this.productItems,
    required this.giftItems,
    required this.popItems,
    required this.onChanged,
    required this.sampleItems,
    required this.nonProductive,
  });

  @override
  State<SearchItemListWidget> createState() => _SearchItemListWidgetState();
}

class _SearchItemListWidgetState extends State<SearchItemListWidget> {
  List<TextEditingController> generalController = [];
  String selectedSize = '';
  String? size, scheme;
  int? schemeApplied;
  int? productSizeId;
  late List<product.Item> products;

  Map<int, int> countMap = {};

  clearCache() {
    size = null;
    productSizeId = null;
    scheme = null;
    schemeApplied = null;
    selectedSize = '';
    generalController = [];
    context.read<ProductBloc>().add(const ClearProductEvent());
  }

  @override
  void initState() {
    super.initState();
    products = widget.state.items ?? [];
    for (int i = 0; i < widget.productItems.length; i++) {
      try {
        int currentId = widget.productItems[i]['product'].id;
        if (countMap.containsKey(currentId)) {
          countMap[currentId] = countMap[currentId]! + 1;
        } else {
          countMap[currentId] = 1;
        }
      } catch (e) {
        showCatchedError(e);
      }
    }

  }

  @override
  void dispose() {
    for (var controller in generalController) {
      controller.dispose();
    }
    super.dispose();
  }

  List<int?> toggleSchemeValues = [];

  @override
  Widget build(BuildContext context) {
    try {
      for (int i = 0; i < ((widget.state.items?.length) ?? 0); i++) {
        generalController.add(TextEditingController(text: ""));
        toggleSchemeValues.add(0);
      }
    } catch (e) {
      showCatchedError(e);
    }
    return products.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30,
                alignment: Alignment.center,
                child: AppText(
                  localization.empty,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        : ListView.separated(
            itemCount: products.length,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppText(
                            '${products[index].name}',
                            fontSize: 17,
                            maxLine: 3,
                          ),
                        ),
                        const AppSpacerWidth(),
                        AppText(
                          ((products[index].price.toString() == '-1' || products[index].price.toString() == '-1.0') ||
                                  (products[index].range.toString() == '-1' || products[index].range.toString() == '-1.0'))
                              ? 'NA'
                              : '₹ ${products[index].price ?? products[index].range}', // check -1 when mr has no right to view price
                          color: orange,
                        ),
                      ],
                    ),
                    AppSpacerHeight(height: products[index].configurable == 0 ? 0 : 10),
                    if (products[index].configurable == 0)
                      const SizedBox.shrink()
                    else
                      ListView.separated(
                        itemCount: products[index].sizes?.length ?? 0,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext context, int i) {
                          List selectedSizeList = [];
                          try {
                            for (int p = 0; p < widget.productItems.length; p++) {
                              selectedSizeList.add(widget.productItems[p]['size_id']);
                            }
                          } catch (e) {
                            showCatchedError(e);
                          }
                          return InnerItem(
                            index: index,
                            i: i,
                            nonProductive: widget.nonProductive,
                            products: products,
                            scheme: scheme ?? "",
                            selectedSize: selectedSize,
                            selectedSizeList: selectedSizeList,
                            size: size ?? "",
                            productSizeId: productSizeId,
                            schemeApplied: schemeApplied,
                            generalController: generalController,
                            toggleSchemeValues: toggleSchemeValues,
                            id: widget.id,
                            productItems: widget.productItems,
                            giftItems: widget.giftItems,
                            popItems: widget.popItems,
                            sampleItems: widget.sampleItems,
                            onChanged: widget.onChanged,
                          );
                        },
                      ),
                    const AppSpacerHeight(),
                    if (products[index].configurable == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ((products[index].configurable == 1 || products[index].scheme == '') &&
                                  products[index].id == int.parse(selectedSize == "" ? '-1' : selectedSize.split('|').first))
                              ? Flexible(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minHeight: 33, maxWidth: double.infinity),
                                    child: InkWell(
                                      onTap: () {
                                        hideKeyboard();
                                        schemeToggle(index);
                                      },
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        semanticContainer: false,
                                        shadowColor: grey,
                                        elevation: 1,
                                        color: secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            toggleSchemeValues[index] == 1
                                                ? Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color: primary,
                                                        size: 18.sp,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            Container(
                                              alignment: Alignment.center,
                                              child: AppText(
                                                scheme == '' ? 'NA' : scheme ?? 'NA',
                                                fontSize: 15,
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          products[index].configurable == 1 || products[index].scheme == ''
                              ? const SizedBox.shrink()
                              : Flexible(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minHeight: 33, maxWidth: double.infinity),
                                    child: InkWell(
                                      onTap: () {
                                        hideKeyboard();
                                        schemeToggle(index);
                                      },
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        semanticContainer: false,
                                        shadowColor: grey,
                                        elevation: 1,
                                        color: secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            toggleSchemeValues[index] == 1
                                                ? Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color: primary,
                                                        size: 18.sp,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            Container(
                                              alignment: Alignment.center,
                                              child: AppText(
                                                '${products[index].scheme == '' ? 'NA' : products[index].scheme}',
                                                fontSize: 15,
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const AppSpacerWidth(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 25.w,
                              child: TextField(
                                controller: generalController[index],
                                key: Key(index.toString()),
                                style: Theme.of(context).textTheme.titleMedium!.merge(
                                      const TextStyle(
                                        color: textBlack,
                                      ),
                                    ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) async {
                                  schemeQtyValidate(context, generalController[index], toggleSchemeValues[index] ?? 0);
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                ],
                                decoration: InputDecoration(
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
                                try {
                                  size = products[index].configurable == 0 ? null : size;
                                  productSizeId = products[index].configurable == 0 ? null : productSizeId;
                                  if ((selectedSize == '' && products[index].configurable == 1)) {
                                    myToastMsg(localization.size_select,
                                        bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                                  } else if (products[index].configurable == 1 &&
                                      products[index].id != int.parse(selectedSize.split('|').first)) {
                                    myToastMsg(localization.size_select,
                                        bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                                  } else if (generalController[index].text.trim() == '') {
                                    myToastMsg(localization.quantity_enter,
                                        bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                                  } else if (generalController[index].text.trim() != '' &&
                                      int.parse(generalController[index].text) <= 0) {
                                    myToastMsg(localization.quantity_invalid,
                                        bg: yellow, textColor: black, gravity: ToastGravity.CENTER);
                                  } else {
                                    if (widget.id == 0) {
                                      if (schemeQtyValidate(context, generalController[index], toggleSchemeValues[index])) {
                                        setState(() {
                                          widget.productItems.add({
                                            'product': products[index],
                                            'price': products[index].price,
                                            'qty': generalController[index].text,
                                            'size': size,
                                            'size_id': productSizeId,
                                            'scheme': products[index].configurable == 0 ? products[index].scheme : scheme,
                                            'schemeApplied': toggleSchemeValues[index]
                                          });
                                        });
                                        widget.onChanged(true);
                                        clearCache();
                                      }
                                    } else if (widget.id == 1) {
                                      setState(() {
                                        widget.giftItems.add({
                                          'gift': products[index],
                                          'price': products[index].price,
                                          'qty': generalController[index].text,
                                          'size': size,
                                          'size_id': productSizeId,
                                          'scheme': scheme,
                                          'schemeApplied': 0
                                        });
                                      });
                                      widget.onChanged(true);
                                      clearCache();
                                    } else if (widget.id == 2) {
                                      setState(() {
                                        widget.popItems.add({
                                          'pop': products[index],
                                          'price': products[index].price,
                                          'qty': generalController[index].text,
                                          'size': size,
                                          'size_id': productSizeId,
                                          'scheme': scheme,
                                          'schemeApplied': 0
                                        });
                                      });
                                      widget.onChanged(true);
                                      clearCache();
                                    } else {
                                      setState(() {
                                        widget.sampleItems.add({
                                          'sample': products[index],
                                          'price': products[index].price,
                                          'qty': generalController[index].text,
                                          'size': size,
                                          'size_id': productSizeId,
                                          'scheme': scheme,
                                          'schemeApplied': 0
                                        });
                                      });
                                      widget.onChanged(true);
                                      clearCache();
                                    }
                                  }
                                } catch (e) {
                                  showCatchedError(e);
                                  widget.onChanged(false);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
  }

  void schemeToggle(int index, {int? newValue}) {
    toggleSchemeValues[index] = (newValue != null)
        ? newValue
        : toggleSchemeValues[index] == 1
            ? 0
            : 1;
    generalController[index].text = toggleSchemeValues[index] == 1 ? '10' : '1';
    schemeApplied = toggleSchemeValues[index];
    setState(() {});
  }
}
