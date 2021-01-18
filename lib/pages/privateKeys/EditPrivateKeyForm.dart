import 'package:adminclient/classes/PrivateKey/PrivateKey.dart';
import 'package:adminclient/util/Keyserver.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class EditPrivateKeyForm extends StatefulWidget
    implements ModalForm<ModalAction<PrivateKey>> {
  _EditPrivateKeyFormState state;

  @override
  _EditPrivateKeyFormState createState() => state;

  String title = "View Private Key Details";
  final String acceptText = "Ok";
  final bool showDelete = true;
  final bool showCancel = false;
  String name() {
    return state.privateKey.name;
  }

  String initialName() {
    return state.privateKey.name;
  }

  EditPrivateKeyForm(PrivateKey privateKey, int index) {
    state = _EditPrivateKeyFormState(privateKey, index);
  }

  @override
  ModalAction<PrivateKey> data([bool destroy = false]) {
    return ModalAction<PrivateKey>(
        value: PrivateKey(
            name: state.privateKey.name,
            email: state.privateKey.email,
            bitWidth: state.privateKey.bitWidth,
            publicKeyUrl: state.privateKey.publicKeyUrl,
            publicKey: state.privateKey.publicKey,
            privateKey: state.privateKey.privateKey),
        index: state.index,
        actionType: destroy ? ActionType.destroy : ActionType.update);
  }

  @override
  Future<ModalAction<PrivateKey>> postProcess(ModalAction<PrivateKey> subject) {
    return Future.value(subject);
  }

  @override
  Future<List<String>> validationErrors(ModalAction<PrivateKey> subject) {
    return Future.value([]);
  }
}

class _EditPrivateKeyFormState extends State<EditPrivateKeyForm> {
  TextEditingController manualUploadController = TextEditingController();
  int index;
  PrivateKey privateKey;
  @override
  void initState() {
    super.initState();
  }

  _EditPrivateKeyFormState(PrivateKey privateKey, int index) {
    this.privateKey = privateKey;
    this.index = index;
  }

  @override
  void dispose() {
    manualUploadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text("Name: ${privateKey.name}"),
        Text("Email: ${privateKey.email}"),
        Text("Strength: ${privateKey.bitWidth.toString()}"),
        if (privateKey.publicKeyUrl == null) Text("Not uploaded to keyserver"),
        if (privateKey.publicKeyUrl == null)
          ElevatedButton(
              onPressed: () async {
                if (kIsWeb) {
                  Clipboard.setData(ClipboardData(text: privateKey.publicKey));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Upload Public Key"),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView(
                            children: [
                              Text(
                                  "To upload the public key to the keyservers, you will need to:\n1. Go to https://keyserver.ubuntu.com\n2. Click \"Submit Key\"\n3. Paste the key in\n4. Click \"Submit Public Key\"\n5. Copy the text returned from that page\n 6. Come back here and paste it into the text box underneath this text\n\n The key has already been copied to your clipboard. Click \"Take me there\" to start."),
                              TextField(controller: manualUploadController),
                            ],
                          ),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          FlatButton(
                              onPressed: () async {
                                await launch("https://keyserver.ubuntu.com");
                              },
                              child: Text("Take me there")),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  privateKey.publicKeyUrl = Keyserver.getUrl(
                                      manualUploadController.text);
                                });
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                  );
                } else {
                  String url = await Keyserver.upload(privateKey.publicKey);
                  setState(() {
                    privateKey.publicKeyUrl = url;
                  });
                }
              },
              child: Text("Upload to keyserver")),
        Text(""),
        if (privateKey.publicKeyUrl != null)
          Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: QrImage(
                      data: "${privateKey.publicKeyUrl}",
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  ))),
        if (privateKey.publicKeyUrl != null)
          ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: privateKey.publicKeyUrl));
                Fluttertoast.showToast(msg: "Copied to clipboard");
              },
              child: Text("Copy Public Key URL")),
        if (privateKey.publicKeyUrl != null && kIsWeb) Text(""),
        ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: privateKey.publicKey));
              Fluttertoast.showToast(msg: "Copied to clipboard");
            },
            child: Text("Copy Public Key")),
      ],
    );
  }
}
