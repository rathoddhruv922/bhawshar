import 'package:bhawsar_chemical/data/models/product_model/item.dart' as product;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_snackbar_toast.dart';
import '../../../../widgets/app_text.dart';

class InnerItem extends StatefulWidget {
  InnerItem({
    super.key,
    required this.selectedSizeList,
    required this.products,
    required this.index,
    required this.i,
    required this.selectedSize,
    required this.size,
    required this.scheme,
    this.productSizeId,
    this.schemeApplied,
    required this.generalController,
    required this.toggleSchemeValues,
    required this.id,
    required this.productItems,
    required this.giftItems,
    required this.popItems,
    required this.sampleItems,
    required this.onChanged,
    required this.nonProductive,
  });

  bool nonProductive;
  List selectedSizeList;
  List<product.Item> products;
  int index;
  int i;
  String selectedSize = '';
  String? size, scheme;
  int? schemeApplied;
  int? productSizeId;
  List<TextEditingController> generalController;

  List<int?> toggleSchemeValues;
  final int id;
  final List<Map<dynamic, dynamic>> productItems, giftItems, popItems, sampleItems;
  final ValueChanged onChanged;

  @override
  State<InnerItem> createState() => _InnerItemState();
}

class _InnerItemState extends State<InnerItem> {
  int selectedValue = 0;
  bool addItem = true;
  bool applyScheme = false;
  TextEditingController generalController1 = TextEditingController(text: "");
  TextEditingController generalController2 = TextEditingController(text: "");
  int currentIndex = 0;

