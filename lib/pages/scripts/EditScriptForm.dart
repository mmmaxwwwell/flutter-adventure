import 'package:adminclient/classes/Script/Script.dart';
import 'package:adminclient/classes/Script/ScriptValidations.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class EditScriptForm extends StatefulWidget
    with ScriptValidations
    implements ModalForm<ModalAction<Script>> {
  _EditScriptFormState state;

  @override
  _EditScriptFormState createState() => state;

  String title = "Edit Script";
  final String acceptText = "Save";
  final bool showDelete = true;
  final bool showCancel = true;
  String name() {
    return state.nameController.text;
  }

  String initialName() {
    return state.nameController.text;
  }

  EditScriptForm(Script script, int index) {
    state = _EditScriptFormState(script, index);
  }

  @override
  ModalAction<Script> data([bool destroy = false]) {
    return ModalAction<Script>(
        value: Script(
            name: state.nameController.text, body: state.bodyController.text),
        index: state.index,
        actionType: destroy ? ActionType.destroy : ActionType.update);
  }

  @override
  Future<ModalAction<Script>> postProcess(ModalAction<Script> subject) {
    return Future.value(subject);
  }
}

class _EditScriptFormState extends State<EditScriptForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  int index;
  @override
  void initState() {
    super.initState();
  }

  _EditScriptFormState(Script script, int index) {
    this.nameController.text = script.name;
    this.bodyController.text = script.body;
    this.index = index;
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
          controller: nameController,
          decoration: InputDecoration(hintText: 'Name'),
        ),
        TextField(
          controller: bodyController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: 'Script Body'),
        ),
      ],
    );
  }
}
