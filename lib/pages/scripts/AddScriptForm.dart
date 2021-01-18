import 'package:adminclient/classes/Script/Script.dart';
import 'package:adminclient/classes/Script/ScriptValidations.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddScriptForm extends StatefulWidget
    with ScriptValidations
    implements ModalForm<ModalAction<Script>> {
  final state = _AddScriptFormState();

  @override
  _AddScriptFormState createState() => state;

  String title = "Create Script";
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
  ModalAction<Script> data([bool destroy = false]) {
    return ModalAction<Script>(
        value: Script(
            name: state.nameController.text, body: state.bodyController.text),
        actionType: ActionType.create);
  }

  @override
  Future<ModalAction<Script>> postProcess(ModalAction<Script> subject) async {
    return Future.value(subject);
  }
}

class _AddScriptFormState extends State<AddScriptForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        TextField(
            decoration: InputDecoration(hintText: "Name"),
            controller: nameController),
        TextField(
            decoration: InputDecoration(hintText: "Body"),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: bodyController),
      ],
    );
  }
}
