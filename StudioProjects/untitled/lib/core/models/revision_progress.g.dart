// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RevisionProgress _$RevisionProgressFromJson(Map<String, dynamic> json) =>
    _RevisionProgress(
      fromSurah: (json['fromSurah'] as num).toInt(),
      fromVerse: (json['fromVerse'] as num).toInt(),
      toSurah: (json['toSurah'] as num).toInt(),
      toVerse: (json['toVerse'] as num).toInt(),
      totalVerses: (json['totalVerses'] as num).toInt(),
    );

Map<String, dynamic> _$RevisionProgressToJson(_RevisionProgress instance) =>
    <String, dynamic>{
      'fromSurah': instance.fromSurah,
      'fromVerse': instance.fromVerse,
      'toSurah': instance.toSurah,
      'toVerse': instance.toVerse,
      'totalVerses': instance.totalVerses,
    };
