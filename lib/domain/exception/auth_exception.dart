import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  static AuthException handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return InvalidEmailException();
      case 'user-disabled':
        return UserDisabledException();
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return WrongPasswordException();
      default:
        return AuthException();
    }
  }
}

class InvalidEmailException extends AuthException {}

class UserDisabledException extends AuthException {}

class UserNotFoundException extends AuthException {}

class WrongPasswordException extends AuthException {}