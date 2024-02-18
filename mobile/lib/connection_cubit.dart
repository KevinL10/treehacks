import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionCubit extends Cubit<ConnState> {
  ConnectionCubit({required this.url}) : super(NotConnected());

  final String url;
  WebSocketChannel? _channel;

  Future<void> connect({required String code, required String name}) async {
    if (state is Connected) {
      return;
    }

    emit(InProgress());

    final channel = WebSocketChannel.connect(Uri.parse(url));
    _channel = channel;

    await channel.ready;

    channel.stream.listen((event) {
      print('DEBUG received: $event');
    });

    channel.sink.add(
      _jsonRpc(
        'join_room',
        {
          'room_id': code,
          'name': name,
        },
      ),
    );

    emit(Connected());
  }

  Future<void> submitData(Map<String, dynamic> data) async {
    assert(_channel != null, 'web socket channel must not be null');

    _channel!.sink.add(_jsonRpc('submit_data', data));
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

class Connected extends ConnState {}
