abstract class SettingsProviderValues {
  String filename;
  Map<String, Type> valueTypes;
  Map<String, dynamic> defaultValues;
  Map<String, String> valueDescription;
}

typedef S ItemCreator<S>();
