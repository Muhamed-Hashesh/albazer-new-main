import 'dart:developer';

import 'package:albazar_app/core/api/urls.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper {
  const SocketHelper._();

  static Socket? _socket;
  static Socket? get socket => _socket;

  static void connect({Map<String, dynamic>? queries}) {
    // if (_socket != null) return;
    log("connecting socket...");
    final options =
        OptionBuilder().setTransports(['websocket']).disableAutoConnect();
    if (queries != null) {
      options.setQuery(queries);
    }
    final socket = io(
      AppUrls.baseUrl,
      options.build(),
    );

    _socket = socket.connect();
    if (_socket?.connected != true) {}
    // log("connected: ${socket.active}");
    _socket?.onConnect((_) {
      log("connected: ${_socket?.connected}");
    });
  }

  static void disconnect() {
    log("disconnecting socket...");
    _socket?.disconnect();
    log("connected: ${_socket?.connected}");
    _socket = null;
  }
}
