/// Class reference model
///
/// Represents a class group in the Quran Madrasa system.
/// Used as a reference in Evaluation records.
///
/// This is a minimal model per Phase 1 scope (id and name only).
///
/// Example:
/// ```dart
/// final classObj = Class(
///   id: 'class_456',
///   name: 'Class A',
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'class.freezed.dart';
part 'class.g.dart';

@freezed
sealed class Class with _$Class {
  /// Creates a Class instance
  ///
  /// [id]: Unique class ID (Firestore document ID)
  /// [name]: Class name
  const factory Class({
    required String id,
    required String name,
  }) = _Class;

  /// Creates a copy of Class with optional fields modified
  const Class._();

  /// Factory constructor for JSON deserialization
  factory Class.fromJson(Map<String, dynamic> json) =>
      _$ClassFromJson(json);
}
