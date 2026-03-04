// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorization_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemorizationProgress _$MemorizationProgressFromJson(
  Map<String, dynamic> json,
) => _MemorizationProgress(
  fromSurah: (json['fromSurah'] as num).toInt(),
  fromVerse: (json['fromVerse'] as num).toInt(),
  toSurah: (json['toSurah'] as num).toInt(),
  toVerse: (json['toVerse'] as num).toInt(),
  totalVerses: (json['totalVerses'] as num).toInt(),
);

Map<String, dynamic> _$MemorizationProgressToJson(
  _MemorizationProgress instance,
) => <String, dynamic>{
  'fromSurah': instance.fromSurah,
  'fromVerse': instance.fromVerse,
  'toSurah': instance.toSurah,
  'toVerse': instance.toVerse,
  'totalVerses': instance.totalVerses,
};
