import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.url}) : super(NotStarted());

  final String url;
  // WebSocketChannel? wsChannel;

  Future<void> connect(String code) async {
    if (state is Connected) return;

    emit(InProgress());

    final channel = WebSocketChannel.connect(Uri.parse(url));
    await channel.ready;

    print('DEBUG connected to $url');

    channel.stream.listen((event) {
      print('DEBUG got event: $event');
    });

    channel.sink.add({
      'jsonrpc': '2.0',
      'method': 'join_room',
      'params': {'partyCode': code},
      'id': 1,
    });

    emit(Connected());
  }
}

sealed class ConnectionState {}

class NotStarted extends ConnectionState {}

class InProgress extends ConnectionState {}

class Connected extends ConnectionState {}
