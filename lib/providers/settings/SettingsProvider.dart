import 'package:adminclient/providers/settings/ApplicationSettings.dart';
import 'package:adminclient/providers/settings/SettingsProviderValues.dart';
import 'package:localstorage/localstorage.dart';

class SettingsProvider<T extends SettingsProviderValues> {
  ItemCreator<T> creator;
  LocalStorage storage;
  T settingsInfo;
  Future<bool> ready;
  bool init = false;

  SettingsProvider(String filename) {
    settingsInfo = creator();
    storage = new LocalStorage(filename);
    ready = storage.ready;
  }

  //callbacks to be used for triggering ui changes across consumers
  Map<Type, Function> callbacks = {};
  void registerCallback({Type sender, Function() callback}) {
    callbacks[sender] = callback;
  }

  void unregisterCallback(Type sender) {
    callbacks.remove(sender);
  }
}
