import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/screens/bottom_navigation/scaffold_with_nav_screen.dart';
import 'package:room_master_app/screens/new_project/new_project_screen.dart';
import 'package:room_master_app/screens/new_task/new_task_screen.dart';
import 'package:room_master_app/screens/profile/edit_profile_screen.dart';
import 'package:room_master_app/screens/statistic/statistic_screen.dart';
import 'package:room_master_app/screens/task_detail/task_detail_screen.dart';

import '../blocs/authentication/authentication_cubit.dart';
import '../common/error_screen.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/register/register_screen.dart';
import '../screens/profile/change_password_screen.dart';

abstract class NavigationPath {
  NavigationPath._();

  static const home = '/home';
  static const login = '/';
  static const register = '/register';
  static const newTask = '/new';
  static const newProject = '/newProject';
  static const detailProject = '/detailProject';
  static const statistic = '/statistic';
  static const editProfile = '/detail/editProfile';
  static const changePassword = '/detail/changePassword';
}

abstract class AppRouter {
  AppRouter._();

  static final routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: NavigationPath.login,
    redirect: (context, state) {
      if (state.matchedLocation == NavigationPath.register) return null;
      final isLoggedIn = getAuthState(context);
      final isLoggingIn = state.matchedLocation == NavigationPath.login;
      if (!isLoggedIn) {
        return NavigationPath.login;
      }

      if (isLoggingIn) {
        return NavigationPath.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: NavigationPath.home,
        builder: (_, __) => const ScaffoldWithNav(),
      ),
      GoRoute(
        path: NavigationPath.newProject,
        builder: (_, __) => NewProjectScreen(),
      ),
      GoRoute(
        path: NavigationPath.statistic,
        builder: (_, __) => StatisticScreen(),
      ),
      GoRoute(
        path: NavigationPath.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
          path: NavigationPath.newTask,
          builder: (context, __) => const NewTaskScreen()),
      GoRoute(
          path: NavigationPath.detailProject,
          builder: (_, __) => ProjectDetailScreen(),
          routes: [
            GoRoute(
              path: 'editProfile',
              builder: (context, __) => EditProfileScreen(
                  user: context.read<AuthenticationCubit>().state.user!),
            ),
            GoRoute(
              path: 'changePassword',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const ChangePasswordScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ]),
      GoRoute(
        path: NavigationPath.register,
        builder: (_, __) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (_, __) => const ErrorScreen(),
  );

  static bool getAuthState(BuildContext context) {
    try {
      final state = context.watch<AuthenticationCubit>().state;
      return state.isAuthenticated && getCurrentTimestamp < state.expireTime!;
    } on Error catch (_) {
      final state = context.read<AuthenticationCubit>().state;
      return state.isAuthenticated && getCurrentTimestamp < state.expireTime!;
    }
  }
}
