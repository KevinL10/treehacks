import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionCubit extends Cubit<ConnState>
    with BlocPresentationMixin<ConnState, ConnectionCubitEvent> {
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
      final data = json.decode(event as String) as Map<String, dynamic>;
      if (data['method'] == 'update_status') {
        final status = data['params']['status'] as String;

        if (status == 'waiting') {
          emit(
            Connected(
              uiState: UiState.waiting,
              roomId: roomId,
              name: name,
              placement: null,
            ),
          );
        } else if (status == 'starting') {
          emit(
            Connected(
              uiState: UiState.starting,
              roomId: roomId,
              name: name,
              placement: null,
            ),
          );
        } else if (status == 'finished') {
          final prevState = state;
          final prevPlacement =
              prevState is Connected ? prevState.placement : null;
          final won = data['params']['won'] as bool;

          if (won) {
            emitPresentation(const ShowWinDialog());
          }

          emit(
            Connected(
              uiState: UiState.finished,
              roomId: roomId,
              name: name,
              placement: prevPlacement,
            ),
          );
        }
      } else if (data['method'] == 'update_placement') {
        final placement = data['params']['index'] as int;
        emit(
          Connected(
            uiState: UiState.starting,
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
    if (state is Connected && state.uiState != UiState.starting) {
      return;
    }

    _channel!.sink.add(_jsonRpc('submit_data', data));
  }

  Future<void> setSong(String title) async {
    assert(_channel != null, 'web socket channel must not be null');

    final state = this.state;
    if (state is Connected && state.uiState != UiState.finished) {
      return;
    }

    _channel!.sink.add(_jsonRpc('set_song', {'song': title}));
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
    required this.uiState,
    required this.roomId,
    required this.name,
    required this.placement,
  });

  final UiState uiState;
  final int roomId;
  final String name;
  final int? placement;
}

enum UiState { waiting, starting, finished }

sealed class ConnectionCubitEvent {}

class ShowWinDialog implements ConnectionCubitEvent {
  const ShowWinDialog();
}
