/// Evaluation record for a student's daily progress
///
/// Represents a student's evaluation for a specific day, including
/// attendance status, memorization/revision progress, notes, and
/// audit metadata (created/updated timestamps and user IDs).
///
/// This is the main model for the evaluations collection in Firestore.
/// It includes embedded nested entities (MemorizationProgress, RevisionProgress,
/// EvaluationNote) and custom Firestore integration with read-time fallback.
///
/// Key Features:
/// - dayKey: Date in YYYY-MM-DD format for fast queries
/// - sessionType: Session type enum (daily, wednesday_review)
/// - audit fields: createdAt, createdBy, updatedAt, updatedBy
/// - embedded entities: memorization, revision, notes
/// - read-time fallback: dayKey and sessionType computed from date if missing
///
/// Example:
/// ```dart
/// final evaluation = Evaluation(
///   id: 'eval_123',
///   studentId: 'student_456',
///   classId: 'class_789',
///   date: DateTime(2026, 3, 2),
///   dayKey: '2026-03-02',
///   attendanceStatus: 'present',
///   sessionType: 'daily',
///   memorization: MemorizationProgress(
///     fromSurah: 1,
///     fromVerse: 1,
///     toSurah: 1,
///     toVerse: 7,
///     totalVerses: 7,
///   ),
///   createdAt: DateTime.now(),
///   createdBy: 'teacher_uid',
/// );
/// ```
library;

import 'dart:core';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:untitled/core/utils/firestore_converters.dart';
import 'package:untitled/core/models/memorization_progress.dart';
import 'package:untitled/core/models/revision_progress.dart';
import 'package:untitled/core/models/evaluation_note.dart';

part 'evaluation.freezed.dart';
part 'evaluation.g.dart';

@freezed
sealed class Evaluation with _$Evaluation {
  /// Creates an Evaluation instance
  ///
  /// [id]: Firestore document ID (unique per evaluation)
  /// [studentId]: Reference to student document
  /// [classId]: Reference to class document
  /// [date]: Evaluation date (timestamp)
  /// [dayKey]: Date in YYYY-MM-DD format for fast queries
  /// [attendanceStatus]: Attendance status (present, absent, excused)
  /// [sessionType]: Session type (daily, wednesday_review)
  /// [memorization]: Memorization progress (optional)
  /// [revision]: Revision progress (optional)
  /// [notes]: Teacher notes (optional list)
  /// [createdAt]: Record creation timestamp
  /// [createdBy]: UID of teacher who created record
  /// [updatedAt]: Last update timestamp (nullable)
  /// [updatedBy]: UID of teacher who last updated record (nullable)
  const factory Evaluation({
    required String id,
    required String studentId,
    required String classId,
    @TimestampJsonConverter() required DateTime date,
    required String dayKey,
    required String attendanceStatus,
    String? sessionType,
    MemorizationProgress? memorization,
    RevisionProgress? revision,
    List<EvaluationNote>? notes,
    @TimestampJsonConverter() required DateTime createdAt,
    required String createdBy,
    @NullableTimestampJsonConverter() DateTime? updatedAt,
    String? updatedBy,
  }) = _Evaluation;

  /// Creates a copy of Evaluation with optional fields modified
  const Evaluation._();

  /// Factory constructor for JSON deserialization
  factory Evaluation.fromJson(Map<String, dynamic> json) =>
      _$EvaluationFromJson(json);

  /// Factory constructor for Firestore deserialization (DocumentSnapshot)
  ///
  /// Includes read-time fallback logic for legacy records:
  /// - dayKey computed from date if missing
  /// - sessionType defaults to "daily" if missing
  factory Evaluation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Read-time fallback for dayKey
    final dayKey = data.containsKey('dayKey') && data['dayKey'] != null
        ? data['dayKey'] as String
        : DateFormat('yyyy-MM-dd').format(
            (data['date'] as Timestamp).toDate(),
          );

    // Read-time fallback for sessionType
    final sessionType = data.containsKey('sessionType') && data['sessionType'] != null
        ? data['sessionType'] as String
        : 'daily';

    // Deserialize nested entities if present
    MemorizationProgress? memorization;
    if (data.containsKey('memorization') && data['memorization'] != null) {
      memorization = MemorizationProgress.fromJson(
        data['memorization'] as Map<String, dynamic>,
      );
    }

    RevisionProgress? revision;
    if (data.containsKey('revision') && data['revision'] != null) {
      revision = RevisionProgress.fromJson(
        data['revision'] as Map<String, dynamic>,
      );
    }

    List<EvaluationNote>? notes;
    if (data.containsKey('notes') && data['notes'] != null) {
      final notesList = data['notes'] as List<dynamic>;
      notes = notesList
          .map((note) => EvaluationNote.fromJson(note as Map<String, dynamic>))
          .toList();
    }

    return Evaluation(
      id: doc.id,
      studentId: data['studentId'] as String,
      classId: data['classId'] as String,
      date: fromJson(data['date']),
      dayKey: dayKey,
      attendanceStatus: data['attendanceStatus'] as String,
      sessionType: sessionType,
      memorization: memorization,
      revision: revision,
      notes: notes,
      createdAt: fromJson(data['createdAt']),
      createdBy: data['createdBy'] as String,
      updatedAt: data.containsKey('updatedAt') && data['updatedAt'] != null
          ? fromJson(data['updatedAt'])
          : null,
      updatedBy: data['updatedBy'] as String?,
    );
  }

  /// Computes dayKey from date (YYYY-MM-DD format)
  ///
  /// Used for read-time fallback when dayKey is missing in legacy records.
  static String computeDayKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Creates a copy of Evaluation with dayKey computed from date
  Evaluation withComputedDayKey() {
    return copyWith(
      dayKey: computeDayKey(date),
    );
  }

  /// Creates a copy of Evaluation with sessionType defaulted to "daily" if null
  Evaluation withDefaultSessionType() {
    return copyWith(
      sessionType: sessionType ?? 'daily',
    );
  }

  /// Creates a copy of Evaluation with fields modified
  ///
  /// Sets updatedAt and updatedBy together (Business Rule BR-004)
  Evaluation copyWithUpdated({
    required String updatedBy,
    DateTime? updatedAt,
    MemorizationProgress? memorization,
    RevisionProgress? revision,
    List<EvaluationNote>? notes,
    String? attendanceStatus,
    String? sessionType,
  }) {
    return copyWith(
      updatedAt: updatedAt ?? DateTime.now(),
      updatedBy: updatedBy,
      memorization: memorization,
      revision: revision,
      notes: notes,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  /// Creates a copy of Evaluation with memorization progress
  Evaluation copyWithMemorization(MemorizationProgress? memorization) {
    return copyWith(
      memorization: memorization,
    );
  }

  /// Creates a copy of Evaluation with revision progress
  Evaluation copyWithRevision(RevisionProgress? revision) {
    return copyWith(
      revision: revision,
    );
  }

  /// Creates a copy of Evaluation with notes
  Evaluation copyWithNotes(List<EvaluationNote>? notes) {
    return copyWith(
      notes: notes,
    );
  }

  /// Creates a copy of Evaluation with attendance status
  Evaluation copyWithAttendanceStatus(String attendanceStatus) {
    return copyWith(
      attendanceStatus: attendanceStatus,
    );
  }
}
