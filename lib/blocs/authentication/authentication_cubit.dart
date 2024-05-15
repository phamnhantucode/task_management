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

  void login({bool isAutoLogin = false}) async {
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      emit(state.copyWith(status: LoginStatus.loading));
      final result = await _authRepository.login(state.email, state.password);
      if (result.first == null) {
        emit(state.copyWith(
            status: LoginStatus.success,
            isAuthenticated: result.second,
            expireTime: isAutoLogin ? state.expireTime :
                getCurrentTimestamp.add(const Duration(days: 1))));
        setUser();
      } else {
        emit(state.copyWith(
            status: LoginStatus.failure,
            authException: result.first, isAuthenticated: result.second));
      }
    }
  }

  void register() async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _authRepository.register(
        state.email, state.password, state.username);
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
    setUser();
  }

  void logout() async {
    await _authRepository.logOut();
    emit(const AuthenticationState(isAuthenticated: false));
  }

  void setEmail(String content) => emit(state.copyWith(email: content));

  void setUsername(String content) => emit(state.copyWith(username: content));

  void setPassword(String content) => emit(state.copyWith(password: content));

  void setUser() {
    if (state.isAuthenticated && getCurrentTimestamp < state.expireTime!) {
      emit(state.copyWith(user: FirebaseAuth.instance.currentUser));
    }
  }

  void reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    emit(state.copyWith(user: FirebaseAuth.instance.currentUser));
  }

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
    @JsonKey(ignore: true) User? user,
    required bool isAuthenticated,
    DateTime? expireTime,
    @Default('') String email,
    @Default('') String password,
    @JsonKey(ignore: true) @Default('') String username,
    @JsonKey(ignore: true) AuthException? authException,
  }) = _AuthenticationState;

  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationStateFromJson(json);
}
