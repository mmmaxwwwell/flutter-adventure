import 'package:adminclient/classes/Client/Client.dart';
import 'package:adminclient/classes/Client/ClientValidations.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:adminclient/util/QRScanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class AddClientForm extends StatefulWidget
    with ClientValidations
    implements ModalForm<ModalAction<Client>> {
  final state = _AddClientFormState();

  @override
  _AddClientFormState createState() => state;

  String title = "Add Client";
  String acceptText = "Add";
  bool showDelete = false;
  bool showCancel = true;
  String name() {
    return state.usernameController.text;
  }

  String initialName() {
    return "";
  }

  @override
  ModalAction<Client> data([bool destroy = false]) {
    return ModalAction<Client>(
        value: Client(
            publicKey: state.publicKeyController.text,
            username: state.usernameController.text),
        actionType: ActionType.create);
  }

  @override
  Future<ModalAction<Client>> postProcess(ModalAction<Client> subject) {
    return Future.value(subject);
  }
}

class _AddClientFormState extends State<AddClientForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    publicKeyController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void scanCallback(Barcode scanData) async {
    if (scanData.code.startsWith(
        "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x")) {
      var counter = 0;
      //ubuntu keyservers need some time to sync and about half the calls fail
      //try 10 times max to get the key
      while (counter < 10) {
        counter++;
        http.Response response = await http.get(scanData.code);
        if (response.statusCode == 200) {
          setState(() {
            publicKeyController.text = response.body;
          });
          break;
        }
      }

      while (counter < 10) {
        counter++;
        http.Response response = await http.get(
            scanData.code.replaceFirst("op=get", "op=index") +
                "&options=mr,nm");
        if (response.statusCode == 200) {
          RegExp emailRegex = RegExp("^uid:.*?<(.*?)>", multiLine: true);
          var matches = emailRegex.allMatches(response.body);
          if (matches.isNotEmpty) {
            setState(() {
              usernameController.text = matches.first.group(1);
            });
          }
          break;
        }
      }
    } else if (scanData.code
        .startsWith("-----BEGIN PGP PUBLIC KEY BLOCK-----")) {
      setState(() {
        publicKeyController.text = scanData.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        TextField(
            decoration: InputDecoration(hintText: "User Name"),
            controller: usernameController),
        TextField(
            decoration: InputDecoration(hintText: "Public Key"),
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            controller: publicKeyController),
        if (!kIsWeb)
          RaisedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return QRViewExample(callback: scanCallback);
                },
              );
            },
            color: Theme.of(context).accentColor,
            child: Text("Scan from QR code"),
          )
      ],
    );
  }
}
