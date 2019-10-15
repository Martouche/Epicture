// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    url: json['url'] as String,
    bio: json['bio'] as String,
    avatar: json['avatar'] as String,
    reputation: json['reputation'] as int,
    reputationName: json['reputation_name'] as String,
    created: json['created'] as int,
    proExpiration: json['pro_expiration'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'bio': instance.bio,
      'avatar': instance.avatar,
      'reputation': instance.reputation,
      'reputation_name': instance.reputationName,
      'created': instance.created,
      'pro_expiration': instance.proExpiration,
    };
