import 'package:adminclient/util/Keyserver.dart';
import 'package:adminclient/classes/PrivateKey/PrivateKey.dart';
import 'package:adminclient/classes/PrivateKey/PrivateKeyValidations.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/model/bridge.pb.dart';
import 'package:openpgp/openpgp.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class AddPrivateKeyForm extends StatefulWidget
    with PrivateKeyValidations
    implements ModalForm<ModalAction<PrivateKey>> {
  final state = _AddPrivateKeyFormState();

  @override
  _AddPrivateKeyFormState createState() => state;

  String title = "Create Private Key";
  String acceptText = "Create";
  bool showDelete = false;
  bool showCancel = true;
  String name() {
    return state.nameController.text;
  }

  String initialName() {
    return "";
  }

  @override
  ModalAction<PrivateKey> data([bool destroy = false]) {
    return ModalAction<PrivateKey>(
        value: PrivateKey(
            name: state.nameController.text,
            email: state.emailController.text,
            passphrase: state.passphraseController.text,
            confirmPassphrase: state.passphraseConfirmController.text,
            bitWidth: state.bitWidth,
            uploadToKeyserver: state.uploadToKeyserver && !kIsWeb),
        actionType: ActionType.create);
  }

  @override
  Future<ModalAction<PrivateKey>> postProcess(
      ModalAction<PrivateKey> subject) async {
    var keyOptions = KeyOptions()
      ..rsaBits = subject.value.bitWidth
      ..cipher = Cipher.CIPHER_AES256;
    var keyPair = await OpenPGP.generate(
        options: Options()
          ..name = subject.value.name
          ..email = subject.value.email
          ..passphrase = subject.value.passphrase
          ..keyOptions = keyOptions);
    subject.value.passphrase = "";
    subject.value.confirmPassphrase = "";
    subject.value.privateKey = keyPair.privateKey;
    subject.value.publicKey = keyPair.publicKey;

    if (!kIsWeb && subject.value.uploadToKeyserver) {
      subject.value.publicKeyUrl =
          await Keyserver.upload(subject.value.publicKey);
    }

    return Future.value(subject);
  }
}

class _AddPrivateKeyFormState extends State<AddPrivateKeyForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passphraseController = TextEditingController();
  TextEditingController passphraseConfirmController = TextEditingController();
  int bitWidth = 2048;
  bool uploadToKeyserver = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passphraseController.dispose();
    passphraseConfirmController.dispose();
    super.dispose();
  }

  List<int> bitWidths = [2048, 3072, 4096, 5120, 6144, 7168, 8192];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        TextField(
            decoration: InputDecoration(hintText: "Name"),
            controller: nameController),
        TextField(
            decoration: InputDecoration(hintText: "Email"),
            controller: emailController),
        TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Passphrase",
            ),
            controller: passphraseController),
        TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Confirm Passphrase"),
            controller: passphraseConfirmController),
        Row(
          children: [
            Text("Strength: "),
            DropdownButton(
              value: bitWidth,
              items: bitWidths.map((int value) {
                return new DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (int value) {
                setState(() {
                  bitWidth = value;
                });
              },
            )
          ],
        ),
        if (!kIsWeb)
          Row(
            children: [
              Text("Upload to keyserver: "),
              Checkbox(
                  value: uploadToKeyserver,
                  onChanged: (value) {
                    setState(() {
                      uploadToKeyserver = value;
                    });
                  })
            ],
          )
      ],
    );
  }
}
