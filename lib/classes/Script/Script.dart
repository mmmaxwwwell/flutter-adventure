import 'package:json_annotation/json_annotation.dart';
//run `flutter packages pub run build_runner build --delete-conflicting-outputs` to regenerate
part 'Script.g.dart';

@JsonSerializable(nullable: false)
class Script {
  Script({this.name, this.body});
  String name;
  String body;

  Map toJson() => _$ScriptToJson(this);
  factory Script.fromJson(Map<String, dynamic> json) => _$ScriptFromJson(json);
}
