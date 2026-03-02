import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/utils/date_utils.dart';

void main() {
  group('DateUtils Tests', () {
    group('dayKey', () {
      test('dayKey formats 2026-01-01 correctly', () {
        final date = DateTime(2026, 1, 1);
        final result = dayKey(date);
        expect(result, '2026-01-01');
      });

      test('dayKey formats 2026-12-31 correctly', () {
        final date = DateTime(2026, 12, 31);
        final result = dayKey(date);
        expect(result, '2026-12-31');
      });

      test('dayKey handles leap year (2024-02-29)', () {
        final date = DateTime(2024, 2, 29);
        final result = dayKey(date);
        expect(result, '2024-02-29');
      });

      test('dayKey handles single-digit month with zero-padding', () {
        final date = DateTime(2026, 3, 2);
        final result = dayKey(date);
        expect(result, '2026-03-02');
      });

      test('dayKey handles single-digit day with zero-padding', () {
        final date = DateTime(2026, 10, 5);
        final result = dayKey(date);
        expect(result, '2026-10-05');
      });

      test('dayKey handles year with leading zeros', () {
        final date = DateTime(1, 1, 1);
        final result = dayKey(date);
        expect(result, '0001-01-01');
      });
    });

    group('parseDayKey', () {
      test('parseDayKey parses valid string "2026-03-02"', () {
        final result = parseDayKey('2026-03-02');
        expect(result, isNotNull);
        expect(result!.year, 2026);
        expect(result.month, 3);
        expect(result.day, 2);
      });

      test('parseDayKey parses valid string "2026-01-01"', () {
        final result = parseDayKey('2026-01-01');
        expect(result, isNotNull);
        expect(result!.year, 2026);
        expect(result.month, 1);
        expect(result.day, 1);
      });

      test('parseDayKey parses valid string "2026-12-31"', () {
        final result = parseDayKey('2026-12-31');
        expect(result, isNotNull);
        expect(result!.year, 2026);
        expect(result.month, 12);
        expect(result.day, 31);
      });

      test('parseDayKey rejects invalid format "2026-3-2"', () {
        final result = parseDayKey('2026-3-2');
        expect(result, isNull);
      });

      test('parseDayKey rejects invalid month "2026-13-01"', () {
        final result = parseDayKey('2026-13-01');
        expect(result, isNull);
      });

      test('parseDayKey rejects invalid day "2026-01-32"', () {
        final result = parseDayKey('2026-01-32');
        expect(result, isNull);
      });

      test('parseDayKey rejects invalid date "2026-02-30"', () {
        final result = parseDayKey('2026-02-30');
        expect(result, isNull);
      });

      test('parseDayKey rejects non-date string "invalid"', () {
        final result = parseDayKey('invalid');
        expect(result, isNull);
      });

      test('parseDayKey rejects empty string', () {
        final result = parseDayKey('');
        expect(result, isNull);
      });

      test('parseDayKey rejects malformed date', () {
        final result = parseDayKey('2026/03/02');
        expect(result, isNull);
      });

      test('parseDayKey rejects date with missing parts', () {
        final result = parseDayKey('2026-03');
        expect(result, isNull);
      });

      test('parseDayKey rejects date with extra parts', () {
        final result = parseDayKey('2026-03-02-extra');
        expect(result, isNull);
      });

      test('parseDayKey accepts leap year date', () {
        final result = parseDayKey('2024-02-29');
        expect(result, isNotNull);
        expect(result!.year, 2024);
        expect(result.month, 2);
        expect(result.day, 29);
      });

      test('parseDayKey rejects non-leap year February 29', () {
        final result = parseDayKey('2023-02-29');
        expect(result, isNull);
      });
    });
  });
}
