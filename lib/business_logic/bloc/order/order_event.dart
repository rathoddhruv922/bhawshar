part of '../order/order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends OrderEvent {
  final int currentPage, recordPerPage;
  final String? orderType;
  const GetOrdersEvent(
      {required this.currentPage, required this.recordPerPage, this.orderType});

  @override
  List<Object?> get props => [currentPage, recordPerPage, orderType];
}

class GetOrderEvent extends OrderEvent {
  final int orderId;
  const GetOrderEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class DeleteOrderEvent extends OrderEvent {
  final int? orderId, itemIndex;

  const DeleteOrderEvent({required this.orderId, required this.itemIndex});

  @override
  List<Object?> get props => [orderId, itemIndex];
}

class CancelOrderEvent extends OrderEvent {
  final int? orderId, itemIndex;
  final String status;

  const CancelOrderEvent(
      {required this.orderId, required this.itemIndex, required this.status});

  @override
  List<Object?> get props => [orderId, itemIndex, status];
}

class AddOrderEvent extends OrderEvent {
  final Map<String, dynamic> formData;

  final String reqType;

  const AddOrderEvent({required this.formData, required this.reqType});

  @override
  List<Object> get props => [formData, reqType];
}

class ClearOrderEvent extends OrderEvent {
  const ClearOrderEvent();

  @override
  List<Object> get props => [];
}
