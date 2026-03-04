/// Unit tests for Class model
///
/// Tests cover:
/// - Instance creation with required fields
/// - JSON serialization round-trip
/// - Freezed equality and copyWith
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/models/class.dart';

void main() {
  group('Class', () {
    test('creates instance with id and name', () {
      final classObj = Class(
        id: 'class_123',
        name: 'Class A',
      );

      expect(classObj.id, equals('class_123'));
      expect(classObj.name, equals('Class A'));
    });

    test('serialization round-trip preserves data', () {
      final original = Class(
        id: 'class_456',
        name: 'Advanced Quran',
      );

      final json = original.toJson();
      final deserialized = Class.fromJson(json);

      expect(deserialized, equals(original));
      expect(deserialized.id, equals('class_456'));
      expect(deserialized.name, equals('Advanced Quran'));
    });

    test('copyWith creates new instance with modified fields', () {
      final original = Class(
        id: 'class_789',
        name: 'Beginner',
      );

      final modified = original.copyWith(name: 'Beginner A');

      expect(modified.id, equals('class_789'));
      expect(modified.name, equals('Beginner A'));
      expect(modified, isNot(equals(original)));
    });

    test('equality compares by value not reference', () {
      final class1 = Class(
        id: 'class_123',
        name: 'Class A',
      );

      final class2 = Class(
        id: 'class_123',
        name: 'Class A',
      );

      final class3 = Class(
        id: 'class_456',
        name: 'Class A',
      );

      expect(class1, equals(class2));
      expect(class1.hashCode, equals(class2.hashCode));
      expect(class1, isNot(equals(class3)));
    });

    test('toString returns readable format', () {
      final classObj = Class(
        id: 'class_123',
        name: 'Class A',
      );

      expect(classObj.toString(), contains('class_123'));
      expect(classObj.toString(), contains('Class A'));
    });
  });
}
