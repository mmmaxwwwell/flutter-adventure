import 'package:adminclient/providers/settings/ApplicationSettings.dart';
import 'package:adminclient/providers/settings/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import './pages/home.dart';

void main() {
  //need to display an initializing screen while this init is happening,
  //so the app doesn't look like its freezing to the user.
  //this is probably also where we'd  ask for authentication.
  KiwiContainer container = KiwiContainer();
  container.registerInstance(SettingsProvider<ApplicationSettings>("settings"));
  //end init
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}
