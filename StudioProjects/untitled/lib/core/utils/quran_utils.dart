import 'dart:convert';
import 'package:flutter/services.dart';

/// Represents a Surah (chapter) of the Quran
class Surah {
  final int number;
  final String name;
  final String nameEn;
  final int verses;

  Surah({
    required this.number,
    required this.name,
    required this.nameEn,
    required this.verses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      verses: json['verses'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'nameEn': nameEn,
      'verses': verses,
    };
  }
}

/// QuranData provides utility functions for Quran metadata operations
///
/// This class loads Quran metadata from assets and provides methods to query
/// surah information and calculate verse ranges.
class QuranData {
  static List<Surah>? _surahs;
  static const String _assetPath = 'assets/quran_metadata.json';

  /// Initialize QuranData by loading metadata from assets
  ///
  /// Must be called before any other methods. Throws an exception if
  /// the asset cannot be loaded or parsed.
  static Future<void> initialize() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> json = jsonDecode(jsonString);

      if (json.containsKey('surahs') && json['surahs'] is List) {
        _surahs = (json['surahs'] as List)
            .map((e) => Surah.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid Quran metadata format: missing "surahs" key');
      }
    } catch (e) {
      throw Exception('Failed to load Quran metadata: $e');
    }
  }

  /// Get all 114 surahs
  ///
  /// Throws an exception if [initialize] has not been called.
  static List<Surah> getSurahs() {
    if (_surahs == null) {
      throw Exception('QuranData not initialized. Call initialize() first.');
    }
    return List.unmodifiable(_surahs!);
  }

  /// Get the verse count for a specific surah
  ///
  /// [surahNumber] must be between 1 and 114.
  /// Returns the number of verses in the specified surah.
  /// Throws an exception if surah number is invalid or QuranData not initialized.
  static int getVerseCount(int surahNumber) {
    if (_surahs == null) {
      throw Exception('QuranData not initialized. Call initialize() first.');
    }

    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception('Invalid surah number: $surahNumber. Must be between 1 and 114.');
    }

    // Surah numbers are 1-indexed, list is 0-indexed
    return _surahs![surahNumber - 1].verses;
  }

  /// Calculate the total number of verses in a range
  ///
  /// Parameters:
  /// - [fromSurah]: Starting surah number (1-114)
  /// - [fromVerse]: Starting verse number in the fromSurah
  /// - [toSurah]: Ending surah number (1-114)
  /// - [toVerse]: Ending verse number in the toSurah
  ///
  /// Returns the total count of verses in the specified range.
  /// Throws an exception if the range is invalid or QuranData not initialized.
  static int calculateTotalVerses({
    required int fromSurah,
    required int fromVerse,
    required int toSurah,
    required int toVerse,
  }) {
    if (!isValidRange(
      fromSurah: fromSurah,
      fromVerse: fromVerse,
      toSurah: toSurah,
      toVerse: toVerse,
    )) {
      throw Exception('Invalid verse range: $fromSurah:$fromVerse to $toSurah:$toVerse');
    }

    int total = 0;

    // Same surah case
    if (fromSurah == toSurah) {
      total = toVerse - fromVerse + 1;
    } else {
      // Partial first surah
      total += getVerseCount(fromSurah) - fromVerse + 1;

      // Full surahs in between
      for (int i = fromSurah + 1; i < toSurah; i++) {
        total += getVerseCount(i);
      }

      // Partial last surah
      total += toVerse;
    }

    return total;
  }

  /// Validate if a verse range is valid
  ///
  /// Parameters:
  /// - [fromSurah]: Starting surah number (1-114)
  /// - [fromVerse]: Starting verse number in the fromSurah
  /// - [toSurah]: Ending surah number (1-114)
  /// - [toVerse]: Ending verse number in the toSurah
  ///
  /// Returns true if the range is valid, false otherwise.
  /// A range is valid if:
  /// - All surah numbers are between 1 and 114
  /// - Verse numbers are >= 1
  /// - Verse numbers do not exceed the verse count of their respective surahs
  /// - fromSurah <= toSurah
  /// - If fromSurah == toSurah, then fromVerse <= toVerse
  static bool isValidRange({
    required int fromSurah,
    required int fromVerse,
    required int toSurah,
    required int toVerse,
  }) {
    if (_surahs == null) {
      return false;
    }

    // Validate surah numbers
    if (fromSurah < 1 || fromSurah > 114 || toSurah < 1 || toSurah > 114) {
      return false;
    }

    // Validate verse numbers are positive
    if (fromVerse < 1 || toVerse < 1) {
      return false;
    }

    // Validate verse numbers don't exceed surah verse counts
    if (fromVerse > getVerseCount(fromSurah) || toVerse > getVerseCount(toSurah)) {
      return false;
    }

    // Validate fromSurah <= toSurah
    if (fromSurah > toSurah) {
      return false;
    }

    // If same surah, validate fromVerse <= toVerse
    if (fromSurah == toSurah && fromVerse > toVerse) {
      return false;
    }

    return true;
  }
}
