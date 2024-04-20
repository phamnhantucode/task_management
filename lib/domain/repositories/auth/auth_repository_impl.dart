import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_master_app/domain/exception/auth_exception.dart';
import 'package:room_master_app/domain/repositories/auth/auth_repository.dart';
import 'package:room_master_app/models/common/pair.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(FirebaseAuth firebaseAuth) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Pair<AuthException?, bool>> login(
      String username, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return Pair(null, true);
    } on FirebaseAuthException catch (e) {
      final authException = AuthException.handleFirebaseAuthException(e);
      return Pair(authException, false);
    } catch (e) {
      final authException = AuthException();
      return Pair(authException, false);
    }
  }

  @override
  Future<Pair<AuthException?, bool>> register(
      String username, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      return Pair(null, true);
    } on FirebaseAuthException catch (e) {
      final authException = AuthException.handleFirebaseAuthException(e);
      return Pair(authException, false);
    } catch (e) {
      final authException = AuthException();
      return Pair(authException, false);
    }
  }
}
