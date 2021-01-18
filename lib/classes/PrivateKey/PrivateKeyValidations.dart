import 'package:adminclient/classes/PrivateKey/PrivateKey.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';

abstract class PrivateKeyValidations {
  Future<List<String>> validationErrors(ModalAction<PrivateKey> subject) async {
    List<String> validationErrors = [];

    if (subject.value.name.isEmpty) {
      validationErrors.add("Name must not be empty.");
    }

    if (subject.value.email.isEmpty) {
      validationErrors.add("Email must not be empty.");
    } else {
      RegExp emailRegex = RegExp(
          r"^[A-Za-z0-9\.\-\+\_]{1,}@[a-zA-z0-9\-\.]{1,253}\.[a-zA-z]{1,24}$");
      if (!emailRegex.hasMatch(subject.value.email)) {
        validationErrors.add("Email must be in user@domain.tld format.");
      }
    }

    if (subject.value.passphrase.isEmpty ||
        subject.value.confirmPassphrase.isEmpty) {
      validationErrors
          .add("Passphrase and Confirm Passsphrase must not be empty.");
    } else {
      if (subject.value.passphrase.length < 8) {
        validationErrors.add("Passphrase must be 8 characters or longer");
      }

      if (subject.value.passphrase != subject.value.confirmPassphrase) {
        validationErrors.add("Passphrase and Confirm Passphrase must match.");
      }
    }

    return Future<List<String>>.value(validationErrors);
  }
}
