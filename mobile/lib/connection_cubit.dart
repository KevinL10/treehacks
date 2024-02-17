import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.url}) : super(NotStarted());

  final String url;
  WebSocketChannel? wsChannel;

  Future<void> connect(String code) async {
    if (state is Connected) return;

    await _initializeConnection();
    assert(wsChannel != null, 'wsChannel must not be null');

    wsChannel.sink.add(data)
  }

  Future<void> _initializeConnection() async {
    emit(InProgress());

    final channel = WebSocketChannel.connect(Uri.parse(url));

    await channel.ready;

    wsChannel = channel;

    emit(Connected());
  }
}

sealed class ConnectionState {}

class NotStarted extends ConnectionState {}

class InProgress extends ConnectionState {}

class Connected extends ConnectionState {}
