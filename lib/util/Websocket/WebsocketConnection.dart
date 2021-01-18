import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:adminclient/util/Websocket/WebsocketState.dart';

class WebsocketConnection {
  WebSocket socket;
  WebsocketState state = WebsocketState();
  Function stateCallback;
  Map<String, dynamic> headers;
  String url;
  Timer _reconnect;
  List<Function> callbacks = [];
  WebsocketConnection(Function stateCallback) {
    this.stateCallback = stateCallback;
  }

  void register(Function callback) {
    callbacks.add(callback);
  }

  void connect(String url, {String clientId, String clientSecret}) {
    this.url = url;
    headers = {"client-id": clientId, "client-secret": clientSecret};
    _tryConnect();
  }

  void disconnect() {
    if (socket == null) {
      state.status = WebsocketConnectionStatus.disconnected;
      stateCallback(state);
    } else {
      socket.close();
      socket = null;
      state.status = WebsocketConnectionStatus.disconnecting;
      stateCallback(state);
    }
  }

  void _onMessage(dynamic message) {
    print('ws message:' + message);
    var decoded = false;
    try {
      var json = jsonDecode(message);
      decoded = true;
    } catch (e) {}
    if (decoded)
      callbacks.forEach((element) {
        element(json);
      });
  }

  void _send(String json) {
    if (socket != null) socket.add(json);
  }

  void _tryConnect() {
    state.connectedAt = null;
    state.status = WebsocketConnectionStatus.connecting;
    stateCallback(state);
    Timer timer = Timer(Duration(seconds: 5), () {
      _onError('Timeout');
    });
    WebSocket.connect(url, headers: headers).then((ws) {
      socket = ws;
      socket.listen((event) {
        _onMessage(event);
      }, onDone: _onDisconnected, onError: _onError);
      if (socket == null) {
        timer.cancel();
        _onError("Socket closed before connected");
        return;
      }
      timer.cancel();
      state.connectedAt = DateTime.now();
      state.status = WebsocketConnectionStatus.connected;
      stateCallback(state);
      _send('{"event":"client-connected"}');
    });
  }

  void _onError(dynamic e) {
    if (socket != null) {
      socket.close();
    }
    socket = null;
    state.error = e;
    state.status = WebsocketConnectionStatus.error;
    state.connectedAt = null;
    stateCallback(state);
    if (e == "Timeout") {
      if (_reconnect != null) _reconnect.cancel();
      _reconnect = Timer(Duration(seconds: 15), () {
        _tryConnect();
      });
    }
  }

  void _onDisconnected() {
    bool closeError = false;
    if (socket != null) {
      if (socket.closeCode == 1002) closeError = true;
      socket.close();
    }
    socket = null;
    if (closeError) {
      _onError("Connection closed with code 1002");
      return;
    }
    state.status = WebsocketConnectionStatus.disconnected;
    state.connectedAt = null;
    stateCallback(state);
    if (state.status != WebsocketConnectionStatus.error) _tryConnect();
  }
}
