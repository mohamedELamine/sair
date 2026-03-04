// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Evaluation {

 String get id; String get studentId; String get classId;@TimestampJsonConverter() DateTime get date; String get dayKey; String get attendanceStatus; String? get sessionType; MemorizationProgress? get memorization; RevisionProgress? get revision; List<EvaluationNote>? get notes;@TimestampJsonConverter() DateTime get createdAt; String get createdBy;@NullableTimestampJsonConverter() DateTime? get updatedAt; String? get updatedBy;
/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvaluationCopyWith<Evaluation> get copyWith => _$EvaluationCopyWithImpl<Evaluation>(this as Evaluation, _$identity);

  /// Serializes this Evaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Evaluation&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.date, date) || other.date == date)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.memorization, memorization) || other.memorization == memorization)&&(identical(other.revision, revision) || other.revision == revision)&&const DeepCollectionEquality().equals(other.notes, notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,classId,date,dayKey,attendanceStatus,sessionType,memorization,revision,const DeepCollectionEquality().hash(notes),createdAt,createdBy,updatedAt,updatedBy);

@override
String toString() {
  return 'Evaluation(id: $id, studentId: $studentId, classId: $classId, date: $date, dayKey: $dayKey, attendanceStatus: $attendanceStatus, sessionType: $sessionType, memorization: $memorization, revision: $revision, notes: $notes, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $EvaluationCopyWith<$Res>  {
  factory $EvaluationCopyWith(Evaluation value, $Res Function(Evaluation) _then) = _$EvaluationCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String classId,@TimestampJsonConverter() DateTime date, String dayKey, String attendanceStatus, String? sessionType, MemorizationProgress? memorization, RevisionProgress? revision, List<EvaluationNote>? notes,@TimestampJsonConverter() DateTime createdAt, String createdBy,@NullableTimestampJsonConverter() DateTime? updatedAt, String? updatedBy
});


$MemorizationProgressCopyWith<$Res>? get memorization;$RevisionProgressCopyWith<$Res>? get revision;

}
/// @nodoc
class _$EvaluationCopyWithImpl<$Res>
    implements $EvaluationCopyWith<$Res> {
  _$EvaluationCopyWithImpl(this._self, this._then);

  final Evaluation _self;
  final $Res Function(Evaluation) _then;

/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? classId = null,Object? date = null,Object? dayKey = null,Object? attendanceStatus = null,Object? sessionType = freezed,Object? memorization = freezed,Object? revision = freezed,Object? notes = freezed,Object? createdAt = null,Object? createdBy = null,Object? updatedAt = freezed,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,attendanceStatus: null == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as String,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String?,memorization: freezed == memorization ? _self.memorization : memorization // ignore: cast_nullable_to_non_nullable
as MemorizationProgress?,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as RevisionProgress?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<EvaluationNote>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemorizationProgressCopyWith<$Res>? get memorization {
    if (_self.memorization == null) {
    return null;
  }

  return $MemorizationProgressCopyWith<$Res>(_self.memorization!, (value) {
    return _then(_self.copyWith(memorization: value));
  });
}/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevisionProgressCopyWith<$Res>? get revision {
    if (_self.revision == null) {
    return null;
  }

  return $RevisionProgressCopyWith<$Res>(_self.revision!, (value) {
    return _then(_self.copyWith(revision: value));
  });
}
}


