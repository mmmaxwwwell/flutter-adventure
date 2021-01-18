import 'package:adminclient/classes/Client/Client.dart';
import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:openpgp/openpgp.dart';

abstract class ClientValidations {
  Future<List<String>> validationErrors(ModalAction<Client> subject) async {
    List<String> validationErrors = [];

    if (subject.value.username.isEmpty) {
      validationErrors.add("User Name cannot be empty");
    } else {
      RegExp emailRegex = RegExp(
          r"^[A-Za-z0-9\.\-\+\_]{1,}@[a-zA-z0-9\-\.]{1,253}\.[a-zA-z]{1,24}$");

      if (!emailRegex.hasMatch(subject.value.username)) {
        validationErrors.add("User Name must be an email address");
      }
    }

    if (subject.value.publicKey.isEmpty) {
      validationErrors.add("Public Key must not be blank");
    } else {
      RegExp regex = RegExp(
          r"^-----BEGIN PGP PUBLIC KEY BLOCK-----(?:\s|\S)*-----END PGP PUBLIC KEY BLOCK-----$",
          multiLine: true);

      if (!regex.hasMatch(subject.value.publicKey)) {
        validationErrors.add("Public Key is not formatted correctly");
      }

      try {
        await OpenPGP.encrypt("test", subject.value.publicKey);
      } catch (e) {
        validationErrors.add("Public Key is invalid");
      }
    }

    return Future<List<String>>.value(validationErrors);
  }
}
