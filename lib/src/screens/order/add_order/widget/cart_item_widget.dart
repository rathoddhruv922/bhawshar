import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../data/dio/dio_exception.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_dialog.dart';
import '../../../../widgets/app_separator_widget.dart';
import '../../../../widgets/app_snackbar_toast.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_text.dart';
import '../../../expense/widget/expense_card_widget.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.id,
    required this.productItems,
    required this.giftItems,
    required this.popItems,
    required this.sampleItems,
    this.onChanged,
    // this.qtyController,
    this.isOrderSummary = false,
  });

  final int id;
  final bool isOrderSummary;

  // final TextEditingController? qtyController;
  final ValueChanged? onChanged;

  final List<Map<dynamic, dynamic>> productItems, giftItems, popItems, sampleItems;

  @override
  Widget build(BuildContext context) {
    int itemLength = id == 0
        ? productItems.length
        : id == 1
            ? giftItems.length
            : id == 2
                ? popItems.length
                : sampleItems.length;
    return ListView.builder(
      itemCount: itemLength,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Map<dynamic, dynamic> item = id == 0
            ? productItems[index]
            : id == 1
                ? giftItems[index]
                : id == 2
                    ? popItems[index]
                    : sampleItems[index];

        dynamic items = id == 0
            ? productItems[index]['product']
            : id == 1
                ? giftItems[index]['gift']
                : id == 2
                    ? popItems[index]['pop']
                    : sampleItems[index]['sample'];

        String? size = id == 0
            ? productItems[index]['size']
            : id == 1
                ? giftItems[index]['size']
                : id == 2
                    ? popItems[index]['size']
                    : sampleItems[index]['size'];

        String? scheme = id == 0
            ? productItems[index]['scheme']
            : id == 1
                ? giftItems[index]['scheme']
                : id == 2
                    ? popItems[index]['scheme']
                    : sampleItems[index]['scheme'];

        int notInterested = id == 0 ? productItems[index]['not_intrested'] ?? 0 : 0;

        var applied = id == 0 ? productItems[index]['schemeApplied'] : 0;

        // String? reason = id == 0 ? productItems[index]['reason'] : "";

        bool isAdded = id == 0 ? productItems[index]['add_item'] ?? true : false;
        // save initial value of schemeApplied, While user pressed cancel button this value is assign to particular schemeApplied

        String? qty = id == 0
            ? productItems[index]['qty'].toString().isEmpty
                ? "0"
                : productItems[index]['qty'].toString()
            : id == 1
                ? giftItems[index]['qty'].toString()
                : id == 2
                    ? popItems[index]['qty'].toString()
                    : sampleItems[index]['qty'].toString();

        Future<bool?> editQuantity() {
          TextEditingController editQty = TextEditingController(text: qty);
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
                          '${items.name}'.toUpperCase(),
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
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(paddingDefault),
                        child: Row(
                          children: [
                            (scheme == null || scheme == "")
                                ? SizedBox.shrink()
                                : Flexible(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(minHeight: 45, maxWidth: double.infinity),
                                      child: InkWell(
                                        onTap: () {
                                          hideKeyboard();
                                          productItems[index]['schemeApplied'] =
                                              productItems[index]['schemeApplied'] == 1 ? 0 : 1;
                                          editQty.text = productItems[index]['schemeApplied'] == 1 ? '10' : '1';
                                          if (id == 0) {
                                            if (productItems[index]['product'].configurable == 0) {
                                              productItems[index]['qty'] = editQty.text.toString();
                                            } else if (productItems[index]['product'].configurable == 1) {
                                              productItems[index]['product'].sizes!.forEach((element) {
                                                try {
                                                  if (int.parse(productItems[index]['size_id'].toString()) ==
                                                      int.parse(element.productSizeId.toString())) {
                                                    productItems[index]['qty'] = editQty.text.toString();
                                                  }
                                                } catch (e) {
                                                  showCatchedError(e);
                                                }
                                              });
                                            }
                                          } else if (id == 1) {
                                            giftItems[index]['qty'] = editQty.text.toString();
                                          } else if (id == 2) {
                                            popItems[index]['qty'] = editQty.text.toString();
                                          } else {
                                            sampleItems[index]['qty'] = editQty.text.toString();
                                          }
                                          setState(() {});
                                        },
                                        child: Card(
                                          margin: EdgeInsets.only(right: paddingSmall),
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
                                              productItems[index]['schemeApplied'] == 1
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
                                                  scheme == '' ? 'NA' : scheme,
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
                            Flexible(
                              child: TextFormField(
                                autofocus: true,
                                key: Key(index.toString()),
                                controller: editQty,
                                onFieldSubmitted: (value) async {
                                  schemeQtyValidate(context, editQty, productItems[index]['schemeApplied'] ?? 0);
                                },
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
                                      try {
                                        if (editQty.text != '' && int.parse(editQty.text.toString()) > 0) {
                                          if (id == 0) {
                                            if (productItems[index]['product'].configurable == 0) {
                                              productItems[index]['qty'] = editQty.text.toString();
                                              Navigator.of(context).pop(true);
                                            } else if (productItems[index]['product'].configurable == 1) {
                                              if (schemeQtyValidate(context, editQty, productItems[index]['schemeApplied'])) {
                                                productItems[index]['product'].sizes!.forEach((element) {
                                                  try {
                                                    if (int.parse(productItems[index]['size_id'].toString()) ==
                                                        int.parse(element.productSizeId.toString())) {
                                                      productItems[index]['qty'] = editQty.text.toString();
                                                      Navigator.of(context).pop(true);
                                                    }
                                                  } catch (e) {
                                                    showCatchedError(e);
                                                  }
                                                });
                                              }
                                            }
                                          } else if (id == 1) {
                                            giftItems[index]['qty'] = editQty.text.toString();
                                            Navigator.of(context).pop(true);
                                          } else if (id == 2) {
                                            popItems[index]['qty'] = editQty.text.toString();
                                            Navigator.of(context).pop(true);
                                          } else {
                                            sampleItems[index]['qty'] = editQty.text.toString();
                                            Navigator.of(context).pop(true);
                                          }
                                        } else {
                                          myToastMsg(localization.quantity_invalid,
                                              bg: yellow, textColor: textBlack, gravity: ToastGravity.CENTER);
                                        }
                                      } catch (e) {
                                        myToastMsg(localization.quantity_invalid,
                                            bg: yellow, textColor: textBlack, gravity: ToastGravity.CENTER);
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            isShowButton: false,
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(visible: !isOrderSummary, child: const MySeparator()),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: paddingExtraSmall),
              minLeadingWidth: 0,
              dense: true,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              trailing: isOrderSummary
                  ? null
                  : PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: primary,
                      ),
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      onSelected: (ExpenseMenu item) async {
                        if (item == ExpenseMenu.edit) {
                          await editQuantity().then((value) {
                            if (onChanged != null && value != null) {
                              onChanged!(true);
                            } else {
                              if (productItems.isNotEmpty) {
                                productItems[index]['schemeApplied'] = applied;
                              }
                            }
                          });
                        } else if (item == ExpenseMenu.delete) {
                          try {
                            await _deleteCartItem(context, index).then((value) {
                              if (value == true) {
                                if (onChanged != null) {
                                  onChanged!(true);
                                }
                              }
                            });
                          } catch (e) {
                            showCatchedError(e);
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<ExpenseMenu>>[
                        PopupMenuItem(
                          value: ExpenseMenu.edit,
                          child: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(
                              Icons.edit,
                              color: textBlack,
                            ),
                            label: AppText(localization.edit),
                          ),
                        ),
                        PopupMenuItem(
                          value: ExpenseMenu.delete,
                          child: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(
                              Icons.delete,
                              color: textBlack,
                            ),
                            label: AppText(localization.delete),
                          ),
                        ),
                      ],
                    ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Tooltip(
                      padding: const EdgeInsets.symmetric(
                        horizontal: paddingSmall,
                        vertical: paddingSmall,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: paddingMedium,
                      ),
                      showDuration: const Duration(seconds: 3),
                      enableFeedback: true,
                      message: items.name ?? '',
                      triggerMode: TooltipTriggerMode.tap,
                      child: AppText(
                        '${items.name}',
                        fontSize: 17,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const AppSpacerWidth(),
                  AppText(
                    isOrderSummary
                        ? _getProductTotalAmount(item['price'].toString().contains('-1') == true ? -1.0 : item['price'], qty)
                            .toString() // check -1 when mr has no right to view price
                        : (item['price'].toString().contains('-1') == true)
                            ? 'NA'
                            : '₹ ${currencyFormat.format(item['price'])}', // check -1 when mr has no right to view price
                    fontSize: 16,
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                        decoration: BoxDecoration(
                          color: greyLight,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: AppText(
                          size != null && size.trim() != "" ? size : '-',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const AppSpacerWidth(width: 5),
                  if (notInterested == 0)
                    Row(
                      children: [
                        AppText(
                          isAdded ? localization.quantity : "Available",
                          fontSize: 14,
                        ),
                        const AppSpacerWidth(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: AppText(
                            qty != '0' && qty.trim() != "" ? qty : '0',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        // AppText(
                        //   isAdded ? localization.quantity : "Available",
                        //   fontSize: 14,
                        // ),
                        // const AppSpacerWidth(width: 5),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                        //   decoration: BoxDecoration(
                        //     color: secondary,
                        //     borderRadius: BorderRadius.circular(4.0),
                        //   ),
                        //   child: AppText(
                        //     qty != '0' && qty.trim() != "" ? qty : '0',
                        //     fontSize: 15,
                        //   ),
                        // ),
                      ],
                    ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            if (notInterested == 0)
              Visibility(
                visible: (scheme != null && scheme.trim() != "") ? true : false,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: paddingExtraSmall, horizontal: paddingExtraSmall),
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  decoration: BoxDecoration(
                    color: (scheme != null && scheme.trim() != "" && (productItems[index]['schemeApplied'] == 1))
                        ? primary.withOpacity(0.2)
                        : greyLight,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText(
                          (scheme != null && scheme.trim() != "" && (productItems[index]['schemeApplied']))
                              ? '${localization.scheme_apply} $scheme'
                              : '${localization.scheme_available} ${scheme ?? '-'}',
                          fontSize: 16,
                        ),
                      ),
                      (scheme != null && scheme.trim() != "" && isAdded)
                          ? AppText(
                              '${localization.shipped_qty} ${_getShippedQty(scheme.toString(), productItems[index]['schemeApplied'] ? 1 : 0, qty.toString())}',
                              fontSize: 16,
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(vertical: paddingExtraSmall, horizontal: paddingExtraSmall),
                padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                decoration: BoxDecoration(
                  color: greyLight,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      localization.not_interested,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    // AppText(
                    //   reason ?? "",
                    //   fontSize: 16,
                    // )
                  ],
                ),
              ),
            Visibility(
              visible: isOrderSummary && index != itemLength - 1,
              child: const Divider(
                color: grey,
              ),
            ),
          ],
        );
      },
    );
  }

  String? _getShippedQty(String? scheme, int schemeApplied, String qty) {
    try {
      if (schemeApplied == 1) {
        if (int.parse(scheme.toString().split('+').first) != 0) {
          // int qty0 = (int.parse(scheme.toString().split('+').first) +
          //     int.parse(scheme.toString().split('+').elementAt(1)));
          double tempQty = (int.parse(qty) / int.parse(scheme?.split('+').first ?? '1'));
          int totalQty = (int.parse(tempQty.toString().split('.').first)) + int.parse(qty);
          return totalQty.toString();
        }
      } else {
        return qty;
      }
    } catch (e) {
      showCatchedError(e);
    }
    return qty; //* if something went wrong with scheme or qty than return actual quantity not shipped quantity.
  }

  String _getProductTotalAmount(double? price, String? qty) {
    if (price == -1.0 || price == -1) {
      return 'NA'; // check -1 when mr has no right to view price
    } else {
      num total = 0;
      String priceOld = "0.00";
      priceOld = currencyFormat.format(price).toString();
      try {
        double productPrice = 0;
        if (priceOld != '0.00') {
          productPrice = double.parse(priceOld.toString());
        }
        total = total + (productPrice * (int.parse(qty ?? '0')));
      } catch (e) {
        showCatchedError(e);
      }
      return '₹ ${currencyFormat.format(total)}';
    }
  }

  Future<bool?> _deleteCartItem(BuildContext context, int index) {
    return appAlertDialog(
        context,
        AppText(
          S.of(context).confirmation,
          textAlign: TextAlign.center,
          fontSize: 17,
        ), () {
      Navigator.of(context).pop(true);
      try {
        if (id == 0) {
          productItems[index].remove(productItems.removeAt(index));
        } else if (id == 1) {
          giftItems[index].remove(giftItems.removeAt(index));
        } else if (id == 2) {
          popItems[index].remove(popItems.removeAt(index));
        } else {
          sampleItems[index].remove(sampleItems.removeAt(index));
        }
        myToastMsg(localization.product_remove, bg: yellow, textColor: textBlack);
      } catch (e) {
        showCatchedError(e);
        mySnackbar(DioExceptions.getErrorMessage(const DioExceptions.unexpectedError()));
      }
    }, () {
      Navigator.of(context).pop(false);
    });
  }
}
