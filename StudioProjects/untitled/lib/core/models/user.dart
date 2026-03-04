/// User reference model
///
/// Represents a user in the Quran Madrasa system (teachers, administrators).
/// Used as a reference in Evaluation records (createdBy, updatedBy).
///
/// This is a minimal model per Phase 1 scope (id only).
///
/// Example:
/// ```dart
/// final user = User(
///   id: 'teacher_789',
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class User with _$User {
  /// Creates a User instance
  ///
  /// [id]: User ID (Firebase Auth UID for teachers/admins)
  const factory User({
    required String id,
  }) = _User;

  /// Creates a copy of User with optional fields modified
  const User._();

  /// Factory constructor for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
