// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evaluation_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EvaluationNote {

 String get type; String get text;@TimestampJsonConverter() DateTime get createdAt;
/// Create a copy of EvaluationNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvaluationNoteCopyWith<EvaluationNote> get copyWith => _$EvaluationNoteCopyWithImpl<EvaluationNote>(this as EvaluationNote, _$identity);

  /// Serializes this EvaluationNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvaluationNote&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,createdAt);

@override
String toString() {
  return 'EvaluationNote(type: $type, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EvaluationNoteCopyWith<$Res>  {
  factory $EvaluationNoteCopyWith(EvaluationNote value, $Res Function(EvaluationNote) _then) = _$EvaluationNoteCopyWithImpl;
@useResult
$Res call({
 String type, String text,@TimestampJsonConverter() DateTime createdAt
});




}
/// @nodoc
class _$EvaluationNoteCopyWithImpl<$Res>
    implements $EvaluationNoteCopyWith<$Res> {
  _$EvaluationNoteCopyWithImpl(this._self, this._then);

  final EvaluationNote _self;
  final $Res Function(EvaluationNote) _then;

/// Create a copy of EvaluationNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? text = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EvaluationNote].
extension EvaluationNotePatterns on EvaluationNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvaluationNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvaluationNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvaluationNote value)  $default,){
final _that = this;
switch (_that) {
case _EvaluationNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvaluationNote value)?  $default,){
final _that = this;
switch (_that) {
case _EvaluationNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String text, @TimestampJsonConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvaluationNote() when $default != null:
return $default(_that.type,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String text, @TimestampJsonConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EvaluationNote():
return $default(_that.type,_that.text,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String text, @TimestampJsonConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EvaluationNote() when $default != null:
return $default(_that.type,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EvaluationNote extends EvaluationNote {
  const _EvaluationNote({required this.type, required this.text, @TimestampJsonConverter() required this.createdAt}): super._();
  factory _EvaluationNote.fromJson(Map<String, dynamic> json) => _$EvaluationNoteFromJson(json);

@override final  String type;
@override final  String text;
@override@TimestampJsonConverter() final  DateTime createdAt;

/// Create a copy of EvaluationNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvaluationNoteCopyWith<_EvaluationNote> get copyWith => __$EvaluationNoteCopyWithImpl<_EvaluationNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvaluationNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvaluationNote&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,createdAt);

@override
String toString() {
  return 'EvaluationNote(type: $type, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EvaluationNoteCopyWith<$Res> implements $EvaluationNoteCopyWith<$Res> {
  factory _$EvaluationNoteCopyWith(_EvaluationNote value, $Res Function(_EvaluationNote) _then) = __$EvaluationNoteCopyWithImpl;
@override @useResult
$Res call({
 String type, String text,@TimestampJsonConverter() DateTime createdAt
});




}
/// @nodoc
class __$EvaluationNoteCopyWithImpl<$Res>
    implements _$EvaluationNoteCopyWith<$Res> {
  __$EvaluationNoteCopyWithImpl(this._self, this._then);

  final _EvaluationNote _self;
  final $Res Function(_EvaluationNote) _then;

/// Create a copy of EvaluationNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? text = null,Object? createdAt = null,}) {
  return _then(_EvaluationNote(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
