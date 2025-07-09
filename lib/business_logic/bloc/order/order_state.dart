part of '../order/order_bloc.dart';

class OrderState extends Equatable {
  const OrderState(
      {this.status = OrderStatus.initial,
      this.hasReachedMax = false,
      this.res,
      this.msg});

  final String? msg;
  final dynamic res;
  final OrderStatus status;
  final bool hasReachedMax;

  OrderState copyWith(
      {dynamic res, String? msg, OrderStatus? status, bool? hasReachedMax}) {
    return OrderState(
        res: status == OrderStatus.initial ? null : res ?? this.res,
        msg: msg ?? this.msg,
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object?> get props => [status, msg, res, hasReachedMax];
}
