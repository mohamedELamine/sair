// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Evaluation _$EvaluationFromJson(Map<String, dynamic> json) => _Evaluation(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  classId: json['classId'] as String,
  date: const TimestampJsonConverter().fromJson(json['date']),
  dayKey: json['dayKey'] as String,
  attendanceStatus: json['attendanceStatus'] as String,
  sessionType: json['sessionType'] as String?,
  memorization: json['memorization'] == null
      ? null
      : MemorizationProgress.fromJson(
          json['memorization'] as Map<String, dynamic>,
        ),
  revision: json['revision'] == null
      ? null
      : RevisionProgress.fromJson(json['revision'] as Map<String, dynamic>),
  notes: (json['notes'] as List<dynamic>?)
      ?.map((e) => EvaluationNote.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: const TimestampJsonConverter().fromJson(json['createdAt']),
  createdBy: json['createdBy'] as String,
  updatedAt: const NullableTimestampJsonConverter().fromJson(json['updatedAt']),
  updatedBy: json['updatedBy'] as String?,
);

Map<String, dynamic> _$EvaluationToJson(_Evaluation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'classId': instance.classId,
      'date': const TimestampJsonConverter().toJson(instance.date),
      'dayKey': instance.dayKey,
      'attendanceStatus': instance.attendanceStatus,
      'sessionType': instance.sessionType,
      'memorization': instance.memorization?.toJson(),
      'revision': instance.revision?.toJson(),
      'notes': instance.notes?.map((e) => e.toJson()).toList(),
      'createdAt': const TimestampJsonConverter().toJson(instance.createdAt),
      'createdBy': instance.createdBy,
      'updatedAt': const NullableTimestampJsonConverter().toJson(
        instance.updatedAt,
      ),
      'updatedBy': instance.updatedBy,
    };
