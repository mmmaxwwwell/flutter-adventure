import 'package:adminclient/classes/Script/Script.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';

abstract class ScriptValidations {
  Future<List<String>> validationErrors(ModalAction<Script> subject) async {
    List<String> validationErrors = [];

    if (subject.value.name.isEmpty) {
      validationErrors.add("Name cannot be empty.");
    }

    if (subject.value.body.isEmpty) {
      validationErrors.add("Body must not be blank.");
    }

    return Future<List<String>>.value(validationErrors);
  }
}
