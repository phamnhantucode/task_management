import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/screens/home_screen/home_screen.dart';
import 'package:room_master_app/screens/upcoming_task/upcoming_task_screen.dart';

import 'bloc/bottom_nav_cubit.dart';
import 'nav_bar.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<BottomNavCubit, NavFunction>(
          builder: (context, state) => switch (state) {
            NavFunction.home => const HomeScreen(),
            NavFunction.calendar => const UpcomingTaskScreen(),
            NavFunction.chat => const HomeScreen(),
            NavFunction.user => const HomeScreen(),
          },
        ),
        bottomNavigationBar: const NavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => {},
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
      ),
    );
  }
}
