import 'package:adminclient/classes/Client/Client.dart';
import 'package:adminclient/classes/Client/ClientValidations.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditClientForm extends StatefulWidget
    with ClientValidations
    implements ModalForm<ModalAction<Client>> {
  _EditClientFormState state;

  @override
  _EditClientFormState createState() => state;

  String title = "Edit Client";
  final String acceptText = "Save";
  final bool showDelete = true;
  final bool showCancel = true;
  String name() {
    return state.usernameController.text;
  }

  String initialName() {
    return state.initialName;
  }

  EditClientForm(Client client, int index) {
    state = _EditClientFormState(client, index);
  }

  @override
  ModalAction<Client> data([bool destroy = false]) {
    return ModalAction<Client>(
        value: Client(
            publicKey: state.publicKeyController.text,
            username: state.usernameController.text),
        index: state.index,
        actionType: destroy ? ActionType.destroy : ActionType.update);
  }

  @override
  Future<ModalAction<Client>> postProcess(ModalAction<Client> subject) {
    return Future.value(subject);
  }
}

class _EditClientFormState extends State<EditClientForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();
  int index;
  String initialName;
  @override
  void initState() {
    super.initState();
  }

  _EditClientFormState(Client client, int index) {
    usernameController.text = client.username;
    publicKeyController.text = client.publicKey;
    this.index = index;
    this.initialName = client.username;
  }

  @override
  void dispose() {
    publicKeyController.dispose();
    usernameController.dispose();
    super.dispose();
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
          controller: publicKeyController,
        )
      ],
    );
  }
}
