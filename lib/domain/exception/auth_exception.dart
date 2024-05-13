import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:room_master_app/l10n/l10n.dart';

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

  String errorMessage(BuildContext context) {
    switch (runtimeType) {
      case InvalidEmailException: return context.l10n.invalid_email_exception;
      case UserNotFoundException: return context.l10n.user_not_found_exception;
      case UserDisabledException: return context.l10n.user_disabled_exception;
      case WrongPasswordException: return 'Wrong password';
    }
    return 'Please ensure you fill in email and password field.';
  }
}

class InvalidEmailException extends AuthException {}

class UserDisabledException extends AuthException {}

class UserNotFoundException extends AuthException {}

class WrongPasswordException extends AuthException {}