import 'package:json_annotation/json_annotation.dart';
//run `flutter packages pub run build_runner build --delete-conflicting-outputs` to regenerate
part 'Client.g.dart';

@JsonSerializable(nullable: false)
class Client {
  Client({this.username, this.publicKey});
  final String username;
  final String publicKey;

  Map toJson() => _$ClientToJson(this);
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}
