import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/auth/auth_repository.dart';

import '../../domain/exception/auth_exception.dart';

part 'authentication_cubit.freezed.dart';
part 'authentication_cubit.g.dart';

final class AuthenticationCubit extends HydratedCubit<AuthenticationState> {
  AuthenticationCubit(this._authRepository)
      : super(const AuthenticationState(isAuthenticated: false));

  final AuthRepository _authRepository;

  void login() async {
    emit(state.copyWith(status: LoginStatus.loading)) ;
    final result = await _authRepository.login(state.email, state.password);
    if (result.first == null) {
      emit(state.copyWith(
          status: LoginStatus.success,
          isAuthenticated: result.second,
          expireTime: getCurrentTimestamp.add(const Duration(days: 1))));
    } else {
      emit(state.copyWith(
          status: LoginStatus.failure,
          authException: result.first, isAuthenticated: result.second));
    }
  }

  void register() async {
        emit(state.copyWith(status: LoginStatus.loading));
        final result = await _authRepository.register(state.email, state.password);
        if (result.first == null) {
          emit(state.copyWith(
              status: LoginStatus.success,
              isAuthenticated: result.second,
              expireTime: getCurrentTimestamp.add(const Duration(days: 1))));
        } else {
          emit(state.copyWith(
              authException: result.first, isAuthenticated: result.second));
        }
  }

  void logout() {
    emit(const AuthenticationState(isAuthenticated: false));
    FirebaseAuth.instance.signOut();
  }

  void setEmail(String content) => emit(state.copyWith(email: content));

  void setPassword(String content) => emit(state.copyWith(password: content));

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) =>
      AuthenticationState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) =>state.toJson();

  void clean() {
    emit(state.copyWith(authException: null, status: LoginStatus.unknown));
  }
}

enum LoginStatus { loading, success, failure, unknown }

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @JsonKey(ignore: true) @Default(LoginStatus.unknown) LoginStatus status,
    required bool isAuthenticated,
    DateTime? expireTime,
    @Default('') String email,
    @Default('') String password,
    @JsonKey(ignore: true) AuthException? authException,
  }) = _AuthenticationState;

  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationStateFromJson(json);
}
