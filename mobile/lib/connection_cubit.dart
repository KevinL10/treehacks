import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionCubit extends Cubit<ConnState> {
  ConnectionCubit({required this.url}) : super(NotConnected());

  final String url;
  WebSocketChannel? _channel;

  Future<void> connect({required int roomId, required String name}) async {
    if (state is Connected) {
      throw StateError('already connected!');
    }

    emit(InProgress());

    final channel = WebSocketChannel.connect(Uri.parse(url));
    _channel = channel;
    await channel.ready;

    channel.stream.listen((event) {
      print('DEBUG received event: $event');

      // event is JSON map
      final data = json.decode(event as String) as Map<String, dynamic>;
      if (data['method'] == 'update_status') {
        final status = data['params']['status'] as String;

        if (status == 'waiting') {
          emit(
            Connected(
              waiting: true,
              roomId: roomId,
              name: name,
              placement: null,
            ),
          );
        } else if (status == 'starting') {
          emit(
            Connected(
              waiting: false,
              roomId: roomId,
              name: name,
              placement: null,
            ),
          );
        } else if (status == 'update_placement') {
          emit(
            Connected(
              waiting: false,
              roomId: roomId,
              name: name,
              placement: null,
            ),
          );
        }
      } else if (data['method'] == 'update_placement') {
        final placement = data['params']['index'] as int;
        emit(
          Connected(
            waiting: false,
            roomId: roomId,
            name: name,
            placement: placement,
          ),
        );
      }
    });

    channel.sink.add(
      _jsonRpc(
        'join_room',
        {
          'room_id': roomId,
          'name': name,
        },
      ),
    );
  }

  Future<void> submitData(Map<String, dynamic> data) async {
    assert(_channel != null, 'web socket channel must not be null');

    final state = this.state;
    // if (state is Connected && state.) {

    // }

    _channel!.sink.add(_jsonRpc('submit_data', data));
  }

  void leaveParty() {
    _channel?.sink.close();
    _channel = null;
    emit(NotConnected());
  }
}

var _id = 0;

String _jsonRpc(String methodName, [Map<String, dynamic>? data]) {
  final message = <String, dynamic>{
    'jsonrpc': '2.0',
    'method': methodName,
    if (data != null) 'params': data,
    'id': _id++,
  };

  return json.encode(message);
}

sealed class ConnState {}

class NotConnected extends ConnState {}

class InProgress extends ConnState {}

class Connected extends ConnState {
  Connected({
    required this.waiting,
    required this.roomId,
    required this.name,
    required this.placement,
  });

  final bool waiting;
  final int roomId;
  final String name;
  final int? placement;
}
