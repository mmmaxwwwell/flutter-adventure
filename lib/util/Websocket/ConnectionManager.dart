import 'package:adminclient/util/Websocket/WebsocketConnection.dart';
import 'package:flutter/cupertino.dart';

class ConnectionManager {
  WebsocketConnection _connection;
  ConnectionManager(WebsocketConnection connection) {
    _connection = connection;
    connection.register(callback);
  }

  Function callback(Map<String, dynamic> json) {}

  Future<bool> addClient(String publicKey, String username, String pass) {
    var requestId = UniqueKey();
  }
}
