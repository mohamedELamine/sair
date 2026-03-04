import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing a user in the system
///
/// Contains authentication and profile information including role-based access control
@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String role,
    required String email,
    required String phone,
    required String madrasaId,
    required bool active,
    required DateTime createdAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
