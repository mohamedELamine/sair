/// Unit tests for EvaluationService
///
/// Tests cover:
/// - Audit trail tracking (updatedAt, updatedBy)
/// - Field preservation during updates
/// - Error handling (no auth user, Firestore errors)
/// - Multiple rapid updates
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:untitled/core/models/evaluation.dart' as model;
import 'package:untitled/core/services/evaluation_service.dart';

void main() {
  group('EvaluationService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late EvaluationService service;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockUser = MockUser(
        uid: 'teacher_uid_123',
        email: 'teacher@example.com',
      );
      mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
      service = EvaluationService(
        firestore: fakeFirestore,
        auth: mockAuth,
      );
    });

    group('updateEvaluation', () {
      test('sets updatedAt timestamp (T106)', () async {
        // Create initial evaluation
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        // Store in Firestore
        await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .set(evaluation.toJson());

        // Update
        final beforeUpdate = DateTime.now();
        await service.updateEvaluation(evaluation);
        final afterUpdate = DateTime.now();

        // Verify updatedAt is set and recent
        final doc = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final updated = model.Evaluation.fromFirestore(doc);

        expect(updated.updatedAt, isNotNull);
        expect(
          updated.updatedAt!.isAfter(beforeUpdate.subtract(Duration(seconds: 1))),
          isTrue,
        );
        expect(
          updated.updatedAt!.isBefore(afterUpdate.add(Duration(seconds: 1))),
          isTrue,
        );
      });

      test('sets updatedBy with current user UID (T107)', () async {
        // Create initial evaluation
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .set(evaluation.toJson());

        // Update
        await service.updateEvaluation(evaluation);

        // Verify updatedBy matches current user
        final doc = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final updated = model.Evaluation.fromFirestore(doc);

        expect(updated.updatedBy, equals('teacher_uid_123'));
      });

      test('preserves other fields unchanged (T108)', () async {
        // Create evaluation with all fields populated
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          sessionType: 'daily',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .set(evaluation.toJson());

        // Update
        await service.updateEvaluation(evaluation);

        // Verify all original fields preserved
        final doc = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final updated = model.Evaluation.fromFirestore(doc);

        expect(updated.id, equals(evaluation.id));
        expect(updated.studentId, equals(evaluation.studentId));
        expect(updated.classId, equals(evaluation.classId));
        expect(updated.date, equals(evaluation.date));
        expect(updated.dayKey, equals(evaluation.dayKey));
        expect(updated.attendanceStatus, equals(evaluation.attendanceStatus));
        expect(updated.sessionType, equals(evaluation.sessionType));
        expect(updated.createdAt, equals(evaluation.createdAt));
        expect(updated.createdBy, equals(evaluation.createdBy));
      });

      test('multiple updates in quick succession record each timestamp accurately (T109)', () async {
        // Create initial evaluation
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .set(evaluation.toJson());

        // First update
        await service.updateEvaluation(evaluation);
        final doc1 = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final firstUpdate = model.Evaluation.fromFirestore(doc1);
        final firstTimestamp = firstUpdate.updatedAt!;

        // Small delay to ensure different timestamp
        await Future.delayed(Duration(milliseconds: 100));

        // Second update
        await service.updateEvaluation(evaluation);
        final doc2 = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final secondUpdate = model.Evaluation.fromFirestore(doc2);
        final secondTimestamp = secondUpdate.updatedAt!;

        // Verify timestamps are different and second is after first
        expect(secondTimestamp.isAfter(firstTimestamp), isTrue);
        expect(
          secondTimestamp.difference(firstTimestamp).inMilliseconds,
          greaterThan(50),
        );
      });

      test('throws StateError when no user is authenticated', () async {
        // Create service with no authenticated user
        final noAuthService = EvaluationService(
          firestore: fakeFirestore,
          auth: MockFirebaseAuth(signedIn: false),
        );

        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        expect(
          () => noAuthService.updateEvaluation(evaluation),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('getEvaluationsByDate', () {
      test('validates dayKey format (T122)', () async {
        expect(
          () => service.getEvaluationsByDate('2026-3-2'),
          throwsA(isA<FormatException>()),
        );
      });

      test('rejects invalid formats (T123)', () async {
        // Wrong separators
        expect(
          () => service.getEvaluationsByDate('03/02/2026'),
          throwsA(isA<FormatException>()),
        );

        // Missing leading zeros
        expect(
          () => service.getEvaluationsByDate('2026-3-02'),
          throwsA(isA<FormatException>()),
        );

        // Wrong order
        expect(
          () => service.getEvaluationsByDate('02-03-2026'),
          throwsA(isA<FormatException>()),
        );
      });

      test('deserializes Firestore documents to Evaluation list (T124)', () async {
        // Create test evaluations
        final eval1 = model.Evaluation(
          id: 'eval_1',
          studentId: 'student_1',
          classId: 'class_1',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        final eval2 = model.Evaluation(
          id: 'eval_2',
          studentId: 'student_2',
          classId: 'class_1',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'absent',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        // Store in Firestore
        await fakeFirestore
            .collection('evaluations')
            .doc(eval1.id)
            .set(eval1.toJson());
        await fakeFirestore
            .collection('evaluations')
            .doc(eval2.id)
            .set(eval2.toJson());

        // Query by date
        final results = await service.getEvaluationsByDate('2026-03-02');

        // Verify
        expect(results.length, equals(2));
        expect(results[0].id, equals('eval_1'));
        expect(results[1].id, equals('eval_2'));
        expect(results[0].dayKey, equals('2026-03-02'));
        expect(results[1].dayKey, equals('2026-03-02'));
      });
    });

    group('createEvaluation with sessionType', () {
      test('validates sessionType enum (T139)', () async {
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        expect(
          () => service.createEvaluation(evaluation, sessionType: 'monthly'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('defaults sessionType to "daily" if null (T140)', () async {
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        await service.createEvaluation(evaluation);

        final doc = await fakeFirestore
            .collection('evaluations')
            .doc(evaluation.id)
            .get();
        final created = model.Evaluation.fromFirestore(doc);

        expect(created.sessionType, equals('daily'));
      });

      test('rejects invalid sessionType values (T141)', () async {
        final evaluation = model.Evaluation(
          id: 'eval_123',
          studentId: 'student_456',
          classId: 'class_789',
          date: DateTime(2026, 3, 2),
          dayKey: '2026-03-02',
          attendanceStatus: 'present',
          createdAt: DateTime(2026, 3, 2, 10, 0),
          createdBy: 'teacher_uid',
        );

        expect(
          () => service.createEvaluation(evaluation, sessionType: 'yearly'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getEvaluationsBySessionType', () {
      test('filters correctly by type (T142)', () async {
        // Create daily evaluation
        final daily = model.Evaluation(
          id: 'eval_daily',
          studentId: 'student_1',
          classId: 'class_1',
          date: DateTime(2026, 3, 6),
          dayKey: '2026-03-06',
          attendanceStatus: 'present',
          sessionType: 'daily',
          createdAt: DateTime(2026, 3, 6, 10, 0),
          createdBy: 'teacher_uid',
        );

        // Create wednesday_review evaluation
        final review = model.Evaluation(
          id: 'eval_review',
          studentId: 'student_2',
          classId: 'class_1',
          date: DateTime(2026, 3, 6),
          dayKey: '2026-03-06',
          attendanceStatus: 'present',
          sessionType: 'wednesday_review',
          createdAt: DateTime(2026, 3, 6, 14, 0),
          createdBy: 'teacher_uid',
        );

        await fakeFirestore
            .collection('evaluations')
            .doc(daily.id)
            .set(daily.toJson());
        await fakeFirestore
            .collection('evaluations')
            .doc(review.id)
            .set(review.toJson());

        // Query for daily only
        final dailyResults = await service.getEvaluationsBySessionType(
          'class_1',
          '2026-03-06',
          'daily',
        );

        expect(dailyResults.length, equals(1));
        expect(dailyResults[0].id, equals('eval_daily'));
        expect(dailyResults[0].sessionType, equals('daily'));

        // Query for wednesday_review only
        final reviewResults = await service.getEvaluationsBySessionType(
          'class_1',
          '2026-03-06',
          'wednesday_review',
        );

        expect(reviewResults.length, equals(1));
        expect(reviewResults[0].id, equals('eval_review'));
        expect(reviewResults[0].sessionType, equals('wednesday_review'));
      });
    });
  });
}
