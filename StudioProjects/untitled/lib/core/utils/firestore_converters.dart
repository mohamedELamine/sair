/// Firestore Timestamp converters for DateTime <-> Timestamp conversion
///
/// This file provides converter utilities for handling Firestore Timestamp
/// serialization with DateTime objects. It handles Timestamp, int milliseconds,
/// and ISO string formats for fromJson, and converts DateTime to Firestore Timestamp
/// for toJson operations.
///
/// Usage in Freezed models:
/// ```dart
/// @freezed
/// class Evaluation with _$Evaluation {
///   const factory Evaluation({
///     required DateTime date,
///     @TimestampConverter() required DateTime createdAt,
///     @NullableTimestampConverter() DateTime? updatedAt,
///   }) = _Evaluation;
/// }
/// ```
library;

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// JsonConverter for DateTime <-> Timestamp conversion (non-nullable)
///
/// Use this with @JsonKey annotation in Freezed models:
/// ```dart
/// @TimestampJsonConverter() required DateTime createdAt,
/// ```
class TimestampJsonConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampJsonConverter();

  @override
  DateTime fromJson(dynamic data) {
    if (data == null) {
      throw FormatException('Timestamp data is null');
    }

    // Handle Firestore Timestamp object
    if (data is Timestamp) {
      return data.toDate();
    }

    // Handle Unix milliseconds (int or double)
    if (data is int || data is double) {
      return DateTime.fromMillisecondsSinceEpoch(data.toInt());
    }

    // Handle ISO 8601 string (assume UTC)
    if (data is String) {
      return DateTime.parse(data);
    }

    throw FormatException(
      'Cannot convert $data to DateTime. Expected Timestamp, int milliseconds, or ISO string.',
    );
  }

  @override
  dynamic toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}

/// JsonConverter for DateTime <-> Timestamp conversion (nullable)
///
/// Use this with @JsonKey annotation in Freezed models:
/// ```dart
/// @NullableTimestampJsonConverter() DateTime? updatedAt,
/// ```
class NullableTimestampJsonConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampJsonConverter();

  @override
  DateTime? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    // Handle Firestore Timestamp object
    if (data is Timestamp) {
      return data.toDate();
    }

    // Handle Unix milliseconds (int or double)
    if (data is int || data is double) {
      return DateTime.fromMillisecondsSinceEpoch(data.toInt());
    }

    // Handle ISO 8601 string (assume UTC)
    if (data is String) {
      return DateTime.parse(data);
    }

    throw FormatException(
      'Cannot convert $data to DateTime. Expected Timestamp, int milliseconds, or ISO string.',
    );
  }

  @override
  dynamic toJson(DateTime? date) {
    if (date == null) {
      return null;
    }
    return Timestamp.fromDate(date);
  }
}

/// Converts Firestore Timestamp to DateTime
///
/// Handles three input formats:
/// 1. Firestore Timestamp (Timestamp object)
/// 2. Unix milliseconds (int)
/// 3. ISO 8601 string
///
/// Examples:
/// - Timestamp.fromDate(DateTime(2026, 1, 1)) → DateTime(2026, 1, 1)
/// - 1704067200000 → DateTime(2026, 1, 1)
/// - "2026-01-01T00:00:00Z" → DateTime(2026, 1, 1)
///
/// Throws:
/// - [FormatException] if input cannot be parsed as Timestamp or ISO string
DateTime fromJson(dynamic data) {
  if (data == null) {
    throw FormatException('Timestamp data is null');
  }

  // Handle Firestore Timestamp object
  if (data is Timestamp) {
    return data.toDate();
  }

  // Handle Unix milliseconds (int or double)
  if (data is int || data is double) {
    return DateTime.fromMillisecondsSinceEpoch(data.toInt());
  }

  // Handle ISO 8601 string (assume UTC)
  if (data is String) {
    return DateTime.parse(data);
  }

  throw FormatException(
    'Cannot convert $data to Timestamp. Expected Timestamp, int milliseconds, or ISO string.',
  );
}

