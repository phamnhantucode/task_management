import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:room_master_app/common/constant.dart';
import 'package:room_master_app/domain/exception/auth_exception.dart';
import 'package:room_master_app/domain/repositories/auth/auth_repository.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/models/common/pair.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(FirebaseAuth firebaseAuth) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Pair<AuthException?, bool>> login(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
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
      String email, String password, String displayName) async {
    try {
      final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredentials.user?..updateDisplayName(displayName)..updatePhotoURL(AppConstants.defaultUriAvatar);
      await FirebaseChatCore.instance.createUserInFirestore(types.User(id: userCredentials.user!.uid, imageUrl: AppConstants.defaultUriAvatar, firstName: displayName));
      UsersRepository.instance.updateUserId(userCredentials.user!.uid);
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
  Future<void> logOut() async{
    return _firebaseAuth.signOut();
  }
}
