import 'package:room_master_app/models/common/pair.dart';

import '../../exception/auth_exception.dart';

abstract class AuthRepository {
  Future<Pair<AuthException?, bool>> login(String email, String password);
  Future<Pair<AuthException?, bool>> register(String email, String password, String username);
  Future<void> logOut();
}