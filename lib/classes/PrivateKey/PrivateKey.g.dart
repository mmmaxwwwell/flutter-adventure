// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PrivateKey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateKey _$PrivateKeyFromJson(Map<String, dynamic> json) {
  return PrivateKey(
    name: json['name'] as String,
    email: json['email'] as String,
    passphrase: json['passphrase'] as String,
    confirmPassphrase: json['confirmPassphrase'] as String,
    bitWidth: json['bitWidth'] as int,
    uploadToKeyserver: json['uploadToKeyserver'] as bool,
  )
    ..privateKey = json['privateKey'] as String
    ..publicKey = json['publicKey'] as String
    ..publicKeyUrl = json['publicKeyUrl'] as String;
}

Map<String, dynamic> _$PrivateKeyToJson(PrivateKey instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'passphrase': instance.passphrase,
      'confirmPassphrase': instance.confirmPassphrase,
      'bitWidth': instance.bitWidth,
      'privateKey': instance.privateKey,
      'publicKey': instance.publicKey,
      'publicKeyUrl': instance.publicKeyUrl,
      'uploadToKeyserver': instance.uploadToKeyserver,
    };
