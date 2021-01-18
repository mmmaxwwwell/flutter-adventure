import 'dart:convert';
import 'package:adminclient/providers/settings/ApplicationSettings.dart';
import 'package:adminclient/providers/settings/SettingsProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/kiwi.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsPage2 extends StatefulWidget {
  SettingsPage2({Key key}) : super(key: key);

  SettingsProvider<ApplicationSettings> provider =
      KiwiContainer().resolve<SettingsProvider<ApplicationSettings>>();

  @override
  _SettingsPage2State createState() => _SettingsPage2State(provider);
}

class _SettingsPage2State extends State<SettingsPage2> {
  SettingsProvider<ApplicationSettings> provider;
  bool _initalized = false;

  Map<String, TextEditingController> _textControllers = {};

  bool settingsChanged = false;
  Map<String, dynamic> _initSettingsValues = {};

  _SettingsPage2State(SettingsProvider<ApplicationSettings> provider) {
    this.provider = provider;
    provider.re
  }

  @override
  void initState() {
    super.initState();
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
          future: this.provider.ready,
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
