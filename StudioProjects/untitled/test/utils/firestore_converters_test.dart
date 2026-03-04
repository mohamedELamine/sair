/// Unit tests for Firestore Timestamp converters
///
/// Tests cover all conversion scenarios:
/// - TimestampConverter: Timestamp object, int milliseconds, ISO string
/// - NullableTimestampConverter: null handling, non-null conversions
/// - Edge cases: invalid formats, edge dates
library;

import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/core/utils/firestore_converters.dart';

void main() {
  group('TimestampConverter', () {
    final testDate = DateTime(2026, 3, 2, 12, 0, 0);

    group('fromJson', () {
      test('converts Firestore Timestamp object', () {
        final timestamp = Timestamp.fromDate(testDate);
        final result = fromJson(timestamp);

        expect(result, equals(testDate));
      });

      test('converts Unix milliseconds (int)', () {
        final millis = 1704067200000;
        final result = fromJson(millis);

        expect(result.millisecondsSinceEpoch, equals(millis));
      });

      test('converts Unix milliseconds (double)', () {
        final millis = 1704067200000.toDouble();
        final result = fromJson(millis);

        expect(result.millisecondsSinceEpoch, equals(millis.toInt()));
      });

      test('converts ISO 8601 string', () {
        final isoString = '2026-03-02T12:00:00.000Z';
        final result = fromJson(isoString);

        expect(result.millisecondsSinceEpoch, equals(1772449200000));
      });

      test('throws FormatException for null', () {
        expect(
          () => fromJson(null),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException for invalid format', () {
        expect(
          () => fromJson('invalid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException for string date format', () {
        expect(
          () => fromJson('03/02/2026'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('toJson', () {
      test('converts DateTime to Timestamp', () {
        final timestamp = toJson(testDate);
        expect(timestamp.toDate().millisecondsSinceEpoch, equals(testDate.millisecondsSinceEpoch));
      });

      test('handles current time', () {
        final now = DateTime.now();
        final timestamp = toJson(now);
        expect(timestamp.toDate().millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
      });

      test('handles epoch time', () {
        final epoch = DateTime(1970, 1, 1);
        final timestamp = toJson(epoch);
        expect(timestamp.toDate().millisecondsSinceEpoch, equals(epoch.millisecondsSinceEpoch));
      });
    });

    group('TimestampConverter methods', () {
      test('fromTimestamp creates correct converter', () {
        final timestamp = Timestamp.fromDate(testDate);
        final converter = TimestampConverter.fromTimestamp(timestamp);

        expect(converter.toDateTime().millisecondsSinceEpoch, equals(testDate.millisecondsSinceEpoch));
        expect(converter.toTimestamp().toDate().millisecondsSinceEpoch, equals(testDate.millisecondsSinceEpoch));
        expect(converter.toMillis(), equals(testDate.millisecondsSinceEpoch));
        expect(converter.toIsoString(), equals(testDate.toUtc().toIso8601String()));
      });

      test('fromMillis creates correct converter', () {
        final millis = 1704067200000;
        final converter = TimestampConverter.fromMillis(millis);

        expect(converter.toDateTime().millisecondsSinceEpoch, equals(millis));
        expect(converter.toTimestamp().toDate().millisecondsSinceEpoch, equals(millis));
        expect(converter.toMillis(), equals(millis));
        expect(converter.toIsoString(), equals(DateTime.fromMillisecondsSinceEpoch(millis).toUtc().toIso8601String()));
      });

      test('fromIsoString creates correct converter', () {
        final isoString = '2026-03-02T12:00:00.000Z';
        final converter = TimestampConverter.fromIsoString(isoString);

        expect(converter.toDateTime().millisecondsSinceEpoch, equals(1772449200000));
        expect(converter.toTimestamp().toDate().millisecondsSinceEpoch, equals(1772449200000));
        expect(converter.toMillis(), equals(1772449200000));
        expect(converter.toIsoString(), equals('2026-03-02T12:00:00.000Z'));
      });

      test('toDateTime returns underlying date', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        expect(converter.toDateTime().millisecondsSinceEpoch, equals(1704067200000));
      });

      test('toTimestamp converts to Timestamp', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        final timestamp = converter.toTimestamp();

        expect(timestamp, isNotNull);
        expect(timestamp.toDate().millisecondsSinceEpoch, equals(1704067200000));
      });

      test('toMillis returns Unix milliseconds', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        expect(converter.toMillis(), equals(1704067200000));
      });

      test('toIsoString returns ISO 8601 format', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        expect(converter.toIsoString(), equals(DateTime.fromMillisecondsSinceEpoch(1704067200000).toUtc().toIso8601String()));
      });

      test('equals compares dates', () {
        final converter1 = TimestampConverter.fromMillis(1704067200000);
        final converter2 = TimestampConverter.fromMillis(1704067200000);
        final converter3 = TimestampConverter.fromMillis(1704067200001);

        expect(converter1, equals(converter2));
        expect(converter1, isNot(equals(converter3)));
      });

      test('hashCode generates correct hash', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        final otherConverter = TimestampConverter.fromMillis(1704067200000);

        expect(converter.hashCode, equals(otherConverter.hashCode));
      });

      test('toString returns readable format', () {
        final converter = TimestampConverter.fromMillis(1704067200000);
        expect(converter.toString(), contains('TimestampConverter'));
        expect(converter.toString(), contains('1704067200000'));
      });
    });

    group('Edge Cases', () {
      test('handles year 9999', () {
        final date = DateTime(9999, 12, 31);
        final timestamp = toJson(date);
        final result = fromJson(timestamp);
        expect(result, equals(date));
      });

      test('handles leap day', () {
        final date = DateTime(2024, 2, 29);
        final timestamp = toJson(date);
        final result = fromJson(timestamp);
        expect(result, equals(date));
      });

      test('handles noon time', () {
        final date = DateTime(2026, 3, 2, 12, 0, 0, 0);
        final timestamp = toJson(date);
        final result = fromJson(timestamp);
        expect(result, equals(date));
      });

      test('handles midnight time', () {
        final date = DateTime(2026, 3, 2, 0, 0, 0, 0);
        final timestamp = toJson(date);
        final result = fromJson(timestamp);
        expect(result, equals(date));
      });
    });
  });

  group('NullableTimestampConverter', () {
    final testDate = DateTime(2026, 3, 2, 12, 0, 0);

    group('nullableFromJson', () {
      test('returns null for null input', () {
        final result = nullableFromJson(null);
        expect(result, isNull);
      });

      test('converts Timestamp object', () {
        final timestamp = Timestamp.fromDate(testDate);
        final result = nullableFromJson(timestamp);
        expect(result, equals(testDate));
      });

      test('converts Unix milliseconds', () {
        final result = nullableFromJson(testDate.millisecondsSinceEpoch);
        expect(result, equals(testDate));
      });

      test('converts ISO string', () {
        final result = nullableFromJson(testDate.toIso8601String());
        expect(result, equals(testDate));
      });

      test('throws FormatException for invalid non-null input', () {
        expect(
          () => nullableFromJson('invalid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('nullableToJson', () {
      test('returns null for null input', () {
        final result = nullableToJson(null);
        expect(result, isNull);
      });

      test('converts DateTime to Timestamp', () {
        final result = nullableToJson(testDate);
        expect(result, isNotNull);
        expect(result?.toDate().millisecondsSinceEpoch, equals(testDate.millisecondsSinceEpoch));
      });

      test('converts current time', () {
        final now = DateTime.now();
        final result = nullableToJson(now);
        expect(result, isNotNull);
        expect(result?.toDate().millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
      });
    });

    group('NullableTimestampConverter class', () {
      test('fromTimestamp creates converter with date', () {
        final timestamp = Timestamp.fromDate(testDate);
        final converter = NullableTimestampConverter.fromTimestamp(timestamp);

        expect(converter.toDateTime(), equals(testDate));
        expect(converter.toTimestamp(), equals(timestamp));
        expect(converter.toMillis(), equals(testDate.millisecondsSinceEpoch));
      });

      test('fromMillis creates converter with milliseconds', () {
        final millis = 1704067200000;
        final converter = NullableTimestampConverter.fromMillis(millis);

        expect(converter.toMillis(), equals(millis));
        expect(converter.toDateTime()?.millisecondsSinceEpoch, equals(millis));
        expect(converter.toTimestamp()?.toDate().millisecondsSinceEpoch, equals(millis));
      });

      test('fromIsoString creates converter from string', () {
        final isoString = '2026-03-02T12:00:00.000Z';
        final converter = NullableTimestampConverter.fromIsoString(isoString);

        expect(converter.toIsoString(), equals(isoString));
        expect(converter.toMillis(), equals(1772449200000));
      });

      test('toDateTime returns nullable DateTime', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.toDateTime(), isNotNull);
        expect(converter.toDateTime()?.millisecondsSinceEpoch, equals(1704067200000));
      });

      test('toTimestamp returns nullable Timestamp', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        final timestamp = converter.toTimestamp();
        expect(timestamp, isNotNull);
        expect(timestamp?.toDate().millisecondsSinceEpoch, equals(1704067200000));
      });

      test('toMillis returns nullable milliseconds', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.toMillis(), equals(1704067200000));
      });

      test('toIsoString returns nullable ISO string', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.toIsoString(), equals(DateTime.fromMillisecondsSinceEpoch(1704067200000).toUtc().toIso8601String()));
      });

      test('equals compares dates', () {
        final converter1 = NullableTimestampConverter.fromMillis(1704067200000);
        final converter2 = NullableTimestampConverter.fromMillis(1704067200000);
        final converter3 = NullableTimestampConverter.fromMillis(1704067200001);

        expect(converter1, equals(converter2));
        expect(converter1, isNot(equals(converter3)));
      });

      test('hashCode generates correct hash for date', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        final otherConverter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.hashCode, equals(otherConverter.hashCode));
      });

      test('toString returns readable format', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.toString(), contains('NullableTimestampConverter'));
        expect(converter.toString(), contains('1704067200000'));
      });
    });

    group('Edge Cases', () {
      test('handles null values correctly', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter.toDateTime()?.millisecondsSinceEpoch, equals(1704067200000));
        expect(converter.toMillis(), equals(1704067200000));
        expect(converter.toIsoString(), equals(DateTime.fromMillisecondsSinceEpoch(1704067200000).toUtc().toIso8601String()));
      });

      test('equals null converter', () {
        final converter = NullableTimestampConverter.fromMillis(1704067200000);
        final otherConverter = NullableTimestampConverter.fromMillis(1704067200000);
        expect(converter, equals(otherConverter));
      });
    });
  });
}
