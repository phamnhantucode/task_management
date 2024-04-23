import 'package:room_master_app/models/common/pair.dart';

import '../../exception/auth_exception.dart';

abstract class AuthRepository {
  Future<Pair<AuthException?, bool>> login(String username, String password);
  Future<Pair<AuthException?, bool>> register(String username, String password);
}