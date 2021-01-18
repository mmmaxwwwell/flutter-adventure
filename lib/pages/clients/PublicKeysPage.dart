import 'dart:convert';
import 'package:adminclient/classes/Client/Client.dart';
import 'package:adminclient/pages/clients/AddClientForm.dart';
import 'package:adminclient/pages/clients/EditClientForm.dart';
import 'package:adminclient/util/Modal/AlertModal.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  ClientsPage({Key key}) : super(key: key);
  final String title = "Public Keys";
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  LocalStorage _storage;
  bool _initalized = false;
  List<Client> _clients = [];

  @override
  void initState() {
    super.initState();
    _storage = new LocalStorage(widget.title);
  }

  void _showEditClientModal(BuildContext context, int index) {
    AlertModal<Client>(context, EditClientForm(_clients[index], index),
        (action) => {_modalCallback(action)});
  }

  void _showAddClientModal(BuildContext context) {
    AlertModal<Client>(
        context, AddClientForm(), (action) => {_modalCallback(action)});
  }

  void _modalCallback(ModalAction<Client> action) async {
    switch (action.actionType) {
      case ActionType.create:
        setState(() {
          _clients.add(action.value);
          _save();
        });
        break;
      case ActionType.update:
        setState(() {
          _clients[action.index] = action.value;
          _save();
        });
        break;
      case ActionType.destroy:
        setState(() {
          _clients.removeAt(action.index);
          _save();
        });
        break;
    }
  }

  void _save() {
    _storage.setItem('clients', jsonEncode(_clients));
  }

  TextStyle textStyle = TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            if (!_initalized) {
              var clients = _storage.getItem('clients');
              if (clients == null) {
                _clients = [];
                _save();
              } else {
                for (var client in jsonDecode(clients)) {
                  _clients.add(Client.fromJson(client));
                }
              }
              _initalized = true;
            }

            if (_clients.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No clients added yet.",
                    style: textStyle,
                  ),
                  Text(
                    "Tap the + button to add one.",
                    style: textStyle,
                  )
                ],
              ));
            } else {
              return Center(
                  child: ListView.builder(
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => {_showEditClientModal(context, index)},
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: (index % 2 == 0)
                              ? Theme.of(context).canvasColor
                              : Theme.of(context).highlightColor,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name:",
                                    style: textStyle,
                                  ),
                                  Text(_clients[index].username,
                                      style: textStyle)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Length:",
                                    style: textStyle,
                                  ),
                                  Text(
                                      _clients[index]
                                              .publicKey
                                              .length
                                              .toString() +
                                          ' bytes',
                                      style: textStyle)
                                ],
                              ),
                            ],
                          )));
                },
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientModal(context),
        tooltip: 'Add Client',
        child: Icon(Icons.add),
      ),
    );
  }
}
