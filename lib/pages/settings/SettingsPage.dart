import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  final String title = "Settings";
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LocalStorage _storage;
  bool _initalized = false;

  Map<String, TextEditingController> _textControllers = {};

  Map<String, Type> _settingsTypes = {
    'Server Address': String,
    'Client ID': String,
    'Client Secret': String,
    'Require Authentication on Launch': bool,
    'Enable Biometric Authentication': bool,
    'sampleInt': int
  };

  Map<String, dynamic> _defaultValues = {
    "Server Address": "ws://localhost:8080",
    "Client ID": "ABC123",
    "Client Secret": "abcdef1234567890",
    'Require Authentication on Launch': false,
    'Enable Biometric Authentication': false,
    'sampleInt': 10
  };

  bool settingsChanged = false;
  Map<String, dynamic> _initSettingsValues = {};
  Map<String, dynamic> _settingsValues = {};

  Map<String, String> _description = {
    'Server Address': "Server that will act as a master hub",
    "Client ID": "Client ID for authentication",
    "Client Secret": "Client Secret for authentication",
    'Require Authentication on Launch':
        "Require password or biometric authentication when starting the app",
    'Enable Biometric Authentication':
        "If enabled, this will allow anyone with biometric access to this phone to authenticate. If disabled, a password will be required.",
    'sampleInt': "This is an example int."
  };

  @override
  void initState() {
    super.initState();
    _storage = new LocalStorage(widget.title);
  }

  void _save() async {
    await _storage.setItem('settings', jsonEncode(_settingsValues));
    _initSettingsValues = Map.from(_settingsValues);
  }

  void _saveButton(BuildContext context) {
    setState(() {
      _save();
    });
    Fluttertoast.showToast(msg: "Saved settings");
  }

  TextStyle keyTextStyle = TextStyle(fontSize: 24);
  TextStyle infoTextStyle = TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    settingsChanged = !mapEquals(_initSettingsValues, _settingsValues);
    return Scaffold(
      body: FutureBuilder(
          future: _storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            if (!_initalized) {
              var temp = _storage.getItem('settings');
              if (temp == null)
                _settingsValues = {};
              else
                _settingsValues = jsonDecode(temp);
              var wasNewVal = false;
              _settingsTypes.forEach((key, value) {
                if (!_settingsValues.keys.contains(key) ||
                    _settingsValues[key] == null) {
                  wasNewVal = true;
                  _settingsValues[key] = _defaultValues[key];
                }
              });
              if (wasNewVal) {
                _save();
              }
              _initSettingsValues = Map.from(_settingsValues);
              settingsChanged =
                  !mapEquals(_initSettingsValues, _settingsValues);
              _settingsTypes.forEach((key, value) {
                if (value == String) {
                  _textControllers[key] = TextEditingController(
                      text: _settingsValues[key] as String);
                }
              });
              _initalized = true;
            }

            return Center(
                child: ListView.builder(
              itemCount: _settingsTypes.keys.length,
              itemBuilder: (context, index) {
                String key = _settingsTypes.keys.elementAt(index);
                Type type = _settingsTypes[key];
                String description = _description[key];

                bool boolValue;
                int intValue;

                switch (type) {
                  case bool:
                    boolValue = _settingsValues[key] as bool;
                    break;
                  case int:
                    intValue = _settingsValues[key] as int;
                    break;
                }

                return Container(
                    padding: EdgeInsets.all(5),
                    color: (index % 2 == 0)
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).highlightColor,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              key,
                              style: keyTextStyle,
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              description,
                              style: infoTextStyle,
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (type == bool)
                              Switch(
                                  value: boolValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _settingsValues.update(
                                          key, (value) => newValue,
                                          ifAbsent: () => newValue);
                                    });
                                  })
                            else if (type == String)
                              Expanded(
                                  child: TextField(
                                controller: _textControllers[key],
                                onChanged: (newValue) {
                                  setState(() {
                                    _settingsValues.update(
                                        key, (value) => newValue,
                                        ifAbsent: () => newValue);
                                  });
                                },
                              ))
                            else if (type == int)
                              new NumberPicker.horizontal(
                                  initialValue: intValue,
                                  minValue: 0,
                                  maxValue: 10,
                                  step: 1,
                                  zeroPad: false,
                                  onChanged: (newValue) => setState(() {
                                        _settingsValues.update(
                                            key, (value) => newValue,
                                            ifAbsent: () => newValue);
                                      })),
                          ],
                        ),
                      ],
                    ));
              },
            ));
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: settingsChanged ? () => _saveButton(context) : null,
          backgroundColor: settingsChanged
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          tooltip: 'Add Client',
          child: Icon(Icons.save)),
    );
  }
}