/// Adds pattern-matching-related methods to [Evaluation].
extension EvaluationPatterns on Evaluation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Evaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Evaluation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Evaluation value)  $default,){
final _that = this;
switch (_that) {
case _Evaluation():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Evaluation value)?  $default,){
final _that = this;
switch (_that) {
case _Evaluation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String classId, @TimestampJsonConverter()  DateTime date,  String dayKey,  String attendanceStatus,  String? sessionType,  MemorizationProgress? memorization,  RevisionProgress? revision,  List<EvaluationNote>? notes, @TimestampJsonConverter()  DateTime createdAt,  String createdBy, @NullableTimestampJsonConverter()  DateTime? updatedAt,  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Evaluation() when $default != null:
return $default(_that.id,_that.studentId,_that.classId,_that.date,_that.dayKey,_that.attendanceStatus,_that.sessionType,_that.memorization,_that.revision,_that.notes,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String classId, @TimestampJsonConverter()  DateTime date,  String dayKey,  String attendanceStatus,  String? sessionType,  MemorizationProgress? memorization,  RevisionProgress? revision,  List<EvaluationNote>? notes, @TimestampJsonConverter()  DateTime createdAt,  String createdBy, @NullableTimestampJsonConverter()  DateTime? updatedAt,  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _Evaluation():
return $default(_that.id,_that.studentId,_that.classId,_that.date,_that.dayKey,_that.attendanceStatus,_that.sessionType,_that.memorization,_that.revision,_that.notes,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String classId, @TimestampJsonConverter()  DateTime date,  String dayKey,  String attendanceStatus,  String? sessionType,  MemorizationProgress? memorization,  RevisionProgress? revision,  List<EvaluationNote>? notes, @TimestampJsonConverter()  DateTime createdAt,  String createdBy, @NullableTimestampJsonConverter()  DateTime? updatedAt,  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _Evaluation() when $default != null:
return $default(_that.id,_that.studentId,_that.classId,_that.date,_that.dayKey,_that.attendanceStatus,_that.sessionType,_that.memorization,_that.revision,_that.notes,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Evaluation extends Evaluation {
  const _Evaluation({required this.id, required this.studentId, required this.classId, @TimestampJsonConverter() required this.date, required this.dayKey, required this.attendanceStatus, this.sessionType, this.memorization, this.revision, final  List<EvaluationNote>? notes, @TimestampJsonConverter() required this.createdAt, required this.createdBy, @NullableTimestampJsonConverter() this.updatedAt, this.updatedBy}): _notes = notes,super._();
  factory _Evaluation.fromJson(Map<String, dynamic> json) => _$EvaluationFromJson(json);

@override final  String id;
@override final  String studentId;
@override final  String classId;
@override@TimestampJsonConverter() final  DateTime date;
@override final  String dayKey;
@override final  String attendanceStatus;
@override final  String? sessionType;
@override final  MemorizationProgress? memorization;
@override final  RevisionProgress? revision;
 final  List<EvaluationNote>? _notes;
@override List<EvaluationNote>? get notes {
  final value = _notes;
  if (value == null) return null;
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@TimestampJsonConverter() final  DateTime createdAt;
@override final  String createdBy;
@override@NullableTimestampJsonConverter() final  DateTime? updatedAt;
@override final  String? updatedBy;

/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvaluationCopyWith<_Evaluation> get copyWith => __$EvaluationCopyWithImpl<_Evaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Evaluation&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.date, date) || other.date == date)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.memorization, memorization) || other.memorization == memorization)&&(identical(other.revision, revision) || other.revision == revision)&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,classId,date,dayKey,attendanceStatus,sessionType,memorization,revision,const DeepCollectionEquality().hash(_notes),createdAt,createdBy,updatedAt,updatedBy);

@override
String toString() {
  return 'Evaluation(id: $id, studentId: $studentId, classId: $classId, date: $date, dayKey: $dayKey, attendanceStatus: $attendanceStatus, sessionType: $sessionType, memorization: $memorization, revision: $revision, notes: $notes, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$EvaluationCopyWith<$Res> implements $EvaluationCopyWith<$Res> {
  factory _$EvaluationCopyWith(_Evaluation value, $Res Function(_Evaluation) _then) = __$EvaluationCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String classId,@TimestampJsonConverter() DateTime date, String dayKey, String attendanceStatus, String? sessionType, MemorizationProgress? memorization, RevisionProgress? revision, List<EvaluationNote>? notes,@TimestampJsonConverter() DateTime createdAt, String createdBy,@NullableTimestampJsonConverter() DateTime? updatedAt, String? updatedBy
});


@override $MemorizationProgressCopyWith<$Res>? get memorization;@override $RevisionProgressCopyWith<$Res>? get revision;

}
/// @nodoc
class __$EvaluationCopyWithImpl<$Res>
    implements _$EvaluationCopyWith<$Res> {
  __$EvaluationCopyWithImpl(this._self, this._then);

  final _Evaluation _self;
  final $Res Function(_Evaluation) _then;

/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? classId = null,Object? date = null,Object? dayKey = null,Object? attendanceStatus = null,Object? sessionType = freezed,Object? memorization = freezed,Object? revision = freezed,Object? notes = freezed,Object? createdAt = null,Object? createdBy = null,Object? updatedAt = freezed,Object? updatedBy = freezed,}) {
  return _then(_Evaluation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,attendanceStatus: null == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as String,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String?,memorization: freezed == memorization ? _self.memorization : memorization // ignore: cast_nullable_to_non_nullable
as MemorizationProgress?,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as RevisionProgress?,notes: freezed == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<EvaluationNote>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemorizationProgressCopyWith<$Res>? get memorization {
    if (_self.memorization == null) {
    return null;
  }

  return $MemorizationProgressCopyWith<$Res>(_self.memorization!, (value) {
    return _then(_self.copyWith(memorization: value));
  });
}/// Create a copy of Evaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevisionProgressCopyWith<$Res>? get revision {
    if (_self.revision == null) {
    return null;
  }

  return $RevisionProgressCopyWith<$Res>(_self.revision!, (value) {
    return _then(_self.copyWith(revision: value));
  });
}
}

// dart format on
