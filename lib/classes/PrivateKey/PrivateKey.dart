import 'package:json_annotation/json_annotation.dart';
//run `flutter packages pub run build_runner build --delete-conflicting-outputs` to regenerate
part 'PrivateKey.g.dart';

@JsonSerializable(nullable: false)
class PrivateKey {
  PrivateKey(
      {this.name,
      this.email,
      this.passphrase,
      this.confirmPassphrase,
      this.bitWidth,
      this.uploadToKeyserver,
      this.publicKeyUrl,
      this.publicKey,
      this.privateKey});
  String name;
  String email;
  String passphrase;
  String confirmPassphrase;
  int bitWidth;
  String privateKey;
  String publicKey;
  String publicKeyUrl;
  bool uploadToKeyserver;

  Map toJson() => _$PrivateKeyToJson(this);
  factory PrivateKey.fromJson(Map<String, dynamic> json) =>
      _$PrivateKeyFromJson(json);
}
