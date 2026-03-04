/// Service layer for Evaluation CRUD operations with audit trail tracking
///
/// This service implements business logic for managing evaluation records,
/// including automatic audit trail tracking (updatedAt/updatedBy) on every
/// update operation.
///
/// Business Rules:
/// - BR-004: updatedAt and updatedBy must be set together (both or neither)
/// - All update operations must record the current timestamp and user ID
/// - Audit fields are immutable once set (new update replaces them)
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/core/models/evaluation.dart';

/// Service for managing evaluation records with audit trail support
class EvaluationService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Creates an EvaluationService with optional Firestore and Auth instances
  ///
  /// Allows dependency injection for testing (pass mock instances)
  EvaluationService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Collection reference for evaluations
  CollectionReference get _evaluationsCollection =>
      _firestore.collection('evaluations');

  /// Updates an evaluation record with automatic audit trail tracking
  ///
  /// Automatically sets:
  /// - updatedAt: Current timestamp (DateTime.now())
  /// - updatedBy: Current user UID from Firebase Auth
  ///
  /// Business Rule BR-004: Both updatedAt and updatedBy are set together
  ///
  /// Throws:
  /// - [StateError] if no user is currently authenticated
  /// - [FirebaseException] on Firestore errors (permission denied, network, etc.)
  ///
  /// Example:
  /// ```dart
  /// final service = EvaluationService();
  /// final updated = evaluation.copyWith(
  ///   attendanceStatus: 'absent',
  /// );
  /// await service.updateEvaluation(updated);
  /// ```
  Future<void> updateEvaluation(Evaluation evaluation) async {
    // Validate authenticated user exists (T099)
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw StateError(
        'Cannot update evaluation: No authenticated user. '
        'User must be logged in to update records.',
      );
    }

    // Add audit trail fields (T098, T099, T100)
    final now = DateTime.now();
    final updatedEvaluation = evaluation.copyWith(
      updatedAt: now,
      updatedBy: currentUser.uid,
    );

    // Convert to Firestore map (T101)
    final data = updatedEvaluation.toJson();

    // Write to Firestore (T102)
    try {
      await _evaluationsCollection.doc(evaluation.id).update(data);
    } on FirebaseException catch (e) {
      // Handle Firestore errors (T103)
      if (e.code == 'not-found') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Evaluation document not found: ${evaluation.id}',
          code: 'not-found',
        );
      } else if (e.code == 'permission-denied') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Permission denied: Cannot update evaluation ${evaluation.id}',
          code: 'permission-denied',
        );
      } else if (e.code == 'unavailable') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Network error: Cannot reach Firestore server',
          code: 'unavailable',
        );
      }
      rethrow;
    }
  }

  /// Valid session type values
  static const List<String> validSessionTypes = ['daily', 'wednesday_review'];

  /// Creates a new evaluation record
  ///
  /// Sets:
  /// - createdAt: Current timestamp
  /// - createdBy: Current user UID
  /// - sessionType: Defaults to "daily" if null or not provided (T134)
  ///
  /// Validates:
  /// - sessionType must be one of validSessionTypes (T133)
  ///
  /// Note: updatedAt and updatedBy are null on creation
  ///
  /// Throws:
  /// - [ArgumentError] if sessionType is invalid
  /// - [StateError] if no user is authenticated
  Future<void> createEvaluation(Evaluation evaluation, {String? sessionType}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw StateError(
        'Cannot create evaluation: No authenticated user',
      );
    }

    // Validate and default sessionType (T133, T134)
    final finalSessionType = sessionType ?? evaluation.sessionType ?? 'daily';
    if (!validSessionTypes.contains(finalSessionType)) {
      throw ArgumentError(
        'Invalid sessionType: "$finalSessionType". '
        'Must be one of: ${validSessionTypes.join(", ")}',
      );
    }

    // Create evaluation with validated sessionType
    final evaluationWithSessionType = evaluation.copyWith(
      sessionType: finalSessionType,
    );

    final data = evaluationWithSessionType.toJson();
    await _evaluationsCollection.doc(evaluation.id).set(data);
  }

  /// Retrieves an evaluation by ID
  ///
  /// Returns null if the evaluation doesn't exist
  Future<Evaluation?> getEvaluation(String id) async {
    final doc = await _evaluationsCollection.doc(id).get();
    if (!doc.exists) {
      return null;
    }
    return Evaluation.fromFirestore(doc);
  }

  /// Deletes an evaluation record
  Future<void> deleteEvaluation(String id) async {
    await _evaluationsCollection.doc(id).delete();
  }

  /// Queries evaluations by date using dayKey field
  ///
  /// [dayKey] must be in YYYY-MM-DD format (e.g., "2026-03-02")
  ///
  /// Returns list of evaluations for the specified date.
  /// Uses Firestore field equality query on indexed dayKey field
  /// for fast performance (<1 second per SC-001).
  ///
  /// Throws:
  /// - [FormatException] if dayKey format is invalid
  /// - [FirebaseException] on Firestore errors
  ///
  /// Example:
  /// ```dart
  /// final service = EvaluationService();
  /// final evaluations = await service.getEvaluationsByDate('2026-03-02');
  /// print('Found ${evaluations.length} evaluations for March 2');
  /// ```
  Future<List<Evaluation>> getEvaluationsByDate(String dayKey) async {
    // Validate dayKey format (T117)
    final dayKeyRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dayKeyRegex.hasMatch(dayKey)) {
      throw FormatException(
        'Invalid dayKey format: "$dayKey". '
        'Expected YYYY-MM-DD format (e.g., "2026-03-02")',
      );
    }

    // Query Firestore (T118)
    try {
      final querySnapshot = await _evaluationsCollection
          .where('dayKey', isEqualTo: dayKey)
          .get();

      // Deserialize to List<Evaluation> (T119)
      return querySnapshot.docs
          .map((doc) => Evaluation.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      // Handle Firestore errors (T121)
      if (e.code == 'permission-denied') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Permission denied: Cannot query evaluations',
          code: 'permission-denied',
        );
      } else if (e.code == 'unavailable') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Network error: Cannot reach Firestore server',
          code: 'unavailable',
        );
      }
      rethrow;
    }
  }

  /// Queries evaluations by session type for a specific class and date
  ///
  /// Filters evaluations by classId, dayKey, and sessionType.
  ///
  /// Parameters:
  /// - [classId]: The class identifier
  /// - [dayKey]: Date in YYYY-MM-DD format
  /// - [sessionType]: Type of session ("daily" or "wednesday_review")
  ///
  /// Returns list of evaluations matching all three criteria.
  ///
  /// Throws:
  /// - [ArgumentError] if sessionType is invalid (T138)
  /// - [FormatException] if dayKey format is invalid
  /// - [FirebaseException] on Firestore errors
  ///
  /// Example:
  /// ```dart
  /// final service = EvaluationService();
  /// final reviews = await service.getEvaluationsBySessionType(
  ///   'class_123',
  ///   '2026-03-06',
  ///   'wednesday_review',
  /// );
  /// ```
  Future<List<Evaluation>> getEvaluationsBySessionType(
    String classId,
    String dayKey,
    String sessionType,
  ) async {
    // Validate sessionType (T138)
    if (!validSessionTypes.contains(sessionType)) {
      throw ArgumentError(
        'Invalid sessionType: "$sessionType". '
        'Must be one of: ${validSessionTypes.join(", ")}',
      );
    }

    // Validate dayKey format
    final dayKeyRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dayKeyRegex.hasMatch(dayKey)) {
      throw FormatException(
        'Invalid dayKey format: "$dayKey". '
        'Expected YYYY-MM-DD format',
      );
    }

    // Query with filters (T137)
    try {
      final querySnapshot = await _evaluationsCollection
          .where('classId', isEqualTo: classId)
          .where('dayKey', isEqualTo: dayKey)
          .where('sessionType', isEqualTo: sessionType)
          .get();

      return querySnapshot.docs
          .map((doc) => Evaluation.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Permission denied: Cannot query evaluations',
          code: 'permission-denied',
        );
      } else if (e.code == 'unavailable') {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Network error: Cannot reach Firestore server',
          code: 'unavailable',
        );
      }
      rethrow;
    }
  }
}
