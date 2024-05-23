import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/screens/chat/rooms_screen.dart';
import 'package:room_master_app/screens/home_screen/home_screen.dart';
import 'package:room_master_app/screens/new_project/new_project_screen.dart';
import 'package:room_master_app/screens/profile/profile_screen.dart';
import 'package:room_master_app/screens/upcoming_task/upcoming_task_screen.dart';

import '../../domain/service/notification_service.dart';
import 'bloc/bottom_nav_cubit.dart';
import 'nav_bar.dart';

class ScaffoldWithNav extends StatefulWidget {
  const ScaffoldWithNav({super.key});

  @override
  State<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends State<ScaffoldWithNav> {
  @override
  void initState() {
    NotificationService.instance.foregroundMessage();
    NotificationService.instance.setupInteractMessage(context);
    NotificationService.instance.firebaseInit(context);
    NotificationService.instance.getDeviceToken().then((token) {
      if (token != null) {
        context.read<AuthenticationCubit>().updateDeviceToken(token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.appColors.defaultBgContainer,
      body: BlocListener<BottomNavCubit, NavFunction>(
        listener: (context, state) {
          context.read<AuthenticationCubit>().reloadUser();
        },
        child: BlocBuilder<BottomNavCubit, NavFunction>(
          builder: (context, state) => switch (state) {
            NavFunction.home => const HomeScreen(),
            NavFunction.calendar => const UpcomingTaskScreen(),
            NavFunction.chat => const RoomsScreen(),
            NavFunction.profile => const ProfileScreen(),
          },
        ),
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
