import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/screens/new_task/new_task_screen.dart';

import '../blocs/authentication/authentication_cubit.dart';
import '../common/error_screen.dart';
import '../screens/home/home.dart';
import '../screens/login/login_screen.dart';


abstract class NavigationPath {
  NavigationPath._();
  static const home = '/home';
  static const login = '/';
}

abstract class AppRouter {
  AppRouter._();

  static final routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: NavigationPath.login,
    redirect: (context, _) {
      if (context.read<AuthenticationCubit>().state) {
        return NavigationPath.login;
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: NavigationPath.home,
        builder: (_, __) => const NewTaskScreen(),
      ),
      GoRoute(
        path: NavigationPath.login,
        builder: (_, __) => const LoginScreen(),
      ),
    ],
    errorBuilder: (_, __) => const ErrorScreen(),
  );
}
