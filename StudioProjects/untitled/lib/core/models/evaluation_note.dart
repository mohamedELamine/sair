/// Evaluation note for a specific day
///
/// Represents a teacher's note for a specific evaluation.
/// Notes can be for behavior, progress, reminders, or other observations.
///
/// This model is used within Evaluation to store teacher notes with
/// timestamp and note type information.
///
/// Example:
/// ```dart
/// final note = EvaluationNote(
///   type: 'behavior',
///   text: 'Good focus today',
///   createdAt: DateTime.now(),
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:untitled/core/utils/firestore_converters.dart';

part 'evaluation_note.freezed.dart';
part 'evaluation_note.g.dart';

@freezed
sealed class EvaluationNote with _$EvaluationNote {
  /// Creates an EvaluationNote instance
  ///
  /// [type]: Type of note (behavior, progress, reminder, other)
  /// [text]: Note text content
  /// [createdAt]: When the note was created
  const factory EvaluationNote({
    required String type,
    required String text,
    @TimestampJsonConverter() required DateTime createdAt,
  }) = _EvaluationNote;

  /// Creates a copy of EvaluationNote with optional fields modified
  const EvaluationNote._();

  /// Factory constructor for JSON deserialization
  factory EvaluationNote.fromJson(Map<String, dynamic> json) =>
      _$EvaluationNoteFromJson(json);

  /// Creates a behavior note
  factory EvaluationNote.behavior(String text, {DateTime? createdAt}) =>
      EvaluationNote(
        type: 'behavior',
        text: text,
        createdAt: createdAt ?? DateTime.now(),
      );

  /// Creates a progress note
  factory EvaluationNote.progress(String text, {DateTime? createdAt}) =>
      EvaluationNote(
        type: 'progress',
        text: text,
        createdAt: createdAt ?? DateTime.now(),
      );

  /// Creates a reminder note
  factory EvaluationNote.reminder(String text, {DateTime? createdAt}) =>
      EvaluationNote(
        type: 'reminder',
        text: text,
        createdAt: createdAt ?? DateTime.now(),
      );
}
