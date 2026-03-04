/// Revision progress for a specific day
///
/// Represents a student's revision progress with verse range
/// (fromSurah, fromVerse to toSurah, toVerse) and total verses.
///
/// This model is used within Evaluation to track daily revision progress
/// for a student. It has the same structure as MemorizationProgress
/// for consistency.
///
/// Example:
/// ```dart
/// final progress = RevisionProgress(
///   fromSurah: 1,
///   fromVerse: 1,
///   toSurah: 1,
///   toVerse: 7,
///   totalVerses: 7,
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'revision_progress.freezed.dart';
part 'revision_progress.g.dart';

@freezed
sealed class RevisionProgress with _$RevisionProgress {
  /// Creates a RevisionProgress instance
  ///
  /// [fromSurah]: Starting surah number (1-114)
  /// [fromVerse]: Starting verse number within surah (1-999)
  /// [toSurah]: Ending surah number (1-114)
  /// [toVerse]: Ending verse number within surah (1-999)
  /// [totalVerses]: Total verses revised (must equal toVerse - fromVerse + 1)
  const factory RevisionProgress({
    required int fromSurah,
    required int fromVerse,
    required int toSurah,
    required int toVerse,
    required int totalVerses,
  }) = _RevisionProgress;

  /// Creates a copy of RevisionProgress with optional fields modified
  const RevisionProgress._();

  /// Creates a RevisionProgress for a single verse
  factory RevisionProgress.singleVerse({
    required int surah,
    required int verse,
  }) {
    return RevisionProgress(
      fromSurah: surah,
      fromVerse: verse,
      toSurah: surah,
      toVerse: verse,
      totalVerses: 1,
    );
  }

  /// Creates a RevisionProgress for an entire surah
  factory RevisionProgress.entireSurah({
    required int surah,
  }) {
    return RevisionProgress(
      fromSurah: surah,
      fromVerse: 1,
      toSurah: surah,
      toVerse: 7, // Default to 7 for example
      totalVerses: 7,
    );
  }

  /// Factory constructor for JSON deserialization
  factory RevisionProgress.fromJson(Map<String, dynamic> json) =>
      _$RevisionProgressFromJson(json);

  /// Checks if this progress covers a specific verse
  bool coversVerse(int surah, int verse) {
    return fromSurah == surah && fromVerse <= verse && toVerse >= verse;
  }

  /// Checks if this progress covers a specific surah
  bool coversSurah(int surah) {
    return fromSurah <= surah && toSurah >= surah;
  }

  /// Checks if this progress covers a date range
  bool coversDateRange(DateTime startDate, DateTime endDate) {
    final thisDate = DateTime(fromSurah, fromVerse, 1);
    final rangeDate = DateTime(toSurah, toVerse, 1);
    return !thisDate.isAfter(endDate) && !rangeDate.isBefore(startDate);
  }
}
