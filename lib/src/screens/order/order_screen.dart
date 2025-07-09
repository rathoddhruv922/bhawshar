import 'dart:math' as math;

import 'package:bhawsar_chemical/src/screens/order/widget/order_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../business_logic/bloc/order/order_bloc.dart';
import '../../../constants/enums.dart';
import '../../router/route_list.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_connection_widget.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_text.dart';
import '../common/common_reload_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    print("object1");
    context.read<OrderBloc>()
      ..add(const ClearOrderEvent())
      ..add(const GetOrdersEvent(currentPage: 1, recordPerPage: 20));

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.order_history_s,
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: green,
        heroTag: "${math.Random().nextDouble()}",
        onPressed: () {
          navigationKey.currentState?.restorablePushNamed(RouteList.searchMedical, arguments: 'Add Order');
        },
        icon: const Icon(
          Icons.add,
          color: white,
        ),
        label: AppText(
          localization.order_add,
          color: white,
        ),
      ),
      body: SafeArea(
        child: ConnectionStatus(
          isShowAnimation: true,
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: BlocConsumer<OrderBloc, OrderState>(
              listenWhen: (previous, current) {
                if ((previous.status == OrderStatus.updating || previous.status == OrderStatus.adding) &&
                    current.status == OrderStatus.load) {
                  return false;
                }
                return true;
              },
              listener: (context, state) async {
                if (state.status == OrderStatus.added) {
                  print("object2");
                  context.read<OrderBloc>().add(
                        const GetOrdersEvent(currentPage: 1, recordPerPage: 20),
                      );
                } else if (state.status == OrderStatus.loading ||
                    state.status == OrderStatus.deleting ||
                    state.status == OrderStatus.cancelling) {
                  showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
                } else if (state.status == OrderStatus.deleted ||
                    state.status == OrderStatus.cancelled ||
                    state.status == OrderStatus.failure) {
                  Navigator.of(context).pop();
                  mySnackbar(state.msg.toString(), isError: state.status == OrderStatus.failure ? true : false);
                  await Future.delayed(Duration.zero);
                } else if (state.status == OrderStatus.loaded) {
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (previous, current) {
                if (previous.status == OrderStatus.adding || previous.status == OrderStatus.updating) {
                  return false;
                } else if (current.status == OrderStatus.deleted ||
                    current.status == OrderStatus.loaded ||
                    current.status == OrderStatus.cancelled ||
                    current.status == OrderStatus.initial ||
                    (current.res == null && current.status == OrderStatus.failure)) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state.status == OrderStatus.initial) {
                  return Center(child: AppText(state.msg.toString()));
                } else if (state.res == null && state.status == OrderStatus.failure) {
                  print("object3");
                  return CommonReloadWidget(
                      message: state.msg,
                      reload: state.msg.toString() == localization.network_error
                          ? (context.read<OrderBloc>()
                            ..add(const ClearOrderEvent())
                            ..add(const GetOrdersEvent(currentPage: 1, recordPerPage: 20)))
                          : null);
                } else if (state.status == OrderStatus.loaded ||
                    state.status == OrderStatus.deleted ||
                    state.status == OrderStatus.cancelled) {
                  return state.res.items!.length == 0
                      ? Center(child: AppText(localization.empty))
                      : OrderList(hasReachedMax: state.hasReachedMax, orderList: state.res);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
