import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../constants/enums.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetInitial()){
    connectivityStreamSubscription = connectivity.onConnectivityChanged.listen((connectivityResult) {
      if(connectivityResult == ConnectivityResult.wifi) {
        internetConnected(ConnectionType.wifi);
      } else if(connectivityResult == ConnectivityResult.mobile) {
        internetConnected(ConnectionType.mobile);
      } else if(connectivityResult == ConnectivityResult.none) {
        internetDisconnected();
      }
    });
  }

  void internetConnected(ConnectionType _connectionType) => emit(InternetConnected(connectionType: _connectionType));

  void internetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() async {
    connectivityStreamSubscription!.cancel();
    super.close();
  }
}
