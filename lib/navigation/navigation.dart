import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/screens/bottom_navigation/scaffold_with_nav_screen.dart';
import 'package:room_master_app/screens/home_screen/home_screen.dart';
import 'package:room_master_app/screens/new_task/new_task_screen.dart';
import 'package:room_master_app/screens/task_detail/task_detail_screen.dart';
import '../blocs/authentication/authentication_cubit.dart';
import '../common/error_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/upcoming_task/upcoming_task_screen.dart';
import '../screens/register/register_screen.dart';

abstract class NavigationPath {
  NavigationPath._();
  static const home = '/home';
  static const login = '/';
  static const register = '/register';
  static const newTask = '/new';
  static const detail = '/detail';
}

abstract class AppRouter {
  AppRouter._();

  static final routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: NavigationPath.login,
    redirect: (context, state) {
      if (!context.read<AuthenticationCubit>().state) {
        return NavigationPath.login;
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: NavigationPath.home,
        builder: (_, __) => const ScaffoldWithNav(),
      ),
      GoRoute(
        path: NavigationPath.newTask,
        builder: (_, __) => const NewTaskScreen(),
      ),
      GoRoute(
        path: NavigationPath.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: NavigationPath.detail,
        builder: (_, __) => TaskDetailScreen(),
      ),
      GoRoute(
        path: NavigationPath.register,
        builder: (_, __) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (_, __) => const ErrorScreen(),
  );
}
