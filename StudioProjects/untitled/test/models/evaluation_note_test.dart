/// Unit tests for EvaluationNote model
///
/// Tests cover:
/// - Instance creation with timestamp converter
/// - JSON serialization round-trip preserves DateTime
/// - Factory constructors (behavior, progress, reminder)
/// - Freezed equality and copyWith
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/models/evaluation_note.dart';

void main() {
  group('EvaluationNote', () {
    final testDate = DateTime(2026, 3, 2, 12, 0, 0);

    test('creates instance with timestamp converter', () {
      final note = EvaluationNote(
        type: 'behavior',
        text: 'Good focus today',
        createdAt: testDate,
      );

      expect(note.type, equals('behavior'));
      expect(note.text, equals('Good focus today'));
      expect(note.createdAt, equals(testDate));
    });

    test('serialization round-trip preserves DateTime', () {
      final original = EvaluationNote(
        type: 'progress',
        text: 'Completed Surah Al-Fatiha',
        createdAt: testDate,
      );

      final json = original.toJson();
      final deserialized = EvaluationNote.fromJson(json);

      expect(deserialized, equals(original));
      expect(deserialized.type, equals('progress'));
      expect(deserialized.text, equals('Completed Surah Al-Fatiha'));
      expect(deserialized.createdAt.millisecondsSinceEpoch,
          equals(testDate.millisecondsSinceEpoch));
    });

    test('copyWith creates new instance with modified fields', () {
      final original = EvaluationNote(
        type: 'behavior',
        text: 'Good focus',
        createdAt: testDate,
      );

      final modified = original.copyWith(text: 'Excellent focus');

      expect(modified.type, equals('behavior'));
      expect(modified.text, equals('Excellent focus'));
      expect(modified.createdAt, equals(testDate));
      expect(modified, isNot(equals(original)));
    });

    test('equality compares by value', () {
      final note1 = EvaluationNote(
        type: 'behavior',
        text: 'Good focus',
        createdAt: testDate,
      );

      final note2 = EvaluationNote(
        type: 'behavior',
        text: 'Good focus',
        createdAt: testDate,
      );

      final note3 = EvaluationNote(
        type: 'progress',
        text: 'Good focus',
        createdAt: testDate,
      );

      expect(note1, equals(note2));
      expect(note1.hashCode, equals(note2.hashCode));
      expect(note1, isNot(equals(note3)));
    });

    test('behavior factory creates behavior note', () {
      final note = EvaluationNote.behavior(
        'Student was attentive',
        createdAt: testDate,
      );

      expect(note.type, equals('behavior'));
      expect(note.text, equals('Student was attentive'));
      expect(note.createdAt, equals(testDate));
    });

    test('progress factory creates progress note', () {
      final note = EvaluationNote.progress(
        'Memorized 5 verses',
        createdAt: testDate,
      );

      expect(note.type, equals('progress'));
      expect(note.text, equals('Memorized 5 verses'));
      expect(note.createdAt, equals(testDate));
    });

    test('reminder factory creates reminder note', () {
      final note = EvaluationNote.reminder(
        'Review Surah Al-Baqarah',
        createdAt: testDate,
      );

      expect(note.type, equals('reminder'));
      expect(note.text, equals('Review Surah Al-Baqarah'));
      expect(note.createdAt, equals(testDate));
    });

    test('factory constructors default to current time when createdAt omitted',
        () {
      final before = DateTime.now();
      final note = EvaluationNote.behavior('Test note');
      final after = DateTime.now();

      expect(note.createdAt.isAfter(before) || note.createdAt == before,
          isTrue);
      expect(note.createdAt.isBefore(after) || note.createdAt == after, isTrue);
    });
  });
}
