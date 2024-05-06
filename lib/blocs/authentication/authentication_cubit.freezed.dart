// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthenticationState _$AuthenticationStateFromJson(Map<String, dynamic> json) {
  return _AuthenticationState.fromJson(json);
}

/// @nodoc
mixin _$AuthenticationState {
  @JsonKey(ignore: true)
  LoginStatus get status => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  DateTime? get expireTime => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  AuthException? get authException => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticationStateCopyWith<AuthenticationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationStateCopyWith(
          AuthenticationState value, $Res Function(AuthenticationState) then) =
      _$AuthenticationStateCopyWithImpl<$Res, AuthenticationState>;
  @useResult
  $Res call(
      {@JsonKey(ignore: true) LoginStatus status,
      bool isAuthenticated,
      DateTime? expireTime,
      String email,
      String password,
      @JsonKey(ignore: true) AuthException? authException});
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<$Res, $Val extends AuthenticationState>
    implements $AuthenticationStateCopyWith<$Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isAuthenticated = null,
    Object? expireTime = freezed,
    Object? email = null,
    Object? password = null,
    Object? authException = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      authException: freezed == authException
          ? _value.authException
          : authException // ignore: cast_nullable_to_non_nullable
              as AuthException?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthenticationStateImplCopyWith<$Res>
    implements $AuthenticationStateCopyWith<$Res> {
  factory _$$AuthenticationStateImplCopyWith(_$AuthenticationStateImpl value,
          $Res Function(_$AuthenticationStateImpl) then) =
      __$$AuthenticationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(ignore: true) LoginStatus status,
      bool isAuthenticated,
      DateTime? expireTime,
      String email,
      String password,
      @JsonKey(ignore: true) AuthException? authException});
}

/// @nodoc
class __$$AuthenticationStateImplCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res, _$AuthenticationStateImpl>
    implements _$$AuthenticationStateImplCopyWith<$Res> {
  __$$AuthenticationStateImplCopyWithImpl(_$AuthenticationStateImpl _value,
      $Res Function(_$AuthenticationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isAuthenticated = null,
    Object? expireTime = freezed,
    Object? email = null,
    Object? password = null,
    Object? authException = freezed,
  }) {
    return _then(_$AuthenticationStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      authException: freezed == authException
          ? _value.authException
          : authException // ignore: cast_nullable_to_non_nullable
              as AuthException?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthenticationStateImpl implements _AuthenticationState {
  const _$AuthenticationStateImpl(
      {@JsonKey(ignore: true) this.status = LoginStatus.unknown,
      required this.isAuthenticated,
      this.expireTime,
      this.email = '',
      this.password = '',
      @JsonKey(ignore: true) this.authException});

  factory _$AuthenticationStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthenticationStateImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final LoginStatus status;
  @override
  final bool isAuthenticated;
  @override
  final DateTime? expireTime;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey(ignore: true)
  final AuthException? authException;

  @override
  String toString() {
    return 'AuthenticationState(status: $status, isAuthenticated: $isAuthenticated, expireTime: $expireTime, email: $email, password: $password, authException: $authException)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.expireTime, expireTime) ||
                other.expireTime == expireTime) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.authException, authException) ||
                other.authException == authException));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, isAuthenticated,
      expireTime, email, password, authException);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      __$$AuthenticationStateImplCopyWithImpl<_$AuthenticationStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthenticationStateImplToJson(
      this,
    );
  }
}

abstract class _AuthenticationState implements AuthenticationState {
  const factory _AuthenticationState(
          {@JsonKey(ignore: true) final LoginStatus status,
          required final bool isAuthenticated,
          final DateTime? expireTime,
          final String email,
          final String password,
          @JsonKey(ignore: true) final AuthException? authException}) =
      _$AuthenticationStateImpl;

  factory _AuthenticationState.fromJson(Map<String, dynamic> json) =
      _$AuthenticationStateImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  LoginStatus get status;
  @override
  bool get isAuthenticated;
  @override
  DateTime? get expireTime;
  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  AuthException? get authException;
  @override
  @JsonKey(ignore: true)
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
