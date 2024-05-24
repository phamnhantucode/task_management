import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/screens/add_member/add_member_page.dart';
import 'package:room_master_app/screens/bottom_navigation/scaffold_with_nav_screen.dart';
import 'package:room_master_app/screens/listing/list_projects/list_project_screen.dart';
import 'package:room_master_app/screens/notification/notification_screen.dart';
import 'package:room_master_app/screens/profile/edit_profile_screen.dart';
import 'package:room_master_app/screens/statistic/statistic_screen.dart';
import 'package:room_master_app/screens/task_detai_real/task_detail.dart';

import '../blocs/authentication/authentication_cubit.dart';
import '../common/error_screen.dart';
import '../models/dtos/project/project.dart';
import '../models/dtos/user/user_dto.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/register/register_screen.dart';
import '../screens/listing/list_tasks/list_tasks_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/project_detail/project_detail_screen.dart';

abstract class NavigationPath {
  NavigationPath._();

  static const home = '/home';
  static const login = '/';
  static const register = '/register';
  static const newTask = '/newTask';
    static const detailProject = '/project';
  static const listProjects = '/listProjects';
  static const listTasks = '/listTasks';
  static const statistic = '/statistic';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const changePassword = '/changePassword';
  static const notification = '/notification';
  static const addMember = '/addMember';
  static const taskDetail = '/taskDetail';
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
        path: NavigationPath.editProfile,
        builder: (context, __) => EditProfileScreen(
            user: context.read<AuthenticationCubit>().state.user!),
      ),
      GoRoute(
        path: NavigationPath.changePassword,
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
      GoRoute(
        path: NavigationPath.statistic,
        builder: (_, __) => StatisticScreen(),
      ),
      GoRoute(
        path: NavigationPath.listProjects,
        builder: (_, __) => const ListProjectScreen(),
      ),
      GoRoute(
        path: NavigationPath.listTasks,
        builder: (_, __) => const ListTasksScreen(),
      ),
      GoRoute(
        path: NavigationPath.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: NavigationPath.detailProject,
        builder: (context, state) => ProjectDetailScreen(
          projectId: GoRouterState.of(context).extra! as String,
        ),
      ),
      GoRoute(
        path: NavigationPath.taskDetail,
        builder: (context, state) {
          final lists = (state.extra! as String).split('__');
          return TaskDetail(
            taskId: lists.first,
            projectId: lists.last,
          );
        },
      ),
      GoRoute(
        path: NavigationPath.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
          path: NavigationPath.notification,
          builder: (_, __) => const NotificationScreen()),
      GoRoute(
          path: NavigationPath.addMember,
          builder: (context, state) => AddMemberPage(usersAlreadySelected: GoRouterState.of(context).extra! as List<UserDto>,)),
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
