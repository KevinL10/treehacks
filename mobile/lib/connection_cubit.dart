import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ConnectionCubit extends Cubit<ConnState> {
  ConnectionCubit({required this.url}) : super(NotConnected());

  final String url;
  io.Socket? socket;

  Future<void> connect(String code) async {
    if (state is Connected) {
      return;
    }

    final completer = Completer<void>();

    emit(InProgress());
    socket = io.io(url);
    socket!.onConnect((arg) {
      completer.complete();
      print('DEBUG connect, arg: $arg');
      socket!.emit('join_room', 1234);
    });

    socket!.onDisconnect((_) {
      emit(NotConnected());
      print('DEBUG: disconnect');
    });

    completer.isCompleted;
    print('DEBUG completer is completed');
    emit(Connected());
  }

  Future<void> submitData(Map<String, dynamic> data) async {
    assert(socket != null);

    socket!.emit('submit_data', data);
  }
}

sealed class ConnState {}

class NotConnected extends ConnState {}

class InProgress extends ConnState {}

class Connected extends ConnState {}
