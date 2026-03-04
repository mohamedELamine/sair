/// Unit tests for User model
///
/// Tests cover:
/// - Instance creation with id (Firebase UID)
/// - JSON serialization round-trip
/// - Freezed equality and copyWith
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/models/user.dart';

void main() {
  group('User', () {
    test('creates instance with id (UID)', () {
      final user = User(
        id: 'firebase_uid_123',
      );

      expect(user.id, equals('firebase_uid_123'));
    });

    test('serialization round-trip preserves data', () {
      final original = User(
        id: 'teacher_uid_456',
      );

      final json = original.toJson();
      final deserialized = User.fromJson(json);

      expect(deserialized, equals(original));
      expect(deserialized.id, equals('teacher_uid_456'));
    });

    test('copyWith creates new instance with modified fields', () {
      final original = User(
        id: 'uid_789',
      );

      final modified = original.copyWith(id: 'uid_999');

      expect(modified.id, equals('uid_999'));
      expect(modified, isNot(equals(original)));
    });

    test('equality compares by value not reference', () {
      final user1 = User(
        id: 'uid_123',
      );

      final user2 = User(
        id: 'uid_123',
      );

      final user3 = User(
        id: 'uid_456',
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1, isNot(equals(user3)));
    });

    test('toString returns readable format', () {
      final user = User(
        id: 'uid_123',
      );

      expect(user.toString(), contains('uid_123'));
    });
  });
}
