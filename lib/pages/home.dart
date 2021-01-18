import 'dart:core';
import 'package:adminclient/pages/clients/PublicKeysPage.dart';
import 'package:adminclient/pages/privateKeys/PrivateKeysPage.dart';
import 'package:adminclient/pages/scripts/ScriptsPage.dart';
import 'package:adminclient/pages/settings/SettingsPage.dart';
import 'package:adminclient/pages/status/StatusPage.dart';
import 'package:flutter/material.dart';
import './demo.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Widget> _pages = {
    'Demo': DemoPage(title: "Demo Page"),
    'Public Keys': ClientsPage(),
    'Private Keys': PrivateKeysPage(),
    'Scripts': ScriptsPage(),
    'Settings': SettingsPage(),
    'Status': StatusPage(),
  };

  Map<String, IconData> _pageIcons = {
    "Demo": Icons.emoji_objects,
    'Public Keys': Icons.people,
    'Private Keys': Icons.lock,
    'Scripts': Icons.description,
    'Settings': Icons.settings,
    'Status': Icons.flaky
  };

  String _selectedPage = 'Status';

  @override
  void initState() {
    super.initState();
  }

  _selectPage(selected) {
    setState(() {
      _selectedPage = selected;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
        Icon(_pageIcons[_selectedPage], size: 34),
        Text(" " + _selectedPage, style: TextStyle(fontSize: 28))
      ])),
      body: LayoutBuilder(builder: (context, constraints) {
        return ListView(
          children: [
            for (var page in _pages.keys)
              Offstage(
                child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: _pages[page]),
                offstage: page != _selectedPage,
              )
          ],
        );
      }),
      drawer: Drawer(
          child: ListView(children: [
        for (var pageTitle in _pages.keys)
          GestureDetector(
              onTap: () => _selectPage(pageTitle),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  color: pageTitle == _selectedPage
                      ? Theme.of(context).indicatorColor
                      : Theme.of(context).canvasColor,
                  child: Row(
                    children: [
                      Icon(_pageIcons[pageTitle], size: 34),
                      Text(
                        " " + pageTitle,
                        style: TextStyle(fontSize: 34),
                      )
                    ],
                  )))
      ])),
    );
  }
}
