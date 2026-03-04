// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revision_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevisionProgress {

 int get fromSurah; int get fromVerse; int get toSurah; int get toVerse; int get totalVerses;
/// Create a copy of RevisionProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevisionProgressCopyWith<RevisionProgress> get copyWith => _$RevisionProgressCopyWithImpl<RevisionProgress>(this as RevisionProgress, _$identity);

  /// Serializes this RevisionProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevisionProgress&&(identical(other.fromSurah, fromSurah) || other.fromSurah == fromSurah)&&(identical(other.fromVerse, fromVerse) || other.fromVerse == fromVerse)&&(identical(other.toSurah, toSurah) || other.toSurah == toSurah)&&(identical(other.toVerse, toVerse) || other.toVerse == toVerse)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromSurah,fromVerse,toSurah,toVerse,totalVerses);

@override
String toString() {
  return 'RevisionProgress(fromSurah: $fromSurah, fromVerse: $fromVerse, toSurah: $toSurah, toVerse: $toVerse, totalVerses: $totalVerses)';
}


}

/// @nodoc
abstract mixin class $RevisionProgressCopyWith<$Res>  {
  factory $RevisionProgressCopyWith(RevisionProgress value, $Res Function(RevisionProgress) _then) = _$RevisionProgressCopyWithImpl;
@useResult
$Res call({
 int fromSurah, int fromVerse, int toSurah, int toVerse, int totalVerses
});




}
/// @nodoc
class _$RevisionProgressCopyWithImpl<$Res>
    implements $RevisionProgressCopyWith<$Res> {
  _$RevisionProgressCopyWithImpl(this._self, this._then);

  final RevisionProgress _self;
  final $Res Function(RevisionProgress) _then;

/// Create a copy of RevisionProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromSurah = null,Object? fromVerse = null,Object? toSurah = null,Object? toVerse = null,Object? totalVerses = null,}) {
  return _then(_self.copyWith(
fromSurah: null == fromSurah ? _self.fromSurah : fromSurah // ignore: cast_nullable_to_non_nullable
as int,fromVerse: null == fromVerse ? _self.fromVerse : fromVerse // ignore: cast_nullable_to_non_nullable
as int,toSurah: null == toSurah ? _self.toSurah : toSurah // ignore: cast_nullable_to_non_nullable
as int,toVerse: null == toVerse ? _self.toVerse : toVerse // ignore: cast_nullable_to_non_nullable
as int,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevisionProgress].
extension RevisionProgressPatterns on RevisionProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevisionProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevisionProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevisionProgress value)  $default,){
final _that = this;
switch (_that) {
case _RevisionProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevisionProgress value)?  $default,){
final _that = this;
switch (_that) {
case _RevisionProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fromSurah,  int fromVerse,  int toSurah,  int toVerse,  int totalVerses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevisionProgress() when $default != null:
return $default(_that.fromSurah,_that.fromVerse,_that.toSurah,_that.toVerse,_that.totalVerses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fromSurah,  int fromVerse,  int toSurah,  int toVerse,  int totalVerses)  $default,) {final _that = this;
switch (_that) {
case _RevisionProgress():
return $default(_that.fromSurah,_that.fromVerse,_that.toSurah,_that.toVerse,_that.totalVerses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fromSurah,  int fromVerse,  int toSurah,  int toVerse,  int totalVerses)?  $default,) {final _that = this;
switch (_that) {
case _RevisionProgress() when $default != null:
return $default(_that.fromSurah,_that.fromVerse,_that.toSurah,_that.toVerse,_that.totalVerses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevisionProgress extends RevisionProgress {
  const _RevisionProgress({required this.fromSurah, required this.fromVerse, required this.toSurah, required this.toVerse, required this.totalVerses}): super._();
  factory _RevisionProgress.fromJson(Map<String, dynamic> json) => _$RevisionProgressFromJson(json);

@override final  int fromSurah;
@override final  int fromVerse;
@override final  int toSurah;
@override final  int toVerse;
@override final  int totalVerses;

/// Create a copy of RevisionProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevisionProgressCopyWith<_RevisionProgress> get copyWith => __$RevisionProgressCopyWithImpl<_RevisionProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevisionProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevisionProgress&&(identical(other.fromSurah, fromSurah) || other.fromSurah == fromSurah)&&(identical(other.fromVerse, fromVerse) || other.fromVerse == fromVerse)&&(identical(other.toSurah, toSurah) || other.toSurah == toSurah)&&(identical(other.toVerse, toVerse) || other.toVerse == toVerse)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromSurah,fromVerse,toSurah,toVerse,totalVerses);

@override
String toString() {
  return 'RevisionProgress(fromSurah: $fromSurah, fromVerse: $fromVerse, toSurah: $toSurah, toVerse: $toVerse, totalVerses: $totalVerses)';
}


}

/// @nodoc
abstract mixin class _$RevisionProgressCopyWith<$Res> implements $RevisionProgressCopyWith<$Res> {
  factory _$RevisionProgressCopyWith(_RevisionProgress value, $Res Function(_RevisionProgress) _then) = __$RevisionProgressCopyWithImpl;
@override @useResult
$Res call({
 int fromSurah, int fromVerse, int toSurah, int toVerse, int totalVerses
});




}
/// @nodoc
class __$RevisionProgressCopyWithImpl<$Res>
    implements _$RevisionProgressCopyWith<$Res> {
  __$RevisionProgressCopyWithImpl(this._self, this._then);

  final _RevisionProgress _self;
  final $Res Function(_RevisionProgress) _then;

/// Create a copy of RevisionProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromSurah = null,Object? fromVerse = null,Object? toSurah = null,Object? toVerse = null,Object? totalVerses = null,}) {
  return _then(_RevisionProgress(
fromSurah: null == fromSurah ? _self.fromSurah : fromSurah // ignore: cast_nullable_to_non_nullable
as int,fromVerse: null == fromVerse ? _self.fromVerse : fromVerse // ignore: cast_nullable_to_non_nullable
as int,toSurah: null == toSurah ? _self.toSurah : toSurah // ignore: cast_nullable_to_non_nullable
as int,toVerse: null == toVerse ? _self.toVerse : toVerse // ignore: cast_nullable_to_non_nullable
as int,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