/// Converts DateTime to Timestamp
///
/// Examples:
/// - DateTime(2026, 1, 1) → Timestamp.fromDate(DateTime(2026, 1, 1))
/// - DateTime.now() → Timestamp.now()
Timestamp toJson(DateTime date) {
  return Timestamp.fromDate(date);
}

/// TimestampConverter class for type-safe conversions
///
/// This class provides static methods for converting between DateTime and
/// different Timestamp representations.
class TimestampConverter {
  /// Create TimestampConverter from Firestore Timestamp object
  TimestampConverter.fromTimestamp(Timestamp timestamp)
      : _date = timestamp.toDate();

  /// Create TimestampConverter from Unix milliseconds
  TimestampConverter.fromMillis(int millis)
      : _date = DateTime.fromMillisecondsSinceEpoch(millis);

  /// Create TimestampConverter from ISO 8601 string
  TimestampConverter.fromIsoString(String isoString)
      : _date = DateTime.parse(isoString);

  /// The underlying DateTime value
  final DateTime _date;

  /// Convert to DateTime
  DateTime toDateTime() {
    return _date;
  }

  /// Convert to Timestamp
  Timestamp toTimestamp() {
    return Timestamp.fromDate(_date);
  }

  /// Convert to Unix milliseconds
  int toMillis() {
    return _date.millisecondsSinceEpoch;
  }

  /// Convert to ISO 8601 string (UTC)
  String toIsoString() {
    return _date.toUtc().toIso8601String();
  }

  @override
  String toString() {
    return 'TimestampConverter(${_date.toUtc().toIso8601String()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimestampConverter && other._date == _date;
  }

  @override
  int get hashCode => _date.hashCode;
}

/// Converts Firestore Timestamp to DateTime (nullable version)
///
/// Handles null input by returning null, otherwise delegates to fromJson().
///
/// Examples:
/// - null → null
/// - Timestamp → DateTime
/// - 1704067200000 → DateTime(2026, 1, 1)
/// - "2026-01-01T00:00:00Z" → DateTime(2026, 1, 1)
///
/// Throws:
/// - [FormatException] if non-null data cannot be parsed
DateTime? nullableFromJson(dynamic data) {
  if (data == null) {
    return null;
  }
  return fromJson(data);
}

/// Converts DateTime to Timestamp (nullable version)
///
/// Returns null if input DateTime is null, otherwise delegates to toJson().
///
/// Examples:
/// - null → null
/// - DateTime(2026, 1, 1) → Timestamp
Timestamp? nullableToJson(DateTime? date) {
  if (date == null) {
    return null;
  }
  return toJson(date);
}

/// NullableTimestampConverter class for type-safe nullable conversions
///
/// This class provides static methods for converting between nullable DateTime
/// and nullable Timestamp representations.
class NullableTimestampConverter {
  /// Create from Firestore Timestamp object
  NullableTimestampConverter.fromTimestamp(Timestamp timestamp)
      : _date = timestamp.toDate();

  /// Create from Unix milliseconds
  NullableTimestampConverter.fromMillis(int millis)
      : _date = DateTime.fromMillisecondsSinceEpoch(millis);

  /// Create from ISO 8601 string
  NullableTimestampConverter.fromIsoString(String isoString)
      : _date = DateTime.parse(isoString);

  final DateTime? _date;

  /// Convert to nullable DateTime
  DateTime? toDateTime() {
    return _date;
  }

  /// Convert to nullable Timestamp
  Timestamp? toTimestamp() {
    return _date != null ? Timestamp.fromDate(_date) : null;
  }

  /// Convert to nullable Unix milliseconds
  int? toMillis() {
    return _date?.millisecondsSinceEpoch;
  }

  /// Convert to nullable ISO 8601 string (UTC)
  String? toIsoString() {
    return _date?.toUtc().toIso8601String();
  }

  @override
  String toString() {
    return 'NullableTimestampConverter(${_date?.toUtc().toIso8601String() ?? "null"})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NullableTimestampConverter &&
        other._date == _date;
  }

  @override
  int get hashCode => _date?.hashCode ?? 0;
}
