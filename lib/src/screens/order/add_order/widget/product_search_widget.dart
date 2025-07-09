import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../../constants/app_const.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_text_field.dart';

class ProductSearchWidget extends StatelessWidget {
  const ProductSearchWidget({
    super.key,
    required this.headerItem,
    required this.searchProductController,
    this.productItems,
    this.giftItems,
    this.popItems,
    this.sampleItems,
  });

  final int? headerItem;
  final TextEditingController searchProductController;
  final List<Map>? productItems;
  final List<Map>? giftItems;
  final List<Map>? popItems;
  final List<Map>? sampleItems;

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    String? lastInputValue = '';
    List<int> existingProductIds = [];
    if (headerItem == 0) {
      for (var item in productItems!) {
        if (item['product'].configurable == 0) {
          existingProductIds.add(item['product'].id);
        }
      }
    } else if (headerItem == 1) {
      for (var item in giftItems!) {
        existingProductIds.add(item['gift'].id);
      }
    } else if (headerItem == 2) {
      for (var item in popItems!) {
        existingProductIds.add(item['pop'].id);
      }
    } else {
      for (var item in sampleItems!) {
        existingProductIds.add(item['sample'].id);
      }
    }
    onSearchChanged(headerItem) {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (searchProductController.text.trim() != '') {
          BlocProvider.of<ProductBloc>(context).add(
            SearchProductEvent(
              searchKeyword: searchProductController.text.toString(),
              type: headerItem == 0
                  ? 'product'
                  : headerItem == 1
                      ? 'gift article'
                      : headerItem == 2
                          ? 'pop material'
                          : 'free sample',
              existingProductIds: existingProductIds,
            ),
          );
        }
      });
    }

    return headerItem == 0
        ? SizedBox()
        : Padding(
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
              hintText:
                  '${headerItem == 0 ? localization.product_search : headerItem == 1 ? localization.gift : headerItem == 2 ? localization.pop : localization.sample}...',
              labelText: headerItem == 0
                  ? localization.product_search
                  : headerItem == 1
                      ? localization.gift
                      : headerItem == 2
                          ? localization.pop
                          : localization.sample,
              textInputAction: TextInputAction.search,
              onTap: () async {
                if (headerItem == 0) {
                  for (var item in productItems!) {
                    if (item['product'].configurable == 0) {
                      existingProductIds.add(item['product'].id);
                    }
                  }
                } else if (headerItem == 1) {
                  for (var item in giftItems!) {
                    existingProductIds.add(item['gift'].id);
                  }
                } else if (headerItem == 2) {
                  for (var item in popItems!) {
                    existingProductIds.add(item['pop'].id);
                  }
                } else {
                  for (var item in sampleItems!) {
                    existingProductIds.add(item['sample'].id);
                  }
                }
                context.read<ProductBloc>().add(const ClearProductEvent());
                await Future.delayed(Duration.zero);
                BlocProvider.of<ProductBloc>(context).add(GetProductsEvent(
                  type: headerItem == 0
                      ? 'product'
                      : headerItem == 1
                          ? 'gift article'
                          : headerItem == 2
                              ? 'pop material'
                              : 'free sample',
                  existingProductIds: existingProductIds,
                ));
              },
              onFieldSubmit: (value) async {
                if (value != '') {
                  BlocProvider.of<ProductBloc>(context).add(
                    SearchProductEvent(
                      searchKeyword: searchProductController.text.toString(),
                      type: headerItem == 0
                          ? 'product'
                          : headerItem == 1
                              ? 'gift article'
                              : headerItem == 2
                                  ? 'pop material'
                                  : 'free sample',
                      existingProductIds: existingProductIds,
                    ),
                  );
                }
              },
              onChanged: (value) async {
                if (value != '') {
                  if (lastInputValue != value) {
                    lastInputValue = value;
                    onSearchChanged(headerItem);
                  }
                }
              },
            ),
          );
  }
}
