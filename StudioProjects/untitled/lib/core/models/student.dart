/// Student reference model
///
/// Represents a student in the Quran Madrasa system.
/// Used as a reference in Evaluation records.
///
/// This is a minimal model per Phase 1 scope (id and name only).
///
/// Example:
/// ```dart
/// final student = Student(
///   id: 'student_123',
///   name: 'Ahmed',
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
sealed class Student with _$Student {
  /// Creates a Student instance
  ///
  /// [id]: Unique student ID (Firestore document ID)
  /// [name]: Student's name
  const factory Student({
    required String id,
    required String name,
  }) = _Student;

  /// Creates a copy of Student with optional fields modified
  const Student._();

  /// Factory constructor for JSON deserialization
  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
