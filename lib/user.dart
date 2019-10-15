import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String url;
  String bio;
  String avatar;
  int reputation;
  @JsonKey(name: 'reputation_name')
  String reputationName;
  int created;
  @JsonKey(name: 'pro_expiration')
  bool proExpiration;

  User({this.id, this.url, this.bio, this.avatar, this.reputation, this.reputationName, this.created, this.proExpiration});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}