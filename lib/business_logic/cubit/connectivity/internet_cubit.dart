import 'dart:async';

import 'package:bhawsar_chemical/constants/enums.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late StreamSubscription connectivityStreamSubscription;

  InternetCubit() : super(InternetConnected(connectionType: ConnectionType.mobile)) {
    // monitorInternetConnection();
  }

  // StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {
  //   //* check connectivity status when connection is changed or lost
  //   return connectivityStreamSubscription = Connectivity().onConnectivityChanged.listen((connectivityResult) async {
  //     if (connectivityResult.first == ConnectivityResult.wifi ||
  //         connectivityResult.first == ConnectivityResult.mobile ||
  //         connectivityResult.first == ConnectivityResult.ethernet) {
  //       checkInitialConnectivity(connectivityResult.first);
  //     } else if (connectivityResult.first == ConnectivityResult.none) {
  //       var connectivityResult = await (Connectivity().checkConnectivity());
  //       checkInitialConnectivity(connectivityResult.first);
  //     }
  //   });
  // }

  // void checkInitialConnectivity(ConnectivityResult connectivityResult) async {
  //   try {
  //     final res = await InternetAddress.lookup('www.google.com');
  //     if (connectivityResult == ConnectivityResult.mobile) {
  //       hasConnection = true;
  //       emitInternetConnected(ConnectionType.mobile);
  //     } else if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
  //       hasConnection = true;
  //       emitInternetConnected(ConnectionType.wifi);
  //     } else {
  //       hasConnection = false;
  //       emitInternetDisconnected();
  //     }
  //   } catch (e) {
  //     emitInternetDisconnected();
  //     hasConnection = false;
  //   }
  // }

  void emitInternetConnected(ConnectionType connectionType) => emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