  clearCache() {
    widget.size = null;
    widget.productSizeId = null;
    widget.scheme = null;
    widget.schemeApplied = null;
    widget.selectedSize = '';
    widget.generalController = [];
    context.read<ProductBloc>().add(const ClearProductEvent());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => addItemToCart());
  }

  addItemToCart() {
    if (!widget.productItems.any(
      (element) =>
          element["productId"] == widget.products[widget.index].id &&
          element["productSizeId"] == widget.products[widget.index].sizes?[widget.i].productSizeId,
    )) {
      widget.productItems.add({
        'productId': widget.products[widget.index].id,
        'product': widget.products[widget.index],
        'price': widget.products[widget.index].sizes?[widget.i].price,
        'qty': widget.generalController[widget.i].text,
        'size': widget.products[widget.index].sizes?[widget.i].size,
        'size_id': widget.products[widget.index].sizes?[widget.i].sizeId,
        'productSizeId': widget.products[widget.index].sizes?[widget.i].productSizeId,
        'add_item': widget.nonProductive ? false : true,
        'reason': "",
        'not_intrested': selectedValue,
        'scheme': widget.products[widget.index].sizes?[widget.i].scheme,
        'schemeApplied': applyScheme
      });

      currentIndex = widget.productItems.length - 1;
    } else {
      // var myItems = widget.productItems
      //     .where(
      //       (element) =>
      //           element["productId"] == widget.products[widget.index].id &&
      //           element["productSizeId"] == widget.products[widget.index].sizes?[widget.i].productSizeId,
      //     )
      //     .toList()
      //     .first;
      // addItem = myItems["add_item"];
      // if (addItem == false) {
      //   selectedValue = myItems["not_intrested"];
      // }
      // generalController1.text = myItems["qty"].toString();
      // applyScheme = myItems["schemeApplied"] == 1 ? true : false;

      int myItemIndex = widget.productItems.indexWhere(
        (element) =>
            element["productId"] == widget.products[widget.index].id &&
            element["productSizeId"] == widget.products[widget.index].sizes?[widget.i].productSizeId,
      );

      if (myItemIndex != -1) {
        var myItems = widget.productItems[myItemIndex];
        addItem = myItems["add_item"];
        if (addItem == false) {
          selectedValue = myItems["not_intrested"];
        }
        generalController1.text = myItems["qty"].toString();
        applyScheme = myItems["schemeApplied"] == 1 ? true : false;
      } else {
        print("No matching item found");
      }
      currentIndex = myItemIndex;
    }
    if (widget.nonProductive) {
      addItem = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: paddingSmall),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.hardEdge,
            decoration:
                BoxDecoration(color: Colors.white, border: Border.all(color: grey), borderRadius: BorderRadius.circular(15)),
            child: AppText(
              '${widget.products[widget.index].sizes?[widget.i].size}',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.nonProductive)
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          localization.add_item,
                          fontSize: 18,
                          color: black,
                        ),
                      ),
                      Switch(
                        value: addItem,
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: grey,
                        onChanged: (value) {
                          setState(() {
                            addItem = value;
                            widget.productItems[currentIndex]["add_item"] = addItem;
                            widget.productItems[currentIndex]["not_intrested"] = 0;
                            selectedValue = 0;
                          });
                        },
                      ),
                    ],
                  ),
                if (!addItem)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AppText(
                      localization.please_select_reason,
                      fontSize: 16,
                      color: black,
                    ),
                  ),
                if (!addItem)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 0,
                              activeColor: Colors.grey,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                hideKeyboard();
                                setState(() {
                                  selectedValue = value!;
                                  widget.productItems[currentIndex]["not_intrested"] = 0;
                                });
                              },
                            ),
                            Flexible(
                              child: AppText(
                                'Available',
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: Colors.grey,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                hideKeyboard();
                                setState(() {
                                  selectedValue = value!;
                                  widget.productItems[currentIndex]["qty"] = "0";
                                  widget.productItems[currentIndex]["not_intrested"] = 1;
                                });
                              },
                            ),
                            Flexible(
                              child: AppText(
                                localization.not_interested,
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (selectedValue == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: addItem
                                  ? generalController1
                                  : selectedValue == 0
                                      ? generalController1
                                      : generalController2,
                              key: Key(widget.index.toString()),
                              style: Theme.of(context).textTheme.titleMedium!.merge(
                                    const TextStyle(
                                      color: textBlack,
                                    ),
                                  ),
                              textInputAction: TextInputAction.done,
                              keyboardType: selectedValue == 0 ? TextInputType.number : TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                selectedValue == 0
                                    ? FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                    : FilteringTextInputFormatter.singleLineFormatter,
                              ],
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: selectedValue == 0 ? localization.quantity : "Reason",
                                contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                                isDense: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
                                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(height: 0, color: errorRed),
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            fixedSize: Size(80, 40),
                          ),
                          onPressed: () async {
                            hideKeyboard();
                            setState(() {
                              if (generalController1.text.trim().isNotEmpty) {
                                int quantity = int.tryParse(generalController1.text.trim()) ?? -1;
                                if (quantity > 0) {
                                  widget.productItems[currentIndex]["qty"] = quantity.toString();
                                  mySnackbar("Quantity added ${widget.productItems[currentIndex]["qty"]}");
                                } else {
                                  mySnackbar("No valid quantity");
                                }
                              } else {
                                mySnackbar("Quantity is empty");
                              }
                              if (selectedValue == 0) {
                              } else {
                                // widget.productItems[currentIndex]["qty"] = "0";
                                // widget.productItems[currentIndex]["reason"] = generalController2.text;
                                // widget.productItems[currentIndex]["not_intrested"] = 1;
                                // if (generalController2.text.isNotEmpty) {
                                //   mySnackbar("Reason added ${widget.productItems[currentIndex]["reason"]}");
                                // } else {
                                //   mySnackbar("Reason is empty");
                                // }
                              }
                            });
                          },
                          child: AppText(
                            addItem ? localization.add : 'Submit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (addItem)
                  Row(
                    children: [
                      Checkbox(
                        value: applyScheme,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            applyScheme = value!;
                            widget.productItems[currentIndex]["schemeApplied"] = value;
                          });
                        },
                      ),
                      AppText(
                        'Apply  ${widget.products[widget.index].sizes?[widget.i].scheme} Scheme  ',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
