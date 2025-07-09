import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/order_model/order_model.dart';
import 'package:bhawsar_chemical/data/models/orders_model/orders_model.dart';
import 'package:bhawsar_chemical/data/repositories/order_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'order_event.dart';
part 'order_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc(this.orderRepository) : super(const OrderState()) {
    on<ClearOrderEvent>(_onClearOrder, transformer: throttleSequentials(throttleDuration));
    on<AddOrderEvent>(_onAddOrder);
    on<GetOrdersEvent>(_onGetOrders, transformer: throttleDroppable(throttleDuration));
    on<GetOrderEvent>(_onGetOrder, transformer: throttleDroppable(throttleDuration));

    on<DeleteOrderEvent>(_onDeleteOrder, transformer: throttleSequentials(throttleDuration));
    on<CancelOrderEvent>(_onCancelOrder, transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onClearOrder(ClearOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.initial, msg: localization.loading));
  }

  Future<void> _onGetOrder(GetOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      ApiResult<OrderModel> apiResult = await orderRepository.getOrder(event.orderId);
      apiResult.when(success: (OrderModel data) {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: OrderStatus.load,
          ),
        );
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          status: OrderStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: OrderStatus.failure,
      ));
    }
  }

  Future<void> _onGetOrders(GetOrdersEvent event, Emitter<OrderState> emit) async {
    if (state.hasReachedMax &&
        event.currentPage != 1 &&
        state.status != OrderStatus.updated &&
        state.status != OrderStatus.deleted &&
        state.status != OrderStatus.added) return;
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      ApiResult<OrdersModel> apiResult =
          await orderRepository.getOrders(event.currentPage, event.recordPerPage, orderType: event.orderType);
      apiResult.when(success: (OrdersModel data) {
        updateFeedbackCount(data.openFeedback ?? 0);
        OrdersModel? orderList;
        if (state.res != null && event.currentPage <= data.meta!.lastPage! && event.currentPage != 1) {
          orderList = state.res;
          orderList?.items?.addAll(data.items!);
          orderList?.meta = data.meta;
        } else {
          orderList = data;
        }
        emit(
          state.copyWith(
            res: orderList,
            msg: data.message,
            status: OrderStatus.loaded,
            hasReachedMax: event.currentPage == data.meta!.lastPage ? true : false,
          ),
        );
      }, failure: (DioExceptions error) {
        emit(state.copyWith(
          status: OrderStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: OrderStatus.failure,
      ));
    }
  }

  Future<void> _onAddOrder(AddOrderEvent event, Emitter<OrderState> emit) async {
    emit(
      state.copyWith(
        status: event.reqType == 'post' ? OrderStatus.adding : OrderStatus.updating,
      ),
    );
    try {

      // bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!isLocationEnabled) {
      //   emit(
      //     state.copyWith(
      //       res: null,
      //       msg: localization.location_enabled,
      //       status: OrderStatus.failure,
      //       hasReachedMax: false,
      //     ),
      //   );
      //   return;
      // }
      // Position position =
      //     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 30));
      //
      // event.formData["order"]["lat"] = position.latitude;
      // event.formData["order"]["lng"] = position.longitude;
      ApiResult<Response> apiResult = await orderRepository.addOrderDetail(
        event.formData,
        reqType: event.reqType,
      );

      await apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            res: event.reqType == 'post' ? data : state.res,
            msg: data.data['message'],
            status: event.reqType == 'post' ? OrderStatus.added : OrderStatus.updated,
            hasReachedMax: false,
          ),
        );
      }, failure: (DioExceptions error) async {
        String errorMsg = DioExceptions.getErrorMSg(error);
        emit(state.copyWith(
          msg: errorMsg == "" ? DioExceptions.getErrorMessage(const DioExceptions.internalServerError()) : errorMsg,
          status: OrderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: OrderStatus.failure,
      ));
    }
  }

  Future<void> _onDeleteOrder(DeleteOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      status: OrderStatus.deleting,
      res: state.res,
    ));
    try {
      ApiResult<Response> apiResult = await orderRepository.deleteOrder(event.orderId, event.itemIndex);
      apiResult.when(success: (Response data) async {
        OrdersModel orderList = state.res;
        orderList.items?.removeAt(event.itemIndex!);
        emit(state.copyWith(
          res: orderList,
          msg: data.data['message'],
          status: OrderStatus.deleted,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: OrderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: OrderStatus.failure,
      ));
    }
  }

  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      status: OrderStatus.cancelling,
      res: state.res,
    ));
    try {
      ApiResult<Response> apiResult = await orderRepository.cancelOrder(event.orderId, event.itemIndex, event.status);
      apiResult.when(success: (Response data) async {
        OrdersModel orderList = state.res;
        orderList.items?.elementAt(event.itemIndex!).status = data.data['order']['status'];
        emit(state.copyWith(
          res: orderList,
          msg: data.data['message'],
          status: OrderStatus.cancelled,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: OrderStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: OrderStatus.failure,
      ));
    }
  }
}
