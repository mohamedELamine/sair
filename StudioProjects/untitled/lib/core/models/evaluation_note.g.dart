// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EvaluationNote _$EvaluationNoteFromJson(Map<String, dynamic> json) =>
    _EvaluationNote(
      type: json['type'] as String,
      text: json['text'] as String,
      createdAt: const TimestampJsonConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$EvaluationNoteToJson(_EvaluationNote instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'createdAt': const TimestampJsonConverter().toJson(instance.createdAt),
    };
