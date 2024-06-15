import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/domain/repositories/auth/auth_repository.dart';
import 'package:room_master_app/domain/exception/auth_exception.dart';
import 'package:room_master_app/models/common/pair.dart';

class MockAuthCubit extends MockCubit<AuthenticationState> implements AuthenticationCubit {}

void main() {
  group('AuthenticationCubit', () {
    late MockAuthCubit mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthCubit();
    });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [loading, success] when login succeeds',
      build: () {
        when(mockAuthRepository.login('', ''))
            .thenAnswer((_) async => Pair(null, true));
        return AuthenticationCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.login(),
      expect:() => const AuthenticationState(status: LoginStatus.success, isAuthenticated: true),
    );

    // blocTest<AuthenticationCubit, AuthenticationState>(
    //   'emits [loading, failure] when login fails',
    //   build: () {
    //     when(mockAuthRepository.login(any, any))
    //         .thenAnswer((_) async => Pair(AuthException('Error message'), false));
    //     return AuthenticationCubit(mockAuthRepository);
    //   },
    //   act: (cubit) => cubit.login(),
    //   expect: [
    //     AuthenticationState(status: LoginStatus.loading, isAuthenticated: false),
    //     AuthenticationState(status: LoginStatus.failure, isAuthenticated: false),
    //   ],
    // );
    //
    // blocTest<AuthenticationCubit, AuthenticationState>(
    //   'emits [loading, success] when register succeeds',
    //   build: () {
    //     when(mockAuthRepository.register(any, any, any))
    //         .thenAnswer((_) async => Pair(null, true));
    //     return AuthenticationCubit(mockAuthRepository);
    //   },
    //   act: (cubit) => cubit.register(),
    //   expect: [
    //     AuthenticationState(status: LoginStatus.loading, isAuthenticated: false),
    //     AuthenticationState(status: LoginStatus.success, isAuthenticated: true),
    //   ],
    // );
    //
    // blocTest<AuthenticationCubit, AuthenticationState>(
    //   'emits [loading, failure] when register fails',
    //   build: () {
    //     when(mockAuthRepository.register(any, any, any))
    //         .thenAnswer((_) async => Pair(AuthException('Error message'), false));
    //     return AuthenticationCubit(mockAuthRepository);
    //   },
    //   act: (cubit) => cubit.register(),
    //   expect: [
    //     AuthenticationState(status: LoginStatus.loading, isAuthenticated: false),
    //     AuthenticationState(status: LoginStatus.failure, isAuthenticated: false),
    //   ],
    // );
    //
    // blocTest<AuthenticationCubit, AuthenticationState>(
    //   'emits [false] when logout is called',
    //   build: () => AuthenticationCubit(mockAuthRepository),
    //   act: (cubit) => cubit.logout(),
    //   expect: [
    //     AuthenticationState(isAuthenticated: false),
    //   ],
    // );
  });
}