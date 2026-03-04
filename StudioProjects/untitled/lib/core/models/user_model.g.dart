// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  role: json['role'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  madrasaId: json['madrasaId'] as String,
  active: json['active'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'email': instance.email,
      'phone': instance.phone,
      'madrasaId': instance.madrasaId,
      'active': instance.active,
      'createdAt': instance.createdAt.toIso8601String(),
    };
