// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) {
  return Client(
    username: json['username'] as String,
    publicKey: json['publicKey'] as String,
  );
}

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'username': instance.username,
      'publicKey': instance.publicKey,
    };
