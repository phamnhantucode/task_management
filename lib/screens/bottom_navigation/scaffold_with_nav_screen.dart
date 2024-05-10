import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/chat/rooms_screen.dart';
import 'package:room_master_app/screens/home_screen/home_screen.dart';
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
        onPressed: ()  {
          if (context.read<BottomNavCubit>().state == NavFunction.home) {
            context.go(NavigationPath.newProject);
          }
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            side:
                BorderSide(width: 3, color: context.appColors.buttonEnable)),
        child: Icon(
          Icons.add,
          color: context.appColors.buttonEnable,
          size: 32,
        ),
      ),
    );
  }
}
