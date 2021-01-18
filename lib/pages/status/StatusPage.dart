import 'dart:convert';

import 'package:adminclient/util/Websocket/WebsocketConnection.dart';
import 'package:adminclient/util/Websocket/WebsocketState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class StatusPage extends StatefulWidget {
  StatusPage({Key key}) : super(key: key);
  final String title = "Settings";
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  LocalStorage storage;
  bool initialized = false;
  WebsocketState connectionState = WebsocketState();
  WebsocketConnection connection;
  Map<String, dynamic> settings;
  @override
  void initState() {
    super.initState();
    storage = new LocalStorage("Settings");
    connection = WebsocketConnection(stateCallback);
    storage.ready.whenComplete(() => _storageReady());
  }

  void _storageReady() async {
    settings = await jsonDecode(storage.getItem('settings'));
    initialized = true;
    _connect();
  }

  void _connect() {
    connection.connect(settings['Server Address'],
        clientId: settings['Client ID'],
        clientSecret: settings['Client Secret']);
  }

  void stateCallback(WebsocketState newState) {
    setState(() {
      connectionState = newState;
    });
  }

  Widget connectionStatusIcon() {
    switch (connectionState.status) {
      case WebsocketConnectionStatus.connecting:
        return Icon(
          Icons.signal_cellular_4_bar,
          size: 32,
        );
        break;
      case WebsocketConnectionStatus.connected:
        return Icon(
          Icons.check_box,
          size: 32,
        );
        break;
      case WebsocketConnectionStatus.disconnecting:
        return Icon(
          Icons.signal_cellular_connected_no_internet_4_bar,
          size: 32,
        );
        break;
      case WebsocketConnectionStatus.disconnected:
        return Icon(
          Icons.check_box_outline_blank,
          size: 32,
        );
        break;
      case WebsocketConnectionStatus.error:
        return Icon(
          Icons.error,
          size: 32,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text("Connection Status:", style: TextStyle(fontSize: 28)),
          connectionStatusIcon()
        ]),
        if (connectionState.error == null)
          Text("No connection error")
        else
          Text(connectionState.error.toString()),
        ElevatedButton(
            onPressed: () {
              _storageReady();
            },
            child: Text("Connect", style: TextStyle(fontSize: 24))),
        ElevatedButton(
            onPressed: () {
              connection.disconnect();
            },
            child: Text("Disconnect", style: TextStyle(fontSize: 24))),
        ElevatedButton(
            onPressed: () {},
            child: Text("Add Client", style: TextStyle(fontSize: 24))),
      ],
    )));
  }
}
