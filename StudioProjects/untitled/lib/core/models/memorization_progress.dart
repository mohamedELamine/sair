/// Memorization progress for a specific day
///
/// Represents a student's memorization progress with verse range
/// (fromSurah, fromVerse to toSurah, toVerse) and total verses.
///
/// This model is used within Evaluation to track daily memorization
/// progress for a student.
///
/// Example:
/// ```dart
/// final progress = MemorizationProgress(
///   fromSurah: 1,
///   fromVerse: 1,
///   toSurah: 1,
///   toVerse: 7,
///   totalVerses: 7,
/// );
/// ```
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'memorization_progress.freezed.dart';
part 'memorization_progress.g.dart';

@freezed
sealed class MemorizationProgress with _$MemorizationProgress {
  /// Creates a MemorizationProgress instance
  ///
  /// [fromSurah]: Starting surah number (1-114)
  /// [fromVerse]: Starting verse number within surah (1-999)
  /// [toSurah]: Ending surah number (1-114)
  /// [toVerse]: Ending verse number within surah (1-999)
  /// [totalVerses]: Total verses memorized (must equal toVerse - fromVerse + 1)
  const factory MemorizationProgress({
    required int fromSurah,
    required int fromVerse,
    required int toSurah,
    required int toVerse,
    required int totalVerses,
  }) = _MemorizationProgress;

  /// Private constructor for custom methods
  const MemorizationProgress._();

  /// Creates a MemorizationProgress for a single verse
  factory MemorizationProgress.singleVerse({
    required int surah,
    required int verse,
  }) {
    return MemorizationProgress(
      fromSurah: surah,
      fromVerse: verse,
      toSurah: surah,
      toVerse: verse,
      totalVerses: 1,
    );
  }

  /// Creates a MemorizationProgress for an entire surah
  factory MemorizationProgress.entireSurah({
    required int surah,
  }) {
    return MemorizationProgress(
      fromSurah: surah,
      fromVerse: 1,
      toSurah: surah,
      toVerse: 7, // Default to 7 for example
      totalVerses: 7,
    );
  }

  /// Factory constructor for JSON deserialization
  factory MemorizationProgress.fromJson(Map<String, dynamic> json) =>
      _$MemorizationProgressFromJson(json);

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
