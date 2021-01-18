class WebsocketState {
  DateTime connectedAt;
  WebsocketConnectionStatus status = WebsocketConnectionStatus.disconnected;
  dynamic error;
}

enum WebsocketConnectionStatus {
  connecting,
  connected,
  disconnecting,
  disconnected,
  error
}
