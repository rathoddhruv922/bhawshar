import 'package:bhawsar_chemical/src/screens/requestGiftPop/widgets/request_gift_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/bloc/order/order_bloc.dart';
import '../../../../data/models/orders_model/orders_model.dart';
import '../../../../main.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_text.dart';

class RequestGiftListWidget extends StatefulWidget {
  final OrdersModel orderList;
  final bool hasReachedMax;

  const RequestGiftListWidget(
      {Key? key, required this.orderList, required this.hasReachedMax})
      : super(key: key);

  @override
  State<RequestGiftListWidget> createState() => _RequestGiftListWidgetState();
}

class _RequestGiftListWidgetState extends State<RequestGiftListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<OrderBloc>().add(GetOrdersEvent(
          currentPage: widget.orderList.meta!.currentPage! + 1,
          recordPerPage: 20,
          orderType: 'MR'));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.90);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.orderList.items!.length + 1,
      itemBuilder: (buildContext, index) {
        if (index >= widget.orderList.items!.length) {
          return widget.hasReachedMax
              ? Center(
                  child: AppText(localization.no_more_data),
                )
              : const AppLoader();
        } else {
          return RequestGiftCard(
              order: widget.orderList.items![index], index: index);
        }
      },
      // ),
    );
  }
}
