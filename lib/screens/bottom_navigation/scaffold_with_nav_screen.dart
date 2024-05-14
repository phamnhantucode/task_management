import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/chat/rooms_screen.dart';
import 'package:room_master_app/screens/home_screen/home_screen.dart';
import 'package:room_master_app/screens/new_project/new_project_screen.dart';
import 'package:room_master_app/screens/profile/profile_other_user/profile_other_user_page.dart';
import 'package:room_master_app/screens/profile/profile_screen.dart';
import 'package:room_master_app/screens/upcoming_task/upcoming_task_screen.dart';

import 'bloc/bottom_nav_cubit.dart';
import 'nav_bar.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<BottomNavCubit, NavFunction>(
        builder: (context, state) => switch (state) {
          NavFunction.home => const HomeScreen(),
          NavFunction.calendar => const UpcomingTaskScreen(),
          NavFunction.chat => const RoomsScreen(),
          NavFunction.profile => const ProfileScreen(),
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          if (context.read<BottomNavCubit>().state == NavFunction.home) {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext innerContext) {
                return const NewProjectScreen();
              },
            );
          }
          if (context.read<BottomNavCubit>().state == NavFunction.chat) {
            UsersRepository.instance.getUserById("VDAaWR74ZCWDrMXZ4BltqmDVEdP2").then((user) {
              if (user != null &&
                  context.read<AuthenticationCubit>().state.user?.uid !=
                      user.id) {
                // context.pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => ProfileOtherUserPage(
                      otherUser: user,
                    ),
                  ),
                  (route) => true,
                );
              }
            });
          }
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            side: BorderSide(width: 3, color: context.appColors.buttonEnable)),
        child: Icon(
          Icons.add,
          color: context.appColors.buttonEnable,
          size: 32,
        ),
      ),
    );
  }
}
