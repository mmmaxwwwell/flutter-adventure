import 'dart:convert';
import 'package:adminclient/classes/PrivateKey/PrivateKey.dart';
import 'package:adminclient/pages/privateKeys/AddPrivateKeyForm.dart';
import 'package:adminclient/pages/privateKeys/EditPrivateKeyForm.dart';
import 'package:adminclient/util/Modal/AlertModal.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

class PrivateKeysPage extends StatefulWidget {
  PrivateKeysPage({Key key}) : super(key: key);
  final String title = "Private Keys";
  @override
  _PrivateKeysPageState createState() => _PrivateKeysPageState();
}

class _PrivateKeysPageState extends State<PrivateKeysPage> {
  LocalStorage _storage;
  bool _initalized = false;
  List<PrivateKey> _privateKeys = [];

  @override
  void initState() {
    super.initState();
    _storage = new LocalStorage(widget.title);
  }

  void _showEditClientModal(BuildContext context, int index) {
    AlertModal<PrivateKey>(
        context,
        EditPrivateKeyForm(_privateKeys[index], index),
        (action) => {_modalCallback(action)});
  }

  void _showAddClientModal(BuildContext context) {
    AlertModal<PrivateKey>(
        context, AddPrivateKeyForm(), (action) => {_modalCallback(action)});
  }

  void _modalCallback(ModalAction<PrivateKey> action) async {
    switch (action.actionType) {
      case ActionType.create:
        setState(() {
          _privateKeys.add(action.value);
          _save();
        });
        break;
      case ActionType.destroy:
        setState(() {
          _privateKeys.removeAt(action.index);
          _save();
        });
        break;
      case ActionType.update:
        setState(() {
          _privateKeys[action.index] = action.value;
          _save();
        });
        break;
    }
  }

  void _save() {
    _storage.setItem('clients', jsonEncode(_privateKeys));
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
                _privateKeys = [];
                _save();
              } else {
                for (var client in jsonDecode(clients)) {
                  _privateKeys.add(PrivateKey.fromJson(client));
                }
              }
              _initalized = true;
            }

            if (_privateKeys.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No ${widget.title} added yet.",
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
                itemCount: _privateKeys.length,
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
                                  Text(_privateKeys[index].name,
                                      style: textStyle)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email:",
                                    style: textStyle,
                                  ),
                                  Text(_privateKeys[index].email,
                                      style: textStyle)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bits:",
                                    style: textStyle,
                                  ),
                                  Text(_privateKeys[index].bitWidth.toString(),
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
