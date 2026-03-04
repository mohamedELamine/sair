/// Unit tests for Student model
///
/// Tests cover:
/// - Instance creation with required fields
/// - JSON serialization round-trip
/// - Freezed equality and copyWith
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/models/student.dart';

void main() {
  group('Student', () {
    test('creates instance with id and name', () {
      final student = Student(
        id: 'student_123',
        name: 'Ahmed',
      );

      expect(student.id, equals('student_123'));
      expect(student.name, equals('Ahmed'));
    });

    test('serialization round-trip preserves data', () {
      final original = Student(
        id: 'student_456',
        name: 'Fatima',
      );

      final json = original.toJson();
      final deserialized = Student.fromJson(json);

      expect(deserialized, equals(original));
      expect(deserialized.id, equals('student_456'));
      expect(deserialized.name, equals('Fatima'));
    });

    test('copyWith creates new instance with modified fields', () {
      final original = Student(
        id: 'student_789',
        name: 'Omar',
      );

      final modified = original.copyWith(name: 'Omar Ali');

      expect(modified.id, equals('student_789'));
      expect(modified.name, equals('Omar Ali'));
      expect(modified, isNot(equals(original)));
    });

    test('equality compares by value not reference', () {
      final student1 = Student(
        id: 'student_123',
        name: 'Ahmed',
      );

      final student2 = Student(
        id: 'student_123',
        name: 'Ahmed',
      );

      final student3 = Student(
        id: 'student_456',
        name: 'Ahmed',
      );

      expect(student1, equals(student2));
      expect(student1.hashCode, equals(student2.hashCode));
      expect(student1, isNot(equals(student3)));
    });

    test('toString returns readable format', () {
      final student = Student(
        id: 'student_123',
        name: 'Ahmed',
      );

      expect(student.toString(), contains('student_123'));
      expect(student.toString(), contains('Ahmed'));
    });
  });
}
