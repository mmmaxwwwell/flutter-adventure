import 'dart:core';
import 'package:adminclient/providers/settings/SettingsProviderValues.dart';

class ApplicationSettingsValues {
  String serverAddress;
  String clientId;
  String clientSecret;
  bool requireAuthOnLaunch;
  bool enableBiometrics;
  int sampleInt;
}

class ApplicationSettings extends SettingsProviderValues {
  String filename = "ApplicationSettings";

  Map<String, String> propertyMappings = {
    'Server Address': 'serverAddress',
    'Client ID': 'clientId',
    'Client Secret': 'clientSecret',
    'Require Authentication on Launch': 'requireAuthOnLaunch',
    'Enable Biometric Authentication': 'enableBiometrics',
    'sampleInt': 'sampleInt'
  };

  Map<String, Type> valueTypes = {
    'Server Address': String,
    'Client ID': String,
    'Client Secret': String,
    'Require Authentication on Launch': bool,
    'Enable Biometric Authentication': bool,
    'sampleInt': int
  };

  Map<String, dynamic> defaultValues = {
    "Server Address": "ws://localhost:8080",
    "Client ID": "ABC123",
    "Client Secret": "abcdef1234567890",
    'Require Authentication on Launch': false,
    'Enable Biometric Authentication': false,
    'sampleInt': 10
  };

  Map<String, String> valueDescription = {
    'Server Address': "Server that will act as a master hub",
    "Client ID": "Client ID for authentication",
    "Client Secret": "Client Secret for authentication",
    'Require Authentication on Launch':
        "Require password or biometric authentication when starting the app",
    'Enable Biometric Authentication':
        "If enabled, this will allow anyone with biometric access to this phone to authenticate. If disabled, a password will be required.",
    'sampleInt': "This is an example int."
  };
}
